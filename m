Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:33279 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750783AbeCZHhh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Mar 2018 03:37:37 -0400
Received: by mail-lf0-f65.google.com with SMTP id x205-v6so26648539lfa.0
        for <linux-wireless@vger.kernel.org>; Mon, 26 Mar 2018 00:37:36 -0700 (PDT)
Date: Mon, 26 Mar 2018 09:37:25 +0200
From: Marcus Folkesson <marcus.folkesson@gmail.com>
To: Govind Singh <govinds@codeaurora.org>
Cc: ath10k@lists.infradead.org, bjorn.andersson@linaro.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 10/12] ath10k: add bdf/cal indication support
Message-ID: <20180326073725.GA3689@gmail.com> (sfid-20180326_093740_925174_433EA603)
References: <1522042886-26343-1-git-send-email-govinds@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
In-Reply-To: <1522042886-26343-1-git-send-email-govinds@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Govind,

On Mon, Mar 26, 2018 at 11:11:26AM +0530, Govind Singh wrote:
> Add support for bdf download and cold boot
> calibration trigger qmi message support.
>=20
> Signed-off-by: Govind Singh <govinds@codeaurora.org>
> ---
>  drivers/net/wireless/ath/ath10k/qmi.c | 195 ++++++++++++++++++++++++++++=
++++++
>  drivers/net/wireless/ath/ath10k/qmi.h |  10 ++
>  2 files changed, 205 insertions(+)
>=20
> diff --git a/drivers/net/wireless/ath/ath10k/qmi.c b/drivers/net/wireless=
/ath/ath10k/qmi.c
> index a33681d..f23d0fe 100644
> --- a/drivers/net/wireless/ath/ath10k/qmi.c
> +++ b/drivers/net/wireless/ath/ath10k/qmi.c
> @@ -28,6 +28,7 @@
>  #include <linux/soc/qcom/qmi.h>
>  #include <linux/qcom_scm.h>
>  #include <linux/of.h>
> +#include <linux/firmware.h>
>  #include "qmi.h"
>  #include "qmi_svc_v01.h"
> =20
> @@ -270,6 +271,179 @@ static int ath10k_qmi_msa_ready_send_sync_msg(struc=
t ath10k_qmi *qmi)
>  	return ret;
>  }
> =20
> +int ath10k_qmi_bdf_dnld_send_sync(struct ath10k_qmi *qmi)
> +{
> +	struct wlfw_bdf_download_resp_msg_v01 *resp;
> +	struct wlfw_bdf_download_req_msg_v01 *req;
> +	const struct firmware *fw_entry;
> +	unsigned int remaining;
> +	struct qmi_txn txn;
> +	const u8 *temp;
> +	int ret;
> +
> +	req =3D kzalloc(sizeof(*req), GFP_KERNEL);
> +	if (!req)
> +		return -ENOMEM;
> +
> +	resp =3D kzalloc(sizeof(*resp), GFP_KERNEL);
> +	if (!resp) {
> +		kfree(req);
> +		return -ENOMEM;
> +	}
> +
> +	ret =3D request_firmware(&fw_entry, BDF_FILE_NAME, &qmi->pdev->dev);
> +	if (ret < 0) {
> +		pr_err("fail to load bdf: %s\n", BDF_FILE_NAME);

Do we want to use the dev_* family print functions instead?

For example:
dev_err(&qmi->pdev->dev,"fail to load bdf: %s\n", BDF_FILE_NAME);


> +		goto err_req_fw;
> +	}
> +
> +	temp =3D fw_entry->data;
> +	remaining =3D fw_entry->size;
> +
> +	pr_debug("downloading bdf: %s, size: %u\n",
> +		 BDF_FILE_NAME, remaining);
> +
> +	while (remaining) {
> +		req->valid =3D 1;
> +		req->file_id_valid =3D 1;
> +		req->file_id =3D 0;
> +		req->total_size_valid =3D 1;
> +		req->total_size =3D fw_entry->size;
> +		req->seg_id_valid =3D 1;
> +		req->data_valid =3D 1;
> +		req->end_valid =3D 1;
> +
> +		if (remaining > QMI_WLFW_MAX_DATA_SIZE_V01) {
> +			req->data_len =3D QMI_WLFW_MAX_DATA_SIZE_V01;
> +		} else {
> +			req->data_len =3D remaining;
> +			req->end =3D 1;
> +		}
> +
> +		memcpy(req->data, temp, req->data_len);
> +
> +		ret =3D qmi_txn_init(&qmi->qmi_hdl, &txn,
> +				   wlfw_bdf_download_resp_msg_v01_ei,
> +				   resp);
> +		if (ret < 0) {
> +			pr_err("fail to init txn for bdf download %d\n", ret);
> +			goto out;
> +		}
> +
> +		ret =3D
> +		qmi_send_request(&qmi->qmi_hdl, NULL, &txn,
> +				 QMI_WLFW_BDF_DOWNLOAD_REQ_V01,
> +				 WLFW_BDF_DOWNLOAD_REQ_MSG_V01_MAX_MSG_LEN,
> +				 wlfw_bdf_download_req_msg_v01_ei, req);
> +		if (ret < 0) {
> +			qmi_txn_cancel(&txn);
> +			goto err_send;
> +		}
> +
> +		ret =3D qmi_txn_wait(&txn, WLFW_TIMEOUT * HZ);
> +
> +		if (ret < 0)
> +			goto err_send;
> +
> +		if (resp->resp.result !=3D QMI_RESULT_SUCCESS_V01) {
> +			pr_err("bdf download failed, res:%d, err:%d\n",
> +			       resp->resp.result, resp->resp.error);
> +			ret =3D resp->resp.result;
> +			goto err_send;
> +		}
> +
> +		remaining -=3D req->data_len;
> +		temp +=3D req->data_len;
> +		req->seg_id++;
> +	}
> +
> +	pr_debug("bdf download request completed\n");
> +
> +	kfree(resp);
> +	kfree(req);

release_firmware(fw_entry);

I think we need to release firmware before return?

> +	return 0;
> +
> +err_send:
> +	release_firmware(fw_entry);
> +
> +err_req_fw:
> +	kfree(req);
> +	kfree(resp);
> +
> +out:
> +	return ret;
> +}

