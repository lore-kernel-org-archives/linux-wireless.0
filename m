Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:38488 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752419AbbK3J45 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2015 04:56:57 -0500
Date: Mon, 30 Nov 2015 11:56:52 +0200
From: Jouni Malinen <j@w1.fi>
To: Michal Sojka <sojkam1@fel.cvut.cz>
Cc: linux-wireless@vger.kernel.org, bernd.lehmann@volkswagen.de,
	s.sander@nordsys.de, wireless-regdb@lists.infradead.org,
	ath9k-devel@lists.ath9k.org, ath9k-devel@qca.qualcomm.com,
	Jan =?utf-8?B?S2Fpc3Jsw61r?= <kaisrja1@fel.cvut.cz>,
	Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH v2 4/8] cfg80211: reg: Properly handle rules for 5 and 10
 MHz channels
Message-ID: <20151130095652.GA7054@w1.fi> (sfid-20151130_105700_562689_2529B730)
References: <1448303241-27747-1-git-send-email-sojkam1@fel.cvut.cz>
 <1448303241-27747-5-git-send-email-sojkam1@fel.cvut.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1448303241-27747-5-git-send-email-sojkam1@fel.cvut.cz>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 23, 2015 at 07:27:17PM +0100, Michal Sojka wrote:
> Regulatory rules are applied to channels as if the channel is at least
> 20 MHz wide. This is a problem when dealing with 5 and 10 MHz channels
> because side channels of a regulatory rule get disabled even when they
> fall into rule's frequency range.
> 
> This problem was already fixed in commit
> 4edd56981c8fbb349b1529a2feaf772636eb1c83, but only for custom regulatory
> domains provided by drivers. Here we fix it also for all other (e.g.
> user-supplied) regulatory domains.
> 
> Before that, similar commit was
> reverted (e33e2241e272eddc38339692500bd1c7d8753a77) due to it allowing
> running AP on channel 12 in the US regulatory domain.

I'm afraid this new patch needs to be reverted as well since it allows
active scanning on channel 12 in the US regulatory domain. I.e., every
full scan with this commit included results in a Probe Request frame
being sent on channel 12..

This 5 and 10 MHz channel case needs to be handled in a way that does
not enable 20 MHz channels that go beyond the regdb rule. Channel 12 is
2457-2477 MHz and the regdb rule for US covers 2402-2472 MHz. This used
to disable channel 12 correctly, but with this new change, that 5 MHz
range going beyond the rule is not noticed and channel 12 gets included
even with 20 MHz bandwidth.

> I have checked that this is not possible with this change:
> 
>   # iw reg set US
>   # iw dev wlan0 interface add wlan0_ap  type __ap
>   # iw dev wlan0_ap set channel 12
>   command failed: Invalid argument (-22)

That's not sufficient. Please take a look at a sniffer capture on what
goes out when running
iw reg set US
iw dev wlan0 scan

-- 
Jouni Malinen                                            PGP id EFC895FA
