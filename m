Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:52916 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752392AbdJMUkp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Oct 2017 16:40:45 -0400
Message-ID: <59E124EB.6090602@candelatech.com> (sfid-20171013_224117_594672_AFAA1038)
Date: Fri, 13 Oct 2017 13:41:15 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Adrian Chadd <adrian@freebsd.org>,
        Kalle Valo <kvalo@qca.qualcomm.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH v2] ath10k: Retry pci probe on failure.
References: <1507068826-14677-1-git-send-email-greearb@candelatech.com> <87a80vnrsb.fsf@kamboji.qca.qualcomm.com> <CAJ-Vmon0SszxH22Zb+O5RVQSommFFuc5XmG+at9=xbGagOb7PQ@mail.gmail.com>
In-Reply-To: <CAJ-Vmon0SszxH22Zb+O5RVQSommFFuc5XmG+at9=xbGagOb7PQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/13/2017 08:50 AM, Adrian Chadd wrote:
> On 13 October 2017 at 05:41, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> greearb@candelatech.com writes:
>>
>>> From: Ben Greear <greearb@candelatech.com>
>>>
>>> This works around a problem we see when sometimes the wifi NIC does
>>> not respond the first time.  This seems to happen especially often on
>>> some of the 9984 NICs in mid-range platforms.
>>>
>>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>>
>> [...]
>>
>>> -static int ath10k_pci_probe(struct pci_dev *pdev,
>>> -                         const struct pci_device_id *pci_dev)
>>> +static int __ath10k_pci_probe(struct pci_dev *pdev,
>>> +                           const struct pci_device_id *pci_dev)
>>>   {
>>>        int ret = 0;
>>>        struct ath10k *ar;
>>> @@ -3672,6 +3672,22 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
>>>        return ret;
>>>   }
>>>
>>> +static int ath10k_pci_probe(struct pci_dev *pdev,
>>> +                         const struct pci_device_id *pci_dev)
>>> +{
>>> +     int cnt = 0;
>>> +     int rv;
>>> +     do {
>>> +             rv = __ath10k_pci_probe(pdev, pci_dev);
>>> +             if (rv == 0)
>>> +                     return rv;
>>> +             pr_err("ath10k: failed to probe PCI : %d, retry-count: %d\n", rv, cnt);
>>> +             mdelay(10); /* let the ath10k firmware gerbil take a small break */
>>> +     } while (cnt++ < 10);
>>> +     return rv;
>>> +}
>>
>> This is a sledgehammer approach and it causes reload for all error
>> cases, like when hardware is broken or memory allocation is failing.
>>
>> When the problem happens does it always fail at the the same place? Is
>> it hw reset or something else? It's better to retry the invidiual action
>> than to do this hack. Or is it just some more delay needed somewhere?
>
> I am seeing WMI timeouts during initial firmware load and wait on
> QCA9984 + BCM7444S SoC.
> My guess is the WMI wakeup time is not "right" enough and needs to be
> extended a little bit.
>
> But then, I have played a lot of whackamole with WMI timeouts during
> my loooong porting effort..

The failure I saw was a failure to wake pci, and from comments, it seems that
the current wait is longer than what should be required, and it warns on slow
wakes, and I never saw that warning.  So I assume that waiting longer would not help.

I saw it fail twice in a row to wake pci and then succeed on the third try, for instance,
when testing my patch.

As for a big hammer, I guess we could check for certain return codes if you think
that is better than just retrying all failures?

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
