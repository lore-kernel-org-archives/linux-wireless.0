Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 068D4C00449
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 08:58:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C00712089F
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 08:58:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="AW/azU4X";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="AW/azU4X"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C00712089F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727438AbeJCPpp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 11:45:45 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:47470 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727356AbeJCPpo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 11:45:44 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D7D3560B26; Wed,  3 Oct 2018 08:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538557097;
        bh=9sLkJeVZxASo88LzjXeNPiYhrRSeXdIYCGwbFaDyeSU=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=AW/azU4XWyHQ767er9lWK8S/pbRzYP+2d5tF3QB7ItmXaBFL3Tbu80sJUDQSZ/FCb
         kIwoSlNhZfqMyhUoGKMmfW386l+iGWFbMRNpElOmDQ5IqoyjPFxNsIEgPunucSuQfT
         MytVvf3tuLL28zWEmhCGQzsun6+Um6SgbJ0XAukA=
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5619460B26;
        Wed,  3 Oct 2018 08:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538557097;
        bh=9sLkJeVZxASo88LzjXeNPiYhrRSeXdIYCGwbFaDyeSU=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=AW/azU4XWyHQ767er9lWK8S/pbRzYP+2d5tF3QB7ItmXaBFL3Tbu80sJUDQSZ/FCb
         kIwoSlNhZfqMyhUoGKMmfW386l+iGWFbMRNpElOmDQ5IqoyjPFxNsIEgPunucSuQfT
         MytVvf3tuLL28zWEmhCGQzsun6+Um6SgbJ0XAukA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5619460B26
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Luciano Coelho <luciano.coelho@intel.com>
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        linux-kernel@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 3/3] iwlwifi: Load firmware exclusively for Intel WiFi
References: <20181003071513.13004-3-kai.heng.feng@canonical.com>
        <2787bccf20b6f647de9f4cafae5fd223e771b167.camel@intel.com>
Date:   Wed, 03 Oct 2018 11:58:12 +0300
In-Reply-To: <2787bccf20b6f647de9f4cafae5fd223e771b167.camel@intel.com>
        (Luciano Coelho's message of "Wed, 03 Oct 2018 10:24:44 +0300")
Message-ID: <87bm8bjtjv.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Luciano Coelho <luciano.coelho@intel.com> writes:

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
>>  	else
>>  		ret = iwl_pcie_load_given_ucode(trans, fw);
>>  
>
> I'm not sure I like adding this BT-specific stuff here, especially not
> without a detailed explanation.

This looks like an ugly hack and the commit log tells nothing. This
really needs strong justifications to even consider doing something like
this.

-- 
Kalle Valo
