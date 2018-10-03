Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58CF8C00449
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 07:27:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29B5D2089F
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 07:27:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 29B5D2089F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=canonical.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbeJCOOz convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 10:14:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56029 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbeJCOOy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 10:14:54 -0400
Received: from mail-pf1-f199.google.com ([209.85.210.199])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1g7bZQ-0007hI-GR
        for linux-wireless@vger.kernel.org; Wed, 03 Oct 2018 07:27:44 +0000
Received: by mail-pf1-f199.google.com with SMTP id d22-v6so2324961pfn.3
        for <linux-wireless@vger.kernel.org>; Wed, 03 Oct 2018 00:27:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=rwvN3xFgqX8djnx4/f40EwH2bHf5qGLUn3YQ6V1KyAY=;
        b=pCvTsGh3zBNHvV7PbgYtLOik7VPFoFoc4lvJzozakxt2+po4MbfR4ereMud9By2AL8
         p6V2sI8Xcv3d/2Z+HZr3AYPjhefshASFbTnrFT83lbxGqeJg82Eo7/SMUzFkdGcxXHKM
         qchOFmTF0Ni8VeTj/yJXKOg16D9/CKMv2ZoTsrZQ/xC70VtLf8N/Yca6gJRY7XkdfXdH
         Aog4roj6kR63D2OrKMUtreLUQ3CP1mgpQ8JGzb8O7LUX4C5MWcDg8DrAoef77lIEjRbj
         IktUrrKoS/G/+/+MjpitSWQwatuT06jYJn6tFoAoyyDq7eWsEPQT2UJ96HTGXaitEqSH
         xKRA==
X-Gm-Message-State: ABuFfojdLpWRxyvx4Oxs5f2GW5zKkCCb4MtipG5HDrC6N1/Xq7hVidTN
        ff40M3+jdhOqkhbInF4dSLwwo0afhcbPI5NtEB+Y9LA4rnMB1E3CoYvajPaSJ/+p9ZsrtOUP1ze
        uqUIJ7/UAMce9m5DpaSSpL1Uj4bDLoSf7u7LlJTTBWCsJ
X-Received: by 2002:a63:cc04:: with SMTP id x4-v6mr169290pgf.33.1538551663149;
        Wed, 03 Oct 2018 00:27:43 -0700 (PDT)
X-Google-Smtp-Source: ACcGV626LxYrEetKnQ2p/4120j85bSg7WVkZ3P+Wma3/ZtIxmNvVpzdroGJ2CdRGIjYsnVPzP+d8nQ==
X-Received: by 2002:a63:cc04:: with SMTP id x4-v6mr169278pgf.33.1538551662779;
        Wed, 03 Oct 2018 00:27:42 -0700 (PDT)
Received: from [10.101.46.95] (61-220-137-37.HINET-IP.hinet.net. [61.220.137.37])
        by smtp.gmail.com with ESMTPSA id f13-v6sm792454pgq.63.2018.10.03.00.27.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Oct 2018 00:27:42 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.0 \(3445.100.39\))
Subject: Re: [PATCH 3/3] iwlwifi: Load firmware exclusively for Intel WiFi
From:   Kai Heng Feng <kai.heng.feng@canonical.com>
In-Reply-To: <2787bccf20b6f647de9f4cafae5fd223e771b167.camel@intel.com>
Date:   Wed, 3 Oct 2018 15:27:32 +0800
Cc:     lkml <linux-kernel@vger.kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <81B978A9-270E-4C0B-BE67-D05899B1BC3B@canonical.com>
References: <20181003071513.13004-3-kai.heng.feng@canonical.com>
 <2787bccf20b6f647de9f4cafae5fd223e771b167.camel@intel.com>
To:     Luciano Coelho <luciano.coelho@intel.com>
X-Mailer: Apple Mail (2.3445.100.39)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



> On Oct 3, 2018, at 3:24 PM, Luciano Coelho <luciano.coelho@intel.com> wrote:
> 
> On Wed, 2018-10-03 at 15:15 +0800, Kai-Heng Feng wrote:
>> To avoid the firmware loading race between Bluetooth and WiFi on Intel
>> 8260, load firmware exclusively when BT_INTEL is enabled.
>> 
>> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
>> ---
> 
> Where is this coming from? Can you explain what "the firmware loading
> race" is?

