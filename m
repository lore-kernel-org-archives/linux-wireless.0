Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51989 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934816Ab2JYTD2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2012 15:03:28 -0400
Message-ID: <1351191838.10421.15.camel@jlt4.sipsolutions.net> (sfid-20121025_210332_103208_142D1636)
Subject: Re: [PATCH] mac80211: Don't inspect Sequence Control field on
 control frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: linville@tuxdriver.com, Javier Lopez <jlopex@cozybit.com>,
	linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Date: Thu, 25 Oct 2012 21:03:58 +0200
In-Reply-To: <1351188618-11155-1-git-send-email-javier@cozybit.com> (sfid-20121025_201029_989398_BC8461E0)
References: <1351188618-11155-1-git-send-email-javier@cozybit.com>
	 (sfid-20121025_201029_989398_BC8461E0)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-10-25 at 11:10 -0700, Javier Cardona wrote:
> Per IEEE Std. 802.11-2012, Sec 8.2.4.4.1, the sequence Control field is
> not present in control frames.  We noticed this problem when processing
> Block Ack Requests.
> 

Cc stable?

>  	hdr = (struct ieee80211_hdr *)rx->skb->data;
>  	fc = hdr->frame_control;
> +
> +	if (ieee80211_is_ctl(fc))
> +		return RX_CONTINUE;

Shouldn't that be "goto out"? And it seems it should also incorporate
the skb->len check here, rather than accessing the field before checking
that it's present?

johannes

