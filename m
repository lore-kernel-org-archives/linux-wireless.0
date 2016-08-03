Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cit-hm8-mail01.bmw-carit.de ([212.118.206.84]:42862 "EHLO
	cit-hm8-gw01.bmw-carit.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752300AbcHCHIN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Aug 2016 03:08:13 -0400
Subject: Re: [RFC v0 7/8] Input: ims-pcu: use firmware_stat instead of
 completion
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
References: <20160728190151.GV13516@tuxbot>
 <c05a7b98-5ada-701f-9a77-65d81b841c17@bmw-carit.de>
 <ee9a29aa-0d29-a33f-e43a-057dc359cf89@broadcom.com>
 <20160730165817.GQ3296@wotan.suse.de>
 <C528E404-0CA5-46B4-B551-B1D4B58BC053@gmail.com>
 <37a3cd66-262e-ffbe-ea7a-a6d5b1ca1c8b@bmw-carit.de>
 <20160801194408.GZ3296@wotan.suse.de>
 <0f9350fa-e8b5-9d64-b2d3-afda5e5f6bbf@bmw-carit.de>
 <20160802063419.GG3296@wotan.suse.de>
 <2713d779-ef55-793d-f37e-d1414bb1bfc2@bmw-carit.de>
 <20160802074106.GI3296@wotan.suse.de>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Daniel Wagner <wagi@monom.org>,
	Bastien Nocera <hadess@hadess.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Ohad Ben-Cohen <ohad@wizery.com>,
	Mimi Zohar <zohar@linux.vnet.ibm.com>,
	David Howells <dhowells@redhat.com>,
	Andy Lutomirski <luto@amacapital.net>,
	David Woodhouse <dwmw2@infradead.org>,
	Julia Lawall <julia.lawall@lip6.fr>,
	<linux-input@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>
From: Daniel Wagner <daniel.wagner@bmw-carit.de>
Message-ID: <ef14dc68-d2f8-0934-7be5-dfb3a4771f27@bmw-carit.de> (sfid-20160803_090836_875038_0DB78DD6)
Date: Wed, 3 Aug 2016 08:57:09 +0200
MIME-Version: 1.0
In-Reply-To: <20160802074106.GI3296@wotan.suse.de>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/02/2016 09:41 AM, Luis R. Rodriguez wrote:
> On Tue, Aug 02, 2016 at 08:53:55AM +0200, Daniel Wagner wrote:
>> On 08/02/2016 08:34 AM, Luis R. Rodriguez wrote:
>>> On Tue, Aug 02, 2016 at 07:49:19AM +0200, Daniel Wagner wrote:
>> So you argue for the remoteproc use case with 100+ MB firmware that
>> if there is a way to load after pivot_root() (or other additional
>> firmware partition shows up) then there is no need at all for
>> usermode helper?
>
> No, I'm saying I'd like to hear valid uses cases for the usermode helper and so
> far I have only found using coccinelle grammar 2 explicit users, that's it. My
> patch series (not yet merge) then annotates these as valid as I've verified
> through their documentation they have some quirky requirement.

I got that question wrong. It should read something like 'for the 
remoteproc 100+MB there is no need for the user help?'. I've gone 
through your patches and they make perfectly sense too. Maybe I can 
convince you to take a better version of my patch 3 into your queue. And 
I help you converting the exiting drivers. Obviously if you like my help 
at all.

> Other than these two drivers I'd like hear to valid requirements for it.
>
> The existential issue is a real issue but it does not look impossible to
> resolve. It may be a solution to bloat up the kernel with 100+ MB size just to
> stuff built-in firmware to avoid this issue, but it does not mean a solution
> is not possible.
>
> Remind me -- why can remoteproc not stuff the firmware in initramfs ?

I don't know. I was just bringing it up with the hope that Bjorn will 
defend it. It seems my tactics didn't work out :)

> Anyway, here's a simple suggestion: fs/exec.c gets a sentinel file monitor
> support per enum kernel_read_file_id. For instance we'd have one for
> READING_FIRMWARE, one for READING_KEXEC_IMAGE, perhaps READING_POLICY, and this
> would in turn be used as the system configurable deterministic file for
> which to wait for to be present before enabling each enum kernel_read_file_id
> type read.
>
> Thoughts ?

Not sure if I get you here correctly. Is the 'system configurable 
deterministic file' is a knob which controlled by user space? Or it this 
something you define at compile time?

Hmm, so it would allow to decided to ask a userspace helper or load the 
firmware directly (to be more precised the kernel_read_file_id type). If 
yes, than it is what currently already have just integrated nicely into 
the new sysdata API.

cheers,
daniel

