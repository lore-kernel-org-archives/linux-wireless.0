Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:60792 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465Ab0KCOuV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Nov 2010 10:50:21 -0400
Received: by vws13 with SMTP id 13so1158828vws.19
        for <linux-wireless@vger.kernel.org>; Wed, 03 Nov 2010 07:50:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20101103141413.GA5364@sig21.net>
References: <4CC0D0F6.4080507@web.de>
	<201010290017.13174.helmut.schaa@googlemail.com>
	<4CCB3F24.1030701@web.de>
	<201010301430.15868.helmut.schaa@googlemail.com>
	<20101102125007.GA30000@sig21.net>
	<20101103141413.GA5364@sig21.net>
Date: Wed, 3 Nov 2010 15:50:20 +0100
Message-ID: <AANLkTimR8aGZs3AMWGFzMwKvvaTTEQt9ovL7yS7DTi9A@mail.gmail.com>
Subject: Re: [regression]AP with hostapd 0.7.3 can't receive packets beyond
 authentication (2.6.36, rt73usb)
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Johannes Stezenbach <js@sig21.net>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	Lee <lee-in-berlin@web.de>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

>>
>> While reading through the code I noticed the following in rt2800_config_intf():
>>
>>               rt2x00_set_field32(&reg, MAC_BSSID_DW1_BSS_ID_MASK, 3);
>>
>> However, in Ralink source from http://www.ralinktech.com/support.php?s=2
>> in DPO_RT3370_LinuxSTA_V2.4.0.1_20100831/include/chip/rtmp_mac.h it says:
>>                 USHORT          BssIdMask:2; // 0: one BSSID, 10: 4 BSSID,  01: 2 BSSID , 11: 8BSSID
>>
>> This is different from rt73usb where 3 means "one BSSID".
>
> Any comments on this?
>
>
> I still have a very limited understanding of mac80211 and rt2xx code,
> but I'm reading through the code and report what looks suspicious
> to me.  I hope that's OK?   Here's another one:

Off course thats ok. :)

> In rt2x00lib_rxdone():
>
>        /*
>         * Allocate a new sk_buffer. If no new buffer available, drop the
>         * received frame and reuse the existing buffer.
>         */
>        skb = rt2x00queue_alloc_rxskb(rt2x00dev, entry);
>        if (!skb)
>                return;
>
> Should this not be "goto submit_entry;"?

Absolutely true, I committed a patch for that 1 or 2 weeks ago,
so that should be visible in compat-wireless by now.

Ivo
