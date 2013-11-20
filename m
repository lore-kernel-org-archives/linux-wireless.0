Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53349 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752414Ab3KTRhi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Nov 2013 12:37:38 -0500
Message-ID: <528CF359.9000900@openwrt.org> (sfid-20131120_183741_176557_853F18E1)
Date: Wed, 20 Nov 2013 18:37:29 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Karl Beldan <karl.beldan@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: Re: [PATCH] mac80211: use capped prob when computing throughputs
References: <1384908668-27869-1-git-send-email-karl.beldan@gmail.com> <528C6590.1000803@openwrt.org> <528CE9E2.7030707@openwrt.org> <20131120170444.GF9335@magnum.frso.rivierawaves.com>
In-Reply-To: <20131120170444.GF9335@magnum.frso.rivierawaves.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-11-20 18:04, Karl Beldan wrote:
> On Wed, Nov 20, 2013 at 05:57:06PM +0100, Felix Fietkau wrote:
>> On 2013-11-20 08:32, Felix Fietkau wrote:
>> > On 2013-11-20 01:51, Karl Beldan wrote:
>> >> From: Karl Beldan <karl.beldan@rivierawaves.com>
>> >> 
>> >> Commit 3e8b1eb "mac80211/minstrel_ht: improve rate selection stability"
>> >> introduced a local capped prob in minstrel_ht_calc_tp but omitted to use
>> >> it to compute the rate throughput.
>> >> 
>> >> Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
>> >> CC: Felix Fietkau <nbd@openwrt.org>
>> > Nice catch!
>> > Acked-by: Felix Fietkau <nbd@openwrt.org>
>> Sorry, I need to revoke that ACK - there's a bug in this patch:
>> 
>> > -	tp = 1000000 * ((mr->probability * 1000) / nsecs);
>> > +	tp = 1000000 * (prob * 1000) / nsecs;
>> Removing the outer () is wrong, it leads to overflow that makes all
>> throughput values 0.
>> 
> Do you handle this one or I resend ?
Please resend.

- Felix

