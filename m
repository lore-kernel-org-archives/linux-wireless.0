Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:39250 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750841AbeERJiT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 May 2018 05:38:19 -0400
Message-ID: <1526636295.3805.10.camel@sipsolutions.net> (sfid-20180518_113826_453487_76F3524E)
Subject: Re: [RESEND PATCH] cfg80211: dynamically allocate per-tid stats for
 station info
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 18 May 2018 11:38:15 +0200
In-Reply-To: <5AFE9ECE.50306@broadcom.com> (sfid-20180518_113721_333172_594E80B6)
References: <5AF430B2.2060903@broadcom.com> <5AF431F4.9060408@broadcom.com>
         <1526635514.3805.3.camel@sipsolutions.net> <5AFE9ECE.50306@broadcom.com>
         (sfid-20180518_113721_333172_594E80B6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2018-05-18 at 11:37 +0200, Arend van Spriel wrote:
> On 5/18/2018 11:25 AM, Johannes Berg wrote:
> > On Thu, 2018-05-10 at 13:50 +0200, Arend van Spriel wrote:
> > > 
> > > Here an alternative approach. Currently the only cfg80211-based driver
> > > providing per-tid stats is mac80211. This patch only changes mac80211
> > > and the other driver can keep using stack allocation. Even mac80211 could
> > > if wanted, but I left that part as is.
> > 
> > I decided to take this and remove the BIT() thing entirely (you had a
> > bug there anyway)
> 
> I figured you would drop this one. The error paths may need to do kfree 
> here and there. Kalle took dynamic alloc fixes in driver already so my 
> patch is not really needed right now.

Heh. I asked Kalle if he wanted to revert, but I decided that for the
single user in mac80211 it wasn't worth the hassle of doing the dynamic
allocations all over the place.

I'll look at the error paths I guess.

johannes
