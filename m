Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web51404.mail.re2.yahoo.com ([206.190.38.183]:31586 "HELO
	web51404.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751795AbXFDMD6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jun 2007 08:03:58 -0400
Date: Mon, 4 Jun 2007 05:03:57 -0700 (PDT)
From: Joerg Pommnitz <pommnitz@yahoo.com>
Subject: AW: Drivers that do not honor regulatory restrictions
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
Message-ID: <297494.10588.qm@web51404.mail.re2.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote: 
> No, that would've been the driver, the firmware has nothing to do with 
> the radio frequency at all. 
>  
> johannes 
 
Actually it was mac80211. In ieee80211_ioctl.c the allowed frequencies for Japan are defined this way: 
 
1574 static const struct ieee80211_channel_range ieee80211_mkk_channels[] = { 
 1575         { 2412, 2472, 20, 6 } /* IEEE 802.11b/g, channels 1..13 */, 
 1576         { 5170, 5240, 20, 6 } /* IEEE 802.11a, channels 34..48 */, 
 1577         { 5260, 5320, 20, 6 } /* IEEE 802.11a, channels 52..64 */, 
 1578         { 0 } 
 1579 }; 

This prevents channel 14 from being used. Changing line 1575 to 
 
1575         { 2412, 2484, 20, 6 } /* IEEE 802.11b/g, channels 1..13 */, 

did the trick.

BTW: ieee80211_ioctl_set_regulatory_domain changes conf->regulatory_domain, but this seems not to change the selected frequency table (that one is selected solely based on the module parameter "ieee80211_regdom". Why are there two places to store the regdomain (that seem to be used from different places)?
 
--   
Regards 
  
       Joerg 
 
 
 




       __________________________________ Yahoo! Clever - Der einfachste Weg, Fragen zu stellen und Wissenswertes mit Anderen zu teilen. www.yahoo.de/clever

