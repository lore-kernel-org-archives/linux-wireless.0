Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:54445 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933733Ab3EGN6A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 May 2013 09:58:00 -0400
Message-ID: <1367935076.8328.35.camel@jlt4.sipsolutions.net> (sfid-20130507_155816_530016_D42CA868)
Subject: Re: [PATCH v2 1/2] cfg80211: Userspace may inform kernel of mesh
 auth method.
From: Johannes Berg <johannes@sipsolutions.net>
To: Colleen Twitty <colleen@cozybit.com>
Cc: open80211s <devel@lists.open80211s.org>,
	linux-wirelss <linux-wireless@vger.kernel.org>
Date: Tue, 07 May 2013 15:57:56 +0200
In-Reply-To: <1367884164-15953-1-git-send-email-colleen@cozybit.com> (sfid-20130507_014932_282742_1BD03472)
References: <1367884164-15953-1-git-send-email-colleen@cozybit.com>
	 (sfid-20130507_014932_282742_1BD03472)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-05-06 at 16:49 -0700, Colleen Twitty wrote:

> +	if (tb[NL80211_MESH_SETUP_AUTH_PROTOCOL]) {
> +		if (!setup->user_mpm)
> +			return -EINVAL;
> +		switch (nla_get_u8(tb[NL80211_MESH_SETUP_AUTH_PROTOCOL])) {
> +		case NL80211_AUTHTYPE_SAE:
> +			setup->auth_id = IEEE80211_AUTH_PROTO_SAE;
> +			break;
> +		case NL80211_AUTHTYPE_OPEN_SYSTEM:
> +			setup->auth_id = IEEE80211_AUTH_PROTO_NONE;
> +			break;
> +		default:
> +			return -EINVAL;
> +		}
> +	}

Ok one more question. Does it actually make sense to check the auth
protocol?

>From what I see, the entire auth protocol (e.g. SAE) is handled entirely
in userspace, so if somebody invents a new protocol (e.g. number 3), or
wants to use 802.1X (number 2) they should also be able to implement
that completely in userspace. As such, why validate it? It could be a
valid protocol?

Or am I missing something and there's some kernel part involved in
handling the auth protocol, so we need to check that the kernel code
actually supports it?

johannes

