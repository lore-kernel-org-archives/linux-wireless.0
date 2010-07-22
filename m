Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33093 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754826Ab0GVHpQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 03:45:16 -0400
Received: by bwz1 with SMTP id 1so685106bwz.19
        for <linux-wireless@vger.kernel.org>; Thu, 22 Jul 2010 00:45:14 -0700 (PDT)
Message-ID: <4C47F706.4060102@iki.fi>
Date: Thu, 22 Jul 2010 09:45:10 +0200
From: Kalle Valo <kalle.valo@iki.fi>
MIME-Version: 1.0
To: Luciano Coelho <luciano.coelho@nokia.com>
CC: "ext John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] wl1251: fix sparse-generated warnings
References: <1279729917-4451-1-git-send-email-linville@tuxdriver.com> <1279780458.2322.25.camel@powerslave>
In-Reply-To: <1279780458.2322.25.camel@powerslave>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/22/2010 08:34 AM, Luciano Coelho wrote:
> Hi John,

Hi Luca and John,

> Great that someone finally made the endianess changes that we never had
> the time to do for wl1251. Thanks for that! :)

Yeah, it really is. wl1251 endian support has been broken almost from
day one. Unfortunately I don't any hardware to test wl1251 right now, so
we have to rely on careful review :/

>> @@ -467,7 +467,7 @@ static int wl1251_boot_upload_nvs(struct wl1251 *wl)
>>  		val = (nvs_ptr[0] | (nvs_ptr[1] << 8)
>>  		       | (nvs_ptr[2] << 16) | (nvs_ptr[3] << 24));
>>  
>> -		val = cpu_to_le32(val);
>> +		val = (u32 __force) cpu_to_le32(val);
> 
> This will work, but such casts always make me a bit suspicious.  I think
> this is fine for now

This line was very suspicious already from beginning, I can't remember
why it was added and I don't see why it's needed here.

> but later I think we should make sure that all the
> _write() functions explicitly receive __le32 as val, or receives the
> cpu's u32 and converts it before actually writing the value, for
> clarity reasons.  Kalle, what do you think?

I agree that we should change write() to handle endianess properly. I'm
in favor of having the conversion in write(), but I didn't think this
that much.

>> @@ -191,11 +191,13 @@ static int wl1251_tx_send_packet(struct wl1251 *wl, struct sk_buff *skb,
>>  	if (control->control.hw_key &&
>>  	    control->control.hw_key->alg == ALG_TKIP) {
>>  		int hdrlen;
>> -		u16 fc;
>> +		__le16 fc;
>> +		u16 length;
>>  		u8 *pos;
>>  
>> -		fc = *(u16 *)(skb->data + sizeof(*tx_hdr));
>> -		tx_hdr->length += WL1251_TKIP_IV_SPACE;
>> +		fc = *(__le16 *)(skb->data + sizeof(*tx_hdr));
> 
> Is this going to work? sizeof(*tx_hdr), and the operation, will be in
> the cpu's endianess, right?

I think this is correct. We first calculate a pointer to a __le16 value
and then dereference that value to a __le16 variable.

> Wouldn't the following be the right thing to
> do then?
> 
> fc = cpu_to_le16(le16_to_cpu(skb->data) + sizeof(*tx_hdr));
> 
> Maybe some casts are needed too, I didn't check that, but regarding the
> endianess, I think this is how it should go.  It's the same thing as the
> length parameter:
> 
>> +		length = le16_to_cpu(tx_hdr->length) + WL1251_TKIP_IV_SPACE;
>> +		tx_hdr->length = cpu_to_le16(length);
> 
> ...which is treated correctly here.

This is different. Here we are adding something to a __le16 value, not
calculating with pointers.

Kalle
