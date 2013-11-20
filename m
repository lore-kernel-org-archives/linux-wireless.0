Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:45506 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093Ab3KTRFT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Nov 2013 12:05:19 -0500
Received: by mail-wg0-f44.google.com with SMTP id k14so9410285wgh.23
        for <linux-wireless@vger.kernel.org>; Wed, 20 Nov 2013 09:05:18 -0800 (PST)
Date: Wed, 20 Nov 2013 18:04:44 +0100
From: Karl Beldan <karl.beldan@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: Re: [PATCH] mac80211: use capped prob when computing throughputs
Message-ID: <20131120170444.GF9335@magnum.frso.rivierawaves.com> (sfid-20131120_180522_434696_DB3F0E78)
References: <1384908668-27869-1-git-send-email-karl.beldan@gmail.com>
 <528C6590.1000803@openwrt.org>
 <528CE9E2.7030707@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <528CE9E2.7030707@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 20, 2013 at 05:57:06PM +0100, Felix Fietkau wrote:
> On 2013-11-20 08:32, Felix Fietkau wrote:
> > On 2013-11-20 01:51, Karl Beldan wrote:
> >> From: Karl Beldan <karl.beldan@rivierawaves.com>
> >> 
> >> Commit 3e8b1eb "mac80211/minstrel_ht: improve rate selection stability"
> >> introduced a local capped prob in minstrel_ht_calc_tp but omitted to use
> >> it to compute the rate throughput.
> >> 
> >> Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
> >> CC: Felix Fietkau <nbd@openwrt.org>
> > Nice catch!
> > Acked-by: Felix Fietkau <nbd@openwrt.org>
> Sorry, I need to revoke that ACK - there's a bug in this patch:
> 
> > -	tp = 1000000 * ((mr->probability * 1000) / nsecs);
> > +	tp = 1000000 * (prob * 1000) / nsecs;
> Removing the outer () is wrong, it leads to overflow that makes all
> throughput values 0.
> 
Do you handle this one or I resend ?
 
Karl
