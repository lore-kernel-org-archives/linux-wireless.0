Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:50989 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751420Ab3KTQ5R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Nov 2013 11:57:17 -0500
Message-ID: <528CE9E2.7030707@openwrt.org> (sfid-20131120_175720_673169_EB6366EF)
Date: Wed, 20 Nov 2013 17:57:06 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Karl Beldan <karl.beldan@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: Re: [PATCH] mac80211: use capped prob when computing throughputs
References: <1384908668-27869-1-git-send-email-karl.beldan@gmail.com> <528C6590.1000803@openwrt.org>
In-Reply-To: <528C6590.1000803@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-11-20 08:32, Felix Fietkau wrote:
> On 2013-11-20 01:51, Karl Beldan wrote:
>> From: Karl Beldan <karl.beldan@rivierawaves.com>
>> 
>> Commit 3e8b1eb "mac80211/minstrel_ht: improve rate selection stability"
>> introduced a local capped prob in minstrel_ht_calc_tp but omitted to use
>> it to compute the rate throughput.
>> 
>> Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
>> CC: Felix Fietkau <nbd@openwrt.org>
> Nice catch!
> Acked-by: Felix Fietkau <nbd@openwrt.org>
Sorry, I need to revoke that ACK - there's a bug in this patch:

> -	tp = 1000000 * ((mr->probability * 1000) / nsecs);
> +	tp = 1000000 * (prob * 1000) / nsecs;
Removing the outer () is wrong, it leads to overflow that makes all
throughput values 0.

- Felix
