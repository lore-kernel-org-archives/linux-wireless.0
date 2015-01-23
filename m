Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35419 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750996AbbAWJm6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 04:42:58 -0500
Message-ID: <1422006174.2728.12.camel@sipsolutions.net> (sfid-20150123_104302_972030_ACE35486)
Subject: Re: [PATCH v3] mac80211: Avoid STA expiration timer truncation to
 u32
From: Johannes Berg <johannes@sipsolutions.net>
To: Masashi Honma <masashi.honma@gmail.com>
Cc: linux-wireless@vger.kernel.org, me@bobcopeland.com
Date: Fri, 23 Jan 2015 10:42:54 +0100
In-Reply-To: <1421722023-4691-1-git-send-email-masashi.honma@gmail.com> (sfid-20150120_034734_203758_428E04AE)
References: <CAFk-A4nF4jPiFR1c9fx-+sa=YWUZseEOKtut7rKWHihmLWp02w@mail.gmail.com>
	 <1421722023-4691-1-git-send-email-masashi.honma@gmail.com>
	 (sfid-20150120_034734_203758_428E04AE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-01-20 at 11:47 +0900, Masashi Honma wrote:
> On some combination of plink_timeout and HZ, the STA expiration timer will be
> unexpectedly truncated to u32. Maybe there is a question "Who sets such a large
> number to plink_timeout ?". At least wpa_supplicant will set 0xffffffff to
> plink_timeout to disable this timer because wpa_supplicant has it's own
> expiration mechanism.

Ok - but that doesn't really disable the timer? Perhaps we should have a
new userspace API to explicitly disable it? OTOH, worst case I guess
that means it's like >100 years in the future, so I guess it doesn't
matter. However, though, you can hardly rely on this fix being present
in the kernel, so you can't really set such a large value
unconditionally anyway, no? Otherwise a newer wpa_supplicant running on
an older kernel would suddenly behave incorrectly. That doesn't seem
right.

Having an explicit feature to disable plink timeout would perhaps be
better?

> --- a/net/mac80211/mesh.c
> +++ b/net/mac80211/mesh.c
> @@ -573,8 +573,11 @@ static void ieee80211_mesh_housekeeping(struct ieee80211_sub_if_data *sdata)
>  {
>  	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
>  	u32 changed;
> +	u64 exp_time;
>  
> -	ieee80211_sta_expire(sdata, ifmsh->mshcfg.plink_timeout * HZ);
> +	exp_time = ifmsh->mshcfg.plink_timeout * (u64)HZ;
> +	if (exp_time < 0x100000000)
> +		ieee80211_sta_expire(sdata, exp_time);

I'm not convinced this is right. For one, I believe on 32-bit machines
you'll need to write "0x100000000ULL" instead of the plain constant.
Perhaps preferably, you'd use use ">= MAX_UINT".

However, the argument to ieee80211_sta_expire() is an unsigned long (as
is jiffies), so on 64-bit machines you could even still use the value
and the conditional isn't needed.

Given these complications, I would prefer having a feature attribute to
treat e.g. 0 as disabling the timer entirely, and if this feature isn't
present then have wpa_supplicant instead use a safe value that doesn't
trigger the kernel bug - e.g. 0xffffffff/1000 [which is the max possible
HZ].

johannes

