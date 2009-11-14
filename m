Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:37193 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567AbZKNCNj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2009 21:13:39 -0500
Received: by iwn8 with SMTP id 8so3105854iwn.33
        for <linux-wireless@vger.kernel.org>; Fri, 13 Nov 2009 18:13:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <40101cc30911130420n6fa79a55vfc2bffc615e9606b@mail.gmail.com>
References: <f74418680911120331w1ea31a68y56440dc0fbd253bb@mail.gmail.com>
	<40101cc30911120618m5d9acd34pf6aa9ec89c6c40b8@mail.gmail.com>
	<20091112154440.GD19349@tux> <43e72e890911120749n72360f0btfb058ab3a521eabb@mail.gmail.com>
	<40101cc30911121118h17db32a1y61edac1a4c0aec24@mail.gmail.com>
	<1258054304.3899.36.camel@johannes.local> <40101cc30911121418h4109d62bv763bed2036446901@mail.gmail.com>
	<1258097485.3899.76.camel@johannes.local> <f74418680911130055o7d8fa94brc3fd7a0c315bb7b0@mail.gmail.com>
	<40101cc30911130420n6fa79a55vfc2bffc615e9606b@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 13 Nov 2009 18:13:25 -0800
Message-ID: <43e72e890911131813g2bc15fe6rd9c636959f698535@mail.gmail.com>
Subject: Re: [ath9k-devel] Possible memory leak in ath9k monitor mode
	injection
To: Matteo Croce <technoboy85@gmail.com>
Cc: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	rodriguez@atheros.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 13, 2009 at 4:20 AM, Matteo Croce <technoboy85@gmail.com> wrote:
> On Fri, Nov 13, 2009 at 12:27 PM,  <Lorenzo.Bianconi83@gmail.com> wrote:
>> Il giorno , Lorenzo Bianconi <lorenzo.bianconi83@gmail.com> ha scritto:
>>> 2009/11/13 Johannes Berg johannes@sipsolutions.net>:
>>> Yes, I tested ath5k/mac80211 and ath9k/mac80211 and both show the same
>>> problem
>>>
>>> whereas madwifi/net80211, tested with the same module, has not memory
>>> leak.
>>>
>>
>> Hi all,
>>
>> I found a way to stop the mem leak. In the ath_tx_complete() function I have
>> noticed that the struct tx_info_priv is not freed. I have made the following
>> changes and now the memory remains stable. I do not know if this is the
>> right place to put the kfree(tx_info_priv), however this seems to solve the
>> issue.
>>
>> Cheers,
>>
>> Lorenzo
>>
>> @@ -1825,9 +1825,10 @@
>> SC_OP_WAIT_FOR_TX_ACK));
>> }
>>
>> - if (frame_type == ATH9K_NOT_INTERNAL)
>> + if (frame_type == ATH9K_NOT_INTERNAL) {
>> ieee80211_tx_status(hw, skb);
>> - else
>> + kfree(tx_info_priv);
>> + } else
>> ath9k_tx_status(hw, skb);
>> }
>
> That's great. I'll try the fix with ath5k too

Can you guys try Felix's RFC patches ? It removes this completely.

  Luis
