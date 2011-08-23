Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53193 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079Ab1HWLM2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 07:12:28 -0400
Received: by eyx24 with SMTP id 24so3521373eyx.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Aug 2011 04:12:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1314049818-21839-2-git-send-email-Larry.Finger@lwfinger.net>
References: <1314049818-21839-1-git-send-email-Larry.Finger@lwfinger.net> <1314049818-21839-2-git-send-email-Larry.Finger@lwfinger.net>
From: Jonas Gorski <jonas.gorski@gmail.com>
Date: Tue, 23 Aug 2011 13:12:07 +0200
Message-ID: <CAOiHx==qGMcTm_2nW4ktO=HzGGLrdjX2cqkb2Aj=0qANfuMGBg@mail.gmail.com> (sfid-20110823_131231_840055_BAE48A4D)
Subject: Re: [PATCH 1/5] rtlwifi: Install updated rate-mapping routine
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Chaoming Li <chaoming_li@realsil.com.cn>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 22 August 2011 23:50, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> In preparation for fixing the rate-mapping situation, place a driver-agnostic
> version in rtlwifi. This one contains the updated rate incormation.
>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Chaoming Li <chaoming_li@realsil.com.cn>
> ---
>  drivers/net/wireless/rtlwifi/base.c |  161 +++++++++++++++++++++++++++++++++++
>  drivers/net/wireless/rtlwifi/base.h |    2 +
>  drivers/net/wireless/rtlwifi/wifi.h |   35 ++++++++
>  3 files changed, 198 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/rtlwifi/base.c b/drivers/net/wireless/rtlwifi/base.c
> index 0b598db..098fc55 100644
> --- a/drivers/net/wireless/rtlwifi/base.c
> +++ b/drivers/net/wireless/rtlwifi/base.c
> @@ -664,6 +664,167 @@ static u8 _rtl_get_highest_n_rate(struct ieee80211_hw *hw)
>        return hw_rate;
>  }
>
> +/* mac80211's rate_idx is like this:
> + *
> + * 2.4G band:rx_status->band == IEEE80211_BAND_2GHZ
> + *
> + * B/G rate:
> + * (rx_status->flag & RX_FLAG_HT) = 0,
> + * DESC92_RATE1M-->DESC92_RATE54M ==> idx is 0-->11,
> + *
> + * N rate:
> + * (rx_status->flag & RX_FLAG_HT) = 1,
> + * DESC92_RATEMCS0-->DESC92_RATEMCS15 ==> idx is 0-->15
> + *
> + * 5G band:rx_status->band == IEEE80211_BAND_5GHZ
> + * A rate:
> + * (rx_status->flag & RX_FLAG_HT) = 0,
> + * DESC92_RATE6M-->DESC92_RATE54M ==> idx is 0-->7,
> + *
> + * N rate:
> + * (rx_status->flag & RX_FLAG_HT) = 1,
> + * DESC92_RATEMCS0-->DESC92_RATEMCS15 ==> idx is 0-->15
> + */
> +int rtlwifi_rate_mapping(struct ieee80211_hw *hw,
> +                        bool isht, u8 desc_rate, bool first_ampdu)

first_ampdu is never used in this function, is this intentional? I see
the (later) removed functions change the default based on this, but
without much knowledge of 802.11 I can't tell whether this actually
makes sense, etc. ;-).

</review>


Jonas
