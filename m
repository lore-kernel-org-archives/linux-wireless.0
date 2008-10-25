Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:34685 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751957AbYJYLiU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2008 07:38:20 -0400
Date: Sat, 25 Oct 2008 13:38:19 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org,
	Shaddy Baddah <shaddy_baddah@hotmail.com>
Subject: Re: zd1211rw (2.6.26 sparc64): unaligned access (zd_mac_rx)
Message-ID: <20081025113819.GA12489@Chamillionaire.breakpoint.cc> (sfid-20081025_133825_633728_3903F821)
References: <4902DEBB.3050205@hotmail.com> <200810251325.07916.mb@bu3sch.de> <20081025112813.GC12252@Chamillionaire.breakpoint.cc> <200810251331.24311.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
In-Reply-To: <200810251331.24311.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Michael Buesch | 2008-10-25 13:31:24 [+0200]:

>On Saturday 25 October 2008 13:28:13 Sebastian Andrzej Siewior wrote:
>> @@ -662,7 +663,7 @@ int zd_mac_rx(struct ieee80211_hw *hw, const u8 *buffer, unsigned int length)
>>  			&& !mac->pass_ctrl)
>>  		return 0;
>>  
>> -	fc = *(__le16 *)buffer;
>> +	fc = get_unaligned_le16(buffer);
>
>This still does semantically change the code.
>fc is supposed to be LE and is used as LE in the following code.
So you say we need a get_unaligned() here. Okay. 
A few lines before that, in filter_ack() we dereferance the same
position. filter_ack() is used once and probably inlined so I guess
that's the address where the unaligned access occurs.

>>  	need_padding = ieee80211_is_data_qos(fc) ^ ieee80211_has_a4(fc);
>>  
>>  	skb = dev_alloc_skb(length + (need_padding ? 2 : 0));



>-- 
>Greetings Michael.

Sebastian
