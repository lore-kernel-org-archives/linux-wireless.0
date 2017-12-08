Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:48817 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752905AbdLHJ16 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Dec 2017 04:27:58 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Sven Eckelmann <sven.eckelmann@openmesh.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "ext.waldemar.rymarkiewicz@tieto.com"
        <ext.waldemar.rymarkiewicz@tieto.com>
Subject: Re: [PATCH 2/2] ath10k: search DT for qcom,ath10k-calibration-variant
Date: Fri, 8 Dec 2017 09:27:52 +0000
Message-ID: <87fu8ltvqg.fsf@kamboji.qca.qualcomm.com> (sfid-20171208_102821_602774_0B175A48)
References: <20170310080615.22958-1-sven.eckelmann@openmesh.com>
        <20170310080615.22958-2-sven.eckelmann@openmesh.com>
In-Reply-To: <20170310080615.22958-2-sven.eckelmann@openmesh.com> (Sven
        Eckelmann's message of "Fri, 10 Mar 2017 09:06:15 +0100")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sven Eckelmann <sven.eckelmann@openmesh.com> writes:

> Board Data File (BDF) is loaded upon driver boot-up procedure. The right
> board data file is identified on QCA4019 using bus, bmi-chip-id and
> bmi-board-id.
>
> The problem, however, can occur when the (default) board data file cannot
> fulfill with the vendor requirements and it is necessary to use a differe=
nt
> board data file.
>
> This problem was solved for SMBIOS by adding a special SMBIOS type 0xF8.
> Something similar has to be provided for systems without SMBIOS but with
> device trees. No solution was specified by QCA and therefore a new one ha=
s
> to be found for ath10k.
>
> The device tree requires addition strings to define the variant name
>
>     wifi@a000000 {
>     	status =3D "okay";
>     	qcom,ath10k-calibration-variant =3D "RT-AC58U";
>     };
>
>     wifi@a800000 {
>     	status =3D "okay";
>     	qcom,ath10k-calibration-variant =3D "RT-AC58U";
>     };
>
> This would create the boarddata identifiers for the board-2.bin search
>
>  *  bus=3Dahb,bmi-chip-id=3D0,bmi-board-id=3D16,variant=3DRT-AC58U
>  *  bus=3Dahb,bmi-chip-id=3D0,bmi-board-id=3D17,variant=3DRT-AC58U
>
> Signed-off-by: Sven Eckelmann <sven.eckelmann@openmesh.com>
> ---
> Since RFC:
>
>  - initialize variant pointer to have it initialized to NULL when
>    of_property_read_string fails (thanks Christian Lamparter)
>  - Only print warning that DT doesn't contain string ones (thanks Christi=
an
>    Lamparter)
>  - Split patch in DT doc and ath10k part (thanks Christian Lamparter)
>  - Allow to overwrite the variant string via DT and ignore that SMBIOS ha=
d
>    written anything to it

[...]

> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -779,6 +779,25 @@ static int ath10k_core_check_smbios(struct ath10k *a=
r)
>  	return 0;
>  }
> =20
> +static int ath10k_core_check_dt(struct ath10k *ar)
> +{
> +	struct device_node *node;
> +	const char *variant =3D NULL;
> +
> +	node =3D ar->dev->of_node;
> +	if (!node)
> +		return -ENOENT;
> +
> +	of_property_read_string(node, "qcom,ath10k-calibration-variant",
> +				&variant);
> +	if (!variant)
> +		return -ENODATA;
> +
> +	strscpy(ar->id.bdf_ext, variant, sizeof(ar->id.bdf_ext));

Kbuild bot found a warning here:

   drivers/net/wireless/ath/ath10k/core.c: In function 'ath10k_core_check_d=
t':
>> drivers/net/wireless/ath/ath10k/core.c:877:2: warning: ignoring return v=
alue of 'strscpy', declared with attribute warn_unused_result [-Wunused-res=
ult]
     strscpy(ar->id.bdf_ext, variant, sizeof(ar->id.bdf_ext));
     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

I guess warn_unused_result in strscpy() is a recent addition and that's
why you didn't see it.

--=20
Kalle Valo=
