Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38370 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277AbbKZRvX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2015 12:51:23 -0500
Message-ID: <1448560280.2167.41.camel@sipsolutions.net> (sfid-20151126_185126_474566_D358D3ED)
Subject: Re: [PATCH v2 4/8] cfg80211: reg: Properly handle rules for 5 and
 10 MHz channels
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Sojka <sojkam1@fel.cvut.cz>, linux-wireless@vger.kernel.org
Cc: bernd.lehmann@volkswagen.de, s.sander@nordsys.de,
	wireless-regdb@lists.infradead.org, ath9k-devel@lists.ath9k.org,
	ath9k-devel@qca.qualcomm.com,
	Jan =?ISO-8859-1?Q?Kaisrl=EDk?= <kaisrja1@fel.cvut.cz>,
	Felix Fietkau <nbd@openwrt.org>
Date: Thu, 26 Nov 2015 18:51:20 +0100
In-Reply-To: <1448303241-27747-5-git-send-email-sojkam1@fel.cvut.cz> (sfid-20151123_192801_651522_A290ADE4)
References: <1448303241-27747-1-git-send-email-sojkam1@fel.cvut.cz>
	 <1448303241-27747-5-git-send-email-sojkam1@fel.cvut.cz>
	 (sfid-20151123_192801_651522_A290ADE4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-11-23 at 19:27 +0100, Michal Sojka wrote:
> Regulatory rules are applied to channels as if the channel is at
> least
> 20 MHz wide. This is a problem when dealing with 5 and 10 MHz
> channels
> because side channels of a regulatory rule get disabled even when
> they
> fall into rule's frequency range.
> 
> This problem was already fixed in commit
> 4edd56981c8fbb349b1529a2feaf772636eb1c83, but only for custom
> regulatory
> domains provided by drivers. Here we fix it also for all other (e.g.
> user-supplied) regulatory domains.
> 
> Before that, similar commit was
> reverted (e33e2241e272eddc38339692500bd1c7d8753a77) due to it
> allowing
> running AP on channel 12 in the US regulatory domain. I have checked
> that this is not possible with this change:
> 
>   # iw reg set US
>   # iw dev wlan0 interface add wlan0_ap  type __ap
>   # iw dev wlan0_ap set channel 12
>   command failed: Invalid argument (-22)
> 
Applied, with some fixups to the commit message :)

johannes
