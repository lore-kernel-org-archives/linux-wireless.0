Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from deine-taler.de ([217.160.107.63]:62872 "EHLO deine-taler.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231AbXHTWnf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Aug 2007 18:43:35 -0400
Date: Tue, 21 Aug 2007 00:43:34 +0200
From: Ulrich Kunitz <kune@deine-taler.de>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Broadcom Linux <bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] mac80211: fix software decryption with b43legacy
Message-ID: <20070820224333.GA6363@deine-taler.de>
References: <1187346385.23489.157.camel@johannes.berg> <46C5CC0D.2040609@lwfinger.net> <1187384230.6090.7.camel@johannes.berg> <46C612E8.4020604@lwfinger.net> <1187387215.6090.13.camel@johannes.berg> <46C64777.1000602@lwfinger.net> <1187453173.6090.33.camel@johannes.berg> <46C752FE.4030706@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <46C752FE.4030706@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger wrote:

> I have added the lists to this message.
> 
> I got b43legacy up and running with the software decryption modifications. 
> It started OK with WPA-PSK TKIP encryption, but soon thereafter, I got this 
> message:
> 
> eth1: No ProbeResp from current AP 00:1a:70:46:ba:b1 - assume out of range
> 

Since the git tree reorg wireless-dev branch created comparable
problems for zd1211rw-mac80211 too. It might be related:

Aug 19 07:08:51 keks kernel: [   83.572628] wlan0: CCMP replay detected for RX frame from 00:04:0e:68:ad:70 (RX PN 00000000000c <= prev. PN 00000000000c)
Aug 19 07:08:54 keks kernel: [   87.432010] usb 1-2: handle_regs_int() regs interrupt ignored
Aug 19 07:08:55 keks kernel: [   87.898447] wlan0: No ProbeResp from current AP 00:04:0e:68:ad:70 - assume out of range
Aug 19 07:08:55 keks kernel: [   87.899649] wmaster0: Removed STA 00:04:0e:68:ad:70
Aug 19 07:08:55 keks kernel: [   87.901406] wlan0: set_encrypt - unknown addr 00:04:0e:68:ad:70

The first message might be a simple duplicate. The
handle_regs_int() is absolutely suspicious and I cannot really
explain it right now. The "No ProbeResp" might be a follow-up
problem. The whole USB subsystem becomes absolutely instable to
the point that I can't use keyboard and mouse anymore. 

I will try Johannes' patch tomorrow.

BTW the wireless-dev reorg makes it impossible to actually use
git-bisect to find the patch, which caused the problem. 

BTW the current Linus tree following patch doesn't work with the
current zd1211rw-mac80211. The offending patch is the following one:

commit b9bf1e60a294fc7795d5198f94a917290e52865b
Author: John W. Linville <linville@tuxdriver.com>
Date:   Tue Aug 7 16:33:15 2007 -0400

    [PATCH] mac80211: probe for hidden SSIDs in pre-auth scan
    
    Probe for hidden SSIDs if initiating pre-authentication scan and SSID
    is set for STA interface.
    
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 7ba352e..0d99b68 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -2154,7 +2154,11 @@ static int ieee80211_sta_config_auth(struct net_device *dev,
 		return 0;
 	} else {
 		if (ifsta->state != IEEE80211_AUTHENTICATE) {
-			ieee80211_sta_start_scan(dev, NULL, 0);
+			if (ifsta->auto_ssid_sel)
+				ieee80211_sta_start_scan(dev, NULL, 0);
+			else
+				ieee80211_sta_start_scan(dev, ifsta->ssid,
+							 ifsta->ssid_len);
 			ifsta->state = IEEE80211_AUTHENTICATE;
 			set_bit(IEEE80211_STA_REQ_AUTH, &ifsta->request);
 		} else

-- 
Uli Kunitz
