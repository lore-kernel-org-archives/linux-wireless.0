Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51177 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211Ab0BIHwA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Feb 2010 02:52:00 -0500
Subject: Re: [PATCH] ath9k: fix keycache leak in split tkip case
From: Johannes Berg <johannes@sipsolutions.net>
To: Ming Lei <tom.leiming@gmail.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	linville@tuxdriver.com, stable@kernel.org
In-Reply-To: <20100209093612.08d9ae17@tom-lei>
References: <1265467103-11474-1-git-send-email-tom.leiming@gmail.com>
	 <43e72e891002081338q466d9747p10a61b5e1aca4c6d@mail.gmail.com>
	 <20100209093612.08d9ae17@tom-lei>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Feb 2010 08:51:48 +0100
Message-ID: <1265701908.3783.13.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-02-09 at 09:36 +0800, Ming Lei wrote:
> From 67b0faf7e7a57c3e6a971ff43d1f03f8e939429b Mon Sep 17 00:00:00 2001
> From: Ming Lei <tom.leiming@gmail.com>
> Date: Sat, 6 Feb 2010 22:30:53 +0800
> Subject: [PATCH] ath9k: fix keycache leak in split tkip case
> 
> If split tkip key is used, ath_delete_key should delete
> rx key and rx mic key. This patch fixes the leak of hw
> keycache in the case.
> 
> ---
> The patch is against the latest wireless test tree.
> 
> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> Cc: stable@kernel.org

This is ordered wrong, it needs to be

----------
From: foo

If split ...

Signed-off-by: ...
Cc: stable...
---
The patch is against...
(everything after --- is removed from the commit log when committing)
----------

johannes

