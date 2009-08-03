Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f175.google.com ([209.85.210.175]:51350 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbZHCU2r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 16:28:47 -0400
Received: by yxe5 with SMTP id 5so2291991yxe.33
        for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2009 13:28:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1249329503.5652.9.camel@mj>
References: <1249328027-24865-1-git-send-email-lrodriguez@atheros.com>
	<1249329503.5652.9.camel@mj>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 3 Aug 2009 13:28:26 -0700
Message-ID: <43e72e890908031328g18afdb2mcee0a4d8f8d58fce@mail.gmail.com>
Subject: Re: [ath9k-devel] [PATCH 08/24] ath9k: pass only one argument to hw
	attach
To: Pavel Roskin <proski@gnu.org>
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 3, 2009 at 12:58 PM, Pavel Roskin<proski@gnu.org> wrote:
> On Mon, 2009-08-03 at 12:33 -0700, Luis R. Rodriguez wrote:
>> The softc is cached and set within the ath_hw struct.
>
> That's not meant to criticize this particular patch, but what's the
> point in distinguishing sc from ah these days?  I believe "ah" used to
> refer to the closed part of the sc structure that was only touched by
> Atheros HAL, hence the name.
>
> Since there is no HAL anymore, ah should disappear.

I started looking to do this but stopped for a few reasons.

1) It seems softc still serves some good purpose to us:
   a) Rate control stuff
   b) Place holder for timers, spin_locks, etc
   c) Configuration knobs not yet available on upper layers (tx/rx
chainmask is one, for example)
2) ath9k virtual wiphy stuff

Rate control is one chapter in itself, but the general idea is to get
proper HT support added to mac80211 rate control API and to one rate
control algorithm, say minstrel. To really accomplish this we should
strive to allow users to select between the private driver rate
control algorithm or minstrel on ath9k.

I don't see a point to move timers/spinlocks to hw related structs, at
least yet.

We then should see what knobs we can make generic or not.

Virtual wiphy is very specific to ath9k so far, some serious work is
required to see if we can move some of this up later.

> As the first step, ah should be allocated as part of sc.  Then ah and sc
> should stop pointing to each other.  Instead, macros based on offsetof
> should be used.  Then ah should be dissolved and replaced with sc
> throughout the code.

That sounds reasonable.

> That's probably a good task for an aspiring kernel hacker, as it
> requires little specialized knowledge.

Patches welcomed.

  Luis
