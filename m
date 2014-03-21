Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f51.google.com ([209.85.219.51]:48746 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933349AbaCULCH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Mar 2014 07:02:07 -0400
Received: by mail-oa0-f51.google.com with SMTP id i4so2351575oah.10
        for <linux-wireless@vger.kernel.org>; Fri, 21 Mar 2014 04:02:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1395396014-24631-1-git-send-email-yeohchunyeow@gmail.com>
References: <1395396014-24631-1-git-send-email-yeohchunyeow@gmail.com>
Date: Fri, 21 Mar 2014 12:02:06 +0100
Message-ID: <CA+BoTQ=X=UxikrVrmr3hyQgjN2Tg5aeW5Ok7b+23n9X6bxRshA@mail.gmail.com> (sfid-20140321_120213_375554_9650ED83)
Subject: Re: [PATCH] ath10k: add the Rx rate in FW stats
From: Michal Kazior <michal.kazior@tieto.com>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21 March 2014 11:00, Chun-Yeow Yeoh <yeohchunyeow@gmail.com> wrote:
> FW stats does provide the Rx rate information. Add this.
> Tested with firmware 10.1.467.2-1.
>
> Further investigation on firmware 999.999.0.636 indicates
> that there is no Tx Rate and Rx Rate in the peer stats.

Incorrect.

999.999.0.636 does have Tx Rate. It doesn't have Rx Rate.

10.1.467.2-1 has both.


>
> Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
> ---
>  drivers/net/wireless/ath/ath10k/core.h  |    1 +
>  drivers/net/wireless/ath/ath10k/debug.c |    5 +++++
>  drivers/net/wireless/ath/ath10k/wmi.h   |    1 +
>  3 files changed, 7 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
> index ad209a6..ca4cdab 100644
> --- a/drivers/net/wireless/ath/ath10k/core.h
> +++ b/drivers/net/wireless/ath/ath10k/core.h
> @@ -119,6 +119,7 @@ struct ath10k_peer_stat {
>         u8 peer_macaddr[ETH_ALEN];
>         u32 peer_rssi;
>         u32 peer_tx_rate;
> +       u32 peer_rx_rate;
>  };
>
>  struct ath10k_target_stats {
> diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
> index f95defa..4662cb7 100644
> --- a/drivers/net/wireless/ath/ath10k/debug.c
> +++ b/drivers/net/wireless/ath/ath10k/debug.c
> @@ -257,6 +257,8 @@ void ath10k_debug_read_target_stats(struct ath10k *ar,
>                         s->peer_rssi = __le32_to_cpu(peer_stats->peer_rssi);
>                         s->peer_tx_rate =
>                                 __le32_to_cpu(peer_stats->peer_tx_rate);
> +                       s->peer_rx_rate =
> +                               __le32_to_cpu(peer_stats->peer_rx_rate);
>
>                         tmp += sizeof(struct wmi_peer_stats);
>                 }
> @@ -425,6 +427,9 @@ static ssize_t ath10k_read_fw_stats(struct file *file, char __user *user_buf,
>                 len += scnprintf(buf + len, buf_len - len, "%30s %u\n",
>                                  "Peer TX rate",
>                                  fw_stats->peer_stat[i].peer_tx_rate);
> +               len += scnprintf(buf + len, buf_len - len, "%30s %u\n",
> +                                "Peer RX rate",
> +                                fw_stats->peer_stat[i].peer_rx_rate);
>                 len += scnprintf(buf + len, buf_len - len, "\n");
>         }
>         spin_unlock_bh(&ar->data_lock);
> diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
> index 084bcc5..2b2f0b7 100644
> --- a/drivers/net/wireless/ath/ath10k/wmi.h
> +++ b/drivers/net/wireless/ath/ath10k/wmi.h
> @@ -2825,6 +2825,7 @@ struct wmi_peer_stats {
>         struct wmi_mac_addr peer_macaddr;
>         __le32 peer_rssi;
>         __le32 peer_tx_rate;
> +       __le32 peer_rx_rate;
>  } __packed;

Unfortunately this isn't as simple as it seems.

Stats are received via wmi_stats_event. This structure contains fields
describing number of pdev/vdev/beer/bcn stat entries. All entries
(structures) are appended in certain order after this header. This
means if you change length of structure type you skew the calculation
of all succeeding entries.

IOW this means this patch breaks peer stats for 999.999.0.636.

I'm quite positive wmi_pdev_stats is also broken. This implies vdev
stats and peer stats position calculation is skewed in the first place
and you get garbage.

The main problem here is there are subtle yet crazy binary
incompatibilities between these firmwares.

The best way would probably be to implement wmi as an abstraction
layer with completely different backends for different firmware
branches/revisions. Otherwise you sign up for some pain..


Micha³
