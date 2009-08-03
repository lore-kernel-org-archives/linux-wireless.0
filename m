Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:43976 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849AbZHCNJ5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 09:09:57 -0400
From: Christian Lamparter <chunkeey@web.de>
To: "Joerg Albert" <jal2@gmx.de>
Subject: Re: ar9170usb crashes during iwconfig for ad-hoc mode
Date: Mon, 3 Aug 2009 15:09:54 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <4A759341.1090006@gmx.de> <1249289274.4561.0.camel@johannes.local> <20090803123642.242160@gmx.net>
In-Reply-To: <20090803123642.242160@gmx.net>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_jGudK0RXrett0jO"
Message-Id: <200908031509.55277.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Boundary-00=_jGudK0RXrett0jO
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Monday 03 August 2009 14:36:42 Joerg Albert wrote:
> 
> > On Mon, 2009-08-03 at 10:44 +0200, Johannes Berg wrote:
> > 
> > > > >     ifconfig wlan1 down
> > > > >     iwconfig wlan1 mode managed essid huhu
> > > > >     ifconfig wlan1 up
> > > > >     ifconfig wlan1 down
> > > > >     iwconfig wlan1 mode ad-hoc essid huhu_a channel 1
> > 
> > > No, it's a bug in cfg80211 :)
> > 
> > But it's not making sense to me. I'll have to try to reproduce it. In
> > any case, we shouldn't be calling in to mac80211 from cfg80211 while the
> > interface is down.
> 
> I guess this is caused by the call to __cfg80211_leave_ibss()
> in  net/wireless/ibss.c::cfg80211_ibss_wext_siwfreq() trying to
> disable the beacon via net/mac80211::ieee80211_ibss_leave().
what about this? (only compiled so far, don't have the device here...)

Regards,
	Chr

--Boundary-00=_jGudK0RXrett0jO
Content-Type: text/x-patch;
  charset="iso-8859-1";
  name="bss-beacon.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="bss-beacon.diff"

diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
index 099ed3c..9c97ad7 100644
--- a/drivers/net/wireless/ath/ar9170/main.c
+++ b/drivers/net/wireless/ath/ar9170/main.c
@@ -2177,7 +2177,7 @@ static void ar9170_op_bss_info_changed(struct ieee80211_hw *hw,
 			goto out;
 	}
 
-	if (changed & (BSS_CHANGED_BEACON | BSS_CHANGED_BEACON_ENABLED)) {
+	if (changed & BSS_CHANGED_BEACON_ENABLED) {
 		err = ar9170_update_beacon(ar);
 		if (err)
 			goto out;

--Boundary-00=_jGudK0RXrett0jO--
