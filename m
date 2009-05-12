Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:37512 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757141AbZELIgH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2009 04:36:07 -0400
Received: by bwz22 with SMTP id 22so3120038bwz.37
        for <linux-wireless@vger.kernel.org>; Tue, 12 May 2009 01:36:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890905120014w13ca9317r8ec8fa270f2bbb1e@mail.gmail.com>
References: <43e72e890905101141r6fe3b655ta158acabf4c87ec3@mail.gmail.com>
	<OF24E7AF48.E39EC671-ONC12575B4.00236C72-C12575B4.0024C49C@drz-wien.at>
	<43e72e890905112355t53537ca9w2797cfc8694302@mail.gmail.com>
	<1242112310.3873.55.camel@johannes.local> <43e72e890905120014w13ca9317r8ec8fa270f2bbb1e@mail.gmail.com>
From: Davide Pesavento <davidepesa@gmail.com>
Date: Tue, 12 May 2009 10:35:47 +0200
Message-ID: <2da21fe50905120135h1cb8746foae4b3b4b37b3cb24@mail.gmail.com>
Subject: Re: Re: [ath9k-devel] ath9k module-Unable to set channel-since ath
	comes
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	alexander.bartha@drz-wien.at,
	Alexander Bartha <alex.xy.privat@gmx.at>,
	ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Pavel Roskin <proski@gnu.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Tue, May 12, 2009 at 09:14, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Tue, May 12, 2009 at 12:11 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> On Mon, 2009-05-11 at 23:55 -0700, Luis R. Rodriguez wrote:
>>
>>> I've tested this and its not the "ath" module which introduces an
>>> issue its a patch which enables PS by default. You can disable that by
>>> recompiling with:
>>>
>>> CONFIG_MAC80211_DEFAULT_PS_VALUE=0
>>>
>>> If using compat-wireless just stuff it into config.mk.
>>
>> I object to that assertion, or at least this way of putting it.
>>
>> If powersave by default causes issues then it's not my patch that's
>> causing the problem, it's the fact that ath9k can't properly deal with
>> powersave in this case. Had the user enabled powersave manually they
>> would have run into the same issue. As such, I think ath9k should
>> probably simply stop claiming it can support PS.
>
> Heh yes, what I meant was ath9k's PS support has some issues which
> still need to be resolved (at least as I've tested it).
>

I've already reported ath9k's issues with PS multiple times [1] [2]
[3], but the driver hasn't been fixed yet. You can find a verbose
debugging output at [4], I hope that helps in fixing the problem (I
can provide even more info if needed and I'm willing to test patches).

Anyway, if the issue isn't going to be resolved quickly (e.g. before
Johannes' "enable PS by default" patch lands in mainline), I think
it's better to disable PS in ath9k as previously suggested.

Regards,
Davide

[1] http://marc.info/?l=linux-wireless&m=123816406913599&w=2
[2] http://marc.info/?l=linux-wireless&m=123999864507104&w=2
[3] http://marc.info/?l=linux-wireless&m=124025926613089&w=2
[4] http://marc.info/?l=linux-wireless&m=124026772102023&w=2
