Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:52265 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756632AbaHHKpl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Aug 2014 06:45:41 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/6] ath10k: remove target soc ps code
References: <1407402212-29809-1-git-send-email-michal.kazior@tieto.com>
	<1407402212-29809-3-git-send-email-michal.kazior@tieto.com>
Date: Fri, 8 Aug 2014 13:45:31 +0300
In-Reply-To: <1407402212-29809-3-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 7 Aug 2014 11:03:28 +0200")
Message-ID: <878umzz2d0.fsf@kamboji.qca.qualcomm.com> (sfid-20140808_124550_773657_3E032126)
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

This one introduced new warnings:

drivers/net/wireless/ath/ath10k/pci.c:646:5: warning: symbol 'ath10k_pci_wake' was not declared. Should it be static?
drivers/net/wireless/ath/ath10k/pci.c:653:6: warning: symbol 'ath10k_pci_sleep' was not declared. Should it be static?

Is it okay if I fix it like this:

--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -643,14 +643,14 @@ static int ath10k_pci_wake_wait(struct ath10k *ar)
        return -ETIMEDOUT;
 }
 
-int ath10k_pci_wake(struct ath10k *ar)
+static int ath10k_pci_wake(struct ath10k *ar)
 {
        ath10k_pci_reg_write32(ar, PCIE_SOC_WAKE_ADDRESS,
                               PCIE_SOC_WAKE_V_MASK);
        return ath10k_pci_wake_wait(ar);
 }
 
-void ath10k_pci_sleep(struct ath10k *ar)
+static void ath10k_pci_sleep(struct ath10k *ar)
 {
        ath10k_pci_reg_write32(ar, PCIE_SOC_WAKE_ADDRESS,
                               PCIE_SOC_WAKE_RESET);


-- 
Kalle Valo
