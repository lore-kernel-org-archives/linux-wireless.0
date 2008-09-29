Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:57118 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712AbYI2KVX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2008 06:21:23 -0400
Date: Mon, 29 Sep 2008 13:20:21 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jiri Slaby <jirislaby@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Thomas Graf <tgraf@suug.ch>
Subject: Re: NL80211_CMD_GET_WIPHY reply doesn't fit into nl message buffer
Message-ID: <20080929102021.GE10429@jm.kir.nu> (sfid-20080929_122128_713135_D298F66C)
References: <48E0A65A.2060102@gmail.com> <1222682480.7064.16.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1222682480.7064.16.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 29, 2008 at 12:01:20PM +0200, Johannes Berg wrote:

> > I've found out, that NL80211_CMD_GET_WIPHY reply doesn't fit into a message
> > socket buffer now. Used driver is ath5k.
> 
> Ok, humm, I have no idea what to do. I guess we'll somehow have to make
> it possible to split it up on band or channel boundaries. But since
> those are nested it seems somewhat weird to me. Any ideas?

Isn't ath5k reporting quite a large set of channels that would never
really be used? 26 channels on 2.4 GHz and 194(huh!) on 5 GHz.. First
workaround could be to just limit those to somewhat more common set of
channels.

Sure, it would be nice to be able to handle long enough replies, but in
this particular case, I'm not sure whether the reply is that realistic.
Split on band boundary would not be enough here since the 5 GHz band
alone would probably have went beyond the size limit.

> > There is also a bug in hostapd which waits for ACK forever when this error occur
> > in i802_get_hw_feature_data().
> 
> I should replace all the code there with the current code from iw, it's
> much better and actually handles all the corner cases.

I have following (completely untested) patch.. Does it look correct or
do you have something more complete that should be used here?



diff --git a/hostapd/driver_nl80211.c b/hostapd/driver_nl80211.c
index f8c83e1..9b1a0a2 100644
--- a/hostapd/driver_nl80211.c
+++ b/hostapd/driver_nl80211.c
@@ -1531,12 +1531,17 @@ static struct hostapd_hw_modes *i802_get_hw_feature_data(void *priv,
 	nl_cb_set(cb, NL_CB_VALID, NL_CB_CUSTOM, phy_info_handler, &result);
 	nl_cb_set(cb, NL_CB_ACK, NL_CB_CUSTOM, ack_wait_handler, &finished);
 
-	err = nl_recvmsgs(drv->nl_handle, cb);
-
-	if (!finished)
+	if (result.error)
+		err = -1;
+	else if (!finished)
 		err = nl_wait_for_ack(drv->nl_handle);
+	else
+		err = 0;
+
+	if (err >= 0)
+		err = nl_recvmsgs(drv->nl_handle, cb);
 
-	if (err < 0 || result.error) {
+	if (err < 0) {
 		hostapd_free_hw_features(result.modes, *num_modes);
 		result.modes = NULL;
 	}

-- 
Jouni Malinen                                            PGP id EFC895FA
