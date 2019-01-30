Return-Path: <SRS0=OIIa=QG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42F3CC282D9
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 14:46:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D404218AE
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 14:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548859610;
	bh=jyL/ycpruDY4rRpLFI8o6T0aCyq1b+sbGwsAujcZC6o=;
	h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:
	 List-ID:From;
	b=j5zR+tYVV9M4LFY44Q0pEZd186aLD7GaMwS89+LoldwMd3pp+BJjxhfZOeFCRdlQf
	 ar8/HQJXJa1yDSCb7ZR81/7bvMlEBAiw46ob43MTDCPBFmIJothvWmM3ACXXg2pDaW
	 LOoVo+NwILdDnZOtWAcbKS6RLAI7ZV4F296LS+X8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731189AbfA3Oqt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 30 Jan 2019 09:46:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:49736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725828AbfA3Oqt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Jan 2019 09:46:49 -0500
Received: from localhost (unknown [23.100.24.84])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7880F20882;
        Wed, 30 Jan 2019 14:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548859608;
        bh=jyL/ycpruDY4rRpLFI8o6T0aCyq1b+sbGwsAujcZC6o=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=pyNs7wQl1crZsAFnsIznlclJYFVZI0Ms9NMHJbesQo+iJh3UPEEEKZbIBC4Y3z4nJ
         kLnK8QVAj1yH7IElYZQ/tdNIkMnrNHXlMP3UO2/mxnkHCA/b0B90yOkiD1fZBEtXTk
         H9VCeAxRYcvL9TEZHAEM2Q1lT93qogPLmsXm7pOU=
Date:   Wed, 30 Jan 2019 14:46:47 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] mac80211: ensure that mgmt tx skbs have tailroom for encryption
In-Reply-To: <20190129101057.83295-1-nbd@nbd.name>
References: <20190129101057.83295-1-nbd@nbd.name>
Message-Id: <20190130144648.7880F20882@mail.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v4.20.5, v4.19.18, v4.14.96, v4.9.153, v4.4.172, v3.18.133.

v4.20.5: Build OK!
v4.19.18: Build OK!
v4.14.96: Build OK!
v4.9.153: Build OK!
v4.4.172: Build OK!
v3.18.133: Failed to apply! Possible dependencies:
    057fcd426e14 ("bcma: gpio: use predictable base for all BCM47XX buses")
    077efc8c42e8 ("ath10k: clean up sta auth/assoc code")
    202e86e60646 ("ath10k: add ATH10K_FW_IE_WMI_OP_VERSION")
    292a753d4b18 ("ath10k: clean up num_peers locking")
    30686bf7f5b3 ("mac80211: convert HW flags to unsigned long bitmap")
    34b28b6e9a66 ("ath10k: print wmi version info")
    3c7984e97f32 ("ath10k: don't create bssid peer for ibss")
    3cb10943fc60 ("ath10k: use IEEE80211_HW_SW_CRYPTO_CONTROL")
    41fbf6e4f317 ("ath10k: enable IEEE80211_HW_SUPPORT_FAST_XMIT")
    5f2144d9b2ea ("ath10k: create ath10k_core_init_features()")
    830915597747 ("ath10k: refactor ath10k_init_download_firmware()")
    84cbf3a75928 ("ath10k: split ce pipe init/alloc further")
    a52c0282721e ("ath10k: add missing goto")
    a58227ef69a7 ("ath10k: retrieve calibration data from file")
    c6ce492d03e8 ("ath10k: clean up error handling in ath10k_core_probe_fw()")
    ca996ec56608 ("ath10k: implement wmi-tlv backend")
    cfd1061e9b52 ("ath10k: fix station count enforcement")
    d63955b33b3b ("ath10k: add support for qca6174")
    d98c3edcbbbf ("Merge tag 'wireless-drivers-next-for-davem-2015-05-21' of git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next")


How should we proceed with this patch?

--
Thanks,
Sasha