Looks like the patch is not correctly threaded. I’ll resend the series.

> 
> 
>> .../net/wireless/intel/iwlwifi/pcie/trans.c   | 37 ++++++++++++++++++-
>> 1 file changed, 36 insertions(+), 1 deletion(-)
>> 
>> diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
>> index cc8c53dc0ab6..c30d3989e2a8 100644
>> --- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
>> +++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
>> @@ -71,6 +71,7 @@
>> #include <linux/vmalloc.h>
>> #include <linux/pm_runtime.h>
>> #include <linux/module.h>
>> +#include <linux/intel-wifi-bt.h>
> 
> I don't see this upstream.  Is it something that was recently added?
> Looks odd...
> 
> Regardless, this should also be protected on CONFIG_BT_INTEL.

Thanks, I’ll update this one.

> 
> 
>> #include "iwl-drv.h"
>> #include "iwl-trans.h"
>> @@ -1335,6 +1336,10 @@ static int iwl_trans_pcie_start_fw(struct iwl_trans *trans,
>> 	bool hw_rfkill;
>> 	int ret;
>> 
>> +#if IS_ENABLED(CONFIG_BT_INTEL)
>> +	void (*firmware_lock_func)(void);
>> +	void (*firmware_unlock_func)(void);
>> +#endif
>> 	/* This may fail if AMT took ownership of the device */
>> 	if (iwl_pcie_prepare_card_hw(trans)) {
>> 		IWL_WARN(trans, "Exit HW not ready\n");
>> @@ -1394,6 +1399,7 @@ static int iwl_trans_pcie_start_fw(struct iwl_trans *trans,
>> 	 * RF-Kill switch is toggled, we will find out after having loaded
>> 	 * the firmware and return the proper value to the caller.
>> 	 */
>> +
> 
> Stray empty line.
> 
>> 	iwl_enable_fw_load_int(trans);
>> 
>> 	/* really make sure rfkill handshake bits are cleared */
>> @@ -1401,8 +1407,37 @@ static int iwl_trans_pcie_start_fw(struct iwl_trans *trans,
>> 	iwl_write32(trans, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
>> 
>> 	/* Load the given image to the HW */
>> -	if (trans->cfg->device_family >= IWL_DEVICE_FAMILY_8000)
>> +	if (trans->cfg->device_family >= IWL_DEVICE_FAMILY_8000) {
>> +#if IS_ENABLED(CONFIG_BT_INTEL)
>> +		firmware_lock_func = symbol_request(btintel_firmware_lock);
>> +		firmware_unlock_func = symbol_request(btintel_firmware_unlock);
>> +		if (!firmware_lock_func || !firmware_unlock_func) {
>> +			if (firmware_lock_func) {
>> +				symbol_put(btintel_firmware_lock);
>> +				firmware_lock_func = NULL;
>> +			}
>> +
>> +			if (firmware_unlock_func) {
>> +				symbol_put(btintel_firmware_unlock);
>> +				firmware_unlock_func = NULL;
>> +			}
>> +		}
>> +
>> +		if (firmware_lock_func)
>> +			firmware_lock_func();
>> +#endif
>> 		ret = iwl_pcie_load_given_ucode_8000(trans, fw);
>> +
>> +#if IS_ENABLED(CONFIG_BT_INTEL)
>> +		if (firmware_unlock_func) {
>> +			firmware_unlock_func();
>> +			symbol_put(btintel_firmware_lock);
>> +			firmware_lock_func = NULL;
>> +			symbol_put(btintel_firmware_unlock);
>> +			firmware_unlock_func = NULL;
>> +		}
>> +#endif
>> +	}
>> 	else
>> 		ret = iwl_pcie_load_given_ucode(trans, fw);
>> 
> 
> I'm not sure I like adding this BT-specific stuff here, especially not
> without a detailed explanation.
> 
> Did you also send the other patches in this series to linux-wireless? I
> can't see them…

I’ll resend one soon.

Thanks!

Kai-Heng

> 
> --
> Cheers,
> Luca.

