Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39432 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab3KYVKu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Nov 2013 16:10:50 -0500
Message-ID: <1385413847.4443.63.camel@jlt4.sipsolutions.net> (sfid-20131125_221053_397114_7D787DF5)
Subject: Re: [PATCHv2 2/5] mac80211: modify beacon using sdata/wdev-lock,
 not rtnl lock
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <sw@simonwunderlich.de>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 25 Nov 2013 22:10:47 +0100
In-Reply-To: <1385054393-17238-3-git-send-email-sw@simonwunderlich.de>
References: <1385054393-17238-1-git-send-email-sw@simonwunderlich.de>
	 <1385054393-17238-3-git-send-email-sw@simonwunderlich.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-11-21 at 18:19 +0100, Simon Wunderlich wrote:

> +#define sdata_dereference(p, sdata) \
> +	rcu_dereference_protected(p, &sdata->wdev.mtx)

This is obviously broken - I've fixed it.

johannes

