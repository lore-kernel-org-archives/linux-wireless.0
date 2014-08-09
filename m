Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:45052 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbaHISV0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Aug 2014 14:21:26 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/6] ath10k: remove target soc ps code
References: <1407402212-29809-1-git-send-email-michal.kazior@tieto.com>
	<1407402212-29809-3-git-send-email-michal.kazior@tieto.com>
Date: Sat, 9 Aug 2014 21:21:18 +0300
In-Reply-To: <1407402212-29809-3-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 7 Aug 2014 11:03:28 +0200")
Message-ID: <87ha1lttgh.fsf@kamboji.qca.qualcomm.com> (sfid-20140809_202131_619012_69774D13)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> The soc powersave was disabled by default. It
> never was fully tested. Some hw apparently had
> problems with it and the implementation itself had
> a possible race.
>
> Just remove the refcounting and simply wake up the
> device when probing and put to sleep when
> removing.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

[...]

> @@ -1838,12 +1799,6 @@ static int ath10k_pci_warm_reset(struct ath10k *ar)
>  
>  	ath10k_dbg(ATH10K_DBG_BOOT, "boot warm reset\n");
>  
> -	ret = ath10k_do_pci_wake(ar);
> -	if (ret) {
> -		ath10k_err("failed to wake up target: %d\n", ret);
> -		return ret;
> -	}
> -
>  	/* debug */
>  	val = ath10k_pci_read32(ar, SOC_CORE_BASE_ADDRESS +
>  				PCIE_INTR_CAUSE_ADDRESS);
> @@ -1915,7 +1870,6 @@ static int ath10k_pci_warm_reset(struct ath10k *ar)
>  
>  	ath10k_dbg(ATH10K_DBG_BOOT, "boot warm reset complete\n");
>  
> -	ath10k_do_pci_sleep(ar);
>  	return ret;
>  }

For some reason I don't get all kbuild emails, and I don't know if you
got it either, but smatch found a style error here:

>> drivers/net/wireless/ath/ath10k/pci.c:1797:5-8: Unneeded variable: "ret". Return "0" on line 1873

I made this change:

--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1794,7 +1794,6 @@ static void ath10k_pci_warm_reset_si0(struct ath10k *ar)
 
 static int ath10k_pci_warm_reset(struct ath10k *ar)
 {
-       int ret = 0;
        u32 val;
 
        ath10k_dbg(ATH10K_DBG_BOOT, "boot warm reset\n");
@@ -1870,7 +1869,7 @@ static int ath10k_pci_warm_reset(struct ath10k *ar)
 
        ath10k_dbg(ATH10K_DBG_BOOT, "boot warm reset complete\n");
 
-       return ret;
+       return 0;
 }
 
 static int __ath10k_pci_hif_power_up(struct ath10k *ar, bool cold_reset)

-- 
Kalle Valo
