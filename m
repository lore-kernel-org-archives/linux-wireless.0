Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:61283 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423669Ab2LGSQW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2012 13:16:22 -0500
Received: by mail-qc0-f174.google.com with SMTP id o22so379405qcr.19
        for <linux-wireless@vger.kernel.org>; Fri, 07 Dec 2012 10:16:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1354882082.31150.3.camel@cumari.coelho.fi>
References: <1354095769-8724-1-git-send-email-arik@wizery.com>
 <1354095769-8724-13-git-send-email-arik@wizery.com> <1354882082.31150.3.camel@cumari.coelho.fi>
From: Arik Nemtsov <arik@wizery.com>
Date: Fri, 7 Dec 2012 20:16:05 +0200
Message-ID: <CA+XVXfddbXx_BdsROVTQnr7F4B3yv-srtuG_apTpz08n7XE-gA@mail.gmail.com> (sfid-20121207_191633_284911_7E20718E)
Subject: Re: [PATCH 12/20] wl18xx: limit Tx for the AP single-STA-in-PSM case
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 7, 2012 at 2:08 PM, Luciano Coelho <coelho@ti.com> wrote:
> On Wed, 2012-11-28 at 11:42 +0200, Arik Nemtsov wrote:
>> Treat a single connected STA in PSM as a slow link and regulate Tx speed
>> according to slow link priority/stop thresholds.
>> This allows us to avoid flooding the FW, while delivering decent
>> throughput to a peer in forced-PSM.
>>
>> Signed-off-by: Arik Nemtsov <arik@wizery.com>
>> ---
>>  drivers/net/wireless/ti/wl18xx/main.c |   14 ++++++++------
>>  1 file changed, 8 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
>> index 3836dbd..ada4616 100644
>> --- a/drivers/net/wireless/ti/wl18xx/main.c
>> +++ b/drivers/net/wireless/ti/wl18xx/main.c
>> @@ -1446,10 +1446,11 @@ static bool wl18xx_lnk_high_prio(struct wl1271 *wl, u8 hlid,
>>               return false;
>>
>>       /* the priority thresholds are taken from FW */
>> -     if (test_bit(hlid, (unsigned long *)&wl->fw_fast_lnk_map))
>> -             thold = status_priv->tx_fast_link_prio_threshold;
>> -     else
>> +     if (!test_bit(hlid, (unsigned long *)&wl->fw_fast_lnk_map) ||
>> +         test_bit(hlid, (unsigned long *)&wl->ap_fw_ps_map))
>>               thold = status_priv->tx_slow_link_prio_threshold;
>> +     else
>> +             thold = status_priv->tx_fast_link_prio_threshold;
>
> Am I missing something or is this kind of inverted logic? For some
> reason I always think it is simpler to have something like this:
>
> if (fast_link && !ps)
>         thold = fast;
> else
>         thold = slow;

I guess it's a bit simpler. I really don't mind. You can change it on
commit I guess?

Arik
