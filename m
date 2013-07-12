Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:54937 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932878Ab3GLL77 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jul 2013 07:59:59 -0400
Message-ID: <1373630396.8205.6.camel@jlt4.sipsolutions.net> (sfid-20130712_140001_770654_14F34A27)
Subject: Re: [PATCH] mac80211: fix regression when initializing ibss wmm
 params
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Fri, 12 Jul 2013 13:59:56 +0200
In-Reply-To: <1373558866-5756-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1373558866-5756-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-07-11 at 18:07 +0200, Simon Wunderlich wrote:
> There appear to be two regressions in ibss.c when calling
> ieee80211_sta_def_wmm_params():
>  * the second argument should be a rate length, not a rate array. This
>    was introduced by my commit "mac80211: select and adjust bitrates
>    according to channel mode"
>  * the third argument is not initialized (anymore), making further
>    checks within this function useless.
> 
> Since ieee80211_sta_def_wmm_params() is only used by ibss anyway,
> remove the function entirely and handle the operating mode decision
> immediately.

Applied.

johannes

