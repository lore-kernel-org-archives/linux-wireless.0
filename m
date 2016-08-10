Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:37083 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936506AbcHJTEo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2016 15:04:44 -0400
Received: by mail-wm0-f45.google.com with SMTP id i5so124357899wmg.0
        for <linux-wireless@vger.kernel.org>; Wed, 10 Aug 2016 12:04:43 -0700 (PDT)
Subject: Re: [PATCH v2 8/8] p54: convert to sysdata API
To: "Luis R. Rodriguez" <mcgrof@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Daniel Vetter <daniel.vetter@intel.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>,
	Ming Lei <ming.lei@canonical.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Daniel Wagner <daniel.wagner@bmw-carit.de>,
	Jeff Mahoney <jeffm@suse.com>, Takashi Iwai <tiwai@suse.de>
References: <1466121559-22363-1-git-send-email-mcgrof@kernel.org>
 <1466121559-22363-9-git-send-email-mcgrof@kernel.org>
 <CA+55aFyD+Xa2auP05=pBSxQc2qcuR858syMW5fiQKowbqbkDzQ@mail.gmail.com>
 <20160617013657.GH11948@wotan.suse.de>
 <CA+55aFycG-YfukKpP3x7kbBpCzXGwg35SdTU2r4wBbxrfROLtQ@mail.gmail.com>
 <20160617183503.GV11948@wotan.suse.de> <20160810183211.GL3296@wotan.suse.de>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	Vikram Mulukutla <markivx@codeaurora.org>,
	Stephen Boyd <stephen.boyd@linaro.org>,
	Christian Lamparter <chunkeey@googlemail.com>,
	Andy Lutomirski <luto@amacapital.net>,
	Jonathan Corbet <corbet@lwn.net>,
	Julia Lawall <Julia.Lawall@lip6.fr>,
	Tom Gundersen <teg@jklm.no>, Kay Sievers <kay@vrfy.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Tejun Heo <tj@kernel.org>,
	Josh Boyer <jwboyer@fedoraproject.org>,
	Michal Marek <mmarek@suse.com>,
	David Howells <dhowells@redhat.com>,
	Mimi Zohar <zohar@linux.vnet.ibm.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Daniel Vetter <daniel.vetter@ffwll.ch>, Abhay_Salunke@dell.com,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Wu Fengguang <fengguang.wu@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Jiri Slaby <jslaby@suse.com>, Gilles.Muller@lip6.fr,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-wireless@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
	Richard Purdie <rpurdie@rpsys.net>, nicolas.palix@imag.fr
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <7451c96a-b4f5-e629-a4a7-76d6fe1772e9@broadcom.com> (sfid-20160810_210452_821525_A925FA04)
Date: Wed, 10 Aug 2016 21:04:38 +0200
MIME-Version: 1.0
In-Reply-To: <20160810183211.GL3296@wotan.suse.de>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10-8-2016 20:32, Luis R. Rodriguez wrote:
> On Fri, Jun 17, 2016 at 08:35:03PM +0200, Luis R. Rodriguez wrote:
>> On Thu, Jun 16, 2016 at 05:09:30PM -1000, Linus Torvalds wrote:
>>> On Thu, Jun 16, 2016 at 3:36 PM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
>>>>
>>>> Reason this could not wait is folks seem to want to keep extending the API,
>>>> which is another reason for this, do we want to put an end to an unflexible
>>>> API now or should we wait ?

[big snip]

> 
> Regarding this -- Dmitry recenlty noted devm only works if used on the probe
> path, and as we now determined, we don't want firmware loading on probe [3], unless
> async probe is used, so this would make a devm solution here not ideal for
> freeing the firmware. Even if you use async probe -- that seems very special
> use case and adding devm support for the firmware API just for that seems silly.

So why would drivers want the devm solution anyway. Once firmware is
loaded in the device it can be freed or do you expect device drivers to
keep the firmware/sysdata for suspend/resume scenario as some do because
of firmware cache behaviour. Does the "rootfs ready" event cover
suspend/resume?

> As such the current devised solution in the sysdata API is called for, given
> if you indicated that keep = false, you are explicitly telling the firmware
> API that your firmware will certainly not be needed after the callback is
> called.
> 
> So for the sync case, a new callback is needed, and that explains the extra
> bit of code if someone conerts from the old API to the new one.
> 
> [3] https://lkml.kernel.org/r/20160803161821.GB32965@dtor-ws
> 
>>> or a magical "sysdata_desc" descriptor,
>>
>> This is one way to make a flexible and extensible API without affecting drivers
>> with further collateral evolutions as it gets extended. Its no different than
>> the "flags" lesson learned from writing system calls, for instance.
>>
>> Descriptor seemed, fitting, let me know if you have any other preference.
> 
> I haven't heard otherwise so will be sticking to that.

How about sysdata_req{,uest}_params?

>>> and having a new name ("sysdata") that is less descriptive than the old one
>>> ("firmware")
>>
>> Well no, the APIs are used in *a lot* of cases for things that are not firmware
>> already, and let's recall I originally started working on this to replace CRDA
>> from userspace to be able to just fetch the signed regulatory database file
>> from the kernel. Calling it firmware simply makes no sense anymore.
> 
> So help me bike shed. This seems to be sticking point and I frankly don't
> care what we call it. I've asked others for name suggestions and here are
> a few suggestions:
> 
>  o driver_data
>  o dsd: device specific data
>  o xfw - eXtensible firmware API
>  o bbl - binary blob loader
> 
> Can someone just pick something? I really, really do not care.
> 
> If I don't hear anything concrete I will go with driver_data.

bit of skin crawling here, but not enough to care.

>>> are all in my opinion making the example patch be a
>>> step _backwards_ rather than an improvement. It does not look like a
>>> simpler or more natural interface for a driver.
>>
>> Hope the above explains the current state. Feedback on desirable changes
>> welcomed.
>>
>> [0] https://lkml.kernel.org/r/1466117661-22075-5-git-send-email-mcgrof@kernel.org
> 
> All this said, this series is still justified, the extra code only comes in
> place when porting the sync requests due to the callback stuff described above
> and the inability to use devm there. As far as I can tell, just the bike
> shedding is left.
> 
> As it stands then, unless I hear back, I'll roll Daniel Wagner's changes into
> my series to be applied first, then rename sysdata driver_data, rebase all this
> and shoot it out again.
> 
> Only a few drivers will be converted over as demos. The SmPL grammar can be used
> by those who do want a change due to the few features added. Long term we'll
> add more features to the new API:
> 
>  o the whole ihex conversion is crap, we should do this within the API and
>    this can just be specified as a descriptor preference, then drivers
>    don't have to deal with the ihex crap themselves.
> 
>  o firmware singing - this lets us kill CRDA as a requirement

Strongly suspect a typo here :-p

Regards,
Arend
