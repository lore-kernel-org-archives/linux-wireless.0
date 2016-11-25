Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:41906 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752063AbcKYKa5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Nov 2016 05:30:57 -0500
Message-ID: <1480069846.2517.112.camel@coelho.fi> (sfid-20161125_113101_216090_C64106E2)
From: Luca Coelho <luca@coelho.fi>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 25 Nov 2016 12:30:46 +0200
In-Reply-To: <3fa55a67-4447-9c41-23d2-689db818b60d@broadcom.com>
References: <1479821515-13261-1-git-send-email-arend.vanspriel@broadcom.com>
         <1479821915.9021.4.camel@sipsolutions.net>
         <5c249c34-5e8c-093a-c5df-3507cabc8872@broadcom.com>
         <1480062330.4317.2.camel@sipsolutions.net>
         <3fa55a67-4447-9c41-23d2-689db818b60d@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH] nl80211: provide minimum scheduled scan (plan) interval
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Fri, 2016-11-25 at 11:06 +0100, Arend van Spriel wrote:
> 
> On 11/25/2016 9:25 AM, Johannes Berg wrote:
> > Sorry, forgot to reply to this until Luca's email bumped it up...
> > 
> > On Tue, 2016-11-22 at 21:06 +0100, Arend Van Spriel wrote:
> > 
> > > Are we? Currently, the minimum is not checked in nl80211, but that
> > > does not say anything about the driver which might validate the
> > > interval as well and return an error.
> > 
> > Well, since drivers currently don't return an error (even if they
> > ignore the value!) that *does* change the API.
> > 
> > > What made me start looking at this is that in brcmfmac the interval
> > > in the request was ignored and a fixed interval was provisioned in
> > > the device. I wanted to fix that but was not sure if I needed to
> > > check it against our firmware min..max range and what the appropriate
> > > error handling should be. If silently changing what user-space is
> > > requesting is fine for this, I am happy to make it so. Preferably in
> > > nl80211.
> > 
> > I think (agreeing with Luca) bumping it up is fine.
> 
> Fine by me although the "drift over time" reason seems only more reason 
> to have minimum validation mainly because nowhere is nl80211.h it is 
> stated that the interval is a "soft" requirement. Now Luca proposes 
> bumping to minimum should be done in the driver. What is your opinion?
> 
> I will update the kernel doc to clarify what can be expected from the 
> interval value.

Yeah, I was almost sure there was a statement somewhere that the
interval is "soft", but there isn't.  I was confusing with the match
logic, which is clearly documented as not-guaranteed: "...there is no
guarantee that the reported BSSs are fully complying with the match
sets and userspace needs to be able to ignore them by itself."

A clarification in the documentation would be great.

--
Luca.
