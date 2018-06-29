Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56964 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935223AbeF2Ii3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Jun 2018 04:38:29 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Pkshih <pkshih@realtek.com>
Cc: "briselec\@gmail.com" <briselec@gmail.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Larry.Finger\@lwfinger.net" <Larry.Finger@lwfinger.net>,
        "chaitanya.mgit\@gmail.com" <chaitanya.mgit@gmail.com>,
        dan.carpenter@oracle.com
Subject: New realtek 11ac driver
References: <20180425020820.6141-1-pkshih@realtek.com>
        <87lgdbagb2.fsf@kamboji.qca.qualcomm.com>
        <5B2DA6FDDF928F4E855344EE0A5C39D13BEBF231@RTITMBSV07.realtek.com.tw>
        <20180427224156.GA18163@thinktank.home.org>
        <5B2DA6FDDF928F4E855344EE0A5C39D13BEBFD30@RTITMBSV07.realtek.com.tw>
        <CABPxzYKfZVA8RTADEG5TCu0SXRSVEGWEn+Ym6AkMuFzHC5iSVg@mail.gmail.com>
        <1526371717.12375.8.camel@realtek.com> <871sebkcad.fsf@codeaurora.org>
        <1526646826.1942.1.camel@realtek.com> <87bmd5ihm1.fsf@codeaurora.org>
        <1528162350.2800.3.camel@realtek.com>
Date: Fri, 29 Jun 2018 11:38:22 +0300
In-Reply-To: <1528162350.2800.3.camel@realtek.com> (pkshih@realtek.com's
        message of "Tue, 5 Jun 2018 01:32:56 +0000")
Message-ID: <87h8lmf0n5.fsf_-_@codeaurora.org> (sfid-20180629_103840_083813_9EC13149)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(Was "Re: [PATCH v3 00/19] rtlwifi: halmac: Add new module halmac",
changing the title to reflect what we are discussing)

Pkshih <pkshih@realtek.com> writes:

> On Thu, 2018-05-24 at 11:27 +0300, Kalle Valo wrote:
>>=C2=A0
>> You are missing my point: I don't even have time to review huge rtlwifi
>> patches when they are not even ready for upstream. I cannot start
>> working on cleaning up rtlwifi code and doing multiple iterations of
>> reviews on these kind of huge patchsets. Either you need to
>> significantly scale down the size of patchsets (especially LOC) or you
>> need to get review help from someone else. But the current way of
>> working is not doable for me.
>>=C2=A0
>
> Is there a proper way to look for "someone else" you mentioned?

I don't know, I think there might a project somewhere which helps with
patch review for new people but not sure about that. Adding Dan in case
he has some ideas.

> We plan to rewrite a new driver excluding agnostic OS layer to support=C2=
=A0
> new generation 11AC chips, because they're very different from the chips
> existed in rtlwifi and rtl8xxxu.=C2=A0
>
> If we have a "someone" to review our driver, where is the proper place to
> put developing driver repository? Staging or public git repository=C2=A0
> (e.g. GitHub)?

It depends on the driver really. If it's a good (code) quality driver
following upstream rules, then taking it directly to
drivers/net/wireless is the best approach. That's what we did with
qtnfmac for example.

But if the driver is more like a usual vendor driver with horrible code,
and not following upstream rules, then other options are better. I don't
look at staging at all so I can't comment staging vs github.com, others
more knowledgeable can comment about that.

> Finally, the driver is done. Are there explicit criteria to accept the
> driver as a mainline driver?=C2=A0

You mean like written rules? I don't think that I have seen anything.
But here are some things I usually check when reviewing patches for
upstream:

* good quality, simple, self-documenting and readable code (no magic
  values, ugly hacks)

* in general follows Linux coding style (not every whitespace needs to
  be correct but most of the rules need to be followed, no CamelCode etc)

* clean and simple design (no unnecessary layers and such)

* respects cfg80211 and mac80211 designs (doesn't reinvent the wheel,
  functionality which should be in mac80211 or cfg80211 is not in the
  driver)

* user space interfaces follow the rules

* commit log answers to "Why?" and doesn't leave questions unanswered

This is not a comprehensive list but hopefully still helps you to give
an idea what kind of things we are looking for. I'm sure there are more
tips elsewhere.

And as the last tip I want to give that try to submit the driver as
simple as possible (=3Dsmall), once it's accepted you can start adding
more features on top. In other words: "Submit early, submit often"

https://en.wikipedia.org/wiki/Release_early,_release_often

--=20
Kalle Valo
