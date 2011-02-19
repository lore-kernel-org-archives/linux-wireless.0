Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38550 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482Ab1BSJYJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Feb 2011 04:24:09 -0500
Subject: Re: [PATCH] ath9k: Implement op_flush()
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1298106822-9411-1-git-send-email-vasanth@atheros.com>
References: <1298106822-9411-1-git-send-email-vasanth@atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 19 Feb 2011 10:24:00 +0100
Message-ID: <1298107440.3725.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-02-19 at 01:13 -0800, Vasanthakumar Thiagarajan wrote:
> When op_flush() is called with no drop (drop=false), the driver
> tries to tx as many frames as possible in about 100ms on every
> hw queue. During this time period frames from sw queue are also
> scheduled on to respective hw queue.

Given how long HW queues currently are, I wouldn't set the timeout to
100ms -- mac80211 has no expectation how long this will take, although
100ms seems pretty long I'm not sure it'll always be sufficient?

johannes

