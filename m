Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.249]:13334 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886AbYF3KYD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 06:24:03 -0400
Received: by an-out-0708.google.com with SMTP id d40so281935and.103
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jun 2008 03:24:02 -0700 (PDT)
Message-ID: <43e72e890806300324m68144ff6g97d74f7077f46ed4@mail.gmail.com> (sfid-20080630_122416_967553_BADBC790)
Date: Mon, 30 Jun 2008 03:24:01 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "George Fong" <george@lateralplains.com>
Subject: Re: Problem making compat-wireless-2.6
Cc: "=?UTF-8?Q?Stefanik_G=C3=A1bor?=" <netrolller.3d@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890806300121q34a71b39o6f9868cc0f788a87@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <200806281953.16371.george@lateralplains.com>
	 <69e28c910806280421t5e0de8edm8d6aab9cd582ccb7@mail.gmail.com>
	 <200806291133.45866.george@lateralplains.com>
	 <43e72e890806300121q34a71b39o6f9868cc0f788a87@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 30, 2008 at 1:21 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Sat, Jun 28, 2008 at 6:33 PM, George Fong <george@lateralplains.com> wrote:
>> <snip>
>>
>> Dang :-) This was the fix.
>>
>>> Try editing drivers/net/wireless/b43/rfkill.c, and replacing
>>> RFKILL_STATE_UNBLOCKED with RFKILL_STATE_ON and
>>> RFKILL_STATE_SOFT_BLOCKED with RFKILL_STATE_OFF. Looks like rfkill is
>>> not part of the compat package, and no work has been done to match
>>> compat-wireless to older RFKILLs.
>>
>> Thank you for such prompt responses. Although I did this for the b43 driver, I
>> ended up progressively having to do the same fix for the drivers for a couple
>> more, ie iwlwifi and rxt200
>>
>> I am not concerned about the rxt200 but the driver I was interested in was the
>> iwl4965, so I am not sure that by changing the settings on iwl-rfkill.c I
>> have affected the driver I am using ....
>>
>>
>> Having said that... the email is brought to you courtesy of the iwl9645 wifi
>> device .. which has got to be a Good Thing ;-)
>>
>> Agree about the proper way of doing things - should really install a newer
>> kernel, but I am strapped into an nVidia graphics card on my laptop and the
>> livna drivers keep pace well but I think I risk breaking these at the moment
>> with the newer kernel.
>>
>> Thank you all for your prompt responses and asistance... on a weekend no
>> less :-) I'll monitor progress and contribute whatever little I can as I get
>> this new laptop settled.
>
> I've fixed this in compat-wireless, it should now compile fine for
> kernels <= 2.6.26.

Doh I had used < 2.6.26, I've now added this for <=. This RFKILL stuff
will be part of 2.6.27. Committed and pushed, in case you were trying
to compile compat-wireless on 2.6.26. New tarball will be generated
shortly.

  Luis
