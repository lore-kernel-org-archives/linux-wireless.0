Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47002 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759798Ab2JaTK5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Oct 2012 15:10:57 -0400
Message-ID: <1351710647.6281.10.camel@jlt4.sipsolutions.net> (sfid-20121031_201100_923196_D771AF08)
Subject: Re: WARNING in agg-tx.c (3.5.7+, not tainted)
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <509173D0.9010701@candelatech.com> (sfid-20121031_195414_905498_198D44C4)
References: <509173D0.9010701@candelatech.com>
	 (sfid-20121031_195414_905498_198D44C4)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 31 Oct 2012 20:10:47 +0100
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-10-31 at 11:54 -0700, Ben Greear wrote:
> While trying to debug another kernel splat, I saw this one.  System was
> in process of creating and getting DHCP for 400 virtual stations.
> 
> Code in question:
> 
> 
> 
> 	mutex_lock(&sta->ampdu_mlme.mtx);
> 	tid_tx = rcu_dereference_protected_tid_tx(sta, tid);
> 
> 	if (WARN_ON(!tid_tx)) {
> #ifdef CONFIG_MAC80211_HT_DEBUG
> 		printk(KERN_DEBUG "addBA was not requested!\n");
> #endif

Hm should probably be a WARN(), but ...

>From the backtrace it looks like maybe you were tearing down the
interface? So maybe it's possible that you were remove it or something,
and the driver had just accepted the session? Hmm.

johannes

