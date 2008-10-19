Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.173]:23863 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbYJSXMD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Oct 2008 19:12:03 -0400
Received: by wf-out-1314.google.com with SMTP id 27so1664992wfd.4
        for <linux-wireless@vger.kernel.org>; Sun, 19 Oct 2008 16:12:01 -0700 (PDT)
Message-ID: <1ba2fa240810191612w5e746237r7a65444c6c99f99a@mail.gmail.com> (sfid-20081020_011210_513280_208F1D9C)
Date: Mon, 20 Oct 2008 01:12:00 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Andrew Lutomirski" <luto@myrealbox.com>
Subject: Re: iwlagn: associating with AP causes kernel hiccup
Cc: richard@scherping.de, "Frederik Himpe" <fhimpe@telenet.be>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <cb0375e10810191552l7541e034l6f1e095c0c268baa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <gd5gs4$abi$1@ger.gmane.org> <1224104363.19219.30.camel@rc-desk>
	 <gd9v3f$3ft$1@ger.gmane.org> <gd9vpo$5ql$1@ger.gmane.org>
	 <48F8AEF1.5030603@scherping.de>
	 <1ba2fa240810171302h7dcc92acr18c060425c4a93d@mail.gmail.com>
	 <48FA0C27.8010301@scherping.de> <48FB4FBE.2060909@myrealbox.com>
	 <1ba2fa240810191512i4c6ce748kd13d1671cc2a2ff6@mail.gmail.com>
	 <cb0375e10810191552l7541e034l6f1e095c0c268baa@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 20, 2008 at 12:52 AM, Andrew Lutomirski <luto@myrealbox.com> wrote:
> On Sun, Oct 19, 2008 at 6:12 PM, Tomas Winkler <tomasw@gmail.com> wrote:
>> On Sun, Oct 19, 2008 at 5:18 PM, Andy Lutomirski <luto@myrealbox.com> wrote:
>>> Richard Scherping wrote:
>>>>
>>>> Tomas Winkler schrieb:
>>
>>>
>>> Amen.
>> Stable doesn't mean all components are stable, citation  from Linus blog:
>> "It doesn't have to be perfect (and obviously no release ever is), but
>> it needs to be in reasonable shape"
>>
>> The fact is that some critical patches were rejected as not
>> regressions in rc cycle and probably need to be pushed to the stable
>> version now or distribution will merge them.
>> We gave more priority for testing 32 bit version so it is more stable
>> then 64 bit which got much less in house testing and we've missed many
>> issues there. The driver doesn't get full exposure till it's get to
>> the public in stable version therefore  no bugs are opened in the rc
>> cycle so also are not fixed in the stable version. and unfortunately
>> there is no much system testing at all for what get's into merging
>> window.
>> Second the whole mac80211 stack didn't address fully MQ rewrite so
>> it's a bit shaky as well and this will be fact also in 2.6.28.
>
> OK.
>
>>
>> This driver has been available and more-or-less working for ages.
>>> What kernel am I supposed to run if I just want a stable system? Haven't
>>> found one yet, other than distro kernels...
>>>
>>> In any case, I've seen these complete system hiccups with iwl4965 and iwlagn
>>> since at least 2.6.25 and through quite a few wireless-testing versions.  I
>>> bet that this, along with things like it, is the culprit:
>>
>> Haven't seen you've filled bug for it.
>
> Fair enough.  #1790.
>
Appreciated.

>>
>> Locking need to be really revised but till now I didn't see show
>> stoppers issues so it didn't get priority
>>
>>> Would I be out of line for wishing the iwlwifi developers
>> Patches are always welcome
>
> I can write a patch to add a mutex and change it to:
>
> take mutex
> grab_nic
> spinlock
>
> but I bet that would break all kinds of things. :)
>
I'm far from being lock master but I think mutex just won't work here
it can be used only in sleep-able  context Also if I'm not mistake if
you using the lock in irq context we must use irqsafe version of the
spin lock,
Thanks
Tomas
