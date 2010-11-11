Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:63903 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756023Ab0KKTWa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Nov 2010 14:22:30 -0500
Received: by iwn10 with SMTP id 10so2510491iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 11 Nov 2010 11:22:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTikjg+jY6XYhJjRPydwveW0xr+8tLv-Oypsks4ay@mail.gmail.com>
References: <AANLkTikjg+jY6XYhJjRPydwveW0xr+8tLv-Oypsks4ay@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 11 Nov 2010 11:22:09 -0800
Message-ID: <AANLkTimVEm7=c-fof_niToJqy1t+C5fk_JYH_=x1+p5r@mail.gmail.com>
Subject: Re: ath9k max_power question
To: Mark Mentovai <mark@moxienet.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 11, 2010 at 11:15 AM, Mark Mentovai <mark@moxienet.com> wrote:
> In drivers/net/wireless/ath/ath9k/init.c, both CHAN2G and CHAN5G set
> .max_power to 20, represented in dBm. I’m wondering how this number
> was chosen. Is it simply a safe generic value? I’m dealing with a
> device on which the vendor’s madwifi-based binary driver would show
> 23dBm for 2.4GHz and 18dBm for 5GHz (although only when I asked it for
> 26dBm and 24dBm respectively, so I’m not sure which set of numbers to
> believe.)
>
> I noticed that in ath9k, if these .max_power limits are raised, the
> driver is happy to set a somewhat higher transmit power. In this case,
> it will max out at 25dBm for 2.4GHz and 21dBm for 5GHz. These are
> still below the relevant regulatory limits. These values seem to be
> computed by routines in eeprom_*.c, so I’m wondering if they’re based
> on the card’s own data and safe to use without fear of burning the
> radios.

The values are just some safe value to use as defaults but will
quickly be replaced by the max regulatory allowed and then upon
further inspection also capped to the lower value of the regulatory
limit, the max allowed device limit (where things start becoming
unreliable), and the CTL indexed limit which is calibrated
specifically for the card you use, so this will vary. You can read
more about it here:

http://wireless.kernel.org/en/users/Drivers/ath

  Luis
