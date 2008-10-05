Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hs-out-0708.google.com ([64.233.178.247]:53975 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399AbYJECsT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Oct 2008 22:48:19 -0400
Received: by hs-out-0708.google.com with SMTP id 4so751658hsl.5
        for <linux-wireless@vger.kernel.org>; Sat, 04 Oct 2008 19:48:16 -0700 (PDT)
Message-ID: <43e72e890810041948u41e28940g5b1b821609ed270d@mail.gmail.com> (sfid-20081005_044839_140745_146BB5B2)
Date: Sat, 4 Oct 2008 19:48:16 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Steven Noonan" <steven@uplinklabs.net>
Subject: Re: [PATCH 2/3] ath9k: fix oops on trying to hold the wrong spinlock
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Vasanthakumar Thiagarajan" <vasanth@atheros.com>,
	Sujith <Sujith.Manoharan@atheros.com>,
	"Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <f488382f0810041940p20544fdo88908c7f305a69de@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1223073927-16266-1-git-send-email-lrodriguez@atheros.com>
	 <1223073927-16266-2-git-send-email-lrodriguez@atheros.com>
	 <1223073927-16266-3-git-send-email-lrodriguez@atheros.com>
	 <43e72e890810041932n4034f3c6gbd5c64100338f61e@mail.gmail.com>
	 <f488382f0810041940p20544fdo88908c7f305a69de@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Oct 4, 2008 at 7:40 PM, Steven Noonan <steven@uplinklabs.net> wrote:
> On Sat, Oct 4, 2008 at 7:32 PM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
>> On Fri, Oct 3, 2008 at 3:45 PM, Luis R. Rodriguez
>> <lrodriguez@atheros.com> wrote:
>>> We were trying to hold the wrong spinlock due to a typo
>>> on IEEE80211_BAR_CTL_TID_S's definition. We use this to
>>> compute the tid number and then hold this this tid number's
>>> spinlock.
>>>
>>> Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
>>> Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
>>> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>>
>> Just a head up John -- Ingo has already sucked this into his tree with
>> a proper Reported-by. We still need it in wireless-testing though, not
>> sure how that will be handled.
>>
>>  Luis
>
> Oh, I should add a tested-by for this.
>
> Tested-by: Steven Noonan <steven@uplinklabs.net>

Thanks a lot for testing this Steven, your reports and tests are
greatly appreciated.

Let us know how ANI goes :)

  Luis
