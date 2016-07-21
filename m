Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60819 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462AbcGUMBO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2016 08:01:14 -0400
Message-ID: <5790B988.3080600@redhat.com> (sfid-20160721_140118_005581_8BB6F1CD)
Date: Thu, 21 Jul 2016 08:01:12 -0400
From: Prarit Bhargava <prarit@redhat.com>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: Emmanuel Grumbach <egrumbach@gmail.com>,
	Michal Kazior <michal.kazior@tieto.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath10k <ath10k@lists.infradead.org>,
	Arend van Spriel <arend@broadcom.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ming Lei <ming.lei@canonical.com>
Subject: Re: [RFC] ath10k: silence firmware file probing warnings
References: <1468933237-5226-1-git-send-email-michal.kazior@tieto.com> <20160721070938.GA2658@redhat.com> <CANUX_P3ADxi+RHkH=d8Ypcqy9WVKSu4JYH7K3HtTNCuWg3wCeQ@mail.gmail.com> <20160721080541.GB2658@redhat.com> <5790A28F.8030102@redhat.com> <20160721115122.GA31869@redhat.com>
In-Reply-To: <20160721115122.GA31869@redhat.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 07/21/2016 07:51 AM, Stanislaw Gruszka wrote:
> (cc: firmware and brcmfmac maintainers)

<snip>

>>>
>>> I'm not sure if replacing to request_firmware_direct() is a good
>>> fix though. For example I can see this problem also on brcmfmac, which
>>> use request_firmware_nowait(). I think I would rather prefer special
>>> helper for firmware drivers that needs user helper and have
>>> request_firmware() be direct as default.
>>>
>>
>> The difference between request_firmware_direct() and request_firmware() is that
>> the _direct() version does not wait the 60 seconds for udev interaction.  The
>> only userspace check performed is to see if the file is there, and if the file
>> does exist it is provided to the driver to be applied to the hardware.
>>
>> So the real question to ask here is whether or not the ath10k, brcmfmac, and
>> iwlwifi require udev to do anything beyond checking for the existence and
>> loading the firmware image.  If they don't, then it is better to use
>> request_firmware_direct().
> 
> They don't need that, like 99% of the drivers I think, hence changing the
> default seems to be more reasonable. However changing 3 drivers would work

I think I argued for that a while back and changing the default was rejected.
I can't remember why it was rejected :(.  It may have had something to do with
the complexity of getting a large number of driver maintainers to ack the change.

> for me as well, and that change do not introduce risk of broking drivers
> that require udev fw download.

In my experience, there are very few drivers that actually require userspace
interaction beyond verifying the image location.  (The one that comes to mind is
the dell_rbu driver which attempts to download FW images)

> 
> iwlwifi and ath10k are trivial, bcrmfmac is a bit more complex as it
> use request_firmware_nowait(), so it first need to be converted to
> ordinary request_firmware(), but this should be doable and I can do
> that.
> 
> However I wonder if changing that will not broke the case when
> driver is build-in in the kernel and f/w is not yet available when
> driver start to initialize. 

As you say below ...

Or maybe nowadays this is not the case
> any longer, i.e. the MODULE_FIRMWARE macros assure proper f/w 
> images are build-in in the kernel or copied to initramfs?

This is correct AFAIU.  If MODULE_FIRMWARE=y then the firmware should be loaded
into the kernel image temp fs and/or initramfs.  This of course assumes that the
person building the image is smart enough to have installed the FW on their system.

P.
