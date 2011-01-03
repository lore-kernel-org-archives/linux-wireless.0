Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58689 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069Ab1ACQqf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jan 2011 11:46:35 -0500
Subject: Re: OOPS at ieee80211_aes_ccm_encrypt()?
From: Johannes Berg <johannes@sipsolutions.net>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20110103001006.13085vt89qfm6pcs@hayate.sektori.org>
References: <20110103001006.13085vt89qfm6pcs@hayate.sektori.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 Jan 2011 17:46:30 +0100
Message-ID: <1294073190.3436.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-01-03 at 00:10 +0200, Jussi Kivilinna wrote:

> While doing stress testing on zd1211rw AP-mode I run into this problem  
> that I don't think has that much to do with zd1211rw:

[snip]

> Is key being used after freeing?

It looks like it. Can you reproduce this fairly easily? I wonder if it's
an RCU problem, we do key lookups under RCU but I see no grace period
right now ... try the patch below, I'll look into it in more detail.

johannes

--- wireless-testing.orig/net/mac80211/key.c	2011-01-03 17:44:54.000000000 +0100
+++ wireless-testing/net/mac80211/key.c	2011-01-03 17:45:41.000000000 +0100
@@ -379,6 +379,8 @@ static void __ieee80211_key_destroy(stru
 	if (!key)
 		return;
 
+	synchronize_rcu();
+
 	if (key->local)
 		ieee80211_key_disable_hw_accel(key);
 


