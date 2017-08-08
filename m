Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:28142 "EHLO
        sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751921AbdHHLD6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Aug 2017 07:03:58 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: qca_merez <qca_merez@qca.qualcomm.com>
CC: QCA_gidons <QCA_gidons@qca.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        wil6210 <wil6210@qca.qualcomm.com>
Subject: Re: [PATCH v4 10/10] wil6210: make debugfs compilation optional
Date: Tue, 8 Aug 2017 11:03:52 +0000
Message-ID: <87r2wmianc.fsf@kamboji.qca.qualcomm.com> (sfid-20170808_130402_296807_65659D64)
References: <1501787302-22885-1-git-send-email-qca_merez@qca.qualcomm.com>
        <1501787302-22885-11-git-send-email-qca_merez@qca.qualcomm.com>
In-Reply-To: <1501787302-22885-11-git-send-email-qca_merez@qca.qualcomm.com>
        (Maya Erez's message of "Thu, 3 Aug 2017 22:08:22 +0300")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maya Erez <qca_merez@qca.qualcomm.com> writes:

> From: Gidon Studinski <qca_gidons@qca.qualcomm.com>
>
> Since debugfs is a kernel configuration option, enable the driver to
> compile without debugfs.
>
> Signed-off-by: Gidon Studinski <qca_gidons@qca.qualcomm.com>
> Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/wil6210/Makefile  | 2 +-
>  drivers/net/wireless/ath/wil6210/wil6210.h | 6 ++++++
>  2 files changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/wil6210/Makefile b/drivers/net/wire=
less/ath/wil6210/Makefile
> index 4ae21da..63a751a 100644
> --- a/drivers/net/wireless/ath/wil6210/Makefile
> +++ b/drivers/net/wireless/ath/wil6210/Makefile
> @@ -4,7 +4,7 @@ wil6210-y :=3D main.o
>  wil6210-y +=3D netdev.o
>  wil6210-y +=3D cfg80211.o
>  wil6210-y +=3D pcie_bus.o
> -wil6210-y +=3D debugfs.o
> +wil6210-$(CONFIG_DEBUG_FS) +=3D debugfs.o
>  wil6210-y +=3D wmi.o
>  wil6210-y +=3D interrupt.o
>  wil6210-y +=3D txrx.o
> diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wir=
eless/ath/wil6210/wil6210.h
> index cf20a8c..d7b1e03 100644
> --- a/drivers/net/wireless/ath/wil6210/wil6210.h
> +++ b/drivers/net/wireless/ath/wil6210/wil6210.h
> @@ -940,8 +940,14 @@ int wil_cfg80211_mgmt_tx(struct wiphy *wiphy, struct=
 wireless_dev *wdev,
>  			 struct cfg80211_mgmt_tx_params *params,
>  			 u64 *cookie);
> =20
> +#if defined(CONFIG_DEBUG_FS)
>  int wil6210_debugfs_init(struct wil6210_priv *wil);
>  void wil6210_debugfs_remove(struct wil6210_priv *wil);
> +#else
> +static inline int wil6210_debugfs_init(struct wil6210_priv *wil) { retur=
n 0; }
> +static inline void wil6210_debugfs_remove(struct wil6210_priv *wil) {}
> +#endif

I was thinking more that should we have CONFIG_WIL6210_DEBUGFS, just
like we have CONFIG_ATH10K_DEBUGFS and CONFIG_ATH9K_DEBUGFS? This way it
can be controlled per driver if debugfs interface is available or not.

--=20
Kalle Valo=
