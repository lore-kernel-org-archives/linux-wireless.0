Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:35726 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014Ab2FNEgd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2012 00:36:33 -0400
Message-ID: <4FD96A4B.9080803@qca.qualcomm.com> (sfid-20120614_063637_825179_CE4EB561)
Date: Thu, 14 Jun 2012 10:06:27 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 3.0+] ath9k: Fix softlockup in AR9485(backported)
References: <1339603089-16090-1-git-send-email-mohammed@qca.qualcomm.com> <20440.47742.504036.782035@gargle.gargle.HOWL>
In-Reply-To: <20440.47742.504036.782035@gargle.gargle.HOWL>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sujith,

On Wednesday 13 June 2012 09:36 PM, Sujith Manoharan wrote:
> Mohammed Shafi Shajakhan wrote:
>> From: Mohammed Shafi Shajakhan<mohammed@qca.qualcomm.com>
>>
>> Please note this is the backported version for the linux
>> stable tree, while the patch for wireless-testing tree
>> http://permalink.gmane.org/gmane.linux.kernel.wireless.general/92608
>>
>> steps to recreate:
>> load latest ath9k driver with AR9485
>> stop the network-manager and wpa_supplicant
>> bring the interface up
>>
>> 	Call Trace:
>> 	[<ffffffffa0517490>] ? ath_hw_check+0xe0/0xe0 [ath9k]
>> 	[<ffffffff812cd1e8>] __const_udelay+0x28/0x30
>> 	[<ffffffffa03bae7a>] ar9003_get_pll_sqsum_dvc+0x4a/0x80 [ath9k_hw]
>> 	[<ffffffffa05174eb>] ath_hw_pll_work+0x5b/0xe0 [ath9k]
>> 	[<ffffffff810744fe>] process_one_work+0x11e/0x470
>> 	[<ffffffff8107530f>] worker_thread+0x15f/0x360
>> 	[<ffffffff810751b0>] ? manage_workers+0x230/0x230
>> 	[<ffffffff81079af3>] kthread+0x93/0xa0
>> 	[<ffffffff815fd3a4>] kernel_thread_helper+0x4/0x10
>> 	[<ffffffff81079a60>] ? kthread_freezable_should_stop+0x70/0x70
>> 	[<ffffffff815fd3a0>] ? gs_change+0x13/0x13
>>
>> ensure that the PLL-WAR for AR9485/AR9340 is executed only if the STA is
>> associated (or) IBSS/AP mode had started beaconing. Ideally this WAR
>> is needed to recover from some rare beacon stuck during stress testing.
>> Before the STA is associated/IBSS had started beaconing, PLL4(0x1618c)
>> always seem to have zero even though we had configured PLL3(0x16188) to
>> query about PLL's locking status. When we keep on polling infinitely PLL4's
>> 8th bit(ie check for PLL locking measurements is done), machine hangs
>> due to softlockup.
>
> While I do agree that this patch fixes the regression for AR9485 chipsets,
> the code in ar9003_get_pll_sqsum_dvc needs to be fixed, i.e., to not loop
> till the end of time and have a timeout.
>

agreed, i already have a patch for that and did some tests too :)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c 
b/drivers/net/wireless/ath/ath9k/hw.c
index 6fa8128..932199c 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -719,13 +719,26 @@ static void ath9k_hw_init_qos(struct ath_hw *ah)

  u32 ar9003_get_pll_sqsum_dvc(struct ath_hw *ah)
  {
+       int i = 0;
+       struct ath_common *common = ath9k_hw_common(ah);
+
         REG_CLR_BIT(ah, PLL3, PLL3_DO_MEAS_MASK);
         udelay(100);
         REG_SET_BIT(ah, PLL3, PLL3_DO_MEAS_MASK);

-       while ((REG_READ(ah, PLL4) & PLL4_MEAS_DONE) == 0)
+       while ((REG_READ(ah, PLL4) & PLL4_MEAS_DONE) == 0) {
+
+               i++;
                 udelay(100);

+               if (i > 100) {
+                       ath_err(common, "PLL4 meaurement not done");
+                       WARN_ON(1);
+                       break;
+               }
+
+       }
+
         return (REG_READ(ah, PLL3) & SQSUM_DVC_MASK) >> 3;
  }
  EXPORT_SYMBOL(ar9003_get_pll_sqsum_dvc);


during my testing i found that, when things are fine we would usually 
break out when i = 2. will send this patch too. thanks for your thoughts!


-- 
thanks,
shafi
