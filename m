Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:58048 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783AbZHKMGP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Aug 2009 08:06:15 -0400
Message-ID: <4A811BC2.4060303@openwrt.org>
Date: Tue, 11 Aug 2009 09:20:34 +0200
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [PATCH] iw: fix typos in MCS set parsing code
References: <1249973250-9235-1-git-send-email-juhosg@openwrt.org> <1249973644.5903.14.camel@johannes.local>
In-Reply-To: <1249973644.5903.14.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg írta:
> On Tue, 2009-08-11 at 08:47 +0200, Gabor Juhos wrote:
>> The current code uses wrong binary operator for masking,
>> and the shift values for the 'tx_max_num_spatial_streams' and
>> 'tx_unequal_modulation' fields are off-by-one.
> 
>> -			tx_max_num_spatial_streams = (mcs[12] | ((1 << 3) | (1 << 4))) + 1;
>> -			tx_unequal_modulation = !!(mcs[12] & (1 << 5));
>> +			tx_max_num_spatial_streams = (mcs[12] & ((1 << 2) | (1 << 3))) + 1;
>> +			tx_unequal_modulation = !!(mcs[12] & (1 << 4));
> 
> Are you sure? The "Supported MCS Set" field is defined as a series of
> _bits_, and the bits are transmitted the other way around within each
> byte.

Yes, I'm sure. Here are the relevant definitions from <linux/ieee80211.h>:

#define IEEE80211_HT_MCS_TX_DEFINED             0x01
#define IEEE80211_HT_MCS_TX_RX_DIFF             0x02
/* value 0 == 1 stream etc */
#define IEEE80211_HT_MCS_TX_MAX_STREAMS_MASK    0x0C
#define IEEE80211_HT_MCS_TX_MAX_STREAMS_SHIFT   2
#define         IEEE80211_HT_MCS_TX_MAX_STREAMS 4
#define IEEE80211_HT_MCS_TX_UNEQUAL_MODULATION  0x10

Gabor

