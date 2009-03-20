Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:38367 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758617AbZCTQDU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2009 12:03:20 -0400
Date: Fri, 20 Mar 2009 18:03:08 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>
Subject: Re: [PATCH v2] mac80211: resume properly, add suspend/resume test
Message-ID: <20090320160308.GB28965@jm.kir.nu> (sfid-20090320_170325_117435_EF5AD2EF)
References: <1236939917.5235.7.camel@johannes.local> <1236941058.5235.12.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1236941058.5235.12.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 13, 2009 at 11:44:18AM +0100, Johannes Berg wrote:

> --- wireless-testing.orig/net/mac80211/debugfs.c	2009-03-13 11:36:57.000000000 +0100
> +++ wireless-testing/net/mac80211/debugfs.c	2009-03-13 11:41:53.000000000 +0100
> +static ssize_t reset_write(struct file *file, const char __user *user_buf,
> +			   size_t count, loff_t *ppos)

> +	__ieee80211_suspend(&local->hw);
> +	__ieee80211_resume(&local->hw);

This seems to have broken build if CONFIG_PM is not defined: pm.c, with
these functions, is not included.

-- 
Jouni Malinen                                            PGP id EFC895FA
