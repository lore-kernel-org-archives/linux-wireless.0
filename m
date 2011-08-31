Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:9469 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756570Ab1HaWQ1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 18:16:27 -0400
Received: from hpaq11.eem.corp.google.com (hpaq11.eem.corp.google.com [172.25.149.11])
	by smtp-out.google.com with ESMTP id p7VMGO9Y012610
	for <linux-wireless@vger.kernel.org>; Wed, 31 Aug 2011 15:16:24 -0700
Received: from iagv1 (iagv1.prod.google.com [10.12.223.1])
	by hpaq11.eem.corp.google.com with ESMTP id p7VMGBpF008910
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 31 Aug 2011 15:16:22 -0700
Received: by iagv1 with SMTP id v1so1600723iag.14
        for <linux-wireless@vger.kernel.org>; Wed, 31 Aug 2011 15:16:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1303464039-11574-1-git-send-email-rmanoharan@atheros.com>
References: <1303464039-11574-1-git-send-email-rmanoharan@atheros.com>
Date: Wed, 31 Aug 2011 15:16:22 -0700
Message-ID: <CAMcMvsgrjRFC9pwr_tJLuSfF8N68GUAATmcnkkKgDUx+ufYvuQ@mail.gmail.com> (sfid-20110901_001631_372292_0F601294)
Subject: Re: [PATCH 1/2] ath9k_hw: Fix Tx IQ Calibration hang issue in AR9003 chips
From: Paul Stewart <pstew@google.com>
To: Rajkumar Manoharan <rmanoharan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 22, 2011 at 2:20 AM, Rajkumar Manoharan
<rmanoharan@atheros.com> wrote:
> On AR9003 chips, doing three IQ calibrations will possibly cause chip
> in stuck state. In noisy environment, chip could receive
> a packet during the middle of three calibrations and it causes
> the conflict of HW access and the eventual failure. It also
> causes IQ calibration outliers which results in poor Tx EVM.
[...]
> +       /* find min/max mismatch across all calibrated gains */
> +       for (i = 0; i < nmeasurement; i++) {
> +               mp_avg += mp_coeff[i];
> +               if (mp_coeff[i] > mp_max) {
> +                       mp_max = mp_coeff[i];
> +                       max_idx = i;
> +               } else if (mp_coeff[i] < mp_min) {
> +                       mp_min = mp_coeff[i];
> +                       min_idx = i;
> +               }
> +       }
>
> -       if (diff[0] <= diff[1] && diff[0] <= diff[2])
> -               *mp_avg = (mp_coeff[0] + mp_coeff[1]) / 2;
> -       else if (diff[1] <= diff[2])
> -               *mp_avg = (mp_coeff[1] + mp_coeff[2]) / 2;
> -       else
> -               *mp_avg = (mp_coeff[2] + mp_coeff[0]) / 2;
> +       /* find average (exclude max abs value) */
> +       for (i = 0; i < nmeasurement; i++) {
> +               if ((abs(mp_coeff[i]) < abs(mp_max)) ||
> +                   (abs(mp_coeff[i]) < abs(mp_min)))
Doesn't this potentially throw away more than one potential sample
from your mp_avg sum if more than one value has the same (maximal
absolute) value?  You don't account for it below since you divide by
(nmeasurement - 1) so your average can get arbitrarily smaller than
you intended, which may false-trigger your outlier detection.
> +                       mp_avg += mp_coeff[i];
> +       }
> +       mp_avg /= (nmeasurement - 1);
>
> -       return true;
> +       /* detect outlier */
> +       if (abs(mp_max - mp_min) > max_delta) {
> +               if (abs(mp_max - mp_avg) > abs(mp_min - mp_avg))
> +                       outlier_idx = max_idx;
> +               else
> +                       outlier_idx = min_idx;
> +       }
> +       mp_coeff[outlier_idx] = mp_avg;
>  }
