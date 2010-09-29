Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59450 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab0I2G7a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Sep 2010 02:59:30 -0400
Subject: Re: [PATCH] iw:  Flush stdout when printing events.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1285720244-26149-1-git-send-email-greearb@candelatech.com>
References: <1285720244-26149-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Sep 2010 08:59:27 +0200
Message-ID: <1285743567.3756.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-09-28 at 17:30 -0700, greearb@candelatech.com wrote:

> -#define PARSE_BEACON_CHAN(_attr, _chan) do { \
> -	r = parse_beacon_hint_chan(tb[_attr], \
> -				   &_chan); \
> -	if (r) \
> -		return NL_SKIP; \
> -} while (0)
> +
> +#define PARSE_BEACON_CHAN(_attr, _chan) do {		\
> +		r = parse_beacon_hint_chan(tb[_attr],	\
> +					   &_chan);	\
> +		if (r) {				\
> +			fflush(stdout);			\
> +			return NL_SKIP;			\
> +		}					\
> +	} while (0)
> +

Why does that need fflush() here? We'll eventually finish that line, no?

>  	struct genlmsghdr *gnlh = nlmsg_data(nlmsg_hdr(msg));
>  	struct nlattr *tb[NL80211_ATTR_MAX + 1], *nst;
>  	struct print_event_args *args = arg;
> @@ -349,6 +353,7 @@ static int print_event(struct nl_msg *msg, void *arg)
>  		break;
>  	}
>  
> +	fflush(stdout);
>  	return NL_SKIP;
>  #undef PARSE_BEACON_CHAN

This I'll apply.

> @@ -369,8 +374,8 @@ static int wait_event(struct nl_msg *msg, void *arg)
>  	for (i = 0; i < wait->n_cmds; i++) {
>  		if (gnlh->cmd == wait->cmds[i]) {
>  			wait->cmd = gnlh->cmd;
> -		if (wait->pargs)
> -			print_event(msg, wait->pargs);
> +			if (wait->pargs)
> +				print_event(msg, wait->pargs);

And this is an unrelated patch.

johannes

