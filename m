Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:61194 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837Ab2LOXgR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Dec 2012 18:36:17 -0500
Received: by mail-vc0-f174.google.com with SMTP id d16so5817127vcd.19
        for <linux-wireless@vger.kernel.org>; Sat, 15 Dec 2012 15:36:17 -0800 (PST)
Message-ID: <50CD096D.1000504@lwfinger.net> (sfid-20121216_003626_322562_D93100EC)
Date: Sat, 15 Dec 2012 17:36:13 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Martin Beran <info@berycz.net>
CC: linux-wireless@vger.kernel.org, Piotr Haber <phaber@broadcom.com>
Subject: Re: bugreport Broadcom BCM4313
References: <50CCCF49.7040108@berycz.net> <50CCE126.6020503@berycz.net>
In-Reply-To: <50CCE126.6020503@berycz.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/15/2012 02:44 PM, Martin Beran wrote:
> (sry for my mistake in the subject before, Broadcom BCM4313 it is)
>
> to clarify
> it is still asking for wpa key, but doesnt want to connect
>
> from irc:
>  > b6fc28a158076ca2764edc9a6d1e1402f56e1c0c is the bad commit
>  > it added usleep_range() instead of udelay()

Did you get a patch from IRC? If not, the one below will likely do the trick.

Larry



Index: wireless-testing-new/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c
+++ wireless-testing-new/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c
@@ -1343,13 +1343,13 @@ static bool wlc_lcnphy_rx_iq_cal_gain(st

  	wlc_lcnphy_rx_gain_override_enable(pi, true);
  	wlc_lcnphy_start_tx_tone(pi, 2000, (40 >> 1), 0);
-	usleep_range(500, 500);
+	udelay(500);
  	write_radio_reg(pi, RADIO_2064_REG112, 0);
  	if (!wlc_lcnphy_rx_iq_est(pi, 1024, 32, &iq_est_l))
  		return false;

  	wlc_lcnphy_start_tx_tone(pi, 2000, 40, 0);
-	usleep_range(500, 500);
+	udelay(500);
  	write_radio_reg(pi, RADIO_2064_REG112, 0);
  	if (!wlc_lcnphy_rx_iq_est(pi, 1024, 32, &iq_est_h))
  		return false;
