Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:51225 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862Ab1IFPnq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Sep 2011 11:43:46 -0400
Received: from wpaz33.hot.corp.google.com (wpaz33.hot.corp.google.com [172.24.198.97])
	by smtp-out.google.com with ESMTP id p86Fhhul011735
	for <linux-wireless@vger.kernel.org>; Tue, 6 Sep 2011 08:43:43 -0700
Received: from iakc1 (iakc1.prod.google.com [10.13.50.1])
	by wpaz33.hot.corp.google.com with ESMTP id p86FhgLi012194
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 6 Sep 2011 08:43:42 -0700
Received: by iakc1 with SMTP id c1so7644356iak.3
        for <linux-wireless@vger.kernel.org>; Tue, 06 Sep 2011 08:43:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1315320602-2815-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1315320602-2815-1-git-send-email-rmanohar@qca.qualcomm.com>
Date: Tue, 6 Sep 2011 08:43:42 -0700
Message-ID: <CAMcMvsgm=HYb+KEz9=15w=xL2BESfwZiQgvXru2uUiQZvYqULA@mail.gmail.com> (sfid-20110906_174350_269535_B8487340)
Subject: Re: [PATCH] ath9k_hw: Fix magnitude/phase average in TxIQ Calibration
From: Paul Stewart <pstew@google.com>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Kai Shi <kaishi@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Rajkumar,

On Tue, Sep 6, 2011 at 7:50 AM, Rajkumar Manoharan
<rmanohar@qca.qualcomm.com> wrote:
> The commit "ath9k_hw: Fix Tx IQ Calibration hang issue in
> AR9003 chips" did not consider more than one potential sample
> while calculating magnitude/phase average if more than one
> sample has the same value which could affect post-processing
> of outlier detection that causes an undesirable Tx IQ
> correction value will be assigned to tx gain settings where
> outlier happens.
>
[...]

> +       /*
> +        * finding mean magnitude/phase if possible, otherwise
> +        * just use the last value as the mean
> +        */
> +       if (mp_count)
> +               mp_avg /= mp_count;
> +       else
> +               mp_avg = mp_coeff[i - 1];

Why use "i - 1" here instead of "nmeasurement - 1"?  Seems more
error-prone for later changes and harder to understand.

--
Paul
