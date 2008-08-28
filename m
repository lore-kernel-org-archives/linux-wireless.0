Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:40008 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828AbYH1MfO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 08:35:14 -0400
Date: Thu, 28 Aug 2008 15:34:07 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Fix debugfs union misuse and pointer
	corruption
Message-ID: <20080828123407.GC4863@jm.kir.nu> (sfid-20080828_143518_189324_8ECF0A14)
References: <20080828121206.GA4863@jm.kir.nu> <1219925923.25321.12.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1219925923.25321.12.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 28, 2008 at 02:18:43PM +0200, Johannes Berg wrote:

> Acked-by: Johannes Berg <johannes@sipsolutions.net>
> 
> also the other similar patch, sorry about this, it's surely my mistake.

Dave already took the other fix. This new one is a bit less likely to
cause real problems for most users (i.e., I'm not too concerned about
getting this into 2.6.27).

I'm trying to fix the netdev:mon.wlan0 not being removed correctly
with my 802.11w patches (incorrect order in debugfs keys vs. netdev
deletion) and was seeing very strange behavior here.. I had just added
yet another dentry into the union since I was just duplicating the code
used for default_key symlink.. None of the debug prints made any sense
until I noticed that these "two" pointers were actually changing values
at the same time.. Unions are evil if you do not notice you are using
one ;-).

-- 
Jouni Malinen                                            PGP id EFC895FA
