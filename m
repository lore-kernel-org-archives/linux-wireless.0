Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f54.google.com ([209.85.214.54]:46517 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083AbaAQNiB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jan 2014 08:38:01 -0500
Received: by mail-bk0-f54.google.com with SMTP id u14so1664869bkz.27
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jan 2014 05:38:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1389345564-21042-1-git-send-email-yeohchunyeow@gmail.com>
References: <1389345564-21042-1-git-send-email-yeohchunyeow@gmail.com>
Date: Fri, 17 Jan 2014 14:38:00 +0100
Message-ID: <CA+BoTQmexjQy-+Bv-uofBa2Ndcu56yYOAEeNzdBSE3yMCQdZKw@mail.gmail.com> (sfid-20140117_143806_083620_A15583D9)
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

[...]

> @@ -2820,9 +2820,9 @@ struct wmi_vdev_stats {
>   * TODO: add more stats
>   */
>  struct wmi_peer_stats {
> +       __le32 peer_tx_rate;    /* TBA */
>         struct wmi_mac_addr peer_macaddr;
>         __le32 peer_rssi;
> -       __le32 peer_tx_rate;
>  } __packed;

This looks wrong too. I've just checked it and it seems the
`wal_dbg_tx_stats` is out of date. It's missing a `__le32
stateless_tid_alloc_failure` that has been inserted at some point in
time in the firmware between `pdev_resets` and `phy_underrun`. You
should add this missing field instead of moving `peer_tx_rate`.

Unfortunately AP firmware has even more fields inserted in
`wmi_pdev_stats`. Making this work with both firmwares is a mess.


Michał
