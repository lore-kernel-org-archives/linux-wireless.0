Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47487 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824Ab0HBNY4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Aug 2010 09:24:56 -0400
Subject: Re: [PATCH 3/3] mac80211: AMPDU rx reorder timeout timer
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <201008021516.29731.chunkeey@googlemail.com>
References: <201007270820.25347.chunkeey@googlemail.com>
	 <1280219845.19098.4.camel@jlt3.sipsolutions.net>
	 <201007281721.51568.chunkeey@googlemail.com>
	 <201008021516.29731.chunkeey@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 Aug 2010 15:24:55 +0200
Message-ID: <1280755495.3923.14.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-08-02 at 15:16 +0200, Christian Lamparter wrote:

> @@ -110,6 +110,7 @@ struct tid_ampdu_tx {
>   * @timeout: reset timer value (in TUs).
>   * @dialog_token: dialog token for aggregation session
>   * @rcu_head: RCU head used for freeing this struct
> + * @lock: controls exclusive access to the struct
>   *
>   * This structure is protected by RCU and the per-station
>   * spinlock. Assignments to the array holding it must hold

I think that's misleading. You're only using it to control access to the
reorder stuff here, not any of the other things that are used in
agg-rx.c.

Also, documentation for reorder_timer is missing.

johannes

