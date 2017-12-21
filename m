Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:29139 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752766AbdLUQTF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Dec 2017 11:19:05 -0500
From: Rakesh Pillai <pillair@qti.qualcomm.com>
To: Rakesh Pillai <pillair@qti.qualcomm.com>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        Kalle Valo <kvalo@qca.qualcomm.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Rakesh Pillai" <pillair@codeaurora.org>
Subject: RE: [PATCH v2 3/3] ath10k: Add fw feature flag for non-bmi firmware
 load
Date: Thu, 21 Dec 2017 16:18:57 +0000
Message-ID: <85c2eb6d18d44dbba6d6b0a1fef87ccc@aphydexm01b.ap.qualcomm.com> (sfid-20171221_171909_024618_CAAB2C99)
References: <1513872322-26636-1-git-send-email-pillair@qti.qualcomm.com>
 <1513872322-26636-4-git-send-email-pillair@qti.qualcomm.com>
In-Reply-To: <1513872322-26636-4-git-send-email-pillair@qti.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

I have sent a v3 for this patch with the corrected ownership.


Thanks,
Rakesh Pillai

> -----Original Message-----
> From: Rakesh Pillai [mailto:pillair@qti.qualcomm.com]
> Sent: Thursday, December 21, 2017 9:35 PM
> To: ath10k@lists.infradead.org
> Cc: linux-wireless@vger.kernel.org; Rakesh Pillai <pillair@codeaurora.org=
>;
> Rakesh Pillai <pillair@qti.qualcomm.com>
> Subject: [PATCH v2 3/3] ath10k: Add fw feature flag for non-bmi firmware =
load
>=20
> From: Rakesh Pillai <pillair@codeaurora.org>
>=20
> HL1.0 firmware is not loaded via bmi. The bmi specific
> code should not be executed for HL1.0
>=20
> Add fw feature flag for non bmi targets and skip the bmi
> specific code for non bmi targets.
>=20
> Signed-off-by: Rakesh Pillai <pillair@qti.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath10k/core.c | 180 +++++++++++++++++++--------=
-----
> -
>  drivers/net/wireless/ath/ath10k/core.h |   3 +
>  2 files changed, 108 insertions(+), 75 deletions(-)
>=20
> diff --git a/drivers/net/wireless/ath/ath10k/core.c
> b/drivers/net/wireless/ath/ath10k/core.c
> index b6d5bad6f5ec..188efa8dcfc0 100644
> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -445,6 +445,7 @@ static const char *const ath10k_core_fw_feature_str[]
> =3D {
>  	[ATH10K_FW_FEATURE_ALLOWS_MESH_BCAST] =3D "allows-mesh-
> bcast",
>  	[ATH10K_FW_FEATURE_NO_PS] =3D "no-ps",
>  	[ATH10K_FW_FEATURE_MGMT_TX_BY_REF] =3D "mgmt-tx-by-reference",
> +	[ATH10K_FW_FEATURE_NON_BMI] =3D "non-bmi",
>  };
>=20
>  static unsigned int ath10k_core_get_fw_feature_str(char *buf,
> @@ -1524,8 +1525,8 @@ int ath10k_core_fetch_firmware_api_n(struct ath10k
> *ar, const char *name,
>  		data +=3D ie_len;
>  	}
>=20
> -	if (!fw_file->firmware_data ||
> -	    !fw_file->firmware_len) {
> +	if (!test_bit(ATH10K_FW_FEATURE_NON_BMI, fw_file->fw_features)
> &&
> +	    (!fw_file->firmware_data || !fw_file->firmware_len)) {
>  		ath10k_warn(ar, "No ATH10K_FW_IE_FW_IMAGE found from
> '%s/%s', skipping\n",
>  			    ar->hw_params.fw.dir, name);
>  		ret =3D -ENOMEDIUM;
> @@ -2079,43 +2080,47 @@ int ath10k_core_start(struct ath10k *ar, enum
> ath10k_firmware_mode mode,
>=20
>  	ar->running_fw =3D fw;
>=20
> -	ath10k_bmi_start(ar);
> +	if (!test_bit(ATH10K_FW_FEATURE_NON_BMI,
> +		      ar->running_fw->fw_file.fw_features)) {
> +		ath10k_bmi_start(ar);
>=20
> -	if (ath10k_init_configure_target(ar)) {
> -		status =3D -EINVAL;
> -		goto err;
> -	}
> -
> -	status =3D ath10k_download_cal_data(ar);
> -	if (status)
> -		goto err;
> +		if (ath10k_init_configure_target(ar)) {
> +			status =3D -EINVAL;
> +			goto err;
> +		}
>=20
> -	/* Some of of qca988x solutions are having global reset issue
> -	 * during target initialization. Bypassing PLL setting before
> -	 * downloading firmware and letting the SoC run on REF_CLK is
> -	 * fixing the problem. Corresponding firmware change is also needed
> -	 * to set the clock source once the target is initialized.
> -	 */
> -	if (test_bit(ATH10K_FW_FEATURE_SUPPORTS_SKIP_CLOCK_INIT,
> -		     ar->running_fw->fw_file.fw_features)) {
> -		status =3D ath10k_bmi_write32(ar, hi_skip_clock_init, 1);
> -		if (status) {
> -			ath10k_err(ar, "could not write to skip_clock_init:
> %d\n",
> -				   status);
> +		status =3D ath10k_download_cal_data(ar);
> +		if (status)
>  			goto err;
> +
> +		/* Some of of qca988x solutions are having global reset issue
> +		 * during target initialization. Bypassing PLL setting before
> +		 * downloading firmware and letting the SoC run on REF_CLK is
> +		 * fixing the problem. Corresponding firmware change is also
> +		 * needed to set the clock source once the target is
> +		 * initialized.
> +		 */
> +		if
> (test_bit(ATH10K_FW_FEATURE_SUPPORTS_SKIP_CLOCK_INIT,
> +			     ar->running_fw->fw_file.fw_features)) {
> +			status =3D ath10k_bmi_write32(ar, hi_skip_clock_init, 1);
> +			if (status) {
> +				ath10k_err(ar, "could not write to
> skip_clock_init: %d\n",
> +					   status);
> +				goto err;
> +			}
>  		}
> -	}
>=20
> -	status =3D ath10k_download_fw(ar);
> -	if (status)
> -		goto err;
> +		status =3D ath10k_download_fw(ar);
> +		if (status)
> +			goto err;
>=20
> -	status =3D ath10k_init_uart(ar);
> -	if (status)
> -		goto err;
> +		status =3D ath10k_init_uart(ar);
> +		if (status)
> +			goto err;
>=20
> -	if (ar->hif.bus =3D=3D ATH10K_BUS_SDIO)
> -		ath10k_init_sdio(ar);
> +		if (ar->hif.bus =3D=3D ATH10K_BUS_SDIO)
> +			ath10k_init_sdio(ar);
> +	}
>=20
>  	ar->htc.htc_ops.target_send_suspend_complete =3D
>  		ath10k_send_suspend_complete;
> @@ -2126,9 +2131,12 @@ int ath10k_core_start(struct ath10k *ar, enum
> ath10k_firmware_mode mode,
>  		goto err;
>  	}
>=20
> -	status =3D ath10k_bmi_done(ar);
> -	if (status)
> -		goto err;
> +	if (!test_bit(ATH10K_FW_FEATURE_NON_BMI,
> +		      ar->running_fw->fw_file.fw_features)) {
> +		status =3D ath10k_bmi_done(ar);
> +		if (status)
> +			goto err;
> +	}
>=20
>  	status =3D ath10k_wmi_attach(ar);
>  	if (status) {
> @@ -2371,19 +2379,34 @@ static int ath10k_core_probe_fw(struct ath10k *ar=
)
>  		return ret;
>  	}
>=20
> -	memset(&target_info, 0, sizeof(target_info));
> -	if (ar->hif.bus =3D=3D ATH10K_BUS_SDIO)
> +	switch (ar->hif.bus) {
> +	case ATH10K_BUS_SDIO:
> +		memset(&target_info, 0, sizeof(target_info));
>  		ret =3D ath10k_bmi_get_target_info_sdio(ar, &target_info);
> -	else
> +		if (ret) {
> +			ath10k_err(ar, "could not get target info (%d)\n", ret);
> +			goto err_power_down;
> +		}
> +		ar->target_version =3D target_info.version;
> +		ar->hw->wiphy->hw_version =3D target_info.version;
> +		break;
> +	case ATH10K_BUS_PCI:
> +	case ATH10K_BUS_AHB:
> +		memset(&target_info, 0, sizeof(target_info));
>  		ret =3D ath10k_bmi_get_target_info(ar, &target_info);
> -	if (ret) {
> -		ath10k_err(ar, "could not get target info (%d)\n", ret);
> -		goto err_power_down;
> +		if (ret) {
> +			ath10k_err(ar, "could not get target info (%d)\n", ret);
> +			goto err_power_down;
> +		}
> +		ar->target_version =3D target_info.version;
> +		ar->hw->wiphy->hw_version =3D target_info.version;
> +		break;
> +	case ATH10K_BUS_SNOC:
> +		break;
> +	default:
> +		ath10k_err(ar, "incorrect hif bus type: %d\n", ar->hif.bus);
>  	}
>=20
> -	ar->target_version =3D target_info.version;
> -	ar->hw->wiphy->hw_version =3D target_info.version;
> -
>  	ret =3D ath10k_init_hw_params(ar);
>  	if (ret) {
>  		ath10k_err(ar, "could not get hw params (%d)\n", ret);
> @@ -2403,37 +2426,40 @@ static int ath10k_core_probe_fw(struct ath10k *ar=
)
>=20
>  	ath10k_debug_print_hwfw_info(ar);
>=20
> -	ret =3D ath10k_core_pre_cal_download(ar);
> -	if (ret) {
> -		/* pre calibration data download is not necessary
> -		 * for all the chipsets. Ignore failures and continue.
> -		 */
> -		ath10k_dbg(ar, ATH10K_DBG_BOOT,
> -			   "could not load pre cal data: %d\n", ret);
> -	}
> +	if (!test_bit(ATH10K_FW_FEATURE_NON_BMI,
> +		      ar->normal_mode_fw.fw_file.fw_features)) {
> +		ret =3D ath10k_core_pre_cal_download(ar);
> +		if (ret) {
> +			/* pre calibration data download is not necessary
> +			 * for all the chipsets. Ignore failures and continue.
> +			 */
> +			ath10k_dbg(ar, ATH10K_DBG_BOOT,
> +				   "could not load pre cal data: %d\n", ret);
> +		}
>=20
> -	ret =3D ath10k_core_get_board_id_from_otp(ar);
> -	if (ret && ret !=3D -EOPNOTSUPP) {
> -		ath10k_err(ar, "failed to get board id from otp: %d\n",
> -			   ret);
> -		goto err_free_firmware_files;
> -	}
> +		ret =3D ath10k_core_get_board_id_from_otp(ar);
> +		if (ret && ret !=3D -EOPNOTSUPP) {
> +			ath10k_err(ar, "failed to get board id from otp: %d\n",
> +				   ret);
> +			goto err_free_firmware_files;
> +		}
>=20
> -	ret =3D ath10k_core_check_smbios(ar);
> -	if (ret)
> -		ath10k_dbg(ar, ATH10K_DBG_BOOT, "SMBIOS bdf variant name
> not set.\n");
> +		ret =3D ath10k_core_check_smbios(ar);
> +		if (ret)
> +			ath10k_dbg(ar, ATH10K_DBG_BOOT, "SMBIOS bdf
> variant name not set.\n");
>=20
> -	ret =3D ath10k_core_check_dt(ar);
> -	if (ret)
> -		ath10k_dbg(ar, ATH10K_DBG_BOOT, "DT bdf variant name not
> set.\n");
> +		ret =3D ath10k_core_check_dt(ar);
> +		if (ret)
> +			ath10k_dbg(ar, ATH10K_DBG_BOOT, "DT bdf variant
> name not set.\n");
>=20
> -	ret =3D ath10k_core_fetch_board_file(ar);
> -	if (ret) {
> -		ath10k_err(ar, "failed to fetch board file: %d\n", ret);
> -		goto err_free_firmware_files;
> -	}
> +		ret =3D ath10k_core_fetch_board_file(ar);
> +		if (ret) {
> +			ath10k_err(ar, "failed to fetch board file: %d\n", ret);
> +			goto err_free_firmware_files;
> +		}
>=20
> -	ath10k_debug_print_board_info(ar);
> +		ath10k_debug_print_board_info(ar);
> +	}
>=20
>  	ret =3D ath10k_core_init_firmware_features(ar);
>  	if (ret) {
> @@ -2442,11 +2468,15 @@ static int ath10k_core_probe_fw(struct ath10k *ar=
)
>  		goto err_free_firmware_files;
>  	}
>=20
> -	ret =3D ath10k_swap_code_seg_init(ar, &ar->normal_mode_fw.fw_file);
> -	if (ret) {
> -		ath10k_err(ar, "failed to initialize code swap segment: %d\n",
> -			   ret);
> -		goto err_free_firmware_files;
> +	if (!test_bit(ATH10K_FW_FEATURE_NON_BMI,
> +		      ar->normal_mode_fw.fw_file.fw_features)) {
> +		ret =3D ath10k_swap_code_seg_init(ar,
> +						&ar-
> >normal_mode_fw.fw_file);
> +		if (ret) {
> +			ath10k_err(ar, "failed to initialize code swap segment:
> %d\n",
> +				   ret);
> +			goto err_free_firmware_files;
> +		}
>  	}
>=20
>  	mutex_lock(&ar->conf_mutex);
> diff --git a/drivers/net/wireless/ath/ath10k/core.h
> b/drivers/net/wireless/ath/ath10k/core.h
> index 81285ab30a7d..b747ef52c186 100644
> --- a/drivers/net/wireless/ath/ath10k/core.h
> +++ b/drivers/net/wireless/ath/ath10k/core.h
> @@ -618,6 +618,9 @@ enum ath10k_fw_features {
>  	/* Firmware allows management tx by reference instead of by value. */
>  	ATH10K_FW_FEATURE_MGMT_TX_BY_REF =3D 18,
>=20
> +	/* Firmware load is done externally, not by bmi */
> +	ATH10K_FW_FEATURE_NON_BMI =3D 19,
> +
>  	/* keep last */
>  	ATH10K_FW_FEATURE_COUNT,
>  };
> --
> 2.11.0
