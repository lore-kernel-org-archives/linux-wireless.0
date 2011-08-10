Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34743 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab1HJNia (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 09:38:30 -0400
Subject: Re: [PATCH 1/8] mac80211: improve mpath debugging
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org,
	Javier Cardona <javier@cozybit.com>, linville@tuxdriver.com
In-Reply-To: <1312933511-9486-2-git-send-email-thomas@cozybit.com> (sfid-20110810_014656_188483_29CF88BD)
References: <1312933511-9486-1-git-send-email-thomas@cozybit.com>
	 <1312933511-9486-2-git-send-email-thomas@cozybit.com>
	 (sfid-20110810_014656_188483_29CF88BD)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Aug 2011 15:38:27 +0200
Message-ID: <1312983507.4325.1.camel@jlt3.sipsolutions.net> (sfid-20110810_153832_472660_F04398D5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-08-09 at 16:45 -0700, Thomas Pedersen wrote:

> +#ifdef CONFIG_MAC80211_VERBOSE_MPATH_DEBUG
> +#define mpath_dbg(fmt, args...)	printk(KERN_DEBUG fmt, ##args)
> +#else
> +#define mpath_dbg(fmt, args...)	do { (void)(0); } while (0)
> +#endif

Maybe this should be a static inline for checking the fmt args even when
it's compiled out?

johannes

