Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:36150 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932397AbeAOLrA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Jan 2018 06:47:00 -0500
Message-ID: <1516016818.410.10.camel@sipsolutions.net> (sfid-20180115_124704_345634_3AAA5A73)
Subject: Re: [PATCH v3 2/5] mac80211_hwsim: add hashtable with mac address
 keys for faster lookup
From: Johannes Berg <johannes@sipsolutions.net>
To: Benjamin Beichler <benjamin.beichler@uni-rostock.de>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 15 Jan 2018 12:46:58 +0100
In-Reply-To: <1d7bda28-6a77-4c4e-a3fc-3857b3c05aa1@MAIL2.uni-rostock.de>
References: <20180110164255.2763-1-benjamin.beichler@uni-rostock.de>
         <1d7bda28-6a77-4c4e-a3fc-3857b3c05aa1@MAIL2.uni-rostock.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-01-10 at 17:42 +0100, Benjamin Beichler wrote:
> This patch adds a rhastable for mac address lookup of hwsim radios. This
> especially improve the speed on reception of a netlink message with a new
> frame. Although redundant, we keep holding a normal list for all radios,
> since the rhashtable_walk interface adds a lot of overhead for iterating
> over all radios and the doc of rhashtable recommend a redundant structure
> for stable walks in such situations.
> 
> Since rhashtable is rcu protected we do not need a lock for delivering
> frames and thus improving this scenario.

Applied, but

> +static u32 hwsim_table_hash(const void *addr, u32 len, u32 seed)
> +{
> +	/* Use last four bytes of hw addr as hash index */
> +	return jhash_1word(*(u32 *)(addr + 2), seed);
> +}

I removed this, because that isn't actually safe - there's only 2-byte
alignment guaranteed... rhashtable will just do jhash() on the whole
thing, which should be fast enough.

johannes
