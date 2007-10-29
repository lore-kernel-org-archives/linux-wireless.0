Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:60219 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754093AbXJ2O0x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Oct 2007 10:26:53 -0400
Message-ID: <20071029102652.4u867m2rwog4owkc@webmail.spamcop.net> (sfid-20071029_142700_631503_D3FCE376)
Date: Mon, 29 Oct 2007 10:26:52 -0400
From: Pavel Roskin <proski@gnu.org>
To: dragoran <drago01@gmail.com>
Cc: Larry Finger <larry.finger@lwfinger.net>,
	ipw3945-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Subject: Re: iwl3945 lists supported rates backwards
References: <1192832109.19766.14.camel@dv> <47192F84.1020101@lwfinger.net>
	<20071020014040.40pq9hqkw0c4owc8@webmail.spamcop.net>
	<4719BA96.3010609@gmail.com> <1193644281.27622.12.camel@dv>
	<4725BB09.3030803@gmail.com>
In-Reply-To: <4725BB09.3030803@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting dragoran <drago01@gmail.com>:

> I tryed to reproduce it here using a wrt54gl. I switched it to "B only"
> and was able to acciotate using iwl3945.

I'm not surprised.  Newer routers a very likely to understand the  
extended rates even in 802.11b.  It's not reasonable to dumb them down  
as much as to ignore the extended rates.

I disabled the essid broadcast, and I still can reproduce the problem.

> Can you tell me how you captured the assoc request using wireshark? I
> am only able to capture the dhcp traffic but not the assoc request
> itself.

MadWifi captures everything in monitor mode.  Please make sure to use  
the latest trunk revision with Linux 2.6.24-rc1, which makes sysctl  
check failures survivable.

I made a patch to disable OFDM rates, and the everything is working  
now.  The station associates, dhclient works, I can transfer data.   
Actually, I remember that did something similar in bcm43xx_mac80211  
several months ago to associate to the same router, so maybe the  
problem is in mac80211.

And it's possible that there are different routers with the same model  
number.  Mine is Linksys BEFW11S4 ver 4, firmware version 1.52.02.

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c  
b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 4f22a71..004e57c 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -5343,8 +5343,8 @@ static int iwl_init_geos(struct iwl_priv *priv)

  	modes[G].mode = MODE_IEEE80211G;
  	modes[G].channels = channels;
-	modes[G].rates = rates;
-	modes[G].num_rates = 12;	/* OFDM & CCK */
+	modes[G].rates = &rates[8];
+	modes[G].num_rates = 4;	/* OFDM & CCK */
  	modes[G].num_channels = 0;

  	priv->ieee_channels = channels;

-- 
Regards,
Pavel Roskin
