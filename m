Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35667 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811AbbLCTSI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Dec 2015 14:18:08 -0500
MIME-Version: 1.0
In-Reply-To: <1449162322.31265.2.camel@sipsolutions.net>
References: <1449157807-20298-1-git-send-email-aryabinin@virtuozzo.com>
	<1449157807-20298-3-git-send-email-aryabinin@virtuozzo.com>
	<1449162322.31265.2.camel@sipsolutions.net>
Date: Thu, 3 Dec 2015 22:18:05 +0300
Message-ID: <CAPAsAGyXcsGrneze--o+F=tJpV4cmdgfB-MxZ5S3yB10nG+v3A@mail.gmail.com> (sfid-20151203_201825_735756_EFF31DBC)
Subject: Re: [PATCH v4 2/3] mac80211: Prevent build failure with CONFIG_UBSAN=y
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-wireless@vger.kernel.org,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Peter Zijlstra <peterz@infradead.org>,
	Sasha Levin <sasha.levin@oracle.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Jonathan Corbet <corbet@lwn.net>,
	Michal Marek <mmarek@suse.cz>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Yury Gribov <y.gribov@samsung.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Konstantin Khlebnikov <koct9i@gmail.com>,
	Kostya Serebryany <kcc@google.com>,
	"x86@kernel.org" <x86@kernel.org>,
	"open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
	"open list:KERNEL BUILD + fi..." <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2015-12-03 20:05 GMT+03:00 Johannes Berg <johannes@sipsolutions.net>:
> On Thu, 2015-12-03 at 18:50 +0300, Andrey Ryabinin wrote:
>> With upcoming CONFIG_UBSAN the following BUILD_BUG_ON in
>> net/mac80211/debugfs.c starts to trigger:
>>       BUILD_BUG_ON(hw_flag_names[NUM_IEEE80211_HW_FLAGS] != (void
>> *)0x1);
>>
>> It seems, that compiler instrumentation causes some code
>> deoptimizations.
>> Because of that GCC is not being able to resolve condition in
>> BUILD_BUG_ON()
>> at compile time.
>>
>> We could make size of hw_flag_names array unspecified and replace the
>> condition in BUILD_BUG_ON() with following:
>>       ARRAY_SIZE(hw_flag_names) != NUM_IEEE80211_HW_FLAGS
>>
>> That will have the same effect as before (adding new flag without
>> updating
>> array will trigger build failure) except it doesn't fail with
>> CONFIG_UBSAN.
>> As a bonus this patch slightly decreases size of hw_flag_names array.
>>
> Seems fine, would you want to take it through some other tree together
> with UBSAN, or do you expect that to still take long enough to allow
> this to trickle through our trees?
>

I expect that Andrew will take it with UBSAN for 4.5