Best regards
Marcus Folkesson

--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEBVGi6LZstU1kwSxliIBOb1ldUjIFAlq4ozAACgkQiIBOb1ld
UjJTnRAAz9p9dZeHVGHVW9r8babfEbzCXxn0tE7G9cklHDhIKZzbGqlcy4ojYMz5
ZaTKaErEIe39vy/QYPU6YfhB+nJG5kCzezQ1L34fBabP/yElSWb9OHsWuALH9atY
i4ZAA/svKOwRAlUxfMVuJVWCOf7aQHBMjSnTk5rvQQUMWxbtYQDC1C8Z7K9esKK2
V6x3Fwi3k+G4zoaXKDJBoEfcOpZsONUHQjkbVHh6zTR9EqLy0I7bsEhPnoGxkiMS
nR87E1RZVug6grgiFsDF5kwrhVQkzgiP098u/BYmpm+06w74uqxpazIfNrKaqizX
OybwnUElyldUV1/NbcBjvAqjRnAdW+zUf4ePOyPMdjBu00FaV/MKAYu27g3+fqtB
U9NtJALsuUuQV3U8Xg/lYEd0WEqnKj1IwYshj5e9+i178UemvyB1S+MLVIQCSAlh
G+DQTCzR3H0umKfhcQyQPizM6klwGwYoi9vmbpvuXn4mvX+yLHeqimo+mOni/fIH
RWHitUlZU2opV1VRx4fwX8sYTIaxkFNnGHSv9UurS4FdiLsV+mbkMepShWJu76Jn
slE2vbaR97PGWtPk/O2i0Jk3QocekN6NhWMQBpSSkCCYFA7n1i2HntxaD4/3OGns
cMlTWaaavRk4sWZ7N5XtJ7Py7Gy/AGXx8o2EXwnGdtJ0aXvCFS4=
=Pzxb
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--
