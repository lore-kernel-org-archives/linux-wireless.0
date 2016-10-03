Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:15623 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750890AbcJCHrD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Oct 2016 03:47:03 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Marty Faltesek <mfaltesek@google.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: cache calibration data when the core is stopped.
Date: Mon, 3 Oct 2016 07:46:54 +0000
Message-ID: <87fuodswlu.fsf@kamboji.qca.qualcomm.com> (sfid-20161003_094707_584259_35D160FA)
References: <1473801118-103112-1-git-send-email-mfaltesek@google.com>
In-Reply-To: <1473801118-103112-1-git-send-email-mfaltesek@google.com> (Marty
        Faltesek's message of "Tue, 13 Sep 2016 17:11:58 -0400")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Marty Faltesek <mfaltesek@google.com> writes:

> Caching calibration data allows it to be accessed when the
> device is not active.
>
> Signed-off-by: Marty Faltesek <mfaltesek@google.com>

No comma in the title, please.

What tree did you use as the baseline? This doesn't seem to apply to
ath.git:

Applying: ath10k: cache calibration data when the core is stopped.
fatal: sha1 information is lacking or useless (drivers/net/wireless/ath/ath=
10k/core.c).
Repository lacks necessary blobs to fall back on 3-way merge.
Cannot fall back to three-way merge.
Patch failed at 0001 ath10k: cache calibration data when the core is stoppe=
d.

> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -1227,6 +1227,42 @@ success:
>  	return 0;
>  }
> =20
> +int
> +ath10k_cal_data_alloc(struct ath10k *ar, void **buf)
> +{
> +	u32 hi_addr;
> +	__le32 addr;
> +	int ret;

I think this function should be in debug.c. That way the code is not
wasting memory if DEBUGFS is disabled.=20

> +	vfree(*buf);
> +	*buf =3D vmalloc(QCA988X_CAL_DATA_LEN);
> +	if (!*buf) {
> +		return -EAGAIN;
> +	}

Is it really necessary to allocate memory every time? What if allocate
it only once when module is loaded, just like with
ar->debug.fw_crash_data?

Also please note that this patch (which I'm queuing to 4.9) touches the
same area:

ath10k: fix debug cal data file

https://patchwork.kernel.org/patch/9340953/

> +	hi_addr =3D host_interest_item_address(HI_ITEM(hi_board_data));
> +
> +	ret =3D ath10k_hif_diag_read(ar, hi_addr, &addr, sizeof(addr));
> +
> +	if (ret) {
> +		ath10k_warn(ar, "failed to read hi_board_data address: %d\n", ret);
> +	} else {
> +		ret =3D ath10k_hif_diag_read(ar, le32_to_cpu(addr), *buf,
> +					   QCA988X_CAL_DATA_LEN);
> +		if (ret) {
> +			ath10k_warn(ar, "failed to read calibration data: %d\n", ret);
> +		}
> +	}

We try to avoid using else branches so that only error handling is
indented and the main code flow is not.

> +	/*
> +	 * We are up now, so no need to cache calibration data.
> +	 */
> +	vfree(ar->cal_data);
> +        ar->cal_data =3D NULL;

Indentation looks wrongs here.

> @@ -1757,6 +1799,11 @@ void ath10k_core_stop(struct ath10k *ar)
>  	lockdep_assert_held(&ar->conf_mutex);
>  	ath10k_debug_stop(ar);
> =20
> +	/*
> +	 * Cache caclibration data while stopped.
> +	 */
> +	ath10k_cal_data_alloc(ar, &ar->cal_data);

I like the idea that the calibration data is copied during stop(), but
can you do this from debug.c? For example, add ath10k_debug_stop() and
call it from there? I don't think any of this should be in core.c.

--=20
Kalle Valo=
