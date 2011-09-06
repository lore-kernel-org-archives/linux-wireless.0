Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:9487 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960Ab1IFQeF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Sep 2011 12:34:05 -0400
Received: from hpaq11.eem.corp.google.com (hpaq11.eem.corp.google.com [172.25.149.11])
	by smtp-out.google.com with ESMTP id p86GXruU023730
	for <linux-wireless@vger.kernel.org>; Tue, 6 Sep 2011 09:33:53 -0700
Received: from iage36 (iage36.prod.google.com [10.12.207.36])
	by hpaq11.eem.corp.google.com with ESMTP id p86GWbVu025363
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 6 Sep 2011 09:33:52 -0700
Received: by iage36 with SMTP id e36so9712338iag.37
        for <linux-wireless@vger.kernel.org>; Tue, 06 Sep 2011 09:33:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1315326591-2938-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1315326591-2938-1-git-send-email-rmanohar@qca.qualcomm.com>
Date: Tue, 6 Sep 2011 09:31:53 -0700
Message-ID: <CAMcMvsjhaJu3XL2zZLt8kLWwExA9e7dfLkFN3bjF3q3S75u3Bw@mail.gmail.com> (sfid-20110906_183412_314813_CDD99AE5)
Subject: Re: [PATCH v2] ath9k_hw: Fix magnitude/phase average in TxIQ Calibration
From: Paul Stewart <pstew@google.com>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Kai Shi <kaishi@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 6, 2011 at 9:29 AM, Rajkumar Manoharan
<rmanohar@qca.qualcomm.com> wrote:
> The commit "ath9k_hw: Fix Tx IQ Calibration hang issue in
> AR9003 chips" did not consider more than one potential sample
> while calculating magnitude/phase average if more than one
> sample has the same value which could affect post-processing
> of outlier detection that causes an undesirable Tx IQ
> correction value will be assigned to tx gain settings where
> outlier happens.
>
> Cc: Kai Shi <kaishi@qca.qualcomm.com>
> Reported-by: Paul Stewart <pstew@google.com>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>

Signed-off-by: Paul Stewart <pstew@google.com>
> ---
>  drivers/net/wireless/ath/ath9k/ar9003_calib.c |   17 +++++++++++++----
>  1 files changed, 13 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
> index ee3a8a2..695d9d3 100644
> --- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
> +++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
> @@ -615,11 +615,10 @@ static void ar9003_hw_detect_outlier(int *mp_coeff, int nmeasurement,
>  {
>        int mp_max = -64, max_idx = 0;
>        int mp_min = 63, min_idx = 0;
> -       int mp_avg = 0, i, outlier_idx = 0;
> +       int mp_avg = 0, i, outlier_idx = 0, mp_count = 0;
>
>        /* find min/max mismatch across all calibrated gains */
>        for (i = 0; i < nmeasurement; i++) {
> -               mp_avg += mp_coeff[i];
>                if (mp_coeff[i] > mp_max) {
>                        mp_max = mp_coeff[i];
>                        max_idx = i;
> @@ -632,10 +631,20 @@ static void ar9003_hw_detect_outlier(int *mp_coeff, int nmeasurement,
>        /* find average (exclude max abs value) */
>        for (i = 0; i < nmeasurement; i++) {
>                if ((abs(mp_coeff[i]) < abs(mp_max)) ||
> -                   (abs(mp_coeff[i]) < abs(mp_min)))
> +                   (abs(mp_coeff[i]) < abs(mp_min))) {
>                        mp_avg += mp_coeff[i];
> +                       mp_count++;
> +               }
>        }
> -       mp_avg /= (nmeasurement - 1);
> +
> +       /*
> +        * finding mean magnitude/phase if possible, otherwise
> +        * just use the last value as the mean
> +        */
> +       if (mp_count)
> +               mp_avg /= mp_count;
> +       else
> +               mp_avg = mp_coeff[nmeasurement - 1];
>
>        /* detect outlier */
>        if (abs(mp_max - mp_min) > max_delta) {
> --
> 1.7.6.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
