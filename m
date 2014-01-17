Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f42.google.com ([209.85.214.42]:65353 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbaAQNSp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jan 2014 08:18:45 -0500
Received: by mail-bk0-f42.google.com with SMTP id my12so1635269bkb.15
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jan 2014 05:18:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1389345564-21042-1-git-send-email-yeohchunyeow@gmail.com>
References: <1389345564-21042-1-git-send-email-yeohchunyeow@gmail.com>
Date: Fri, 17 Jan 2014 14:18:43 +0100
Message-ID: <CA+BoTQncY0esFNgo2MGzbrmu=xoXMCb1OMY0Uci0o-=4ATG=6Q@mail.gmail.com> (sfid-20140117_141852_950410_FABAB10A)
Subject: Re: [PATCH v2] ath10k: fix the MAC address of peer statistic
From: Michal Kazior <michal.kazior@tieto.com>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10 January 2014 10:19, Chun-Yeow Yeoh <yeohchunyeow@gmail.com> wrote:
> Fix the MAC address of wmi_peer_stats so that it is
> printed correctly. This is tested and verified using
> firmware version 999.999.0.636.
>
> Based on the verification, maximum only 3 peer statistics including
> self STA able to be printed out.
>
> Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
> ---
> v2: offset the stats to ignore the first peer (Chun-Yeow)
>
>  drivers/net/wireless/ath/ath10k/debug.c |    4 ++++
>  drivers/net/wireless/ath/ath10k/wmi.h   |   14 +++++++-------
>  2 files changed, 11 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
> index 6bdfad3..b39bad8 100644
> --- a/drivers/net/wireless/ath/ath10k/debug.c
> +++ b/drivers/net/wireless/ath/ath10k/debug.c
> @@ -242,6 +242,10 @@ void ath10k_debug_read_target_stats(struct ath10k *ar,
>                 }
>         }
>
> +       /* The first peer is self MAC address, ignore this */
> +       num_peer_stats--;
> +       tmp += sizeof(struct wmi_peer_stats);
> +
>         if (num_peer_stats) {
>                 struct wmi_peer_stats *peer_stats;
>                 struct ath10k_peer_stat *s;
> diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
> index 0087d69..106a23e 100644
> --- a/drivers/net/wireless/ath/ath10k/wmi.h
> +++ b/drivers/net/wireless/ath/ath10k/wmi.h
> @@ -200,12 +200,12 @@ struct wmi_mac_addr {
>
>  /* macro to convert MAC address from WMI word format to char array */
>  #define WMI_MAC_ADDR_TO_CHAR_ARRAY(pwmi_mac_addr, c_macaddr) do { \
> -       (c_macaddr)[0] =  ((pwmi_mac_addr)->word0) & 0xff; \
> -       (c_macaddr)[1] = (((pwmi_mac_addr)->word0) >> 8) & 0xff; \
> -       (c_macaddr)[2] = (((pwmi_mac_addr)->word0) >> 16) & 0xff; \
> -       (c_macaddr)[3] = (((pwmi_mac_addr)->word0) >> 24) & 0xff; \
> -       (c_macaddr)[4] =  ((pwmi_mac_addr)->word1) & 0xff; \
> -       (c_macaddr)[5] = (((pwmi_mac_addr)->word1) >> 8) & 0xff; \
> +       (c_macaddr)[0] = (((pwmi_mac_addr)->word0) >> 24) & 0xff; \
> +       (c_macaddr)[1] = (((pwmi_mac_addr)->word0) >> 16) & 0xff; \
> +       (c_macaddr)[2] = (((pwmi_mac_addr)->word0) >> 8) & 0xff; \
> +       (c_macaddr)[3] =  ((pwmi_mac_addr)->word0) & 0xff; \
> +       (c_macaddr)[4] = (((pwmi_mac_addr)->word1) >> 24) & 0xff; \
> +       (c_macaddr)[5] = (((pwmi_mac_addr)->word1) >> 16) & 0xff; \
>         } while (0)

This is totally wrong. This macro shouldn't be used anymore. It
shouldn't even be here. There's no hardware byte-swapping anymore.
This means mac addresses received from firmware should be treated
as-is, e.g. with memcpy(). See wmi_mac_addr definition - it has
`addr[6]` field which should be used.


Michał
