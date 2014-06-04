Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:61888 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422AbaFDMAI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2014 08:00:08 -0400
Received: by mail-wg0-f47.google.com with SMTP id x12so8358719wgg.30
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jun 2014 05:00:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1401824450.4157.33.camel@jlt4.sipsolutions.net>
References: <1401345535-22991-1-git-send-email-michal.kazior@tieto.com>
	<1401824450.4157.33.camel@jlt4.sipsolutions.net>
Date: Wed, 4 Jun 2014 14:00:06 +0200
Message-ID: <CA+BoTQm+GPUzgxTut+umhuSQZS6m+=e5FzeSGpg64Xy=2A3cUQ@mail.gmail.com> (sfid-20140604_140013_155814_BE033F1B)
Subject: Re: [PATCH v2 0/2] mac80211: fix csa counters
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
	Luciano Coelho <luciano.coelho@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3 June 2014 21:40, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2014-05-29 at 08:38 +0200, Michal Kazior wrote:
>> Hi,
>>
>> I was seeing strange WARN_ON splat loops and
>> crashes while I was testing my multi-vif CSA.
>>
>> CSA counters weren't properly reset and on some
>> failpaths this caused a mess. There were also
>> possible SMP inconsitencies/races.
>
> Thanks. This doesn't seem to apply any more though, something in
> ieee80211_csa_is_complete(). I think the fixup is easy, but would prefer
> if you'd do it since (hopefully :) ) you can also check the result.
>
> I'm guessing the conflict is with some of Andrei's recent patches.

That's strange. I thought I've based it on top of latest
mac80211-next/master when I sent it.

I've also just rebased it locally on latest mac80211-next/master and
git wasn't complaining about conflicts at all.

Anyway, I'll re-send it later.


Michał
