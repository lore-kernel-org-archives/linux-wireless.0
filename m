Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web161201.mail.bf1.yahoo.com ([98.139.210.128]:33091 "HELO
	web161201.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756215Ab1BXOuO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Feb 2011 09:50:14 -0500
Message-ID: <853861.85701.qm@web161201.mail.bf1.yahoo.com>
References: <loom.20110224T145652-996@post.gmane.org> <1298557108.4775.12.camel@jlt3.sipsolutions.net>
Date: Thu, 24 Feb 2011 06:43:33 -0800 (PST)
From: Joerg Pommnitz <pommnitz@yahoo.com>
Subject: AW: IBSS and 802.11i (RSN) with mac80211
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1298557108.4775.12.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes,
thanks for the almost instant reply. I'll give this a try!

 -- 
Regards 
Joerg 




----- Johannes Berg wrote ----
> 
> 1) Check that iw reports that you can do it (I just now  committed code
>    to iw to report it since you asked, so use git  version, which will
>    become 0.9.23 at some point in the  future)
> 
> 2) get git version of wpa_supplicant, compile with  CONFIG_IBSS_RSN and
>    use a config file like  this:
> 
> ap_scan=2
> network={
>     ssid="your  SSID"
>     mode=1
>      frequency=2412
>     proto=RSN
>      key_mgmt=WPA-PSK
>     psk="your secret key!!  :-)"
> }
> 
> 
> If you find a good place, maybe you can add it to the  wiki?
> 
> Note that wpa_supplicant currently doesn't reject the config if  the
> driver doesn't support it, but it won't work.
> 
> If you want to make  your driver support it, the easiest way is to
> implement something like I did  for iwlwifi:
> 
> commit 274102a8a2a4a0b67c401b75a96694db76cfc701
> Author:  Johannes Berg <johannes.berg@intel.com>
> Date:    Tue Jan 18 04:44:03 2011 -0800
> 
>     iwlwifi: support RSN  IBSS
> 
> 
> johannes



