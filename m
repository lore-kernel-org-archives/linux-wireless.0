Return-Path: <SRS0=80NG=P2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B821DC43612
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jan 2019 04:44:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 873BD20883
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jan 2019 04:44:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="DUkuWQtI";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="X34DsA36"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbfAREod (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 17 Jan 2019 23:44:33 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:43080 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726989AbfAREoc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Jan 2019 23:44:32 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 163306081E; Fri, 18 Jan 2019 04:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547786672;
        bh=HOixMPbK7CAMLg2ituGrYyxYuhyLaQzTUYemOdWQL7E=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=DUkuWQtIg2F+oaKK6Jcq/uJD9LNoHX9VAa4zs32c9o4xHlw8QlRVOVfcmkE/iVjE0
         V7BUR+XDpJTPqQlOt3Bw6aqAbdi6ZfYwj76NEKYAYR5TQwafKAwYaK/RTIF8sTANW2
         5LDhaaN9mfyvdGZc2fGPaaYnkvc0P8wfpZhOsmKY=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0D4AD607F4;
        Fri, 18 Jan 2019 04:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547786671;
        bh=HOixMPbK7CAMLg2ituGrYyxYuhyLaQzTUYemOdWQL7E=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=X34DsA36nLip5tNWBMmAgv3PQ3fkgN4N8Z4Wyn1f4Qusc9h4C0DMgOf4XbmWKMMzy
         WLRpcQHKDpQgPezQJM8MbpHaAtsJtNymLSzDzS/pb1yGrHL4fNd+M3CAwnGYj5safu
         MzTOINqhMGNGsTYMYESRp3hPKFkZ+DD49juoBSVI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0D4AD607F4
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     kbuild test robot <lkp@intel.com>
Cc:     Luca Coelho <luciano.coelho@intel.com>, kbuild-all@01.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: ld: drivers/net/wireless/intel/iwlwifi/iwl-devtrace.h:81: undefined reference to `ieee80211_hdrlen'
References: <201901180349.Fq6xzBcd%fengguang.wu@intel.com>
Date:   Fri, 18 Jan 2019 06:44:26 +0200
In-Reply-To: <201901180349.Fq6xzBcd%fengguang.wu@intel.com> (kbuild test
        robot's message of "Fri, 18 Jan 2019 03:52:53 +0800")
Message-ID: <87k1j2pob9.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

+ linux-wireless

kbuild test robot <lkp@intel.com> writes:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> head:   47bfa6d9dc8c060bf56554a465c9031e286d2f80
> commit: aca432f06b8a60a92b27fb46e6518a19b28ca93f iwlwifi: make MVM and DVM depend on MAC80211
> date:   4 weeks ago
> config: x86_64-randconfig-g3-201902 (attached as .config)
> compiler: gcc-8 (Debian 8.2.0-14) 8.2.0
> reproduce:
>         git checkout aca432f06b8a60a92b27fb46e6518a19b28ca93f
>         # save the attached .config to linux build tree
>         make ARCH=x86_64 
>
> All errors (new ones prefixed by >>):
>
>    ld: drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.o: in function `iwl_init_channel_map':
>    drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c:609: undefined reference to `ieee80211_channel_to_frequency'
>    ld: drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.o: in function `iwl_init_channel_map':
>    drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c:353: undefined reference to `ieee80211_channel_to_frequency'
>    ld: drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.o: in function `iwl_parse_nvm_mcc_info':
>    drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c:1050: undefined reference to `ieee80211_channel_to_frequency'
>    ld: drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c:1099: undefined reference to `reg_query_regdb_wmm'
>    ld: drivers/net/wireless/intel/iwlwifi/pcie/tx.o: in function `iwl_trans_pcie_tx':
>    drivers/net/wireless/intel/iwlwifi/pcie/tx.c:2317: undefined reference to `ieee80211_hdrlen'
>    ld: drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.o: in function `iwl_pcie_gen2_build_tfd':
>    drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c:550: undefined reference to `ieee80211_hdrlen'
>    ld: drivers/net/wireless/intel/iwlwifi/iwl-devtrace.o: in function `iwl_rx_trace_len':
>    drivers/net/wireless/intel/iwlwifi/iwl-devtrace.h:81: undefined reference to `ieee80211_hdrlen'
>>> ld: drivers/net/wireless/intel/iwlwifi/iwl-devtrace.h:81: undefined
>>> reference to `ieee80211_hdrlen'
>>> ld: drivers/net/wireless/intel/iwlwifi/iwl-devtrace.h:81: undefined
>>> reference to `ieee80211_hdrlen'
>    ld:
> drivers/net/wireless/intel/iwlwifi/iwl-devtrace.o:drivers/net/wireless/intel/iwlwifi/iwl-devtrace.h:81:
> more undefined references to `ieee80211_hdrlen' follow

This should be fixed by:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git/commit/?id=ec5aecc0b227f5509d25853537f989ca303e2be1

-- 
Kalle Valo
