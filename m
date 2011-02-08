Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51835 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708Ab1BHWGL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Feb 2011 17:06:11 -0500
Received: by iwn9 with SMTP id 9so6215749iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 08 Feb 2011 14:06:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1297200372-79404-2-git-send-email-nbd@openwrt.org>
References: <1297200372-79404-1-git-send-email-nbd@openwrt.org>
	<1297200372-79404-2-git-send-email-nbd@openwrt.org>
Date: Tue, 8 Feb 2011 23:06:10 +0100
Message-ID: <AANLkTinhX9R9XY2_BoJXkRxNMZ3F_Adzwcq5XVQyEX0t@mail.gmail.com>
Subject: Re: [RFC 2/2] ath9k: fix powersave frame filtering/buffering in AP mode
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, j@w1.fi, lrodriguez@atheros.com,
	m.sujith@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 8, 2011 at 10:26 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> This patch fixes a long standing issue of pending packets in the queue being
> sent (and retransmitted many times) to sleeping stations.
> This was made worse by aggregation through driver-internal retransmitting
> of A-MDPU subframes.

Nice. :) Just one thought, shouldn't there be one more call to
ieee80211_sta_set_tim() somewhere? I'm thinking there might be a race
condition otherwise where the tid queues are empty on sta_notify but
then later some failed/filtered A-MPDU subframes get queued...

Also, just curious so feel free to answer or not, but how does the
hardware handle the ps filter thing? Does it have a ps bit for every
dst address? How many different dsts can it keep track of?

/Björn
