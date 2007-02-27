Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([199.232.76.164]:40271 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbXB0BSf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Feb 2007 20:18:35 -0500
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1HLqxf-0000Eh-Nm
	for linux-wireless@vger.kernel.org; Mon, 26 Feb 2007 20:16:59 -0500
Subject: Re: [PATCH] d80211: fix sparse warnings
From: Pavel Roskin <proski@gnu.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1172530759.3870.205.camel@johannes.berg>
References: <1172530759.3870.205.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 26 Feb 2007 20:18:29 -0500
Message-Id: <1172539109.5835.28.camel@dv>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2007-02-26 at 23:59 +0100, Johannes Berg wrote:
> This fixes some sparse warnings in d80211.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> 
> ---
> A few warnings remain:
> 
> net/d80211/ieee80211.c:820:37: warning: potentially expensive pointer subtraction

That's subtraction of pointers to types with sizes that are not power of
two.  This could lead to expensive division operations.  In may cases,
this warning indicates that using array indices instead of pointers
would be more effective (and probably safer).

> net/d80211/ieee80211_ioctl.c:779:4: warning: incorrect type in argument 6 (different signedness)
> net/d80211/ieee80211_ioctl.c:779:4:    expected int *err
> net/d80211/ieee80211_ioctl.c:779:4:    got unsigned int *<noident>

ieee80211_set_encryption() expects a pointer to (signed) integer, be the
code is giving it a pointer to u32.  Please decide what type "err"
should have, and change the function accordingly.

I think "u32" would be better, since it's a part of the hostapd
compatibility code and we don't want to touch the userspace now.  This
code is going to be obsoleted with the rest of hostapd interface.  For
now, it's better to do exactly what the userspace expects.

> net/d80211/sta_info.c:232:3: warning: context imbalance in 'sta_info_free' - unexpected unlock
> 
> The last of these is bogus, the code is perfectly fine. The other two I
> don't understand.

Great catch!  I have reduced this to a simple test case where sparse
behaves unreasonably, and I'm going to send it to sparse developers as a
bug report.

In case you are wondering, the test case is:

void my_lock(void) __attribute__ ((context(lock, 0, 1)));
void my_unlock(void) __attribute__ ((context(lock, 1, 0)));
void foo(void);
static void sta_info_free(int locked)
{
	if (locked)
		my_lock();
	foo();
	if (locked)
		my_unlock();
}

-- 
Regards,
Pavel Roskin

