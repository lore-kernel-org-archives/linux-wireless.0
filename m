Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:35829 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753074Ab3FMMoB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Jun 2013 08:44:01 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: [PATCH v2 1/2] mac80211: move tx_control_flag into flags2 within ieee80211_tx_info
From: =?iso-8859-1?Q?Thomas_H=FChn?= <thomas@net.t-labs.tu-berlin.de>
In-Reply-To: <1371117219.8335.9.camel@jlt4.sipsolutions.net>
Date: Thu, 13 Jun 2013 14:44:01 +0200
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	nbd@nbd.name
Message-Id: <7091254A-FEAD-4B48-9AC9-D6903EDF85F1@net.t-labs.tu-berlin.de> (sfid-20130613_144406_079085_37A531D3)
References: <1371112067-19239-1-git-send-email-thomas@net.t-labs.tu-berlin.de> <1371117219.8335.9.camel@jlt4.sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,
> 
> I'm sure some drivers use it in their status path. Have you audited them
> all?
> 
> No, you clearly haven't. carl9170 is *obviously* broken by this change,
> others may not so obvious.

You are right, carl9170 could access this flag from any context so tx_info->control.flags2 can be invalid.
Sorry for that mistake.

> 
>> 		} else if ((txinfo->flags & IEEE80211_TX_STAT_ACK) &&
>> -			   !(txinfo->flags & IEEE80211_TX_CTL_REQ_TX_STATUS)) {
>> +			   !(txinfo->control.flags2 & IEEE80211_TX_CTL2_REQ_TX_STATUS)) {
> 
> I bet you did some sort of automatic replace, but these lines look far
> too long.
> 
> Also, if you're doing hugely invasive patches like this then I think you
> should move more flags and be done with it.

Ok. I will go through all possible flags to check wether I can move them to flags2 and send a v3.

> 
>> @@ -1561,7 +1561,7 @@ void ieee80211_send_auth(struct ieee80211_sub_if_data *sdata,
>> 			 u16 transaction, u16 auth_alg, u16 status,
>> 			 const u8 *extra, size_t extra_len, const u8 *bssid,
>> 			 const u8 *da, const u8 *key, u8 key_len, u8 key_idx,
>> -			 u32 tx_flags);
>> +			 u32 tx_flags, u16 tx_flags2);
> 
> This function already has far too many arguments, I'm not taking a patch
> adding yet another one.

This should be obsolete as the flag in question would break carl9170 and I will skip that one.


Greetings Thomas

