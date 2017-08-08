Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:11147 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751993AbdHHKxb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Aug 2017 06:53:31 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: qca_merez <qca_merez@qca.qualcomm.com>
CC: QCA_hkadmany <QCA_hkadmany@QCA.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        wil6210 <wil6210@qca.qualcomm.com>
Subject: Re: [PATCH v4 02/10] wil6210: allow configuring scan timers
Date: Tue, 8 Aug 2017 10:53:25 +0000
Message-ID: <87valyib4r.fsf@kamboji.qca.qualcomm.com> (sfid-20170808_125334_767409_2A06C01E)
References: <1501787302-22885-1-git-send-email-qca_merez@qca.qualcomm.com>
        <1501787302-22885-3-git-send-email-qca_merez@qca.qualcomm.com>
In-Reply-To: <1501787302-22885-3-git-send-email-qca_merez@qca.qualcomm.com>
        (Maya Erez's message of "Thu, 3 Aug 2017 22:08:14 +0300")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maya Erez <qca_merez@qca.qualcomm.com> writes:

> From: Hamad Kadmany <qca_hkadmany@qca.qualcomm.com>
>
> Allow setting scan timeout and scan dwell time
> through module parameters.
>
> Signed-off-by: Hamad Kadmany <qca_hkadmany@qca.qualcomm.com>
> Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/wil6210/cfg80211.c | 17 ++++++++++++++---
>  drivers/net/wireless/ath/wil6210/wil6210.h  |  2 +-
>  2 files changed, 15 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wi=
reless/ath/wil6210/cfg80211.c
> index 77af749..d079533 100644
> --- a/drivers/net/wireless/ath/wil6210/cfg80211.c
> +++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
> @@ -26,6 +26,14 @@
>  module_param(disable_ap_sme, bool, 0444);
>  MODULE_PARM_DESC(disable_ap_sme, " let user space handle AP mode SME");
> =20
> +static uint scan_dwell_time  =3D WMI_SCAN_DWELL_TIME_MS;
> +module_param(scan_dwell_time, uint, 0644);
> +MODULE_PARM_DESC(scan_dwell_time, " Scan dwell time (msec)");
> +
> +static uint scan_timeout =3D WIL6210_SCAN_TO_SEC;
> +module_param(scan_timeout, uint, 0644);
> +MODULE_PARM_DESC(scan_timeout, " Scan timeout (seconds)");

Module parameters are not really meant for this kind of configuration
802.11 protocol configuration. Can't you use nl80211?

--=20
Kalle Valo=
