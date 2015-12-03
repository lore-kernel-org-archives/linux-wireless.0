Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33513 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821AbbLCRGa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Dec 2015 12:06:30 -0500
Message-ID: <1449162322.31265.2.camel@sipsolutions.net> (sfid-20151203_180710_783813_BD61CA21)
Subject: Re: [PATCH v4 2/3] mac80211: Prevent build failure with
 CONFIG_UBSAN=y
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrey Ryabinin <aryabinin@virtuozzo.com>,
	linux-kernel@vger.kernel.org
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Andrew Morton <akpm@linux-foundation.org>,
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
	Kostya Serebryany <kcc@google.com>, x86@kernel.org,
	linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org
Date: Thu, 03 Dec 2015 18:05:22 +0100
In-Reply-To: <1449157807-20298-3-git-send-email-aryabinin@virtuozzo.com>
References: <1449157807-20298-1-git-send-email-aryabinin@virtuozzo.com>
	 <1449157807-20298-3-git-send-email-aryabinin@virtuozzo.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-12-03 at 18:50 +0300, Andrey Ryabinin wrote:
> With upcoming CONFIG_UBSAN the following BUILD_BUG_ON in
> net/mac80211/debugfs.c starts to trigger:
> 	BUILD_BUG_ON(hw_flag_names[NUM_IEEE80211_HW_FLAGS] != (void
> *)0x1);
> 
> It seems, that compiler instrumentation causes some code
> deoptimizations.
> Because of that GCC is not being able to resolve condition in
> BUILD_BUG_ON()
> at compile time.
> 
> We could make size of hw_flag_names array unspecified and replace the
> condition in BUILD_BUG_ON() with following:
> 	ARRAY_SIZE(hw_flag_names) != NUM_IEEE80211_HW_FLAGS
> 
> That will have the same effect as before (adding new flag without
> updating
> array will trigger build failure) except it doesn't fail with
> CONFIG_UBSAN.
> As a bonus this patch slightly decreases size of hw_flag_names array.
> 
Seems fine, would you want to take it through some other tree together
with UBSAN, or do you expect that to still take long enough to allow
this to trickle through our trees?

johannes
