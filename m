Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:43383 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756398Ab2K0RA3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 12:00:29 -0500
Received: by mail-wg0-f44.google.com with SMTP id dr13so3018683wgb.1
        for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2012 09:00:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOZOX0XN+pd7k-WQ0U1Vs=+21wyUmEDMJVJHekAj2NvmZfaJTg@mail.gmail.com>
References: <1354031236-8191-1-git-send-email-helmut.schaa@googlemail.com>
	<CAOZOX0XN+pd7k-WQ0U1Vs=+21wyUmEDMJVJHekAj2NvmZfaJTg@mail.gmail.com>
Date: Tue, 27 Nov 2012 18:00:27 +0100
Message-ID: <CAGXE3d_+Pp_p2uWW52Q4q_D3enkgUtrJrUNivjf6wqvh8RYfKA@mail.gmail.com> (sfid-20121127_180038_995695_2D264A45)
Subject: Re: [PATCH] rt2x00: Use addr_mask to catch invalid MAC addresses
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ivo,

On Tue, Nov 27, 2012 at 4:56 PM, Ivo Van Doorn <ivdoorn@gmail.com> wrote:
> Hi,
>
>> This ensures that a user cannot accidentally set up a virtual interface
>> with a MAC address the rt2800 hw cannot handle.
>>
>> Reported-by: Petr Stetiar <ynezz@true.cz>
>> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
>> ---
>>  drivers/net/wireless/rt2x00/rt2800lib.c |    3 +++
>>  1 files changed, 3 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c
>> b/drivers/net/wireless/rt2x00/rt2800lib.c
>> index c0441a7..7f0df12 100644
>> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
>> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
>> @@ -5108,6 +5108,9 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev
>> *rt2x00dev)
>>                                 rt2x00_eeprom_addr(rt2x00dev,
>>                                                    EEPROM_MAC_ADDR_0));
>>
>> +       /* Only the last three bits are variable in rt2800 devices. */
>> +       rt2x00dev->hw->wiphy->addr_mask[ETH_ALEN - 1] = 0x7;
>
>
> Shouldn't this be added for rt61pci and rt73usb as well?

I'm not 100% sure if the same is true in rt61pci and rt73usb. Are they
also using an
address mask?

Thanks,
Helmut
