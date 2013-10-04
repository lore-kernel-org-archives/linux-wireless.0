Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:4395 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754664Ab3JDOg6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Oct 2013 10:36:58 -0400
Date: Fri, 4 Oct 2013 16:38:23 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH v2 3/4] rt2x00: rt2800lib: fix default VGC
 values for RT3593
Message-ID: <20131004143822.GC7842@localhost.localdomain> (sfid-20131004_163702_430652_33F4DD44)
References: <1380823243-11149-1-git-send-email-juhosg@openwrt.org>
 <1380823243-11149-3-git-send-email-juhosg@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1380823243-11149-3-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 03, 2013 at 08:00:42PM +0200, Gabor Juhos wrote:
> Update the rt2800_get_default_vgc function to use the same VGC
> values that the DPO_RT5572_LinuxSTA_2.6.1.3_20121022 reference
> driver uses.
> 
> References:
>   RT35xx_ChipAGCAdjust in chips/rt35xx.c
>   RT3593_R66_MID_LOW_SENS_GET macro in include/chip/rt3593.h
>   RT3593_R66_NON_MID_LOW_SEMS_GET macro in include/chips/rt3593.h
> 
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>

Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>

> @@ -4422,6 +4423,8 @@ static u8 rt2800_get_default_vgc(struct rt2x00_dev *rt2x00dev)
>  	} else { /* 5GHZ band */
>  		if (rt2x00_rt(rt2x00dev, RT3572))
>  			vgc = 0x22 + (rt2x00dev->lna_gain * 5) / 3;

Looks RT3572 values should be also changed ? According to:

                if (pAd->CommonCfg.BBPCurrentBW == BW_20)
                {
                        R66 = 0x32 + (lanGain*5) / 3;
                        if (Rssi > RSSI_FOR_MID_LOW_SENSIBILITY)
                                R66 += 0x10;
                }
                else
                {
                        R66 = 0x3A + (lanGain*5)/3;
                        if (Rssi > RSSI_FOR_MID_LOW_SENSIBILITY)
                                R66 += 0x10;
                }       

