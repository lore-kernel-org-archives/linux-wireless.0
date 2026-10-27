Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.38.247.119
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793087724;
	b=TDbNz4TFKXR1u7td1XwcB4NNz/VzbvUPa5vrKWhR2mMk4BjUNEetnHmdOKH/NZc+5Y8C
	 tprGrLitQ66YylgNgRDV451KIrBKwL3mx6nxnBYCf6sPoBKeuS6x4SfRNdIEcDL4nvFB+
	 dmMvoJeLk+jWLKsQSLaCRJ/f/5Iq5Hu71P6NvhiABGVAifyUsnm+cIDn5inKx8qsSWHGg
	 29gBhRBg1KMs86hKYEqMTACsH/31sVF4TNKiMWhO15IV2ojs5BeS1Bs17fDMSL+0k1ass
	 UWNkCkc15VuQzid2G29r5usdzY6ZVHCjLkAbiGzbJVNFrisGPkHpmL9QUtiHV5l/h9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793087724;
	h=DMARC-Filter:Received:DKIM-Signature:Received:X-Virus-Scanned:
	 X-Spam-Flag:X-Spam-Score:X-Spam-Level:X-Spam-Status:Received:Received:
	 Received-SPF:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:From:Content-Language:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-PPP-Message-ID:X-Rspamd-Server:
	 X-Rspamd-Queue-Id:X-NC-CID;
	bh=jhgLB/G+bnU+2NF4b/GbQk/18YkilOwbFiadUiWuDC4=;
	b=RPKFUpsWRzj/I+DQqIUh/eodproiBj5a3C/+ZOwPclqbXsV2HMEYaJ0Dt1g+IUkCBbam
	 kDvppbholgnjwsXW9gEyQCJFv0miccwyT/9NMT5JocdoklEtGTg56kujYCFq9Pw6IaeIv
	 wU4D+y4bl9YvofJ3codwACcDv3sa8Ljh79KXmXUollAhhcYrofzazb5N9IVpGQsqi7UPX
	 cmZIQsvXNDx+6eIvjsseYMWnfV5Ko/6lB9tskgAkt3TFBXkuWOkkMo8p41MCJqBFA3jbI
	 ElsA+ZWxYWsuGcRM50n6GDuZRBKN8CKB36HaORkjBAyV8F6x4GIfhSsDCiXOU+iDntQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=leemhuis.info;
	spf=pass smtp.mailfrom=leemhuis.info;
	dkim=pass header.d=leemhuis.info header.i=@leemhuis.info header.a=rsa-sha256 header.s=key2 header.b=BNuy2gTW;
	arc=none smtp.remote-ip=46.38.247.119
Received: from relay.yourmailgateway.de (relay.yourmailgateway.de [46.38.247.119])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2B9D606A31D
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 07:55:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C2B9D606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=leemhuis.info header.i=@leemhuis.info header.a=rsa-sha256 header.s=key2 header.b=BNuy2gTW
Received: from mors-relay-8404.netcup.net (localhost [127.0.0.1])
	by mors-relay-8404.netcup.net (Postfix) with ESMTPS id 4jDN831lNcz8YgS;
	Tue, 27 Oct 2026 08:55:15 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=leemhuis.info;
	s=key2; t=1793087715;
	bh=Ijsej1QAoO/3PN6iWABBfAJJaRGLph/2eyq6W4qoBw8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BNuy2gTWo8ujB+fFm9ZYpDfx/SrVsQuki/5zYZ/9OBY0m39PH4FZ5vAJb9wzsqH69
	 ieTnTyL3xg08xv8eqACies5rHlWlmchY+W2e6+CD6AFcFk8tMDSJN1SrpI0uTuc2T1
	 yHl3hT4LEp2SVORrxsZVApMI4iGf+hGtpTBmVl8Klr6Dojfv4XCRwG//vAdwaZBhuw
	 80eeilzNoztfm382It8JM99+G7kpvYnOehaz5zc4DIBq+uysiy3ttxI2xmtrNGfyTW
	 6Aw1YEt3X+GzNZ4SIBvpF72D+kI/fD3b2//abuWAcqpbK6prjVbmDxortgCaS0dvsZ
	 +ffTmkH1PE8og==
