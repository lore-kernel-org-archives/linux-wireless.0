Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53129 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757310Ab0EBQc6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 May 2010 12:32:58 -0400
Subject: Re: [RFC] ibss: Added channel type in order to create HT IBSS
From: Johannes Berg <johannes@sipsolutions.net>
To: Benoit Papillault <benoit.papillault@free.fr>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1272809528-11000-1-git-send-email-benoit.papillault@free.fr>
References: <1272809528-11000-1-git-send-email-benoit.papillault@free.fr>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 02 May 2010 18:32:54 +0200
Message-ID: <1272817974.31265.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2010-05-02 at 16:12 +0200, Benoit Papillault wrote:
> When joining an IBSS, the parameters can be used to create the IBSS. As
> such, we need to know if the user wants to create an HT IBSS or not.
> This is accomplish by passing the channel type (ie ht20, ht40- or
> ht40+). Default is to create a non HT IBSS.
> 
> Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>
> ---
> It is needed for upcoming patches regarding HT IBSS
>  ibss.c |   27 ++++++++++++++++++++++++++-
>  1 files changed, 26 insertions(+), 1 deletions(-)
> 
> diff --git a/ibss.c b/ibss.c
> index 4715ac8..4003a38 100644
> --- a/ibss.c
> +++ b/ibss.c
> @@ -18,6 +18,15 @@ static int join_ibss(struct nl80211_state *state,
>  {
>  	char *end;
>  	unsigned char abssid[6];
> +	int i;
> +	static const struct {
> +		const char *name;
> +		unsigned int val;
> +	} htmap[] = {
> +		{ .name = "HT20", .val = NL80211_CHAN_HT20, },
> +		{ .name = "HT40+", .val = NL80211_CHAN_HT40PLUS, },
> +		{ .name = "HT40-", .val = NL80211_CHAN_HT40MINUS, },
> +	};

There's code to do something like this already when setting the channel,
please factor it out and use it in both places.

johannes

