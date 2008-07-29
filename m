Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.179]:46506 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755188AbYG2MDq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 08:03:46 -0400
Received: by ik-out-1112.google.com with SMTP id c28so4683308ika.5
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jul 2008 05:03:45 -0700 (PDT)
Subject: Re: [PATCH] mac80211: partially fix skb->cb use
From: Luis Carlos Cobo <luisca@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1217332288.10489.33.camel@johannes.berg>
References: <1217323927.10489.9.camel@johannes.berg>
	 <1217330604.6379.12.camel@localhost>
	 (sfid-20080729_132329_995714_6D2C9701)  <1217330667.10489.19.camel@johannes.berg>
	 <1217331773.6379.25.camel@localhost>
	 (sfid-20080729_134300_214751_172329C5)  <1217332288.10489.33.camel@johannes.berg>
Content-Type: text/plain
Date: Tue, 29 Jul 2008 14:03:40 +0200
Message-Id: <1217333020.6379.31.camel@localhost> (sfid-20080729_140349_649719_4EA25C8B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-07-29 at 13:51 +0200, Johannes Berg wrote:
> That sounds sane to me, then you don't need the cb at all, do you? Can
> just send it to the master dev with skb->do_not_encrypt set, right?

Right.

> In fact, looking at the code, there seems to be a bug with promisc, are
> you sure it's allowed to netif_rx/dev_queue_xmit the same frame?

I see, not doing a copy on that case. Yeah, that needs to be fixed, I'll
take care of it.


-- 
Luis Carlos Cobo Rus       GnuPG ID: 44019B60
cozybit Inc.


