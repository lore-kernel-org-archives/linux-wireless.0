Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:40125 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab2GYSmP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2012 14:42:15 -0400
Received: by gglu4 with SMTP id u4so1054646ggl.19
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jul 2012 11:42:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1343059275-49590-2-git-send-email-thomas@net.t-labs.tu-berlin.de>
References: <1343059275-49590-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
	<1343059275-49590-2-git-send-email-thomas@net.t-labs.tu-berlin.de>
Date: Wed, 25 Jul 2012 21:42:14 +0300
Message-ID: <CAFtRNNx+YgGgFp_owGQJcsQVqTuOeWk2J0MwjKMtcUgRq_DF0w@mail.gmail.com> (sfid-20120725_204223_189131_E45D238A)
Subject: Re: [PATCH 1/2] ath5k: fix wrong per rate target power eeprom reads
 for AR5K_EEPROM_MODE_11A
From: Nick Kossifidis <mickflemm@gmail.com>
To: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Cc: linville@tuxdriver.com, jirislaby@gmail.com,
	mcgrof@qca.qualcomm.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, johannes.berg@intel.com,
	nbd@nbd.name
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/7/23 Thomas Huehn <thomas@net.t-labs.tu-berlin.de>:
> This patch reduces the per rate target power eeprom reads for
> AR5K_EEPROM_MODE_11A from 10 to 8, as there are only 8 valid
> power curve entries on the eeprom. The former 10 reads lead to
> wrong per rate power limits where rates above 24MBit could be
> amplified with to high distortion leading to bad performance.
> This was fix validated against the madwifi codebase and a new
> AR5K_EEPROM_N_5GHZ_RATE_CHAN 8 is defined.
>
> Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
> ---
> madwifi cross validation check. Thx to Felix Fiethkau
> ---


Thanks for catching this but the bug is elsewhere:

I've tried to document hw code as much as I can, eeprom stuff is still
missing and I'm sorry for that but here is what comments say on phy.c
@ DOC: Per-rate tx power setting, that should give you an idea of
what's happening...

3498  * Rate power table contains indices to PCDAC/PDADC table (0.5dB steps -
3499  * x values) and is indexed as follows:
3500  * rates[0] - rates[7] -> OFDM rates
3501  * rates[8] - rates[14] -> CCK rates
3502  * rates[15] -> XR rates (they all have the same power)

So guess why the last 2 "invalid" power gain values have the same
power levels for all rates ? They are for XR mode (they've put it
there on the eeprom because XR mode also operates at 5GHz) and since
XR stuff is stripped off Madwifi (at least the public HAL) that's why
it only reads 8 of the piers.

Now notice that the last 2 readings on your previous post start from a
different frequency and most important that 5360 < 5825  and that
makes sense since the idea is to have only 2 points to interpolate
between them for the whole XR range. So we have 2 frequency "ranges"
to search, the one  is the 11a mode from 4920 to 5825 and the other
one is for XR mode from 5360 to 5720. When the first range ends the
other starts.

The bug is here:

ath5k_get_rate_pcal_data:
2704         max = ee->ee_rate_target_pwr_num[mode] - 1;
[...]
2713         if (target > rpinfo[max].freq) {
2714                 idx_l = idx_r = max;
2715                 goto done;
2716         }

So please instead of tweaking the EEPROM code just change
max = ee->ee_rate_target_pwr_num[mode] - 1;
to
max = ee->ee_rate_target_pwr_num[mode] - 3;
in case of AR5K_MODE_11A

Each function has a job to do, ath5k_eeprom_read_target_rate_pwr_info
should read EEPROM contents, not decide what we'll use on
interpolation and what we won't use. Also since EEPROM code uses
offsets etc I don't want to change the way we read it because if we
miss something then the whole dataset will get "shifted" and we'll get
weird stuff :P


-- 
GPG ID: 0xEE878588
As you read this post global entropy rises. Have Fun ;-)
Nick
