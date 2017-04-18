Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35319 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752866AbdDRQiC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Apr 2017 12:38:02 -0400
Received: by mail-wm0-f68.google.com with SMTP id d79so415910wmi.2
        for <linux-wireless@vger.kernel.org>; Tue, 18 Apr 2017 09:38:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3170657.DNPqgEf8fi@prime>
References: <20170323133048.30062-2-sw@simonwunderlich.de> <20170418143654.8AC0A60FAA@smtp.codeaurora.org>
 <3170657.DNPqgEf8fi@prime>
From: Steve deRosier <derosier@gmail.com>
Date: Tue, 18 Apr 2017 09:38:00 -0700
Message-ID: <CALLGbRKADjbZ72W0XD_dU-6YtCHGY2koM4AjUVKdCuHAqCpb3Q@mail.gmail.com> (sfid-20170418_183806_857684_F774ED16)
Subject: Re: [v2,1/3] ath9k: Support channels in licensed bands
To: Simon Wunderlich <sw@simonwunderlich.de>
Cc: Kalle Valo <kvalo@codeaurora.org>, ath10k@lists.infradead.org,
        ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        Mathias Kretschmer <mathias.kretschmer@fit.fraunhofer.de>,
        Ben Greear <greearb@candelatech.com>,
        Julian Calaby <julian.calaby@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

(sorry, resending due to my not noticing that gmail had changed my
default compose mode to HTML. Why does it randomly do that
sometimes?!?!)

On Tue, Apr 18, 2017 at 7:50 AM, Simon Wunderlich <sw@simonwunderlich.de> wrote:
>
> Hi,
>
> On Tuesday, April 18, 2017 2:36:54 PM CEST Kalle Valo wrote:
> > Simon Wunderlich <sw@simonwunderlich.de> wrote:
> > > From: Ben Greear <greearb@candelatech.com>
> > >
> > > Many chips support channels in licensed bands. Add support for those,
> > > along with a corresponding kernel config option to disable them by

...

> > I am not sure that we should support unlicensed bands in Linux and hence
> > hesitant to apply these. My view is that due to regulatory restrictions we
> > should not make it too easy to use unlicensed bands. But I'm open for
> > discussion, this is a challenging area and my knowledge here is limited.
>
...
>
>
> In my personal view, we have quite a few obstacles which I consider "enough",
> but would be interesting to hear others opinions ...
>

I'll throw in my 2-cents. This patch is treading on very dangerous
ground. I can't speak to other regulatory environments, but at least
the FCC is cracking down on even the possibility that anyone can
operate a WiFi device outside the regulatory bounds.

I know this is going to be TLDR, but please bear with me.

The testing groups are (incorrectly in my opinion) interpreting the
current FCC guidelines to be that no one with the device could ever
get in and change it to operate outside the permitted frequencies and
powers. And I'm not even talking about having a command-line interface
and issuing a command as sudo. To the degree that if it's even
possible to recompile a driver or otherwise change the source code and
put that changed code on the device they're denying modular
certifications.

The end result is we have a lot of chip manufacturers' scrambling to
do things like require eeproms, signed board files, etc. Module
manufacturers (think of things like Laird's msd45nbt, msd50nbt, or the
Sterling LWB) are scrambling even harder trying to think of ways to
force chips to fail to function if they aren't using their regulatory
file or other strategies to manage to fulfill their customer's needs
while still getting it to pass through the regulatory agencies.

@Simon, with much respect: With the current regulatory environment,
those obstacles which you are considering "enough", the testing boards
aren't considering "enough".

I happen to agree with you that it's more than enough. And just
because it's possible for a customer of a module who is integrating a
device to operate it out of the regulatory bounds, doesn't mean it
shouldn't get the modular certification. In fact, depending on the
exact situations, it might be _necessary_ for them to make setting
adjustments for their products. And the reality is, anyone with a
soldering iron can make the thing operate outside the regulatory
domain anyway. The whole thing just makes it impossible for modular
operators and for the Linux community instead of solving any real
problems.

What's going on in the FCC regulatory environment has stark
implications that those of us in the Linux wireless community can't
afford to ignore anymore. This is a direct threat to mac80211, Open
Source and the ability to do anything sane with our devices. And even
if you're more practical (like me) about these things, think of it:
each manufacturer being forced to make it harder and harder for anyone
to change the code or work with their chips - you think it's hard to
work with a Marvell or Broadcom chip right now with minimal and
non-accessible documentation? Imagine how it's going to be when
everything is locked behind Secure Boot and signed proprietary drivers
where the hardware itself is locked so it can only work with the (bad
quality and buggy) closed-source driver.

I brought this up at Wireless Summit at the last LPC and basically got
a room of shrugs. Admittedly I wasn't terribly eloquent on the subject
so it's solely my fault I didn't impress. I know that most of us are
representing various companies (though not I anymore) and each has
their own proprietary way to deal with it and no one wants to rock the
boat*. And many of the people in the room are just implementing code
to make stuff work and don't actually know that much depth about the
regulatory environment in which we're working. But we all need to get
together and come up with a better solution.

What's going on right now doesn't serve our interests. I know it's an
agenda being pushed by someone and while I have a few suspects I
really don't know for sure. In any case, who it's being pushed by and
for doesn't matter too much - we as a community aren't pushing back as
a cohesive group; we aren't even talking about it! And so, we're going
to get the short end of the stick.

So, with re: to the patch, that's the environment it will live in.
Personally I don't really care one way or another specifically to what
Simon's patch does. But he opened the door to discussion and it seemed
like an appropriate opportunity. I don't mind that it opens more
functionality, functionality that the chip in question supports. I'd
even regard this as a good thing, especially considering the
"obstacles" in place. And keeping it out doesn't solve anything to do
with the root of the problem either.

As for merging it, I guess my only test would be: is this a
functionality that the community as a whole benefits from? Either
because more than one person would be using it, or we have a vested
interest in keeping a cohesive codebase that doesn't require people to
use it a crazy maintenance overhead by requiring patching every time
they upgrade? But that's always the same questions with any patch.

In either case, patch merged or not: we still have an important
discussion to have about what we're going to do about the FCC
regulatory problems - before someone "solves" it for us in a way that
hurts us all.

If you got this far, thanks for reading this.

Thanks,
- Steve


footnote:
* Personally, I think that many of the devices in the past and
currently are getting certifications by clever wording on the
documents and getting through on a wink and a nod. And no one wants to
talk about it because that means acknowledging that fact and risking
newer devices having a more difficult time getting through.
