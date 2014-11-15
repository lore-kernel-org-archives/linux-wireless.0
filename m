Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:43365 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752401AbaKOLou (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Nov 2014 06:44:50 -0500
Date: Sat, 15 Nov 2014 13:44:45 +0200
From: Jouni Malinen <j@w1.fi>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net
Subject: Re: [PATCH] mac80211: skip legacy rate mask handling for VHT rates
Message-ID: <20141115114445.GA18367@w1.fi> (sfid-20141115_124509_669445_C96057FB)
References: <1416019734-17509-1-git-send-email-nbd@openwrt.org>
 <20141115110459.GA24766@magnum.frso.rivierawaves.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20141115110459.GA24766@magnum.frso.rivierawaves.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 15, 2014 at 12:05:00PM +0100, Karl Beldan wrote:
> On Sat, Nov 15, 2014 at 03:48:54AM +0100, Felix Fietkau wrote:
> > The rate mask code currently assumes that a rate is legacy if
> > IEEE80211_TX_RC_MCS is not set. This might be the cause of bogus VHT
> > rates being reported with minstrel_ht.

> > -	} else {
> > +	} else if (!(rate->flags & IEEE80211_TX_RC_VHT_MCS)) {

> Does it fix things on your side Jouni ?

Yes, it does resolve the nfc_p2p_* test case failures with
CONFIG_MAC80211_RC_MINSTREL_VHT=y.

-- 
Jouni Malinen                                            PGP id EFC895FA
