Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:51946 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971Ab3KTN5G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Nov 2013 08:57:06 -0500
Received: by mail-wg0-f48.google.com with SMTP id n12so9195548wgh.27
        for <linux-wireless@vger.kernel.org>; Wed, 20 Nov 2013 05:57:05 -0800 (PST)
Date: Wed, 20 Nov 2013 14:56:28 +0100
From: Karl Beldan <karl.beldan@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: Re: [PATCH] mac80211: use capped prob when computing throughputs
Message-ID: <20131120135628.GA9335@magnum.frso.rivierawaves.com> (sfid-20131120_145720_063662_2E849EFC)
References: <1384908668-27869-1-git-send-email-karl.beldan@gmail.com>
 <528C6590.1000803@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <528C6590.1000803@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 20, 2013 at 08:32:32AM +0100, Felix Fietkau wrote:
> On 2013-11-20 01:51, Karl Beldan wrote:
> > From: Karl Beldan <karl.beldan@rivierawaves.com>
> > 
> > Commit 3e8b1eb "mac80211/minstrel_ht: improve rate selection stability"
> > introduced a local capped prob in minstrel_ht_calc_tp but omitted to use
> > it to compute the rate throughput.
> > 
> > Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
> > CC: Felix Fietkau <nbd@openwrt.org>
> Nice catch!
> Acked-by: Felix Fietkau <nbd@openwrt.org>
> 
Interestingly enough, consecutive coding rates (5/6, 3/4, 2/3) max ratio
is 9/10, did you do it on purpose ?  (e.g. (9/10) * (5/6) == 3/4,
(9/10) * (3/4) == 2/3 + 11/120).
 
Karl
