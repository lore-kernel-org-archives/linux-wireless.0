Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.230]:55791 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103AbYKCO0Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2008 09:26:25 -0500
Message-ID: <b6c5339f0811030626rf9e7147peb1d4a2ca085bba@mail.gmail.com> (sfid-20081103_152632_163955_7F3C034C)
Date: Mon, 3 Nov 2008 09:26:24 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: "Pavel Roskin" <proski@gnu.org>
Subject: Re: [ath5k-devel] [PATCH] ath5k: fix detection of jumbo frames
Cc: jirislaby@gmail.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	michael+ath5k@stapelberg.de, linux-kernel@vger.kernel.org
In-Reply-To: <1225719328.3575.9.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1225652938-6244-1-git-send-email-me@bobcopeland.com>
	 <1225719328.3575.9.camel@dv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 3, 2008 at 8:35 AM, Pavel Roskin <proski@gnu.org> wrote:
> Thanks for catching it!  Please mention rs_antenna in addition to
> rs_more.
>
>> -     rs->rs_antenna = rx_status->rx_status_0 &
>> -             AR5K_5210_RX_DESC_STATUS0_RECEIVE_ANTENNA;
>> -     rs->rs_more = rx_status->rx_status_0 &
>> -             AR5K_5210_RX_DESC_STATUS0_MORE;
>> +     rs->rs_antenna = AR5K_REG_MS(rx_status->rx_status_0,
>> +             AR5K_5210_RX_DESC_STATUS0_RECEIVE_ANTENNA);
>> +     rs->rs_more = AR5K_REG_MS(rx_status->rx_status_0,
>> +             AR5K_5210_RX_DESC_STATUS0_MORE);
>
> rs_more should be boolean.  It would be better to use "!!" to calculate
> rs_rate.  No need to shift anything.  As for rs_antenna, it's fine with
   ^^^^^^
I assume you meant rs_more again:  rs_more = !!(rx_status_0 & ...)

>> +#define AR5K_5212_RX_DESC_STATUS0_DECOMP_CRC_ERROR_S 13
>
> This doesn't belong to the patch.  It looks like it's another boolean
> value, but it's not currently used.

ACK, all valid.  I'll respin.

-- 
Bob Copeland %% www.bobcopeland.com
