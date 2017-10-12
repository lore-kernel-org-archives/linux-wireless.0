Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:36745 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751587AbdJLAnn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Oct 2017 20:43:43 -0400
MIME-Version: 1.0
In-Reply-To: <20171012003805.GA89253@google.com>
References: <20170919232416.108247-1-briannorris@chromium.org> <20171012003805.GA89253@google.com>
From: Adrian Chadd <adrian@freebsd.org>
Date: Wed, 11 Oct 2017 17:43:40 -0700
Message-ID: <CAJ-Vmo=HF6g9cOsxyn_xkRvpqd0PVgXWESvASi51ccUwNA3hxg@mail.gmail.com> (sfid-20171012_024401_559286_D7B6939F)
Subject: Re: [PATCH] ath10k: fix core PCI suspend when WoWLAN is supported but disabled
To: Brian Norris <briannorris@chromium.org>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Grant Grundler <grundler@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ryan Hsu <ryanhsu@qti.qualcomm.com>,
        Michal Kazior <michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

fwiw - I did this on my in progress ath10k port to freebsd, and I've
tested it on Rome and Peregrine. It seems to be the right thing to do
during suspend to at least cleanly shut things down.


-adrian


On 11 October 2017 at 17:38, Brian Norris <briannorris@chromium.org> wrote:
> Ping? Any comments? I know there's more than one way to slice this
> problem, but it's most definitely a problem...
>
> Brian
>
> On Tue, Sep 19, 2017 at 04:24:16PM -0700, Brian Norris wrote:
>> For devices where the FW supports WoWLAN but user-space has not
>> configured it, we don't do any PCI-specific suspend/resume operations,
>> because mac80211 doesn't call drv_suspend() when !wowlan. This has
>> particularly bad effects for some platforms, because we don't stop the
>> power-save timer, and if this timer goes off after the PCI controller
>> has suspended the link, Bad Things will happen.
>>
>> Commit 32faa3f0ee50 ("ath10k: add the PCI PM core suspend/resume ops")
>> got some of this right, in that it understood there was a problem on
>> non-WoWLAN firmware. But it forgot the $subject case.
>>
>> Fix this by moving all the PCI driver suspend/resume logic exclusively
>> into the driver PM hooks. This shouldn't affect WoWLAN support much
>> (this just gets executed later on).
>>
>> I would just as well kill the entirety of ath10k_hif_suspend(), as it's
>> not even implemented on the USB or SDIO drivers. I expect that we don't
>> need the callback, except to return "supported" (i.e., 0) or "not
>> supported" (i.e., -EOPNOTSUPP).
>>
>> Fixes: 32faa3f0ee50 ("ath10k: add the PCI PM core suspend/resume ops")
>> Fixes: 77258d409ce4 ("ath10k: enable pci soc powersaving")
>> Signed-off-by: Brian Norris <briannorris@chromium.org>
>> Cc: Ryan Hsu <ryanhsu@qti.qualcomm.com>
>> Cc: Kalle Valo <kvalo@qca.qualcomm.com>
>> Cc: Michal Kazior <michal.kazior@tieto.com>
>> ---
>>  drivers/net/wireless/ath/ath10k/pci.c | 24 ++++++++++++++----------
>>  1 file changed, 14 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
>> index bc1633945a56..4655c944e3fd 100644
>> --- a/drivers/net/wireless/ath/ath10k/pci.c
>> +++ b/drivers/net/wireless/ath/ath10k/pci.c
>> @@ -2580,6 +2580,12 @@ void ath10k_pci_hif_power_down(struct ath10k *ar)
>>  #ifdef CONFIG_PM
>>
>>  static int ath10k_pci_hif_suspend(struct ath10k *ar)
>> +{
>> +     /* Nothing to do; the important stuff is in the driver suspend. */
>> +     return 0;
>> +}
>> +
>> +static int ath10k_pci_suspend(struct ath10k *ar)
>>  {
>>       /* The grace timer can still be counting down and ar->ps_awake be true.
>>        * It is known that the device may be asleep after resuming regardless
>> @@ -2592,6 +2598,12 @@ static int ath10k_pci_hif_suspend(struct ath10k *ar)
>>  }
>>
>>  static int ath10k_pci_hif_resume(struct ath10k *ar)
>> +{
>> +     /* Nothing to do; the important stuff is in the driver resume. */
>> +     return 0;
>> +}
>> +
>> +static int ath10k_pci_resume(struct ath10k *ar)
>>  {
>>       struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
>>       struct pci_dev *pdev = ar_pci->pdev;
>> @@ -3403,11 +3415,7 @@ static int ath10k_pci_pm_suspend(struct device *dev)
>>       struct ath10k *ar = dev_get_drvdata(dev);
>>       int ret;
>>
>> -     if (test_bit(ATH10K_FW_FEATURE_WOWLAN_SUPPORT,
>> -                  ar->running_fw->fw_file.fw_features))
>> -             return 0;
>> -
>> -     ret = ath10k_hif_suspend(ar);
>> +     ret = ath10k_pci_suspend(ar);
>>       if (ret)
>>               ath10k_warn(ar, "failed to suspend hif: %d\n", ret);
>>
>> @@ -3419,11 +3427,7 @@ static int ath10k_pci_pm_resume(struct device *dev)
>>       struct ath10k *ar = dev_get_drvdata(dev);
>>       int ret;
>>
>> -     if (test_bit(ATH10K_FW_FEATURE_WOWLAN_SUPPORT,
>> -                  ar->running_fw->fw_file.fw_features))
>> -             return 0;
>> -
>> -     ret = ath10k_hif_resume(ar);
>> +     ret = ath10k_pci_resume(ar);
>>       if (ret)
>>               ath10k_warn(ar, "failed to resume hif: %d\n", ret);
>>
>> --
>> 2.14.1.690.gbb1197296e-goog
>>
