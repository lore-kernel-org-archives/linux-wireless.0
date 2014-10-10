Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:36158 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbaJJHg6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2014 03:36:58 -0400
Received: by mail-wg0-f45.google.com with SMTP id m15so3135550wgh.4
        for <linux-wireless@vger.kernel.org>; Fri, 10 Oct 2014 00:36:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1412842950-14098-4-git-send-email-michal.kazior@tieto.com>
References: <1412842950-14098-1-git-send-email-michal.kazior@tieto.com>
	<1412842950-14098-4-git-send-email-michal.kazior@tieto.com>
Date: Fri, 10 Oct 2014 09:36:57 +0200
Message-ID: <CA+BoTQmZXuo+NkkzE++Puf19ZfRWk7DdLWwonNn7YuREryfEwA@mail.gmail.com> (sfid-20141010_093702_248835_2063824B)
Subject: Re: [PATCH 3/5] ath10k: make warm reset a bit safer and faster
From: Michal Kazior <michal.kazior@tieto.com>
To: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9 October 2014 10:22, Michal Kazior <michal.kazior@tieto.com> wrote:
> One of the problems with warm reset I've found is
> that it must be guaranteed that copy engine
> registers are not being accessed while being
> reset. Otherwise in worst case scenario the host
> may lock up.
>
> Instead of using sleeps and hoping the device is
> operational in some arbitrary timeframes use
> firmware indication register.
>
> As a side effect this makes driver
> boot/stop/recovery faster.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
[...]
> +static int ath10k_pci_warm_reset(struct ath10k *ar)
> +{
> +       int ret;
> +
> +       ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot warm reset\n");
>
> -       /* debug */
> -       val = ath10k_pci_read32(ar, SOC_CORE_BASE_ADDRESS +
> -                               PCIE_INTR_CAUSE_ADDRESS);
> -       ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot host cpu intr cause: 0x%08x\n",
> -                  val);
> +       spin_lock_bh(&ar->data_lock);
> +       ar->stats.fw_warm_reset_counter++;
> +       spin_unlock_bh(&ar->data_lock);
>
> -       val = ath10k_pci_read32(ar, SOC_CORE_BASE_ADDRESS +
> -                               CPU_INTR_ADDRESS);
> -       ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot target cpu intr cause: 0x%08x\n",
> -                  val);
> +       ath10k_pci_irq_disable(ar);
>
> -       /* CPU warm reset */
> -       val = ath10k_pci_read32(ar, RTC_SOC_BASE_ADDRESS +
> -                               SOC_RESET_CONTROL_ADDRESS);
> -       ath10k_pci_write32(ar, RTC_SOC_BASE_ADDRESS + SOC_RESET_CONTROL_ADDRESS,
> -                          val | SOC_RESET_CONTROL_CPU_WARM_RST_MASK);
> +       /* Make sure the target CPU is not doing anything dangerous, e.g. if it
> +        * were to access copy engine while host performs copy engine reset
> +        * then it is possible for the device to confuse pci-e controller to
> +        * the point of bringing host system to a complete stop (i.e. hang).
> +        */
> +       ath10k_pci_warm_reset_si0(ar);
> +       ath10k_pci_warm_reset_cpu(ar);
> +       ath10k_pci_wait_for_target_init(ar);

Since warm_reset now calls wait_for_target_init (and thus can report a
target register dump on crash) and is called in pci_probe CE must be
initialized (which isn't the case in the code now). This can lead to
system crash on very early firmware crash during probing. Kudos to
Janusz for finding this out!

I'll respin a v2 later.


Michał
