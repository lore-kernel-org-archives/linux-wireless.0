Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:36493 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754339Ab3KTRD4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Nov 2013 12:03:56 -0500
Received: by mail-wi0-f177.google.com with SMTP id hq4so7397176wib.4
        for <linux-wireless@vger.kernel.org>; Wed, 20 Nov 2013 09:03:55 -0800 (PST)
Date: Wed, 20 Nov 2013 18:03:21 +0100
From: Karl Beldan <karl.beldan@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: Re: [PATCH] mac80211: use capped prob when computing throughputs
Message-ID: <20131120170321.GE9335@magnum.frso.rivierawaves.com> (sfid-20131120_180400_488905_551E9A24)
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
Arf, totally, the worst part is that I did know I had to keep them.
 
Karl
