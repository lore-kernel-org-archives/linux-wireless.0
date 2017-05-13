Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:38723 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752128AbdEMMMu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 May 2017 08:12:50 -0400
Received: by mail-wm0-f44.google.com with SMTP id v15so5033283wmv.1
        for <linux-wireless@vger.kernel.org>; Sat, 13 May 2017 05:12:49 -0700 (PDT)
Subject: Re: [v2,1/3] ath9k: Support channels in licensed bands
To: Steve deRosier <derosier@gmail.com>,
        Ben Greear <greearb@candelatech.com>
References: <20170323133048.30062-2-sw@simonwunderlich.de>
 <1811221.G4Vz0DPyQ8@prime>
 <12133a0e-b030-5b21-8de1-3bf7334d47df@fit.fraunhofer.de>
 <1863250.VEhGCjvYY0@prime> <87efvvvd0t.fsf@kamboji.qca.qualcomm.com>
 <1c5720d5-8264-26a8-a63e-b225524471cc@candelatech.com>
 <CALLGbR+3JZL4=t78TQbLwKdq938B3cw0qj369dd6sY4q5A5ctw@mail.gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        ath10k@lists.infradead.org,
        Mathias Kretschmer <mathias.kretschmer@fit.fraunhofer.de>,
        Julian Calaby <julian.calaby@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        ath9k-devel@qca.qualcomm.com
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5ef5997b-f243-e9e3-2c45-b3bf8b6d39d7@broadcom.com> (sfid-20170513_141257_021736_F06D80BE)
Date: Sat, 13 May 2017 14:12:48 +0200
MIME-Version: 1.0
In-Reply-To: <CALLGbR+3JZL4=t78TQbLwKdq938B3cw0qj369dd6sY4q5A5ctw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12-5-2017 21:21, Steve deRosier wrote:
> Hi Ben,
> 
> On Fri, May 12, 2017 at 7:12 AM, Ben Greear <greearb@candelatech.com> wrote:
>>
>>
>> On 05/11/2017 04:38 AM, Kalle Valo wrote:
>>>

[snip]

>>> o I don't know about other countries, but in Finland applying for any
>>>   type of license (even if just to a license to drive a moped) needs
>>>   both time and money. So there is significant effort anyway needed to
>>>   legally use this band. And how many users there really are is unclear.
>>
>>
>> This is almost certainly not going to be used by regular end-users.  It is
>> going to be
>> used by public safety organizations who are buying equipment from companies
>> using open-wrt, LEDE, or similar, or possibly small teams at public safety
>> organizations doing the work themselves.  Rather than having each of these
>> vendors
> 
> I agree 100% that this won't be used by "regular end-users", if you
> define those users as the 99% of the population who will go to Best
> Buy and buy a router, plug it into their network and use it to get
> their iOS updates and download movies from Netflix. These aren't the
> users that the FCC is worried about.  They're concerned about the user
> who buys an OpenWRT compatible router, installs OpenWRT on it, builds
> a custom kernel. And that person happens to live in an area with
> congested WiFi bands, the person notices an option to use these other
> non-congested bands, decides that ignoring the warning would be
> harmless and the FCC won't ever know anyway.
> 
> And then there's a fire or other event in the area, and the emergency
> workers can't communicate. At best case, the FCC investigates and
> slaps a $25,000 fine on the operator. At worst case, someone dies.
> 
> I don't feel it's responsible as an engineer to hide behind "well, we
> warned them that they shouldn't do that" while ignoring my culpability
> in the matter. Setting the stage for others to fail due to their
> ignorance is not ethical.

Totally agree this is about being responsible.

> Anyone building a custom kernel is able to enable a config option. You
> can say that, "sure they can pull the patch from here and enable it
> anyway" or "they can figure it out and do it themselves, it's easy",
> but I do think there's a significant difference between being able to
> build a custom kernel with a configuration enabled vs being able to
> find and apply a random patch to a kernel and get it building and
> working. That's a different level of expertise. And going through that
> effort gives a person some time to reflect and think about if it
> should be done in the first place.
> 
> Adding this code to mainline makes it a feature of Linux and this
> driver. There's no way around that argument. Saying that "this is
> almost certainly not going to be used by regular end-users" is both
> fairly true as well as disingenuous. You're still making it an
> accepted feature.

Indeed. I had my concerns back when the CFG80211_CERTIFICATION_ONUS was
added to the kernel, but that is water under the bridge. It is not only
these kind of changes the FCC is looking at. They also have issues with
802.11d support. That does not even need a custom kernel. The end-user
just sets the country to some nice EU channel while being in the US and
screw up some weather radar. It has happened. Not life-threatening,
unless some tornado was missed maybe, but the concern is justified. How
the FCC is handling it may indeed be pointless and technically
misinformed, but that is because there is no good solution right now. At
least not a solution that assures it will not happen. I can only agree
that we as a community should not accommodate such (ab)use. Finding a
solution that is working for everyone is indeed the real challenge.

Regards,
Arend
