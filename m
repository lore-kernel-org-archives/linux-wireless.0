Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:61563 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932236AbcIBPpP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Sep 2016 11:45:15 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Colin King <colin.king@canonical.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix memory leak on caldata on error exit path
Date: Fri, 2 Sep 2016 15:45:09 +0000
Message-ID: <87r392z4ox.fsf@kamboji.qca.qualcomm.com> (sfid-20160902_174537_447156_824A0653)
References: <1471268785-11576-1-git-send-email-colin.king@canonical.com>
In-Reply-To: <1471268785-11576-1-git-send-email-colin.king@canonical.com>
        (Colin King's message of "Mon, 15 Aug 2016 14:46:25 +0100")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Colin King <colin.king@canonical.com> writes:

> From: Colin Ian King <colin.king@canonical.com>
>
> caldata is not being free'd on the error exit path, causing
> a memory leak. kfree it to fix the leak.
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/wireless/ath/ath10k/pci.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless=
/ath/ath10k/pci.c
> index 9a22c47..886337c 100644
> --- a/drivers/net/wireless/ath/ath10k/pci.c
> +++ b/drivers/net/wireless/ath/ath10k/pci.c
> @@ -2725,6 +2725,7 @@ static int ath10k_pci_hif_fetch_cal_eeprom(struct a=
th10k *ar, void **data,
>  	return 0;
> =20
>  err_free:
> +	kfree(caldata);
>  	kfree(data);
> =20
>  	return -EINVAL;

I don't think we should free data at all:

static int ath10k_download_cal_eeprom(struct ath10k *ar)
{
	size_t data_len;
	void *data =3D NULL;
	int ret;

	ret =3D ath10k_hif_fetch_cal_eeprom(ar, &data, &data_len);

Instead we should free only caldata, right?

--=20
Kalle Valo=
