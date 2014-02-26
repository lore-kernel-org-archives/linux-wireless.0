Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:11636 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbaBZMUs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Feb 2014 07:20:48 -0500
Message-ID: <530DDC1C.9070803@broadcom.com> (sfid-20140226_132050_908698_678A8C54)
Date: Wed, 26 Feb 2014 13:20:44 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Florian Fainelli <f.fainelli@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>
Subject: Re: [PATCH 10/14] brcmfmac: Use atomic functions for intstatus update.
References: <1393356639-19169-1-git-send-email-arend@broadcom.com> <1393356639-19169-11-git-send-email-arend@broadcom.com> <CAGVrzcaNp6j4pN5d7LaWaFi0xexbvDzgwt-csEUw3tBfUwpXZQ@mail.gmail.com>
In-Reply-To: <CAGVrzcaNp6j4pN5d7LaWaFi0xexbvDzgwt-csEUw3tBfUwpXZQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/26/2014 12:38 AM, Florian Fainelli wrote:
> Hi Arend,
> 
> 2014-02-25 11:30 GMT-08:00 Arend van Spriel <arend@broadcom.com>:
>> From: Hante Meuleman <meuleman@broadcom.com>
>>
>> The intstatus in sdio code can be updated from different
>> threads. To protect intstatus access, atomic functions are
>> used. One of them is set_bit, but this function is not
>> guaranteed atomic on all platforms. The loop was replaced
>> with local created OR function.
>>
>> Reviewed-by: Arend Van Spriel <arend@broadcom.com>
>> Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
>> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
>> Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
>> Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
>> Signed-off-by: Arend van Spriel <arend@broadcom.com>
>> ---
>>  drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   29 ++++++++++----------
>>  1 file changed, 15 insertions(+), 14 deletions(-)
>>
>> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
>> index ac61419..90ff406 100644
>> --- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
>> +++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
>> @@ -2444,12 +2444,21 @@ static inline void brcmf_sdio_clrintr(struct brcmf_sdio *bus)
>>         }
>>  }
>>
>> +static void atomic_orr(int val, atomic_t *v)
>> +{
>> +       int old_val;
>> +
>> +       old_val = atomic_read(v);
>> +       while (atomic_cmpxchg(v, old_val, val | old_val) != old_val)
>> +               old_val = atomic_read(v);
>> +}
> 
> Is not atomic_set_mask() doing the same thing?

You are right. Hante thought that one was not supported on all archs,
but asm-generic provides a fallback for those. I will revise this patch.

Thanks,
Arend

