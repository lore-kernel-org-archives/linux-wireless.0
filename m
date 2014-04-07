Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:47808 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755142AbaDGLJf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Apr 2014 07:09:35 -0400
Received: by mail-ig0-f174.google.com with SMTP id h18so3457314igc.1
        for <linux-wireless@vger.kernel.org>; Mon, 07 Apr 2014 04:09:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <773DB8A82AB6A046AE0195C68612A319017342EF@sbs2003.acksys.local>
References: <773DB8A82AB6A046AE0195C68612A319017342EF@sbs2003.acksys.local>
Date: Mon, 7 Apr 2014 13:09:34 +0200
Message-ID: <CAFED-j=nyEnfg7n=OF0oA_Geh11DR_XYNPTLeb603jKNNUxv0g@mail.gmail.com> (sfid-20140407_131000_337452_D55B6D16)
Subject: Re: [MAC80211] Radar detection management issue
From: Janusz Dziedzic <janusz.dziedzic@gmail.com>
To: Cedric VONCKEN <cedric.voncken@acksys.fr>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2014-04-07 11:30 GMT+02:00 Cedric VONCKEN <cedric.voncken@acksys.fr>:
>         I'm doing some tests in 802.11a with ath9k driver and I found a
> strange behavior.
>
>         With iw phy0 info, I check the regulation rules. I can see some
> channels needs radar detection. For test I set an AP on this channel and
> I can see the beacon with wireshark. But ATH9K doesn't support radar
> detection, so these channels should be disabled.
>
>         I think the problem is on MAC80211 layer. In /net/wireless/reg.c
> the function map_regdom_flags set the flags IEEE80211_CHAN_RADAR if the
> regulatory domain set NL80211_RRF_DFS.
>         But ATH9K doesn't support the radar detection, and I don't found
> in MAC80211 a test on this capability.
>
>         I only found a capabilities in ATH9K (ATH9K_HW_CAP_DFS), but
> this flag is set and not used.
>
>         I don't know how fix this issue. For the moment I disable the
> channel when the NL80211_RRF_DFS is set (in map_regdom_flags).
>

This seems like a bug in ath9k (init.c) driver, when register
interface combinations.
Seems RADAR combination should be registered only in case when
ATH9K_DFS_CERTIFIED is set.

BR
Janusz
