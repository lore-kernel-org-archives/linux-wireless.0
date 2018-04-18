Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:55490 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753031AbeDRCfj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Apr 2018 22:35:39 -0400
Message-ID: <c4f3d20e8c16c8bf8721f0a50fb809781b30b3f7.camel@redhat.com> (sfid-20180418_043543_663181_E1B125FC)
Subject: Re: [PATCH 2/2] ath10k: support MAC address randomization in scan
From: Dan Williams <dcbw@redhat.com>
To: Brian Norris <briannorris@chromium.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, cjhuang@codeaurora.org,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Date: Tue, 17 Apr 2018 21:35:36 -0500
In-Reply-To: <CA+ASDXOoxMyTq2CVnUwvN1LBWj1Y9wpsRPKuM0tVzA80sDYG-w@mail.gmail.com>
References: <1522379640-6442-1-git-send-email-cjhuang@codeaurora.org>
         <1522379640-6442-3-git-send-email-cjhuang@codeaurora.org>
         <20180412205954.GA34456@rodete-desktop-imager.corp.google.com>
         <e16557d0891352ae0b83902faee97023@codeaurora.org>
         <877epbs5v7.fsf@kamboji.qca.qualcomm.com> <5AD11D7C.1030603@broadcom.com>
         <242be71eb87140c9560163c4000255b2@codeaurora.org>
         <8736zvqtcw.fsf@kamboji.qca.qualcomm.com>
         <20180417002854.GA186697@rodete-desktop-imager.corp.google.com>
         <5AD5AEB5.1040808@broadcom.com>
         <20180417160715.GA255263@rodete-desktop-imager.corp.google.com>
         <5AD66BD9.4000706@broadcom.com>
         <CA+ASDXOoxMyTq2CVnUwvN1LBWj1Y9wpsRPKuM0tVzA80sDYG-w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-04-17 at 15:26 -0700, Brian Norris wrote:
> On Tue, Apr 17, 2018 at 2:49 PM, Arend van Spriel
> <arend.vanspriel@broadcom.com> wrote:
> > On 4/17/2018 6:07 PM, Brian Norris wrote:
> > > On Tue, Apr 17, 2018 at 10:22:13AM +0200, Arend van Spriel wrote:
> > > > I believe checking command support is not really recommended.
> > > > Instead, you
> > > > better check NL80211_ATTR_SCHED_SCAN_MAX_REQS being non-zero
> > > > (since kernel
> > > > 4.12 that is).
> > > 
> > > 
> > > Why not? Command support checking is what wpa_supplicant is
> > > doing.
> > 
> > 
> > That's not really a good argument. A couple (or more) years ago
> > wpa_supplicant was not doing nl80211 but wext and some other using
> > driver private ioctls, but that did not make it the best approach.
> 
> I see what you're saying (though your comparison doesn't seem that
> fair either; private ioctls are nothing like a well-defined nl80211
> support list), and I'm totally good on looking at the new flag
> eventually. But you still haven't answered my question ("why not?").
> Is there a problem with the "supported commands" list?
> 
> > The START_SCHED_SCAN command is indeed still provided to user-
> > space:
> 
> And as I see it, it probably needs to be for essentially forever. Or
> at least a significant amount of time after wpa_supplicant stops
> relying on it. (Hint: it's still using it today, with no reference to
> NL80211_ATTR_SCHED_SCAN_MAX_REQS.) There's a reason the kernel has
> ABI
> guarantees. I suspect you only get a chance to rewrite the world
> (WEXT
> -> nl80211) a few times in the life of kernel ABIs.

It sometimes feels like wpa_supplicant gets treated as a static entity
that can never be changed.  In fact, send a patch to Jouni implementing
the best practice, with a fallback to preserve compat for old kernels,
and I'm sure he'd entertain it.  Just because the supplicant does
something a certain way, doesn't mean it's the *best* way, but it too
evolves.

Dan
