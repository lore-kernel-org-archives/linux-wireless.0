Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:35810 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbbCaXRp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2015 19:17:45 -0400
Received: by wgdm6 with SMTP id m6so35474624wgd.2
        for <linux-wireless@vger.kernel.org>; Tue, 31 Mar 2015 16:17:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1427825785-21389-1-git-send-email-poh@qca.qualcomm.com>
References: <1427825785-21389-1-git-send-email-poh@qca.qualcomm.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 1 Apr 2015 10:17:24 +1100
Message-ID: <CAGRGNgUwxr34b-d_8XY86ZaLq3tJPk_xqf4t8+QnvL+rg3bV_A@mail.gmail.com> (sfid-20150401_011749_367790_5AAB9C3E)
Subject: Re: [PATCH 1/2] ath: define JP DFS patterns separated from FCC
To: Peter Oh <poh@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Peter,

Two very minor points:

On Wed, Apr 1, 2015 at 5:16 AM, Peter Oh <poh@qca.qualcomm.com> wrote:
> Separate Japan's DFS pattern from FCC to control PPB threshold.
>
> Currently all the radar detectors use the same threshold rate at
> 50%, but it's not able to achieve if data traffic rate is higher
> than 40% because WLAN baseband used by ath9k and ath10k often fails
> detecting radar pulses, so that SW cannot get enough radar reports
> to achieve the rate.
>
> Since Japan's W53 band requires 50% data traffic during its DFS
> test we need to apply different threshold rate than others on it.
> Hence define its own pattern to give flexibility to threshold rate.
>
> Signed-off-by: Peter Oh <poh@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/dfs_pattern_detector.c | 27 ++++++++++++++++---------
>  1 file changed, 17 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/dfs_pattern_detector.c b/drivers/net/wireless/ath/dfs_pattern_detector.c
> index b1de8c6..8d1e082 100644
> --- a/drivers/net/wireless/ath/dfs_pattern_detector.c
> +++ b/drivers/net/wireless/ath/dfs_pattern_detector.c
> @@ -42,6 +42,7 @@ struct radar_types {
>  /* percentage on ppb threshold to trigger detection */
>  #define MIN_PPB_THRESH 50
>  #define PPB_THRESH(PPB) ((PPB * MIN_PPB_THRESH + 50) / 100)
> +#define PPB_THRESH_JP(PPB, RATE) ((PPB * RATE + 100 - RATE) / 100)

These two PPB_THRESH defines are essentially doing the same math.

Would it make sense to define them as:

#define MIN_PPB_THRESH 50
#define PPB_THRESH_RATE(PPB, RATE) ((PPB * RATE + 100 - RATE) / 100)
#define PPB_THRESH(PPB) PPB_THRESH_RATE(PPB, MIN_PPB_THRESH)

In case some other country defines a specific rate for their DFS patterns?

>  #define PRF2PRI(PRF) ((1000000 + PRF / 2) / PRF)
>  /* percentage of pulse width tolerance */
>  #define WIDTH_TOLERANCE 5
> @@ -96,17 +97,23 @@ static const struct radar_types fcc_radar_types = {
>         .radar_types            = fcc_radar_ref_types,
>  };
>
> -#define JP_PATTERN FCC_PATTERN
> +#define JP_PATTERN(ID, WMIN, WMAX, PMIN, PMAX, PRF, PPB, RATE, CHIRP)  \
> +{                                                              \
> +       ID, WIDTH_LOWER(WMIN), WIDTH_UPPER(WMAX),               \
> +       PMIN - PRI_TOLERANCE,                                   \
> +       PMAX * PRF + PRI_TOLERANCE, PRF, PPB * PRF,             \
> +       PPB_THRESH_JP(PPB, RATE), PRI_TOLERANCE, CHIRP  \
> +}
>  static const struct radar_detector_specs jp_radar_ref_types[] = {
> -       JP_PATTERN(0, 0, 1, 1428, 1428, 1, 18, false),
> -       JP_PATTERN(1, 2, 3, 3846, 3846, 1, 18, false),
> -       JP_PATTERN(2, 0, 1, 1388, 1388, 1, 18, false),
> -       JP_PATTERN(3, 1, 2, 4000, 4000, 1, 18, false),
> -       JP_PATTERN(4, 0, 5, 150, 230, 1, 23, false),
> -       JP_PATTERN(5, 6, 10, 200, 500, 1, 16, false),
> -       JP_PATTERN(6, 11, 20, 200, 500, 1, 12, false),
> -       JP_PATTERN(7, 50, 100, 1000, 2000, 1, 20, false),
> -       JP_PATTERN(5, 0, 1, 333, 333, 1, 9, false),
> +       JP_PATTERN(0, 0, 1, 1428, 1428, 1, 18, 50, false),
> +       JP_PATTERN(1, 2, 3, 3846, 3846, 1, 18, 50, false),
> +       JP_PATTERN(2, 0, 1, 1388, 1388, 1, 18, 50, false),
> +       JP_PATTERN(3, 1, 2, 4000, 4000, 1, 18, 50, false),
> +       JP_PATTERN(4, 0, 5, 150, 230, 1, 23, 50, false),
> +       JP_PATTERN(5, 6, 10, 200, 500, 1, 16, 50, false),
> +       JP_PATTERN(6, 11, 20, 200, 500, 1, 12, 50, false),
> +       JP_PATTERN(7, 50, 100, 1000, 2000, 1, 20, 50, false),
> +       JP_PATTERN(5, 0, 1, 333, 333, 1, 9, 50, false),

If no JP patterns will have CHIRP set, would it make sense to embed
that parameter into the define?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
