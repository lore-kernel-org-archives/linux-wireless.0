Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:37503 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754680Ab3FKM06 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jun 2013 08:26:58 -0400
Message-ID: <1370953615.8356.34.camel@jlt4.sipsolutions.net> (sfid-20130611_142700_947067_F920588E)
Subject: Re: [PATCH 1/2] iw: Allow user to provide freq during mesh join
From: Johannes Berg <johannes@sipsolutions.net>
To: Ashok Nagarajan <ashok@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	devel@lists.open80211s.org, javier@cozybit.com
Date: Tue, 11 Jun 2013 14:26:55 +0200
In-Reply-To: <1370280859-9860-1-git-send-email-ashok@cozybit.com> (sfid-20130603_193427_844091_21123EA3)
References: <1370280859-9860-1-git-send-email-ashok@cozybit.com>
	 (sfid-20130603_193427_844091_21123EA3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-06-03 at 10:34 -0700, Ashok Nagarajan wrote:
> Allow user to configure frequency and channel type during mesh join command.
> 
> Signed-off-by: Ashok Nagarajan <ashok@cozybit.com>
> ---
>  mesh.c |   49 ++++++++++++++++++++++++++++++++++++++++++++++---
>  1 files changed, 46 insertions(+), 3 deletions(-)
> 
> diff --git a/mesh.c b/mesh.c
> index 5a09b62..ec202c9 100644
> --- a/mesh.c
> +++ b/mesh.c
> @@ -431,8 +431,18 @@ static int join_mesh(struct nl80211_state *state, struct nl_cb *cb,
>  {
>  	struct nlattr *container;
>  	float rate;
> -	int bintval, dtim_period;
> +	int bintval, dtim_period, i;
>  	char *end;
> +	static const struct {
> +		const char *name;
> +		unsigned int val;
> +	} htmap[] = {
> +		{ .name = "HT20", .val = NL80211_CHAN_HT20, },
> +		{ .name = "HT40+", .val = NL80211_CHAN_HT40PLUS, },
> +		{ .name = "HT40-", .val = NL80211_CHAN_HT40MINUS, },
> +		{ .name = "NOHT", .val = NL80211_CHAN_NO_HT, },
> +	};

I think you should use chandefs already, to allow for VHT. Also, it'd be
good to refactor the channel parsing for this, monitor and IBSS (though
I wonder why I haven't done that already?)

johannes

