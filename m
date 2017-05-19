Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:34147 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751055AbdESE4t (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 May 2017 00:56:49 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: qca_merez <qca_merez@qca.qualcomm.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        wil6210 <wil6210@qca.qualcomm.com>,
        qca_liord <qca_liord@qca.qualcomm.com>
Subject: Re: [PATCH v2 4/5] wil6210: add option to ignore OTA regulatory hints
Date: Fri, 19 May 2017 04:56:40 +0000
Message-ID: <8737c1a1h6.fsf@qca.qualcomm.com> (sfid-20170519_065654_886637_B386636D)
References: <1494848759-3651-1-git-send-email-qca_merez@qca.qualcomm.com>
        <1494848759-3651-5-git-send-email-qca_merez@qca.qualcomm.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maya Erez <qca_merez@qca.qualcomm.com> writes:

> On some platforms, the regulatory domain (country) is set
> using mechanisms external to WIFI, such as cellular modem
> and GPS. In these scenarios the regulatory hints that
> are received over the air (in beacons and similar) can
> conflict and even cause an incorrect country to be set.
> Add an option to ignore the OTA regulatory hints to better
> support such scenarios.
>
> Signed-off-by: Lior David <qca_liord@qca.qualcomm.com>
> Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/wil6210/cfg80211.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wi=
reless/ath/wil6210/cfg80211.c
> index 567fe43..0f297c0 100644
> --- a/drivers/net/wireless/ath/wil6210/cfg80211.c
> +++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
> @@ -26,6 +26,11 @@
>  module_param(disable_ap_sme, bool, 0444);
>  MODULE_PARM_DESC(disable_ap_sme, " let user space handle AP mode SME");
> =20
> +static bool ignore_reg_hints;
> +module_param(ignore_reg_hints, bool, 0444);
> +MODULE_PARM_DESC(ignore_reg_hints,
> +		 " Ignore OTA regulatory hints (Default: false)");
> +
>  #define CHAN60G(_channel, _flags) {				\
>  	.band			=3D NL80211_BAND_60GHZ,		\
>  	.center_freq		=3D 56160 + (2160 * (_channel)),	\
> @@ -1763,6 +1768,11 @@ static void wil_wiphy_init(struct wiphy *wiphy)
> =20
>  	wiphy->n_vendor_commands =3D ARRAY_SIZE(wil_nl80211_vendor_commands);
>  	wiphy->vendor_commands =3D wil_nl80211_vendor_commands;
> +
> +	if (ignore_reg_hints) {
> +		wiphy->regulatory_flags |=3D REGULATORY_DISABLE_BEACON_HINTS;
> +		wiphy->regulatory_flags |=3D REGULATORY_COUNTRY_IE_IGNORE;
> +	}

I wonder should something like this be in cfg80211? Because I doubt
wil6210 is the only driver having this problem.

--=20
Kalle Valo=
