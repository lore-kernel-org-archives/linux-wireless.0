Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:38109 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910AbbHSUQC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2015 16:16:02 -0400
Received: by igfj19 with SMTP id j19so15254350igf.1
        for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2015 13:16:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150818194720.GB2606@mwanda>
References: <20150818194720.GB2606@mwanda>
Date: Wed, 19 Aug 2015 22:16:02 +0200
Message-ID: <CAA2SeNJEMAqgJkSKEzLeK6+6F=r+af-2NTtmkwZ0w9BcerYDHQ@mail.gmail.com> (sfid-20150819_221607_953999_7E271745)
Subject: Re: mac80211: add rate mask logic for vht rates
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Hello Lorenzo Bianconi,

Hi Dan,

>
> The patch b119ad6e726c: "mac80211: add rate mask logic for vht rates"
> from Aug 6, 2015, leads to the following static checker warning:
>
>         net/mac80211/cfg.c:2520 ieee80211_set_bitrate_mask()
>         error: buffer overflow 'sdata->rc_rateidx_vht_mcs_mask[i]' 8 <= 9
>
> net/mac80211/cfg.c
>   2516                  for (j = 0; j < IEEE80211_HT_MCS_MASK_LEN; j++) {
>                                         ^^^^^^^^^^^^^^^^^^^^^^^^^
> This is 10.
>
>   2517                          if (~sdata->rc_rateidx_mcs_mask[i][j])
>   2518                                  sdata->rc_has_mcs_mask[i] = true;
>   2519
>   2520                          if (~sdata->rc_rateidx_vht_mcs_mask[i][j])
>                                             ^^^^^^^^^^^^^^^^^^^^^^^^^^
> This only has 8 elements.
>
>   2521                                  sdata->rc_has_vht_mcs_mask[i] = true;
>   2522
>   2523                          if (sdata->rc_has_mcs_mask[i] &&
>   2524                              sdata->rc_has_vht_mcs_mask[i])
>   2525                                  break;
>
> Maybe we always break out before we get to the last two iterations?
>

you are right, this chunk is wrong. We have to use to different for
loops to initialize rc_has_vht_mcs_mask array. I will send a patch in
few days. Thanks.

>   2526                  }
>
> regards,
> dan carpenter

Best regards,

Lorenzo

-- 
UNIX is Sexy: who | grep -i blonde | talk; cd ~; wine; talk; touch;
unzip; touch; strip; gasp; finger; gasp; mount; fsck; more; yes; gasp;
umount; make clean; sleep
