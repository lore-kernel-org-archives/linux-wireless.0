Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:45080 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921AbYKCOha convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2008 09:37:30 -0500
Message-ID: <20081103094047.7zjz0fcy88gc4wo8-cebfxv@webmail.spamcop.net> (sfid-20081103_153734_646829_472CC354)
Date: Mon, 03 Nov 2008 09:40:47 -0500
From: Pavel Roskin <proski@gnu.org>
To: Bob Copeland <me@bobcopeland.com>
Cc: jirislaby@gmail.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	michael+ath5k@stapelberg.de, linux-kernel@vger.kernel.org
Subject: Re: [ath5k-devel] [PATCH] ath5k: fix detection of jumbo frames
References: <1225652938-6244-1-git-send-email-me@bobcopeland.com>
	<1225719328.3575.9.camel@dv>
	<b6c5339f0811030626rf9e7147peb1d4a2ca085bba@mail.gmail.com>
In-Reply-To: <b6c5339f0811030626rf9e7147peb1d4a2ca085bba@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Bob Copeland <me@bobcopeland.com>:

> On Mon, Nov 3, 2008 at 8:35 AM, Pavel Roskin <proski@gnu.org> wrote:
>> Thanks for catching it!  Please mention rs_antenna in addition to
>> rs_more.
>>
>>> -     rs->rs_antenna = rx_status->rx_status_0 &
>>> -             AR5K_5210_RX_DESC_STATUS0_RECEIVE_ANTENNA;
>>> -     rs->rs_more = rx_status->rx_status_0 &
>>> -             AR5K_5210_RX_DESC_STATUS0_MORE;
>>> +     rs->rs_antenna = AR5K_REG_MS(rx_status->rx_status_0,
>>> +             AR5K_5210_RX_DESC_STATUS0_RECEIVE_ANTENNA);
>>> +     rs->rs_more = AR5K_REG_MS(rx_status->rx_status_0,
>>> +             AR5K_5210_RX_DESC_STATUS0_MORE);
>>
>> rs_more should be boolean.  It would be better to use "!!" to calculate
>> rs_rate.  No need to shift anything.  As for rs_antenna, it's fine with
>    ^^^^^^
> I assume you meant rs_more again:  rs_more = !!(rx_status_0 & ...)

Yes, sorry.

>>> +#define AR5K_5212_RX_DESC_STATUS0_DECOMP_CRC_ERROR_S 13
>>
>> This doesn't belong to the patch.  It looks like it's another boolean
>> value, but it's not currently used.
>
> ACK, all valid.  I'll respin.

Please do.

-- 
Regards,
Pavel Roskin
