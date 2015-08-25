Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0134.hostedemail.com ([216.40.44.134]:38549 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751990AbbHYA2f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Aug 2015 20:28:35 -0400
Message-ID: <1440462512.2670.83.camel@perches.com> (sfid-20150825_022839_232088_3EC85C54)
Subject: Re: [PATCH] rfkill: Copy "all" global state to other types
From: Joe Perches <joe@perches.com>
To: =?ISO-8859-1?Q?Jo=E3o?= Paulo Rechi Vita <jprvita@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	=?ISO-8859-1?Q?Jo=E3o?= Paulo Rechi Vita
	<jprvita@endlessm.com>
Date: Mon, 24 Aug 2015 17:28:32 -0700
In-Reply-To: <1440432084-20928-1-git-send-email-jprvita@endlessm.com>
References: <1440432084-20928-1-git-send-email-jprvita@endlessm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-08-24 at 12:01 -0400, João Paulo Rechi Vita wrote:
> When switching the state of all RFKill switches of type all we need to
> replicate the RFKILL_TYPE_ALL global state to all the other types global
> state, so it is used to initialize persistent RFKill switches on
> register.
[]
> diff --git a/net/rfkill/core.c b/net/rfkill/core.c
[]
> @@ -341,7 +341,14 @@ static void __rfkill_switch_all(const enum rfkill_type type, bool blocked)
>  {
>  	struct rfkill *rfkill;
>  
> -	rfkill_global_states[type].cur = blocked;
> +	if (type == RFKILL_TYPE_ALL) {
> +		enum rfkill_type i;

Does it really make sense to use an enum here?

> +		for (i = 0; i < NUM_RFKILL_TYPES; i++)
> +			rfkill_global_states[i].cur = blocked;

increment it and then use it as an index?

Most every other loop use of NUM_RFKILL_TYPES is int


