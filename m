Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:55220 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729924AbeGMRbi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jul 2018 13:31:38 -0400
Subject: Re: [PATCH v2 1/3] ath10k: Add ath10k-ct firmware feature flags and
 descriptions.
To: ath10k@lists.infradead.org
References: <1526313137-23899-1-git-send-email-greearb@candelatech.com>
Cc: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org
From: Ben Greear <greearb@candelatech.com>
Message-ID: <ff36114f-6ac1-56cb-538b-1a2fa1e9a862@candelatech.com> (sfid-20180713_191609_967744_DB12FBC3)
Date: Fri, 13 Jul 2018 10:16:04 -0700
MIME-Version: 1.0
In-Reply-To: <1526313137-23899-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/14/2018 08:52 AM, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
>
> These feature flags are used by ath10k-ct firmware.  Add these
> so we can use them in future patches and so there are no warnings
> about feature flags on loading ath10k-ct firmware.

Hello Kalle,

Any chance you could apply this series?  It has been sitting in patchwork in
new state with no feedback for months (last I checked).

I've plenty more patches after this to provide better support for my
firmware, and some of it will probably also be useful for stock firmware.

If I can get these initial patches in, I'll cook up some more and post
them.

Thanks,
Ben

>
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
> v2:  Fix warings typo in description.
>
>  drivers/net/wireless/ath/ath10k/core.c | 17 +++++++++
>  drivers/net/wireless/ath/ath10k/core.h | 67 ++++++++++++++++++++++++++++++++++
>  2 files changed, 84 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
> index 4cf54a7..f2f8f61 100644
> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -552,6 +552,23 @@ static const char *const ath10k_core_fw_feature_str[] = {
>  	[ATH10K_FW_FEATURE_NO_PS] = "no-ps",
>  	[ATH10K_FW_FEATURE_MGMT_TX_BY_REF] = "mgmt-tx-by-reference",
>  	[ATH10K_FW_FEATURE_NON_BMI] = "non-bmi",
> +	[ATH10K_FW_FEATURE_WMI_10X_CT] = "wmi-10.x-CT",
> +	[ATH10K_FW_FEATURE_CT_RXSWCRYPT] = "rxswcrypt-CT",
> +	[ATH10K_FW_FEATURE_HAS_TXSTATUS_NOACK] = "txstatus-noack",
> +	[ATH10K_FW_FEATURE_CT_RATEMASK] = "ratemask-CT",
> +	[ATH10K_FW_FEATURE_HAS_SAFE_BURST] = "safe-burst",
> +	[ATH10K_FW_FEATURE_REGDUMP_CT] = "regdump-CT",
> +	[ATH10K_FW_FEATURE_TXRATE_CT] = "txrate-CT",
> +	[ATH10K_FW_FEATURE_FLUSH_ALL_CT] = "flush-all-CT",
> +	[ATH10K_FW_FEATURE_PINGPONG_READ_CT] = "pingpong-CT",
> +	[ATH10K_FW_FEATURE_SKIP_CH_RES_CT] = "ch-regs-CT",
> +	[ATH10K_FW_FEATURE_NOP_CT] = "nop-CT",
> +	[ATH10K_FW_FEATURE_HTT_MGT_CT] = "htt-mgt-CT",
> +	[ATH10K_FW_FEATURE_SET_SPECIAL_CT] = "set-special-CT",
> +	[ATH10K_FW_FEATURE_NO_BMISS_CT] = "no-bmiss-CT",
> +	[ATH10K_FW_FEATURE_HAS_GET_TEMP_CT] = "get-temp-CT",
> +	[ATH10K_FW_FEATURE_HAS_TX_RC_CT] = "tx-rc-CT",
> +	[ATH10K_FW_FEATURE_CUST_STATS_CT] = "cust-stats-CT",
>  };
>
>  static unsigned int ath10k_core_get_fw_feature_str(char *buf,
> diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
> index e4ac8f2..c1342c5 100644
> --- a/drivers/net/wireless/ath/ath10k/core.h
> +++ b/drivers/net/wireless/ath/ath10k/core.h
> @@ -711,6 +711,73 @@ enum ath10k_fw_features {
>  	/* Firmware load is done externally, not by bmi */
>  	ATH10K_FW_FEATURE_NON_BMI = 19,
>
> +	/* tx-status has the noack bits (CT firmware version 14 and higher ) */
> +	ATH10K_FW_FEATURE_HAS_TXSTATUS_NOACK = 30,
> +
> +	/* Firmware from Candela Technologies, enables more VIFs, etc */
> +	ATH10K_FW_FEATURE_WMI_10X_CT = 31,
> +
> +	/* Firmware from Candela Technologies with rx-software-crypt.
> +	 * Required for multiple stations connected to same AP when using
> +	 * encryption (ie, commercial version of CT firmware)
> +	 */
> +	ATH10K_FW_FEATURE_CT_RXSWCRYPT = 32,
> +
> +	/* Firmware supports extended wmi_common_peer_assoc_complete_cmd that
> +	 * contains an array of rate-disable masks.  This allows the host to
> +	 * have better control over what rates the firmware will use.  CT
> +	 * Firmware only (v15 and higher)
> +	 */
> +	ATH10K_FW_FEATURE_CT_RATEMASK = 33,
> +
> +	/* Versions of firmware before approximately 10.2.4.72 would corrupt
> +	 * txop fields during burst.  Since this is fixed now, add a flag to
> +	 * denote this.
> +	 */
> +	ATH10K_FW_FEATURE_HAS_SAFE_BURST = 34,
> +
> +	/* Register-dump is supported. */
> +	ATH10K_FW_FEATURE_REGDUMP_CT = 35,
> +
> +	/* TX-Rate is reported. */
> +	ATH10K_FW_FEATURE_TXRATE_CT = 36,
> +
> +	/* Firmware can flush all peers. */
> +	ATH10K_FW_FEATURE_FLUSH_ALL_CT = 37,
> +
> +	/* Firmware can read memory with ping-pong protocol. */
> +	ATH10K_FW_FEATURE_PINGPONG_READ_CT = 38,
> +
> +	/* Firmware can skip channel reservation. */
> +	ATH10K_FW_FEATURE_SKIP_CH_RES_CT = 39,
> +
> +	/* Firmware supports NOP keep-alive message. */
> +	ATH10K_FW_FEATURE_NOP_CT = 40,
> +
> +	/* Firmware supports CT HTT MGT feature. */
> +	ATH10K_FW_FEATURE_HTT_MGT_CT = 41,
> +
> +	/* Set-special cmd-id is supported. */
> +	ATH10K_FW_FEATURE_SET_SPECIAL_CT = 42,
> +
> +	/* SW Beacon Miss is disabled in this kernel, so you have to
> +	 * let mac80211 manage the connection.
> +	 */
> +	ATH10K_FW_FEATURE_NO_BMISS_CT = 43,
> +
> +	/* 10.1 firmware that supports getting temperature.  Stock
> +	 * 10.1 cannot.
> +	 */
> +	ATH10K_FW_FEATURE_HAS_GET_TEMP_CT = 44,
> +
> +	/* Can peer-id be over-ridden to provide rix + retries for raw pkts?
> +	 *  CT only option.
> +	 */
> +	ATH10K_FW_FEATURE_HAS_TX_RC_CT = 45,
> +
> +	/* Do we support requesting custom stats */
> +	ATH10K_FW_FEATURE_CUST_STATS_CT = 46,
> +
>  	/* keep last */
>  	ATH10K_FW_FEATURE_COUNT,
>  };
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
