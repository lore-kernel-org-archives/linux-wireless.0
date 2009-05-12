Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.173]:40408 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbZELHOi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2009 03:14:38 -0400
Received: by wf-out-1314.google.com with SMTP id 26so2745676wfd.4
        for <linux-wireless@vger.kernel.org>; Tue, 12 May 2009 00:14:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1242112310.3873.55.camel@johannes.local>
References: <43e72e890905101141r6fe3b655ta158acabf4c87ec3@mail.gmail.com>
	<OF24E7AF48.E39EC671-ONC12575B4.00236C72-C12575B4.0024C49C@drz-wien.at>
	<43e72e890905112355t53537ca9w2797cfc8694302@mail.gmail.com>
	<1242112310.3873.55.camel@johannes.local>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 12 May 2009 00:14:19 -0700
Message-ID: <43e72e890905120014w13ca9317r8ec8fa270f2bbb1e@mail.gmail.com>
Subject: Re: Re: [ath9k-devel] ath9k module-Unable to set channel-since ath
	comes
To: Johannes Berg <johannes@sipsolutions.net>
Cc: alexander.bartha@drz-wien.at,
	Alexander Bartha <alex.xy.privat@gmx.at>,
	ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Pavel Roskin <proski@gnu.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 12, 2009 at 12:11 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2009-05-11 at 23:55 -0700, Luis R. Rodriguez wrote:
>
>> I've tested this and its not the "ath" module which introduces an
>> issue its a patch which enables PS by default. You can disable that by
>> recompiling with:
>>
>> CONFIG_MAC80211_DEFAULT_PS_VALUE=0
>>
>> If using compat-wireless just stuff it into config.mk.
>
> I object to that assertion, or at least this way of putting it.
>
> If powersave by default causes issues then it's not my patch that's
> causing the problem, it's the fact that ath9k can't properly deal with
> powersave in this case. Had the user enabled powersave manually they
> would have run into the same issue. As such, I think ath9k should
> probably simply stop claiming it can support PS.

Heh yes, what I meant was ath9k's PS support has some issues which
still need to be resolved (at least as I've tested it).

  Luis
