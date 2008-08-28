Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:35802 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754757AbYH1N5s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 09:57:48 -0400
Received: from a88-112-109-230.elisa-laajakaista.fi ([88.112.109.230] helo=jm)
	by hostap.isc.org with esmtpsa (TLS-1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.63)
	(envelope-from <j@w1.fi>)
	id 1KYhvJ-0006za-7t
	for linux-wireless@vger.kernel.org; Thu, 28 Aug 2008 06:52:35 -0700
Date: Thu, 28 Aug 2008 16:56:51 +0300
From: Jouni Malinen <j@w1.fi>
To: linux-wireless@vger.kernel.org
Subject: [RFC] mac80211: Reorder debugfs calls during netdev deinit
Message-ID: <20080828135651.GE4863@jm.kir.nu> (sfid-20080828_155804_821695_2192C1D1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There was some discussion about the order in which debugfs entries are
removed in context of IEEE 802.11w implementation couple of months ago.
The problem that I was seeing ended up leaving the netdev:mon.wlan0
directory in debugfs behind when the monitor interface was removed. This
happened because mac80211 tried to remove the netdev directory before
making sure that all files were removed from the directory. This did not
show up before, but with IEEE 802.11w implementation, the
netdev:mon.wlan0 directory may actually contain a key symlink and that
prevented the directory from being removed.

It looks like someone has cleaned up the netdev uninit sequence (which
was quite a mess at the time I looked at it last and ended up just
delaying the fix till now..) and that seems to make it trivial to fix
the deinit order issue. The key part in fixing this is to make sure that
the possible key symlinks are removed before the netdev directory and
this is now easy to do by just changing the order of the function calls
in ieee80211_teardown_sdata(). I did not find any reason why they would
need to be in the other order, so this looks like a safe change. Did I
miss something there or would the following change be acceptable way of
fixing the issue? I did not notice any problems in my tests and this
allows the debugfs directories to be removed properly with my IEEE
802.11w patches applied.



ieee80211_free_keys() must be called before
ieee80211_debugfs_remove_netdev() in order to make sure that the
possible default_key symlink is removed before the netdev debugfs
directory is removed.

This fixes an issue where a monitor interface may be left behind when
being removed if there is a key symlink in it. This does not happen
with the current mac80211 code, but could happen in future after IEEE
802.11w (management frame protection) is added with its additional
default_mgmt_key symlink.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>


Index: wireless-testing/net/mac80211/iface.c
===================================================================
--- wireless-testing.orig/net/mac80211/iface.c
+++ wireless-testing/net/mac80211/iface.c
@@ -31,11 +31,11 @@ static void ieee80211_teardown_sdata(str
 	int flushed;
 	int i;
 
-	ieee80211_debugfs_remove_netdev(sdata);
-
 	/* free extra data */
 	ieee80211_free_keys(sdata);
 
+	ieee80211_debugfs_remove_netdev(sdata);
+
 	for (i = 0; i < IEEE80211_FRAGMENT_MAX; i++)
 		__skb_queue_purge(&sdata->fragments[i].skb_list);
 	sdata->fragment_next = 0;


-- 
Jouni Malinen                                            PGP id EFC895FA
