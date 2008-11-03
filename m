Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eazy.amigager.de ([213.239.192.238]:60385 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740AbYKCUOP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2008 15:14:15 -0500
Date: Mon, 3 Nov 2008 21:14:12 +0100
From: Tino Keitel <tino.keitel+iwl@tikei.de>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: =?utf-8?B?T25kxZllaiBLdcSNZXJh?= <ondrej.kucera@centrum.cz>,
	jikos@suse.cz, yi.zhu@intel.com, reinette.chatre@intel.com,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Subject: Re: [ipw3945-devel] PROBLEM: Led for wifi blinking all the time
Message-ID: <20081103201412.GB8059@x61> (sfid-20081103_211419_530804_5478AD9C)
References: <490A5D39.1090605@centrum.cz> <20081031145434.GB4310@tuxdriver.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Q68bSM7Ycu6FN28Q"
In-Reply-To: <20081031145434.GB4310@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Fri, Oct 31, 2008 at 10:54:35 -0400, John W. Linville wrote:
> On Fri, Oct 31, 2008 at 02:19:53AM +0100, Ondřej Kučera wrote:
> > Hello,
> >
> > this is my first kernel bug report ever so I'm not 100% sure about the  
> > protocol but I'll try my best...
> >
> > After upgrading to 2.6.27 the wifi led starts blinking right after  
> > connecting to the network and then continues blinking even when there's  
> > no network traffic at all. This wasn't happening before, the led used to  
> > be just "on" when I was connected but not generating any traffic.
> >
> > Up to kernel 2.6.26.5 (the last 2.6.26.* kernel in my distribution -  
> > ArchLinux) the behavior was correct, the problem first occurred with  
> > 2.6.27 and is present up to 2.6.27.4 (the last of 2.6.27.* I've tried).  
> > The driver used is iwl3945, the corresponding line from lspci:
> > 03:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG  
> > Network Connection (rev 02)
> >
> > If any other information is relevant, please tell me and I'll try to  
> > provide it, too.
> 
> I'm pretty sure this is how the iwlwifi team wants the LEDs to work...

To change from the annoying blinking to some more decent traffic
indicator, I wrote a small patch. I attached the version for 2.6.27.

Regards,
Tino

--Q68bSM7Ycu6FN28Q
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="iwl-shorter-blink_2.6.27.patch"

diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index 4eee1b1..50eff75 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -69,7 +69,7 @@ static const struct {
 	{15, 95, 95 },
 	{10, 110, 110},
 	{5, 130, 130},
-	{0, 167, 167},
+	{0, 25, 25},
 /* SOLID_ON */
 	{-1, IWL_LED_SOLID, 0}
 };
@@ -289,7 +289,7 @@ static int iwl_get_blink_rate(struct iwl_priv *priv)
 	if (!priv->allow_blinking)
 		i = IWL_MAX_BLINK_TBL;
 	else
-		for (i = 0; i < IWL_MAX_BLINK_TBL; i++)
+		for (i = IWL_MAX_BLINK_TBL - 1 ; i < IWL_MAX_BLINK_TBL; i++)
 			if (tpt  > (blink_tbl[i].tpt * IWL_1MB_RATE))
 				break;
 
@@ -326,7 +326,7 @@ void iwl_leds_background(struct iwl_priv *priv)
 	}
 	if (!priv->last_blink_time ||
 	    !time_after(jiffies, priv->last_blink_time +
-			msecs_to_jiffies(1000)))
+			msecs_to_jiffies(40)))
 		return;
 
 	blink_idx = iwl_get_blink_rate(priv);

--Q68bSM7Ycu6FN28Q--
