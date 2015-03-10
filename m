Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sbg-il.ceva-dsp.com ([195.82.128.8]:50519 "EHLO
	sbg-il.ceva-dsp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616AbbCJR2t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2015 13:28:49 -0400
From: Cedric Izoard <Cedric.Izoard@ceva-dsp.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Max Stepanov" <Max.Stepanov@intel.com>
Subject: Re: [PATCH v2] mac80211: Get IV len from key conf and not cipher
 scheme
Date: Tue, 10 Mar 2015 17:28:43 +0000
Message-ID: <5842EA9CC042B141995329508713AD672105AA3E@ILMAIL1.corp.local> (sfid-20150310_182854_081234_D4DF5A88)
References: <5842EA9CC042B141995329508713AD672105A9B0@ILMAIL1.corp.local>
	 <1426003477.1926.5.camel@sipsolutions.net>
	 <5842EA9CC042B141995329508713AD672105A9FB@ILMAIL1.corp.local>
 <1426006121.1926.6.camel@sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/03/2015 17:48, Johannes Berg wrote:
> On Tue, 2015-03-10 at 16:46 +0000, Cedric Izoard wrote:
>>> How can this be correct? You have a cipher scheme, so you want to
>>> encrypt, but now you're not doing that? Perhaps you should drop the
>>> frame instead?
>>>
>> On Tx, cipher scheme is "only" available trough sta pointer and is only
>> used in ieee80211_crypto_cs_encrypt to get security header len.
>> Since sta pointer is NULL for bcast messages, the proposed patch get the
>> security header length using the key->conf.iv_len instead.
>>
>> If the key is installed with a cs, then key->conf.iv_len is initialized
>> with cs->hdr_len.
>>
>> If the key is installed without a cs, then  key->conf.iv_len is 0 (hence
>> the early exit in ieee80211_crypto_cs_encrypt)
>
> So in reality, you're checking "is this a CS key"? Perhaps there's a
> better way to do that?
>
> johannes
>
>
The other option I see, would be to add a pointer to the cipher scheme 
in struct ieee80211_key. So that in TX cipher_scheme would be 
test/accessed using key ptr. sta->cipher_scheme would still be used for RX.
Do you consider this as a better option ?

rgds,
cedric
