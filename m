Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:35454 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756665AbbJIPvP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Oct 2015 11:51:15 -0400
Received: by wicge5 with SMTP id ge5so74249926wic.0
        for <linux-wireless@vger.kernel.org>; Fri, 09 Oct 2015 08:51:14 -0700 (PDT)
Message-ID: <5617E271.90007@gmail.com> (sfid-20151009_175118_990932_283D7AAE)
Date: Fri, 09 Oct 2015 17:51:13 +0200
From: "zefir.kurtisi@gmail.com" <zefir.kurtisi@gmail.com>
MIME-Version: 1.0
To: Nick Kossifidis <mickflemm@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: ath9k: issues with HT40 spectral scanning
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Nick,

after using ath9k spectral-scanning feature for a while in 20MHz mode, today I
gave it a first try with 40MHz and failed to get it running.

Setup is as follows: AR9590 operating in HT40+ monitor mode; enabling
SPECTRAL_SCAN debug flag and starting background spectral scanning I get the log
flooded with

>  [12082.712198] ath: phy1: Got radar dump bw_info: 0x13,len: 138 fft_len: 138
>  [12082.712207] ath: phy1: FFT frame len: 135
>  [12082.712219] ath: phy1: FFT HT20/40 frame: lower mag 0xCE,lower_mag_idx 34, upper mag 0xD5,upper_mag_idx 70
>  [12082.712229] ath: phy1: Got lower mag: 0xCE at index 34
>  [12082.712238] ath: phy1: Got upper mag: 0xD5 at index 70
>  [12082.712266] ath: phy1: FFT report truncated(bytes left: 264)
>  [12082.713696] ath: phy1: Got radar dump bw_info: 0x13,len: 138 fft_len: 138
>  [12082.713705] ath: phy1: FFT frame len: 135
>  [12082.713718] ath: phy1: FFT HT20/40 frame: lower mag 0xAD,lower_mag_idx 36, upper mag 0x56,upper_mag_idx 67
>  [12082.713728] ath: phy1: Got lower mag: 0xAD at index 36
>  [12082.713737] ath: phy1: Got upper mag: 0x56 at index 67
>  [12082.713761] ath: phy1: FFT report truncated(bytes left: 264)
>  [12082.715193] ath: phy1: Got radar dump bw_info: 0x13,len: 138 fft_len: 138
>  [12082.715202] ath: phy1: FFT frame len: 135
>  [12082.715215] ath: phy1: FFT HT20/40 frame: lower mag 0x94,lower_mag_idx 49, upper mag 0x8F,upper_mag_idx 40
>  [12082.715225] ath: phy1: Got lower mag: 0x94 at index 49
>  [12082.715235] ath: phy1: Got upper mag: 0x8F at index 104
>  [12082.715259] ath: phy1: FFT report truncated(bytes left: 264)

Last time we discussed the spectral feature, you told me you had it running on
ath9k in 20 and 40MHz mode. Before I start digging the issue, could you confirm
that it is still doing on ath9k/40MHz?


Thanks,
Zefir
