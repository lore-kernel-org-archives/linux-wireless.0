Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:54113 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510AbaDGMxF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Apr 2014 08:53:05 -0400
Received: by mail-ig0-f169.google.com with SMTP id h18so4410029igc.2
        for <linux-wireless@vger.kernel.org>; Mon, 07 Apr 2014 05:53:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <00dc01cf5259$94fd02d0$bef70870$@acksys.fr>
References: <773DB8A82AB6A046AE0195C68612A319017342EF@sbs2003.acksys.local>
	<CAFED-j=nyEnfg7n=OF0oA_Geh11DR_XYNPTLeb603jKNNUxv0g@mail.gmail.com>
	<00dc01cf5259$94fd02d0$bef70870$@acksys.fr>
Date: Mon, 7 Apr 2014 14:53:03 +0200
Message-ID: <CAFED-jkwWPu56R7aTHhkQqbk5SyU2pKD38Z+jJ5e7HEB7xrc+A@mail.gmail.com> (sfid-20140407_145308_988263_6A6197D1)
Subject: Re: [MAC80211] Radar detection management issue
From: Janusz Dziedzic <janusz.dziedzic@gmail.com>
To: voncken <cedric.voncke@acksys.fr>
Cc: Cedric VONCKEN <cedric.voncken@acksys.fr>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2014-04-07 14:04 GMT+02:00 voncken <cedric.voncke@acksys.fr>:
>> >
>> >         I don't know how fix this issue. For the moment I disable the
>> > channel when the NL80211_RRF_DFS is set (in map_regdom_flags).
>> >
>>
>> This seems like a bug in ath9k (init.c) driver, when register interface
>> combinations.
>> Seems RADAR combination should be registered only in case when
>> ATH9K_DFS_CERTIFIED is set.
>
>         Thanks for the answer.
>
>         The ATH9K_HW_CAP_DFS is set in hw.c only  if the function
> ath9k_hw_dfs_tested return true.
>
>         In the ath9k/init.c, the function ath9k_set_hw_capab do not set any
> flags in hw->flags relevant to DFS.
>
>         I'm looking for a similar line
>         if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_DFS)
>         hw->flags |= IEEE80211_HW_xxxx;
>
>         But I don't found.
>
>         I'm looking in net/mac80211.h the IEEE80211 flag relevant to DFS (to
> add the test in ath9k init), but I don't found it.
>
>         It seem the mac80211 do not know the hardware capability to detect
> radar.
>
Driver set this in iface_combinations (check):

  .radar_detect_widths = BIT(NL80211_CHAN_WIDTH_20_NOHT) |
                                       BIT(NL80211_CHAN_WIDTH_20),

BR
Janusz
