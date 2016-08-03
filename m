Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:37831 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939AbcHCTT5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Aug 2016 15:19:57 -0400
Received: by mail-wm0-f52.google.com with SMTP id i5so350339219wmg.0
        for <linux-wireless@vger.kernel.org>; Wed, 03 Aug 2016 12:19:18 -0700 (PDT)
Subject: Re: [RFC] ath10k: silence firmware file probing warnings
To: "Luis R. Rodriguez" <mcgrof@kernel.org>,
	"Valo, Kalle" <kvalo@qca.qualcomm.com>
References: <5790A28F.8030102@redhat.com> <20160721115122.GA31869@redhat.com>
 <a264e995-fc46-7fcd-69f9-80992385b6b1@broadcom.com>
 <20160722102559.GA2662@redhat.com> <20160722221523.GM5537@wotan.suse.de>
 <874m738m02.fsf@kamboji.qca.qualcomm.com>
 <20160802141610.GJ3296@wotan.suse.de>
 <ae734397-6179-d0ba-3d8a-0cffc63a0fd8@broadcom.com>
 <20160803142119.GL3296@wotan.suse.de> <87ziot51x9.fsf@qca.qualcomm.com>
 <20160803171044.GP3296@wotan.suse.de>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	Prarit Bhargava <prarit@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ming Lei <ming.lei@canonical.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath10k <ath10k@lists.infradead.org>,
	"mmarek@suse.com" <mmarek@suse.com>,
	"michal.kazior@tieto.com" <michal.kazior@tieto.com>,
	Arend van Spriel <arend@broadcom.com>,
	Emmanuel Grumbach <egrumbach@gmail.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <6fb6f394-83fe-87e6-ef49-9fa854899721@broadcom.com> (sfid-20160803_212021_872449_083AF5A9)
Date: Wed, 3 Aug 2016 21:19:14 +0200
MIME-Version: 1.0
In-Reply-To: <20160803171044.GP3296@wotan.suse.de>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 03-08-16 19:10, Luis R. Rodriguez wrote:
> On Wed, Aug 03, 2016 at 03:04:39PM +0000, Valo, Kalle wrote:
>> "Luis R. Rodriguez" <mcgrof@kernel.org> writes:
>>
>>> On Wed, Aug 03, 2016 at 01:33:31PM +0200, Arend van Spriel wrote:
>>>> On 02-08-16 16:16, Luis R. Rodriguez wrote:
>>>>> On Tue, Aug 02, 2016 at 11:10:22AM +0000, Valo, Kalle wrote:
>>>>>> "Luis R. Rodriguez" <mcgrof@kernel.org> writes:
>>>>>>
>>>>>>> I was considering this as a future extension to the firmware API
>>>>>>> through the new extensible firmware API, the sysdata API.
>>>>>>
>>>>>> I think Linus mentioned this already, but I want to reiterate anyway.
>>>>>> The name "sysdata" is horrible, I didn't have any idea what it means
>>>>>> until I read your description. Please continue to use the term
>>>>>> "firmware", anyone already know what it means.
>>>>>
>>>>> We've gone well past using the firmware API for firmware though, if
>>>>> we use it for 802.11 to replace CRDA for instance its really odd to
>>>>> be calling it firmware. But sure... I will rebrand again to firmware...
>>>>
>>>> I tend to agree. Although some people even call an OpenWrt image
>>>> firmware. Guess it is just in the eye of the beholder.
>>>
>>> Sure...
>>>
>>> Come to think of it I'll still go with "sysdata", this is a very minor
>>> detail, do let me know if there is anything technical rather than
>>> the color of the bikeshed [0] over the patches.
>>
>> Well, you don't seem to care but I prefer that the terminology is clear
>> and I don't want to waste people's time browsing the source to find out
>> what something means.
> 
> Its not that I don't care, its this is a super trivial matter, like the
> color of a bikeshed, and I'd much prefer to put energy and review on
> technical matters.
> 
>> Even "driverdata" would be more descriptive for me
>> than "sysdata".
>>
>> Actually, what does the "sys" refer here, system? And what system is
>> that exactly?
> 
> Yes system, so as in system data file. "driver_data" is just as good.
> Although who knows, others may want to paint the bikeshed a different
> color.
> 
> The core reason why the name change is to make emphasis of the fact that
> we've gone way past the point where the APIs are used for non-firmware
> and I expect this use will only grow.

Here some colors to add to the palet with "color code" in brackets:
- device specific data (dsd): although if CRDA stuff is loaded it is no
	longer tied to a device.
- eXtensible firmware API (xfw): the ever popular x factor :-p
- binary blob loader (bbl): just popped up in me head.

Need more beer to go on.

Regards,
Arend
