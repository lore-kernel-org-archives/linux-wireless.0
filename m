Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:52885 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751396AbdDEBSm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Apr 2017 21:18:42 -0400
Date: Wed, 5 Apr 2017 11:18:37 +1000
From: "Tobin C. Harding" <me@tobin.cc>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        Kalle Valo <kvalo@codeaurora.org>,
        Tycho Andersen <tycho@tycho.ws>,
        Wolfram Sang <wsa@the-dreams.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Subject: Re: [PATCH RFC] remove custom Michael MIC implementation
Message-ID: <20170405011837.GD18834@eros> (sfid-20170405_031911_170790_94CCF3B1)
References: <1490935659-7196-1-git-send-email-me@tobin.cc>
 <20170331075851.GB1435@katana>
 <20170331102113.GA2930@eros>
 <87fuhq6par.fsf@purkki.adurom.net>
 <20170403090359.GK3755@eros>
 <87y3vhx1ju.fsf@alrua-karlstad>
 <9bfd1405-fd32-e896-b6f0-09ffedeaac33@broadcom.com>
 <20170403213910.GA7480@eros>
 <060699f7-df85-8530-17bc-6174efb946f2@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <060699f7-df85-8530-17bc-6174efb946f2@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 04, 2017 at 11:31:14PM +0200, Arend Van Spriel wrote:
> >> On 3-4-2017 11:50, Toke Høiland-Jørgensen wrote:
> >>> "Tobin C. Harding" <me@tobin.cc> writes:
> >>>
> >>>> Except one: do you know off the top of your head of a canonical
> >>>> implementation of a softmac wi-fi driver.
> >>>
> >>> I'll suggest taking a look at the ath9k driver :)
> >>
> >> Looking at ks7010 driver it looks like it has 802.11 stack in firmware
> >> and not sure if Renesas is actively supporting this effort to come up
> >> with mac80211-friendly firmware or provide detailed chip info.
> > 
> > Thanks for taking a look. If the ks7010 driver has 802.11 stack in
> > firmware does that mean it is not compatible with using the kernel
> > mac80211 stack with the current firmware? I do not have my hopes up
> > about getting any chip information out of Renesas, all I think we have
> > to go in is the current WEXT driver.
> 
> Indeed. That is my gut feeling as well and if that is truly the case
> your best option would be a cfg80211-based driver like ath6kl, mwifiex,
> and brcmfmac.

Ok. So that would mean that we still have to do the Michael MIC in software
(using kernel crypto API) right?

I think the best course of action is to totally clean up the WEXT
interface, including getting Michael MIC working with kernel
crypto, test it all, and then attempt the migration to cfg80211
interface.

If no one thinks that's a bad idea I'll keep working on the WEXT
interface for now.

> > This is an exercise in learning for me, but I do not want to take any
> > ones time up with a project that is not that useful. Is getting the
> > ks7010 driver out of staging something that is of use to the kernel
> > community or are there other wi-fi tasks that our time is better spent
> > on?
> 
> If there are linux users with this hardware than sure. Especially if it
> revised to interface with the latest wireless subsystem so tools like iw
> can operate on it.
> 
> Also I suppose it is preferred if a driver is maintained. I do not see
> the ks7010 listed in the MAINTAINERS file yet.

How's this for a MAINTAINERS entry?

KS7010 KEYSTREAM DRIVER
M:      Wolfram Sang <wsa@the-dreams.de>
M:      Tobin Harding <me@tobin.cc>
L:      driverdev-devel@linuxdriverproject.org
S:      Maintained
F:      drivers/staging/ks7010/

Wolfram, is this ok by you;
(a) To put your name
(b) To put my name

Is the status correct, I'm happy to help maintain it if that is acceptable
for someone of my experience level to do so. Is this driver part of
your job?

thanks,
Tobin.