Received: from policy01-mors.netcup.net (unknown [46.38.225.35])
	by mors-relay-8404.netcup.net (Postfix) with ESMTPS id 4jDN8312MTz502k;
	Tue, 27 Oct 2026 08:55:15 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at policy01-mors.netcup.net
X-Spam-Flag: NO
X-Spam-Score: -2.898
X-Spam-Level: 
Received: from mxe9fb.netcup.net (unknown [10.243.12.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by policy01-mors.netcup.net (Postfix) with ESMTPS id 4jDN822v70z8tk9;
	Tue, 27 Oct 2026 08:55:14 +0100 (CET)
Received: from [IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f] (unknown [IPv6:2a02:8108:8984:1d00:a0cf:1912:4be:477f])
	by mxe9fb.netcup.net (Postfix) with ESMTPSA id 9034E5F98B;
	Tue, 27 Oct 2026 08:55:09 +0100 (CET)
Authentication-Results: mxe9fb;
        spf=pass (sender IP is 2a02:8108:8984:1d00:a0cf:1912:4be:477f) smtp.mailfrom=regressions@leemhuis.info smtp.helo=[IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f]
Received-SPF: pass (mxe9fb: connection is authenticated)
Message-ID: <9a92165c-93dd-42a1-b61c-b494008f45b7@leemhuis.info>
Date: Tue, 27 Oct 2026 08:55:09 +0100
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH iwlwifi-fixes 3/5] wifi: iwlwifi: honor the per-channel
 320 MHz regulatory flag
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org,
 Miri Korenblit <miriam.rachel.korenblit@intel.com>,
 Linux kernel regressions list <regressions@lists.linux.dev>
References: 
 <20260930122439.f8a1ea3af242.I282fab02ab2f183633df0f070229fb5a2d5c9ec3@changeid>
 <20260930122439.08094e4c344f.Ic0a4bf544fd6ebaf1fc62b40bf463bd289e58cf0@changeid>
From: Thorsten Leemhuis <regressions@leemhuis.info>
Content-Language: de-DE, en-US
In-Reply-To: 
 <20260930122439.08094e4c344f.Ic0a4bf544fd6ebaf1fc62b40bf463bd289e58cf0@changeid>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-PPP-Message-ID: <179308770986.901241.14769111465113550766@mxe9fb.netcup.net>
X-Rspamd-Server: rspamd-worker-8404
X-Rspamd-Queue-Id: 9034E5F98B
X-NC-CID: OkT08XUM0Ix4ZJ6JWXsJjg+ncpKuZ6jSmPowZaZN+cT/fdNzIeU=

On 9/30/26 11:25, Miri Korenblit wrote:
> From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> 
> When support for the MCC update response version 8 was added, the API
> change was implemented only partially. That version introduced two new
> pieces of information about 320 MHz: the global capability
> REG_CAPA_V5_320MHZ_ALLOWED and a per-channel bit, BIT(12), in the
> channel flags carried by the response. Only the former was picked up.
> BIT(12) kept its previous meaning in the driver, NVM_CHANNEL_DC_HIGH,
> a leftover from old devices that nothing used, so the new bit was
> silently dropped.

Just wondering: what happened to this regression fix? It from what I see
seems to sit in iwlwifi fixes branch for a while already, but missed
both 7.3 final and also the main net merge in this merge window. Did it
fell trough the cracks?

Ciao, Thorsten
> The two are not equivalent, the per-channel bit can be more restrictive
> than the global capability. When that happens, cfg80211 is told that
> 320 MHz is allowed, mac80211 builds a 320 MHz channel context, and the
> firmware rejects the resulting PHY_CONTEXT_CMD and asserts with
> 0x200014FC.
> 
> Rename the bit to NVM_CHANNEL_320MHZ and set NL80211_RRF_NO_320MHZ for
> the channels that don't have it, so that we cap the bandwidth at
> 160 MHz instead of asserting the firmware. The bit is checked in every
> band, so that a future band that supports 320 MHz is covered as well.
> 
> Fixes: e9b63341dc15 ("wifi: iwlwifi: update response for mcc_update command")
> Assisted-by: GitHub-Copilot:claude-opus-5
> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221675
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
> ---
>  .../wireless/intel/iwlwifi/iwl-nvm-parse.c    |  6 ++---
>  .../wireless/intel/iwlwifi/iwl-nvm-parse.h    |  7 ++++--
>  .../wireless/intel/iwlwifi/tests/nvm_parse.c  | 24 +++++++++++++++----
>  3 files changed, 28 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
> index 863d5e358152..f4df00514fb1 100644
> --- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
> +++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
> @@ -106,8 +106,6 @@ static const u16 iwl_unii9_nvm_channels[] = {
>  #define IWL_NVM_NUM_CHANNELS_EXT	51
>  #define IWL_NVM_NUM_CHANNELS_UHB	110
>  #define IWL_NVM_NUM_CHANNELS_UNII9	ARRAY_SIZE(iwl_unii9_nvm_channels)
> -#define NUM_2GHZ_CHANNELS		14
> -#define NUM_5GHZ_CHANNELS		37
>  #define FIRST_2GHZ_HT_MINUS		5
>  #define LAST_2GHZ_HT_PLUS		9
>  #define N_HW_ADDR_MASK			0xF
> @@ -280,7 +278,7 @@ static inline void iwl_nvm_print_channel_flags(struct device *dev, u32 level,
>  		      CHECK_AND_PRINT_I(40MHZ),
>  		      CHECK_AND_PRINT_I(80MHZ),
>  		      CHECK_AND_PRINT_I(160MHZ),
> -		      CHECK_AND_PRINT_I(DC_HIGH),
> +		      CHECK_AND_PRINT_I(320MHZ),
>  		      CHECK_AND_PRINT_I(VLP),
>  		      CHECK_AND_PRINT_I(AFC));
>  #undef CHECK_AND_PRINT_I
> @@ -1631,6 +1629,8 @@ u32 iwl_nvm_get_regdom_bw_flags(const u16 *nvm_chan,
>  		flags |= NL80211_RRF_NO_80MHZ;
>  	if (!(nvm_flags & NVM_CHANNEL_160MHZ))
>  		flags |= NL80211_RRF_NO_160MHZ;
> +	if (!(nvm_flags & NVM_CHANNEL_320MHZ))
> +		flags |= NL80211_RRF_NO_320MHZ;
>  
>  	if (!(nvm_flags & NVM_CHANNEL_ACTIVE))
>  		flags |= NL80211_RRF_NO_IR;
> diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h
> index 9ebb72d3726a..7b11682f5d45 100644
> --- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h
> +++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h
> @@ -10,6 +10,9 @@
>  #include "iwl-nvm-utils.h"
>  #include "mei/iwl-mei.h"
>  
> +#define NUM_2GHZ_CHANNELS		14
> +#define NUM_5GHZ_CHANNELS		37
> +
>  /**
>   * enum iwl_nvm_sbands_flags - modification flags for the channel profiles
>   *
> @@ -82,7 +85,7 @@ struct iwl_reg_capa {
>   * @NVM_CHANNEL_40MHZ: 40 MHz channel okay
>   * @NVM_CHANNEL_80MHZ: 80 MHz channel okay
>   * @NVM_CHANNEL_160MHZ: 160 MHz channel okay
> - * @NVM_CHANNEL_DC_HIGH: DC HIGH required/allowed (?)
> + * @NVM_CHANNEL_320MHZ: 320 MHz channel okay
>   * @NVM_CHANNEL_VLP: client support connection to UHB VLP AP
>   * @NVM_CHANNEL_AFC: client support connection to UHB AFC AP
>   * @NVM_CHANNEL_VLP_AP_NOT_ALLOWED: UHB VLP AP not allowed,
> @@ -101,7 +104,7 @@ enum iwl_nvm_channel_flags {
>  	NVM_CHANNEL_40MHZ			= BIT(9),
>  	NVM_CHANNEL_80MHZ			= BIT(10),
>  	NVM_CHANNEL_160MHZ			= BIT(11),
> -	NVM_CHANNEL_DC_HIGH			= BIT(12),
> +	NVM_CHANNEL_320MHZ			= BIT(12),
>  	NVM_CHANNEL_VLP				= BIT(13),
>  	NVM_CHANNEL_AFC				= BIT(14),
>  	NVM_CHANNEL_VLP_AP_NOT_ALLOWED		= BIT(15),
> diff --git a/drivers/net/wireless/intel/iwlwifi/tests/nvm_parse.c b/drivers/net/wireless/intel/iwlwifi/tests/nvm_parse.c
> index 853911900bfd..5a50807e3181 100644
> --- a/drivers/net/wireless/intel/iwlwifi/tests/nvm_parse.c
> +++ b/drivers/net/wireless/intel/iwlwifi/tests/nvm_parse.c
> @@ -2,7 +2,7 @@
>  /*
>   * KUnit tests for NVM parse
>   *
> - * Copyright (C) 2025 Intel Corporation
> + * Copyright (C) 2025-2026 Intel Corporation
>   */
>  #include <kunit/static_stub.h>
>  #include <kunit/test.h>
> @@ -12,7 +12,9 @@ MODULE_IMPORT_NS("EXPORTED_FOR_KUNIT_TESTING");
>  
>  static const struct nvm_flag_case {
>  	const char *desc;
> +	int ch_idx;
>  	u16 nvm_flags;
> +	struct iwl_reg_capa reg_capa;
>  	u32 reg_rule_flags;
>  	u32 set_reg_rule_flags;
>  	u32 clear_reg_rule_flags;
> @@ -36,6 +38,20 @@ static const struct nvm_flag_case {
>  		.clear_reg_rule_flags = NL80211_RRF_ALLOW_6GHZ_VLP_AP |
>  					NL80211_RRF_NO_6GHZ_VLP_CLIENT,
>  	},
> +	{
> +		.desc = "Allow 320 MHz on a 6 GHz channel that reports it",
> +		.ch_idx = NUM_2GHZ_CHANNELS + NUM_5GHZ_CHANNELS,
> +		.nvm_flags = NVM_CHANNEL_320MHZ,
> +		.reg_capa = { .allow_320mhz = true, },
> +		.clear_reg_rule_flags = NL80211_RRF_NO_320MHZ,
> +	},
> +	{
> +		.desc = "Restrict 320 MHz on a 6 GHz channel without the bit",
> +		.ch_idx = NUM_2GHZ_CHANNELS + NUM_5GHZ_CHANNELS,
> +		.nvm_flags = 0,
> +		.reg_capa = { .allow_320mhz = true, },
> +		.set_reg_rule_flags = NL80211_RRF_NO_320MHZ,
> +	},
>  };
>  
>  KUNIT_ARRAY_PARAM_DESC(nvm_flag, nvm_flag_cases, desc)
> @@ -43,11 +59,11 @@ KUNIT_ARRAY_PARAM_DESC(nvm_flag, nvm_flag_cases, desc)
>  static void test_nvm_flags(struct kunit *test)
>  {
>  	const struct nvm_flag_case *params = test->param_value;
> -	struct iwl_reg_capa reg_capa = {};
>  	u32 flags = 0;
>  
> -	flags = iwl_nvm_get_regdom_bw_flags(NULL, 0, params->nvm_flags,
> -					    reg_capa);
> +	flags = iwl_nvm_get_regdom_bw_flags(NULL, params->ch_idx,
> +					    params->nvm_flags,
> +					    params->reg_capa);
>  
>  	if ((params->set_reg_rule_flags & flags) != params->set_reg_rule_flags)
>  		KUNIT_FAIL(test, "Expected set bits:0x%08x flags:0x%08x\n",

