Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:55825 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932165AbbFWSsU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jun 2015 14:48:20 -0400
Date: Tue, 23 Jun 2015 21:48:16 +0300
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] wireless: remove superfluous if statement in regulatory
 code
Message-ID: <20150623184816.GA26319@w1.fi> (sfid-20150623_204823_385727_8560E1D6)
References: <1435083066-6750-1-git-send-email-linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1435083066-6750-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 23, 2015 at 02:11:06PM -0400, John W. Linville wrote:
> In reg_process_hint, the test of "treatment == REG_REQ_IGNORE ||
> treatment == REG_REQ_ALREADY_SET" is superfluous because the code in the
> if-then branch is identical to the code after the if statement.

This was introduced (or well, left behind) by commit
eeca9fce1d71a4955855ceb0c3b13c1eb9db27c1 ('cfg80211: Schedule timeout
for all CRDA calls'). It could be useful to mention that commit in the
commit message since the resulting code from this new patch looks pretty
strange and that triggered me to take a closer look at what happened
here (looked like this is fine now).

> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> @@ -2080,9 +2080,6 @@ static void reg_process_hint(struct regulatory_request *reg_request)
>  		return;
>  	case NL80211_REGDOM_SET_BY_USER:
>  		treatment = reg_process_hint_user(reg_request);
> -		if (treatment == REG_REQ_IGNORE ||
> -		    treatment == REG_REQ_ALREADY_SET)
> -			return;
>  		return;

That assignment of 'treatment' is now write-only and you might as well
remove that while cleaning this up. This being the only caller of
reg_process_hint_user(), even more cleanup could be done by removing
return value from there, but I'm not sure whether that would be of
sufficient benefit.
 
-- 
Jouni Malinen                                            PGP id EFC895FA
