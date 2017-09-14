Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:56332 "EHLO
        mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751268AbdINRo2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Sep 2017 13:44:28 -0400
Received: by mail-it0-f45.google.com with SMTP id g18so1060887itg.5
        for <linux-wireless@vger.kernel.org>; Thu, 14 Sep 2017 10:44:28 -0700 (PDT)
Subject: Re: iwlwifi firmware load broken in current -git
From: Jens Axboe <axboe@kernel.dk>
To: Srinath Mannam <srinath.mannam@broadcom.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Luca Coelho <luca@coelho.fi>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        linuxwifi <linuxwifi@intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
References: <04c9b578-693c-1dc6-9f0f-904580231b21@kernel.dk>
 <1505232673.5400.243.camel@intel.com> <1505234187.5400.249.camel@coelho.fi>
 <4bcbcbc1-7c79-09f0-5071-bc2f53bf6574@kernel.dk>
 <1505246657.1974.11.camel@sipsolutions.net>
 <feabbc25-eb85-ffa2-0fd6-254c07e3574b@kernel.dk>
 <CAErSpo777jq9FVRtmoHXVbzE-ZOc7mnT+eRJ_PhP_Dd=MbKv4g@mail.gmail.com>
 <e7af2f85-0ab3-e524-a544-c2ccdf4f8bd6@kernel.dk>
 <CABe79T7WObM+LOGdPFfYC7hf0dKrhm5NwMgQ3DpcWst3eP6kNg@mail.gmail.com>
 <8de8d1e2-1673-e1ff-d0ac-6d3bb03e9e99@kernel.dk>
Message-ID: <93bfbc9b-8829-66fa-f4d6-6d47124e460c@kernel.dk> (sfid-20170914_194431_951087_A23F5749)
Date: Thu, 14 Sep 2017 11:44:25 -0600
MIME-Version: 1.0
In-Reply-To: <8de8d1e2-1673-e1ff-d0ac-6d3bb03e9e99@kernel.dk>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/14/2017 11:35 AM, Jens Axboe wrote:
> On 09/14/2017 11:28 AM, Srinath Mannam wrote:
>> Hi Bjorn,
>>
>> On Thu, Sep 14, 2017 at 10:52 PM, Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>> On 09/14/2017 11:11 AM, Bjorn Helgaas wrote:
>>>> [+cc linux-pci]
>>>>
>>>> On Thu, Sep 14, 2017 at 12:00 PM, Jens Axboe <axboe@kernel.dk> wrote:
>>>>> On 09/12/2017 02:04 PM, Johannes Berg wrote:
>>>>>> On Tue, 2017-09-12 at 13:43 -0600, Jens Axboe wrote:
>>>>>>
>>>>>>> CC'ing the guilty part and Bjorn. I'm assuming it's the
>>>>>>> pci_is_enabled() check, since the rest of the patch shouldn't have
>>>>>>> functional changes.
>>>>>>
>>>>>> and pci_enable_bridge() already checks if it's already enabled, but
>>>>>> still enables mastering in that case if it isn't:
>>>>>>
>>>>>> static void pci_enable_bridge(struct pci_dev *dev)
>>>>>> {
>>>>>> [...]
>>>>>>         if (pci_is_enabled(dev)) {
>>>>>>                 if (!dev->is_busmaster)
>>>>>>                         pci_set_master(dev);
>>>>>>                 return;
>>>>>>         }
>>>>>>
>>>>>> so I guess due to the new check we end up with mastering disabled, and
>>>>>> thus the firmware can't load since that's a DMA thing?
>>>>>
>>>>> Bjorn/Srinath, any input here? This is a regression that prevents wifi
>>>>> from working on a pretty standard laptop. It'd suck to have this be in
>>>>> -rc1. Seems like the trivial fix would be:
>>>>>
>>>>>
>>>>> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
>>>>> index b0002daa50f3..ffbe11dbdd61 100644
>>>>> --- a/drivers/pci/pci.c
>>>>> +++ b/drivers/pci/pci.c
>>>>> @@ -1394,7 +1394,7 @@ static int pci_enable_device_flags(struct pci_dev *dev, unsigned long flags)
>>>>>                 return 0;               /* already enabled */
>>>>>
>>>>>         bridge = pci_upstream_bridge(dev);
>>>>> -       if (bridge && !pci_is_enabled(bridge))
>>>>> +       if (bridge)
>> With this change and keeping "mutex_lock(&pci_bridge_mutex);" in
>> pci_enable_bridge functoin will causes a nexted lock.
> 
> Took a look, and looks like you are right. That code looks like a mess,
> fwiw.
> 
> I'd strongly suggest that the bad commit is reverted until a proper
> solution is found, since the simple one-liner could potentially
> introduce a deadlock with your patch applied.

BTW, your patch looks pretty bad too, introducing a random mutex
deep on code that can be recursive. Why isn't this check in
pci_enable_device_flags() enough to prevent double-enable of
an upstream bridge?

if (atomic_inc_return(&dev->enable_cnt) > 1)                            
	return 0;               /* already enabled */

-- 
Jens Axboe
