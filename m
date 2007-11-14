Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56435 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756269AbXKNS6F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2007 13:58:05 -0500
Subject: patch softmac-fix-wext-mlme-request-reason-code-endianness.patch queued to -stable tree
To: johannes@sipsolutions.net, gregkh@suse.de,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	stable@kernel.org
Cc: <stable@kernel.org>, <stable-commits@vger.kernel.org>
From: <gregkh@suse.de>
Date: Wed, 14 Nov 2007 10:57:53 -0800
In-Reply-To: <1193343383.4406.30.camel@johannes.berg>
Message-Id: <20071114185803.4F26714540D0@imap.suse.de> (sfid-20071114_185809_227333_1B4907DF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


This is a note to let you know that we have just queued up the patch titled

     Subject: softmac: fix wext MLME request reason code endianness

to the 2.6.23-stable tree.  Its filename is

     softmac-fix-wext-mlme-request-reason-code-endianness.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From stable-bounces@linux.kernel.org Fri Oct 26 03:36:47 2007
From: Johannes Berg <johannes@sipsolutions.net>
Date: Thu, 25 Oct 2007 22:16:23 +0200
Subject: softmac: fix wext MLME request reason code endianness
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>, stable <stable@kernel.org>
Message-ID: <1193343383.4406.30.camel@johannes.berg>

From: Johannes Berg <johannes@sipsolutions.net>

patch 94e10bfb8a7372df3ef2759c9ec2a37de2f24aca in mainline.

The MLME request reason code is host-endian and our passing
it to the low level functions is host-endian as well since
they do the swapping. I noticed that the reason code 768 was
sent (0x300) rather than 3 when wpa_supplicant terminates.
This removes the superfluous cpu_to_le16() call.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ieee80211/softmac/ieee80211softmac_wx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ieee80211/softmac/ieee80211softmac_wx.c
+++ b/net/ieee80211/softmac/ieee80211softmac_wx.c
@@ -469,7 +469,7 @@ ieee80211softmac_wx_set_mlme(struct net_
 {
 	struct ieee80211softmac_device *mac = ieee80211_priv(dev);
 	struct iw_mlme *mlme = (struct iw_mlme *)extra;
-	u16 reason = cpu_to_le16(mlme->reason_code);
+	u16 reason = mlme->reason_code;
 	struct ieee80211softmac_network *net;
 	int err = -EINVAL;
 


Patches currently in stable-queue which might be from johannes@sipsolutions.net are

queue-2.6.23/mac80211-filter-locally-originated-multicast-frames.patch
queue-2.6.23/softmac-fix-wext-mlme-request-reason-code-endianness.patch
