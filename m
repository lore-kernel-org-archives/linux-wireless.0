Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51199 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbbBLVaV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Feb 2015 16:30:21 -0500
Message-ID: <54DD1B18.8030803@codeaurora.org> (sfid-20150212_223024_647870_B3775E5A)
Date: Thu, 12 Feb 2015 13:28:56 -0800
From: Peter Oh <poh@codeaurora.org>
MIME-Version: 1.0
To: Peter Oh <poh@qca.qualcomm.com>, ath10k@lists.infradead.org
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/3] ath: Introduce chirp parameter used by DFS
References: <1423775825-19498-1-git-send-email-poh@qca.qualcomm.com>
In-Reply-To: <1423775825-19498-1-git-send-email-poh@qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 02/12/2015 01:17 PM, Peter Oh wrote:
> Some of radar types such as FCC radar type 5 require
> to look up chirp in pulse to detect genuine radar and
> it will prevent DFS channels from false radar detection.
>
> Signed-off-by: Peter Oh <poh@qca.qualcomm.com>
> ---
>   drivers/net/wireless/ath/dfs_pattern_detector.c | 52
> ++++++++++++-------------
>   drivers/net/wireless/ath/dfs_pattern_detector.h |  4 ++
>   2 files changed, 30 insertions(+), 26 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/dfs_pattern_detector.c
> b/drivers/net/wireless/ath/dfs_pattern_detector.c
> index 3d57f87..b1de8c6 100644
> --- a/drivers/net/wireless/ath/dfs_pattern_detector.c
> +++ b/drivers/net/wireless/ath/dfs_pattern_detector.c
> @@ -48,23 +48,23 @@ struct radar_types {
>   #define WIDTH_LOWER(X) ((X*(100-WIDTH_TOLERANCE)+50)/100)
>   #define WIDTH_UPPER(X) ((X*(100+WIDTH_TOLERANCE)+50)/100)
>   
> -#define ETSI_PATTERN(ID, WMIN, WMAX, PMIN, PMAX, PRF, PPB)	\
> +#define ETSI_PATTERN(ID, WMIN, WMAX, PMIN, PMAX, PRF, PPB, CHIRP)	\
>   {								\
>   	ID, WIDTH_LOWER(WMIN), WIDTH_UPPER(WMAX),		\
>   	(PRF2PRI(PMAX) - PRI_TOLERANCE),			\
>   	(PRF2PRI(PMIN) * PRF + PRI_TOLERANCE), PRF, PPB * PRF,	\
> -	PPB_THRESH(PPB), PRI_TOLERANCE,				\
> +	PPB_THRESH(PPB), PRI_TOLERANCE,	CHIRP			\
>   }
>   
>   /* radar types as defined by ETSI EN-301-893 v1.5.1 */
>   static const struct radar_detector_specs etsi_radar_ref_types_v15[] = {
> -	ETSI_PATTERN(0,  0,  1,  700,  700, 1, 18),
> -	ETSI_PATTERN(1,  0,  5,  200, 1000, 1, 10),
> -	ETSI_PATTERN(2,  0, 15,  200, 1600, 1, 15),
> -	ETSI_PATTERN(3,  0, 15, 2300, 4000, 1, 25),
> -	ETSI_PATTERN(4, 20, 30, 2000, 4000, 1, 20),
> -	ETSI_PATTERN(5,  0,  2,  300,  400, 3, 10),
> -	ETSI_PATTERN(6,  0,  2,  400, 1200, 3, 15),
> +	ETSI_PATTERN(0,  0,  1,  700,  700, 1, 18, false),
> +	ETSI_PATTERN(1,  0,  5,  200, 1000, 1, 10, false),
> +	ETSI_PATTERN(2,  0, 15,  200, 1600, 1, 15, false),
> +	ETSI_PATTERN(3,  0, 15, 2300, 4000, 1, 25, false),
> +	ETSI_PATTERN(4, 20, 30, 2000, 4000, 1, 20, false),
> +	ETSI_PATTERN(5,  0,  2,  300,  400, 3, 10, false),
> +	ETSI_PATTERN(6,  0,  2,  400, 1200, 3, 15, false),
>   };
>   
>   static const struct radar_types etsi_radar_types_v15 = {
> @@ -73,21 +73,21 @@ static const struct radar_types etsi_radar_types_v15 =
> {
>   	.radar_types		= etsi_radar_ref_types_v15,
>   };
>   
> -#define FCC_PATTERN(ID, WMIN, WMAX, PMIN, PMAX, PRF, PPB)	\
> +#define FCC_PATTERN(ID, WMIN, WMAX, PMIN, PMAX, PRF, PPB, CHIRP)	\
>   {								\
>   	ID, WIDTH_LOWER(WMIN), WIDTH_UPPER(WMAX),		\
>   	PMIN - PRI_TOLERANCE,					\
>   	PMAX * PRF + PRI_TOLERANCE, PRF, PPB * PRF,		\
> -	PPB_THRESH(PPB), PRI_TOLERANCE,				\
> +	PPB_THRESH(PPB), PRI_TOLERANCE,	CHIRP			\
>   }
>   
>   static const struct radar_detector_specs fcc_radar_ref_types[] = {
> -	FCC_PATTERN(0, 0, 1, 1428, 1428, 1, 18),
> -	FCC_PATTERN(1, 0, 5, 150, 230, 1, 23),
> -	FCC_PATTERN(2, 6, 10, 200, 500, 1, 16),
> -	FCC_PATTERN(3, 11, 20, 200, 500, 1, 12),
> -	FCC_PATTERN(4, 50, 100, 1000, 2000, 1, 1),
> -	FCC_PATTERN(5, 0, 1, 333, 333, 1, 9),
> +	FCC_PATTERN(0, 0, 1, 1428, 1428, 1, 18, false),
> +	FCC_PATTERN(1, 0, 5, 150, 230, 1, 23, false),
> +	FCC_PATTERN(2, 6, 10, 200, 500, 1, 16, false),
> +	FCC_PATTERN(3, 11, 20, 200, 500, 1, 12, false),
> +	FCC_PATTERN(4, 50, 100, 1000, 2000, 1, 1, true),
> +	FCC_PATTERN(5, 0, 1, 333, 333, 1, 9, false),
>   };
>   
>   static const struct radar_types fcc_radar_types = {
> @@ -98,15 +98,15 @@ static const struct radar_types fcc_radar_types = {
>   
>   #define JP_PATTERN FCC_PATTERN
>   static const struct radar_detector_specs jp_radar_ref_types[] = {
> -	JP_PATTERN(0, 0, 1, 1428, 1428, 1, 18),
> -	JP_PATTERN(1, 2, 3, 3846, 3846, 1, 18),
> -	JP_PATTERN(2, 0, 1, 1388, 1388, 1, 18),
> -	JP_PATTERN(3, 1, 2, 4000, 4000, 1, 18),
> -	JP_PATTERN(4, 0, 5, 150, 230, 1, 23),
> -	JP_PATTERN(5, 6, 10, 200, 500, 1, 16),
> -	JP_PATTERN(6, 11, 20, 200, 500, 1, 12),
> -	JP_PATTERN(7, 50, 100, 1000, 2000, 1, 20),
> -	JP_PATTERN(5, 0, 1, 333, 333, 1, 9),
> +	JP_PATTERN(0, 0, 1, 1428, 1428, 1, 18, false),
> +	JP_PATTERN(1, 2, 3, 3846, 3846, 1, 18, false),
> +	JP_PATTERN(2, 0, 1, 1388, 1388, 1, 18, false),
> +	JP_PATTERN(3, 1, 2, 4000, 4000, 1, 18, false),
> +	JP_PATTERN(4, 0, 5, 150, 230, 1, 23, false),
> +	JP_PATTERN(5, 6, 10, 200, 500, 1, 16, false),
> +	JP_PATTERN(6, 11, 20, 200, 500, 1, 12, false),
> +	JP_PATTERN(7, 50, 100, 1000, 2000, 1, 20, false),
> +	JP_PATTERN(5, 0, 1, 333, 333, 1, 9, false),
>   };
>   
>   static const struct radar_types jp_radar_types = {
> diff --git a/drivers/net/wireless/ath/dfs_pattern_detector.h
> b/drivers/net/wireless/ath/dfs_pattern_detector.h
> index dde2652..25a43d6 100644
> --- a/drivers/net/wireless/ath/dfs_pattern_detector.h
> +++ b/drivers/net/wireless/ath/dfs_pattern_detector.h
> @@ -40,12 +40,14 @@ struct ath_dfs_pool_stats {
>    * @freq: channel frequency in MHz
>    * @width: pulse duration in us
>    * @rssi: rssi of radar event
> + * @chirp: chirp detected in pulse
>    */
>   struct pulse_event {
>   	u64 ts;
>   	u16 freq;
>   	u8 width;
>   	u8 rssi;
> +	bool chirp;
>   };
>   
>   /**
> @@ -59,6 +61,7 @@ struct pulse_event {
>    * @ppb: pulses per bursts for this type
>    * @ppb_thresh: number of pulses required to trigger detection
>    * @max_pri_tolerance: pulse time stamp tolerance on both sides [us]
> + * @chirp: chirp required for the radar pattern
>    */
>   struct radar_detector_specs {
>   	u8 type_id;
> @@ -70,6 +73,7 @@ struct radar_detector_specs {
>   	u8 ppb;
>   	u8 ppb_thresh;
>   	u8 max_pri_tolerance;
> +	bool chirp;
Chirp is also used by Japan and ETSI, but need more test and analysis to 
use on them, so they're not enabled at this moment, but should be good 
to have architecturally.
>   };
>   
>   /**
Regards,
Peter
