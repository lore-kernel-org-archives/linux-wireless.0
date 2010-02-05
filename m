Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:65266 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933310Ab0BEHkE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Feb 2010 02:40:04 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 04 Feb 2010 23:40:04 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19307.53126.346898.490736@gargle.gargle.HOWL>
Date: Fri, 5 Feb 2010 13:27:58 +0530
To: Benoit PAPILLAULT <benoit.papillault@free.fr>
CC: "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath9k: Fix rate table choice
In-Reply-To: <4B6BC701.7060407@free.fr>
References: <1265317566-15372-1-git-send-email-benoit.papillault@free.fr>
	<19307.41957.838154.472055@gargle.gargle.HOWL>
	<4B6BC701.7060407@free.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Benoit PAPILLAULT wrote:
> Sure, but when the channel is switched, ath9k rate control is not called
> AFAIK. So nothing is updated.
> ath_rate_update is called by rate_control_rate_update, which is only
> called by enable_ht. enable_ht is called as association time and on RX
> beacon. However, since the content of RX beacon is not changed,
> rate_control_rate_update will not be called again. That's what I show in
> my logs...

Can you post the ath9k logs with debug=0x200 ?

> Will try to do it. I see your point :
> - current code never enables ht40 rate table, but the rate table if
> updated if the AP switch to an ht20 operating channel.

Hm, if the channel type is HT40, then ath9k would enable HT40 in RC.

Sujith
