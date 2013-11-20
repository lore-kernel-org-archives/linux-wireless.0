Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:38309 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609Ab3KTOEo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Nov 2013 09:04:44 -0500
Message-ID: <528CC172.1040402@openwrt.org> (sfid-20131120_150448_135050_DDD58829)
Date: Wed, 20 Nov 2013 15:04:34 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Karl Beldan <karl.beldan@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: use capped prob when computing throughputs
References: <1384908668-27869-1-git-send-email-karl.beldan@gmail.com> <528C6590.1000803@openwrt.org> <20131120135628.GA9335@magnum.frso.rivierawaves.com>
In-Reply-To: <20131120135628.GA9335@magnum.frso.rivierawaves.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-11-20 14:56, Karl Beldan wrote:
> On Wed, Nov 20, 2013 at 08:32:32AM +0100, Felix Fietkau wrote:
>> On 2013-11-20 01:51, Karl Beldan wrote:
>> > From: Karl Beldan <karl.beldan@rivierawaves.com>
>> > 
>> > Commit 3e8b1eb "mac80211/minstrel_ht: improve rate selection stability"
>> > introduced a local capped prob in minstrel_ht_calc_tp but omitted to use
>> > it to compute the rate throughput.
>> > 
>> > Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
>> > CC: Felix Fietkau <nbd@openwrt.org>
>> Nice catch!
>> Acked-by: Felix Fietkau <nbd@openwrt.org>
>> 
> Interestingly enough, consecutive coding rates (5/6, 3/4, 2/3) max ratio
> is 9/10, did you do it on purpose ?  (e.g. (9/10) * (5/6) == 3/4,
> (9/10) * (3/4) == 2/3 + 11/120).
The change has nothing to do with coding rates, it's only about
retransmissions caused by collisions under load.

- Felix

