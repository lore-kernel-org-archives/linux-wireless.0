Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33810 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750796AbdELTVe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 May 2017 15:21:34 -0400
Received: by mail-wm0-f67.google.com with SMTP id d127so15688761wmf.1
        for <linux-wireless@vger.kernel.org>; Fri, 12 May 2017 12:21:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1c5720d5-8264-26a8-a63e-b225524471cc@candelatech.com>
References: <20170323133048.30062-2-sw@simonwunderlich.de> <1811221.G4Vz0DPyQ8@prime>
 <12133a0e-b030-5b21-8de1-3bf7334d47df@fit.fraunhofer.de> <1863250.VEhGCjvYY0@prime>
 <87efvvvd0t.fsf@kamboji.qca.qualcomm.com> <1c5720d5-8264-26a8-a63e-b225524471cc@candelatech.com>
From: Steve deRosier <derosier@gmail.com>
Date: Fri, 12 May 2017 12:21:32 -0700
Message-ID: <CALLGbR+3JZL4=t78TQbLwKdq938B3cw0qj369dd6sY4q5A5ctw@mail.gmail.com> (sfid-20170512_212158_068544_41120B8D)
Subject: Re: [v2,1/3] ath9k: Support channels in licensed bands
To: Ben Greear <greearb@candelatech.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        ath10k@lists.infradead.org,
        Mathias Kretschmer <mathias.kretschmer@fit.fraunhofer.de>,
        Julian Calaby <julian.calaby@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        ath9k-devel@qca.qualcomm.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ben,

On Fri, May 12, 2017 at 7:12 AM, Ben Greear <greearb@candelatech.com> wrote:
>
>
> On 05/11/2017 04:38 AM, Kalle Valo wrote:
>>
>> Simon Wunderlich <sw@simonwunderlich.de> writes:
>>
>>> it seems like there was some discussion here and I wouldn't expect too
>>> many
>>> more opinions ... do you think we can have a decision based on what has
>>> been
>>> discussed here?
>>
>>
>> Well, there was an excellent reply from Steve and quite a few "in my
>> opinion this is safe" type of answers. [1] But bluntly said it does not
>> really matter what we (the engineers) think. What really matters here
>> are regulatory authorities' opinions and rulings. In that respect here
>> are few items I want to point out:
>>
>> o I suspect that from someone's, who is not familiar with software
>>   engineering, point of view there is still quite a diffference from
>>   modifiying source code or just enabling few options from Kconfig with
>>   a custom regdb rule.
>
>
> If someone with real authority ever complains, then the code could be
> backed out again.  Your opinion seems not much more informed than the
> rest of us discussing this.
>

With all due respect, _I_ am quite well informed about this issue.
>From my conversations with him, I'd also judge Kalle to be quite
informed likewise.

"Someone with real authority" has already complained. That's the
entire point here. For the past two+ years it's been difficult to get
modular approvals through the FCC and their TCBs. The standard they
are applying is both pointless and technically misinformed, but
they've got the authority and they're using it. I can't speak for any
other manufacturers other than what I specifically have experience
with, but I expect the rest are having similar conversations with the
TCBs. From my work with them, I know that the chip manufacturers like
QCA, Marvell and Cypress/Broadcom are also having similar issues.
However, the chip manufacturers, and end-user equipment manufacturers
are less vulnerable here than the module manufacturers.


>>
>> o I don't know about other countries, but in Finland applying for any
>>   type of license (even if just to a license to drive a moped) needs
>>   both time and money. So there is significant effort anyway needed to
>>   legally use this band. And how many users there really are is unclear.
>
>
> This is almost certainly not going to be used by regular end-users.  It is
> going to be
> used by public safety organizations who are buying equipment from companies
> using open-wrt, LEDE, or similar, or possibly small teams at public safety
> organizations doing the work themselves.  Rather than having each of these
> vendors

I agree 100% that this won't be used by "regular end-users", if you
define those users as the 99% of the population who will go to Best
Buy and buy a router, plug it into their network and use it to get
their iOS updates and download movies from Netflix. These aren't the
users that the FCC is worried about.  They're concerned about the user
who buys an OpenWRT compatible router, installs OpenWRT on it, builds
a custom kernel. And that person happens to live in an area with
congested WiFi bands, the person notices an option to use these other
non-congested bands, decides that ignoring the warning would be
harmless and the FCC won't ever know anyway.

And then there's a fire or other event in the area, and the emergency
workers can't communicate. At best case, the FCC investigates and
slaps a $25,000 fine on the operator. At worst case, someone dies.

I don't feel it's responsible as an engineer to hide behind "well, we
warned them that they shouldn't do that" while ignoring my culpability
in the matter. Setting the stage for others to fail due to their
ignorance is not ethical.

Anyone building a custom kernel is able to enable a config option. You
can say that, "sure they can pull the patch from here and enable it
anyway" or "they can figure it out and do it themselves, it's easy",
but I do think there's a significant difference between being able to
build a custom kernel with a configuration enabled vs being able to
find and apply a random patch to a kernel and get it building and
working. That's a different level of expertise. And going through that
effort gives a person some time to reflect and think about if it
should be done in the first place.

Adding this code to mainline makes it a feature of Linux and this
driver. There's no way around that argument. Saying that "this is
almost certainly not going to be used by regular end-users" is both
fairly true as well as disingenuous. You're still making it an
accepted feature.


> hack their own crap into their kernels or forcing the the organizations to
> use Cisco gear,
> we could work on it together.
>

I absolutely concur with the idea of "we could work on it together."
Working together means coming up with a holistic plan that will work
and satisfy the regulatory agencies (and I'm not just talking FCC,
though they're right now one of the worst offenders IMHO). Just
putting a patch to use licenced public-safety bands into a single
random 802.11 chip driver to satisfy your particular
project/product/itch is not the same as working together. In
particular because this is _exactly_ the type of stuff that the FCC is
actually concerned about and fighting against with their misinformed
lock-down attitudes.

What really needs to happen to solve these sort of issues is a
whole-system approach where we work with the agencies and figure out a
way that works for everyone. The lawmakers and the regulatory agencies
as a group entity don't understand software, electronics, technology,
nor Open Source. The whole idea of a bunch of us "hackers" able to do
anything we want with just a few lines of code scares the hell out of
them. We need to engage with them. Educate them. Work with the
specific people inside their organizations that _do_ understand the
technology. Let them understand we're not the enemy and then work with
them to achieve both their goals and ours.

I tried to get the ball rolling on this at the Wireless Summit at the
last LPC, but no one bit. Probably some due to the lack of clarity
around the issue as well as my lack of eloquence, but no matter why,
it didn't go anywhere. I'm happy to try again if people are
interested.

This isn't just about letting it operate out of spec, nor a technical
argument. I don't have any issue with making it easier to enable a
feature of the chipset. That's all good. But "making it easier" in
this case equates to making it harder for the entire community who
depends on this stuff to get their work done and their products
certified. That's a net negative.

> Anyway, if upstream is blocked, then maybe we could work on getting this
> into LEDE?
>

Honestly, I don't see how this solves any problems. You're just moving
the chair. A chair that someone will stand on and fall off and get
hurt. LEDE, OpenWRT or even Buildroot is essentially just a big patch
and build system. For a closed-ecosystem manufacturer, which by
definition a public-safety band licensed equipment manufacturer must
be, can just as easily maintain their own internal fork of the kernel
with these patches sitting there.

That's not something I'd normally advocate, but it does seem
appropriate in this specific application.

Thanks,
- Steve
