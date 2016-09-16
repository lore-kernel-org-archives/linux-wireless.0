Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:7404 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755647AbcIPWhm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Sep 2016 18:37:42 -0400
From: "Hsu, Ryan" <ryanhsu@qca.qualcomm.com>
To: "michal.kazior@tieto.com" <michal.kazior@tieto.com>,
        "Valo, Kalle" <kvalo@qca.qualcomm.com>
CC: "marek.puzyniak@tieto.com" <marek.puzyniak@tieto.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH 4/4] ath10k: fix spurious tx/rx during boot
Date: Fri, 16 Sep 2016 22:37:38 +0000
Message-ID: <57DC735D.8020307@qca.qualcomm.com> (sfid-20160917_003746_876359_94082877)
References: <1468924452-23877-1-git-send-email-michal.kazior@tieto.com>
 <1468924452-23877-5-git-send-email-michal.kazior@tieto.com>
In-Reply-To: <1468924452-23877-5-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="Windows-1252"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 07/19/2016 03:34 AM, Michal Kazior wrote:
>  =20
> +static int ath10k_core_reset_rx_filter(struct ath10k *ar)
> +{
> +	int ret;
> +	int vdev_id;
> +	int vdev_type;
> +	int vdev_subtype;
> +	const u8 *vdev_addr;
> +
> +	vdev_id =3D 0;
> +	vdev_type =3D WMI_VDEV_TYPE_STA;
> +	vdev_subtype =3D ath10k_wmi_get_vdev_subtype(ar, WMI_VDEV_SUBTYPE_NONE)=
;
> +	vdev_addr =3D ar->mac_addr;
> +
> +	ret =3D ath10k_wmi_vdev_create(ar, vdev_id, vdev_type, vdev_subtype,
> +				     vdev_addr);
> +	if (ret) {
> +		ath10k_err(ar, "failed to create dummy vdev: %d\n", ret);
> +		return ret;
> +	}
> +
> +	ret =3D ath10k_wmi_vdev_delete(ar, vdev_id);
> +	if (ret) {
> +		ath10k_err(ar, "failed to delete dummy vdev: %d\n", ret);
> +		return ret;
> +	}
> +
> +	/* WMI and HTT may use separate HIF pipes and are not guaranteed to be
> +	 * serialized properly implicitly.
> +	 *
> +	 * Moreover (most) WMI commands have no explicit acknowledges. It is
> +	 * possible to infer it implicitly by poking firmware with echo
> +	 * command - getting a reply means all preceding comments have been
> +	 * (mostly) processed.
> +	 *
> +	 * In case of vdev create/delete this is sufficient.
> +	 *
> +	 * Without this it's possible to end up with a race when HTT Rx ring is
> +	 * started before vdev create/delete hack is complete allowing a short
> +	 * window of opportunity to receive (and Tx ACK) a bunch of frames.
> +	 */
> +	ret =3D ath10k_wmi_barrier(ar);
QCA6174 UTF firmware seems doesn't support the WMI_ECHO command.

[16460.274822] ath10k_pci 0000:04:00.0: wmi tlv echo value 0x0ba991e9
...
[16463.461970] ath10k_pci 0000:04:00.0: failed to ping firmware: -110
[16463.461975] ath10k_pci 0000:04:00.0: failed to reset rx filter: -110

Has anyone verified any AP solution to see if UTF mode is still working=20
with after this patch?

Anyway, I would like to exclude the workaround from all solution's UTF mode=
.

Michal any concerns? (or maybe just for QCA61x4 if any...)

> +	if (ret) {
> +		ath10k_err(ar, "failed to ping firmware: %d\n", ret);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
>
