Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sbg-il.ceva-dsp.com ([195.82.128.8]:48879 "EHLO
	sbg-il.ceva-dsp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbbCJNtJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2015 09:49:09 -0400
From: Cedric Izoard <Cedric.Izoard@ceva-dsp.com>
To: "Stepanov, Max" <Max.Stepanov@intel.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: Get IV len from key conf and not cipher scheme
Date: Tue, 10 Mar 2015 13:49:01 +0000
Message-ID: <5842EA9CC042B141995329508713AD672105A8F0@ILMAIL1.corp.local> (sfid-20150310_144913_462464_EECAD494)
References: <3A934E7FDB083A4683727C7D377065954A23682A@hasmsx109.ger.corp.intel.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/03/2015 12:58, Stepanov, Max wrote:
>> From: Cedric Izoard <Cedric.Izoard@ceva-dsp.com>
>> To: linux-wireless@vger.kernel.org <linux-wireless@vger.kernel.org>
>> Cc: johannes@sipsolutions.net <johannes@sipsolutions.net>
>> Subject: [PATCH] mac80211: Get IV len from key conf and not cipher
>> scheme
>> Date: Tue, 10 Mar 2015 08:52:23 +0000
>>
>> Do not always dereference sta to get cipher scheme as it may be null
>> for broadcast messages.
>> Instead get IV length from key configuration which has been
>> initialized with cipher scheme.
>>
> Cedric, in general a cipher scheme was about to be used with a station holding ucast and mcast/bcast keys, so, my question is about the following line:
>
>> +		res = ieee80211_crypto_cs_encrypt(tx, skb);
> What is a point of calling this function when tx->key->sta or tx->key->sta->cipher_scheme is NULL? In which scenario?
>
> Thanks,
> Max
>

Hi,
We use cipher scheme to support WAPI in both STA and AP mode.
The patch is for the AP use case when sending a broadcast message that 
needs encryption. So we want to call ieee80211_crypto_cs_encrypt even if 
sta is NULL.

rgds,
cedric
