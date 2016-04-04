Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:33672 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbcDDIYz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Apr 2016 04:24:55 -0400
Received: by mail-lb0-f173.google.com with SMTP id u8so149056684lbk.0
        for <linux-wireless@vger.kernel.org>; Mon, 04 Apr 2016 01:24:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <56FE9A10.1060908@candelatech.com>
References: <56FE9A10.1060908@candelatech.com>
Date: Mon, 4 Apr 2016 10:24:53 +0200
Message-ID: <CA+BoTQ=hNyaTm2+U9-sMy5DJ7fmAWG3MovNsxn1WNthraCsfCA@mail.gmail.com> (sfid-20160404_102503_213814_33E4122E)
Subject: Re: mac80211 kasan splat, hacked 4.4.6+, ath10k with modified 10.4.3 fw
From: Michal Kazior <michal.kazior@tieto.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1 April 2016 at 17:56, Ben Greear <greearb@candelatech.com> wrote:
> I saw this splat yesterday evening...  Any ideas on what this could be?
>
> I'll add some bounds checking on the rate->idx in case that is the issue...
>
>
> (gdb) l *(sta_set_rate_info_tx+0x1b3)
> 0x38dcc is in sta_set_rate_info_tx
> (/home/greearb/git/linux-4.4.dev.y/net/mac80211/cfg.c:457).
> 452                     u16 brate;
> 453
> 454                     sband = sta->local->hw.wiphy->bands[
> 455
> ieee80211_get_sdata_band(sta->sdata)];
> 456                     brate = sband->bitrates[rate->idx].bitrate;
> 457                     rinfo->legacy = DIV_ROUND_UP(brate, 1 << shift);
> 458             }
> 459             if (rate->flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
> 460                     rinfo->bw = RATE_INFO_BW_40;
> 461             else if (rate->flags & IEEE80211_TX_RC_80_MHZ_WIDTH)
> (gdb)
>
>
> ==================================================================
> BUG: KASAN: global-out-of-bounds in sta_set_rate_info_tx+0x1b3/0x262
> [mac80211] at addr ffffffffa18a3c0c
> Read of size 2 by task cat/19440
> Address belongs to variable ath10k_rates+0xac/0xfffffffffffd04c7
> [ath10k_core]

This is interesting. The `rate` comes from sta's last_rate which is
updated in tx_status().

Hmm.. From a quick look I suspect ath10k_wmi_mgmt_tx() reports the
offending last_rate. The `info` isn't zero-ed but it may have some
garbage from ath10k's internal txpath processing.


Michał
