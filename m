Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57619 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265Ab1GNJvv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2011 05:51:51 -0400
Subject: Re: [PATCH 4/5] mac80211: move RSN IE to tail of mesh beacon
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1310600747-9583-5-git-send-email-thomas@cozybit.com> (sfid-20110714_014636_987067_066D29B9)
References: <1310600747-9583-1-git-send-email-thomas@cozybit.com>
	 <1310600747-9583-5-git-send-email-thomas@cozybit.com>
	 (sfid-20110714_014636_987067_066D29B9)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Jul 2011 11:51:48 +0200
Message-ID: <1310637108.3874.1.camel@jlt3.sipsolutions.net> (sfid-20110714_115153_845032_0B1C255E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-07-13 at 16:45 -0700, Thomas Pedersen wrote:

> +			if (skb_tailroom(skb) > len)
> +				memcpy(skb_put(skb, len), data, len);
> +			else
> +				printk(KERN_ERR "o11s: not enough tailroom\n");

Can this printk happen? If not, how about WARN(1, ...);, and if, I think
there should be better handling than a printk.

johannes

