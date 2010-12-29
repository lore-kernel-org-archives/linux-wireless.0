Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49496 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492Ab0L2SNO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Dec 2010 13:13:14 -0500
Subject: Re: [PATCH] p54: fix compiler-warning when no P54_LEDS are
 configured
From: Johannes Berg <johannes@sipsolutions.net>
To: christoph.paasch@uclouvain.be
Cc: Larry Finger <Larry.Finger@lwfinger.net>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, chunkeey@googlemail.com
In-Reply-To: <201012291816.27302.christoph.paasch@uclouvain.be>
References: <1293635679-9783-1-git-send-email-christoph.paasch@uclouvain.be>
	 <4D1B65D7.8090103@lwfinger.net>
	 <201012291816.27302.christoph.paasch@uclouvain.be>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Dec 2010 19:13:10 +0100
Message-ID: <1293646390.3546.17.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-12-29 at 18:16 +0100, Christoph Paasch wrote:

> +#if defined(CONFIG_DEBUG_MUTEXES) || defined(CONFIG_P54_LEDS)
>  	struct p54_common *priv = dev->priv;
> +#endif

It seems a lot simpler to just add __maybe_unused...

johannes

