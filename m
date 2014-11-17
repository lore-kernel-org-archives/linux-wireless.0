Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hauke-m.de ([5.39.93.123]:39314 "EHLO hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752873AbaKQXFV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2014 18:05:21 -0500
Message-ID: <546A7F2E.6090501@hauke-m.de> (sfid-20141118_000529_992640_353012D3)
Date: Tue, 18 Nov 2014 00:05:18 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: ASIC Felix <ic.felix@gmail.com>, linux-wireless@vger.kernel.org,
	sujith@msujith.org
Subject: Re: backports-20141114 ath9k doesn't build for me on Ubuntu LTS 14.04
References: <CAJqaZwxC+Us=Vis0gQry_vdF--2SCmW9wej5BY+jAfgeb4U6KQ@mail.gmail.com>
In-Reply-To: <CAJqaZwxC+Us=Vis0gQry_vdF--2SCmW9wej5BY+jAfgeb4U6KQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/18/2014 12:02 AM, ASIC Felix wrote:
> Hi,
> 
> backports-20141114 ath9k doesn't build for me on Ubuntu LTS 14.04
> kernel 3.13.0-39
> 
> ] make defconfig-ath9k && make -j4
> 
> /home/me/Downloads/backports-20141114/drivers/net/wireless/ath/ath9k/common-spectral.c:40:5:
> error: redefinition of \u2018ath_cmn_process_fft\u2019
>  int ath_cmn_process_fft(struct ath_spec_scan_priv *spec_priv, struct
> ieee80211_hdr *hdr,
>      ^
> In file included from
> /home/me/Downloads/backports-20141114/drivers/net/wireless/ath/ath9k/common.h:27:0,
>                  from
> /home/me/Downloads/backports-20141114/drivers/net/wireless/ath/ath9k/ath9k.h:27,
>                  from
> /home/me/Downloads/backports-20141114/drivers/net/wireless/ath/ath9k/common-spectral.c:18:
> /home/me/Downloads/backports-20141114/drivers/net/wireless/ath/ath9k/common-spectral.h:146:19:
> note: previous definition of \u2018ath_cmn_process_fft\u2019 was here
>  static inline int ath_cmn_process_fft(struct ath_spec_scan_priv *spec_priv,
>                    ^
> make[8]: *** [/home/me/Downloads/backports-20141114/drivers/net/wireless/ath/ath9k/common-spectral.o]
> Error 1
> 
> Felix

There is a bug in upstream ath9k, you need this additional patch:

http://www.spinics.net/lists/linux-wireless/msg129456.html

Hauke
