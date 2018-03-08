Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41298 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755256AbeCHN7d (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Mar 2018 08:59:33 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Thu, 08 Mar 2018 19:29:31 +0530
From: govinds@codeaurora.org
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Govind Singh <govinds@qti.qualcomm.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        ath10k@lists.infradead.org
Subject: Re: [PATCH] ath10k: Enable IOMMU support for WCN3990 target
In-Reply-To: <87k1umhe0w.fsf@kamboji.qca.qualcomm.com>
References: <1518685448-15317-1-git-send-email-govinds@codeaurora.org>
 <877eqwqfml.fsf@kamboji.qca.qualcomm.com>
 <CAK8P3a1KomtVHMidxtmx_gRF+92MWdHmeG0eTbcfUpbAaDPe3g@mail.gmail.com>
 <588e4d951bd84ea29dfc1a68353505e7@aphydexm01b.ap.qualcomm.com>
 <CAK8P3a06sDwL8iech_L3Q-zGxio3_RD8c7_-L3HHmFmb=Pq2UQ@mail.gmail.com>
 <87k1umhe0w.fsf@kamboji.qca.qualcomm.com>
Message-ID: <7c627e2af862e2cfdd431a499f725000@codeaurora.org> (sfid-20180308_145937_362493_CC4775AA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-03-08 19:20, Kalle Valo wrote:
> Arnd Bergmann <arnd@arndb.de> writes:
> 
>> On Thu, Mar 1, 2018 at 2:18 PM, Govind Singh 
>> <govinds@qti.qualcomm.com> wrote:
>>>>> The asm/dma-iommu.h header file exsists only on arm32, no other 
>>>>> architecture.
>>>>> I'm not sure about the purpose of the patch to start with:
>>>>> it's normally up to the platform code to allocate IOMMU domains,
>>>>> device drivers should only need to manually interact with the
>>>>> IOMMU layer if they need more than one domain, but this ath10k
>>>>> patch appears to be using the default domain and should have no
>>>>> effect as long as the platform code works correctly.
>>> Thanks Arnd, I have fixed this and migrated to 64bit
>>> API's(iommu_attach_device/iommu_detach_device/
>>> iommu_get_domain_for_dev), will share the next revision.
>>> I tried using the default domain by adding the stream ID and mask in
>>> dt and no manual interaction, but it is resulting in TZ error and
>>> unhandled context fault.
>>> Seems I need to provide explicit mapping range(aperture_start/
>>> aperture_end) as this is only working combination for me..
>> 
>> I don't see why you need to do that at all, can you clarify?
>> 
>> The IOMMU should be set up implicitly for you here based on the iommus
>> property in DT, with no driver changes at all. This should work on all
>> architectures/
> 
> Maybe Govind is using some out-of-tree tree which is buggy in this
> regard?

Actually there is limitations in using the iova address range for wlan 
IP.
It can allow certain iova range and i was attaching the iommu to specify 
the iova range.
I am exploring if i can use "dma-ranges" in dt to avoid the manual 
interaction apart from
stream ID and mask.

BR,
Govind
