Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:65013 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755118Ab0KRHj3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 02:39:29 -0500
Received: by iwn35 with SMTP id 35so3165685iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 17 Nov 2010 23:39:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201011181536.45076.br1@einfach.org>
References: <1290059169-2468-1-git-send-email-lrodriguez@atheros.com> <201011181536.45076.br1@einfach.org>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 17 Nov 2010 23:39:08 -0800
Message-ID: <AANLkTinEMTf28PFbDwcR5+TCc07_R=2LV3Oycdoa9x-5@mail.gmail.com>
Subject: Re: [PATCH 0/4] cfg80211: fix bug with multiple cards and a CRDA delay
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, mark@moxienet.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 17, 2010 at 10:36 PM, Bruno Randolf <br1@einfach.org> wrote:
> On Thu November 18 2010 14:46:05 Luis R. Rodriguez wrote:
>> This series addresses the bug pointed out by Mark Mentovai
>> <mark@moxienet.com> when there is a delay on CRDA and you use multiple
>> cards with the same regulatory domain. After some testing I realized this
>> also introduced an issue when using multiple cards with different
>> regulatory settings. The issue is present only when there is a delay in
>> CRDA so technically this is not a regression so I am not marking these as
>> stable fixes. It also does not seem to be a regulatory bug as when the
>> issue is present you'd end up with an intersected regulatory domain (same
>> alpha2s) or get the regulatory domain rejected for the second card if the
>> alpha2 was different.
>>
>> Thanks to Mark for his testing, good ideas on alternative ways to resolve
>> this and thorough reports.
>>
>> Luis R. Rodriguez (4):
>>   cfg80211: put core regulatory request into queue
>>   cfg80211: move reg_work and reg_todo above
>>   cfg80211: move mutex locking to reg_process_pending_hints()
>>   cfg80211: Fix regulatory bug with multiple cards and delays
>>
>>  include/net/regulatory.h |    7 ++++
>>  net/wireless/reg.c       |   80
>> +++++++++++++++++++++++++++++++-------------- 2 files changed, 62
>> insertions(+), 25 deletions(-)
>
> Yep - this fixes also my case (slow board under load + two or more ath5k
> cards). Thanks, Luis!

Thanks for testing and sorry it took so long to look into this, but
I've just been piled with tons of stuff.

  Luis
