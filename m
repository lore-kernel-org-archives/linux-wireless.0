Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3C70C4332F
	for <linux-wireless@archiver.kernel.org>; Mon, 13 Nov 2023 15:11:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbjKMPLX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 13 Nov 2023 10:11:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbjKMPLW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Nov 2023 10:11:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 384581A6
        for <linux-wireless@vger.kernel.org>; Mon, 13 Nov 2023 07:11:18 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1DFBC433C7;
        Mon, 13 Nov 2023 15:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699888277;
        bh=APV7Qhqjaxd3OtxJX4eUx/5vcGB1ZCX7+5XUWVVLz40=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Qd2FnMhU/BLN+iEceJaGOzttAdjrxg3zw/vuygyDA8PkMvp6whSa2zeGuQuuhuPgf
         elLfZS0xEwTwiSLZJ3o8kCwTPIt5jBpfw0vmrYcoxe+vdTr22mWzg7Ig2pOA0Lvl9M
         DCA9xEZLjKTgP88t9aP2e4sDSJ3jA7hrImjU2McOhcjh9/fB/GUpwtQlRgAvAj2Jpf
         LgJnhuK8nwXcRLa+//beyuRAOrQ/BlI0EQy5G4Zb9OoqzMuerue8km5qi2JG/1Pk97
         5TMbTS1tm9jVcUUVugV3UL5Hh0drWMQrnaJQ5hDwlcG6l5tM2fL04gC6wm62wukrG/
         muLrt0bq/RUcw==
From:   Kalle Valo <kvalo@kernel.org>
To:     Jeff Johnson <quic_jjohnson@quicinc.com>
Cc:     James Prestwood <prestwoj@gmail.com>,
        <linux-wireless@vger.kernel.org>,
        "ath11k@lists.infradead.org" <ath11k@lists.infradead.org>
Subject: Re: Can ath11k automatically enable CRYPTO_MICHAEL_MIC?
References: <c558e244-b10d-43f3-9f42-f6c2f98d5b95@gmail.com>
        <b2a44dc4-f5ec-46fe-a4ce-a2151ac65aa3@quicinc.com>
Date:   Mon, 13 Nov 2023 17:11:14 +0200
In-Reply-To: <b2a44dc4-f5ec-46fe-a4ce-a2151ac65aa3@quicinc.com> (Jeff
        Johnson's message of "Wed, 8 Nov 2023 06:39:14 -0800")
Message-ID: <87edgtu1rh.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Jeff Johnson <quic_jjohnson@quicinc.com> writes:

> On 11/8/2023 6:33 AM, James Prestwood wrote:
>> Hi,
>> I'm not very familiar with how the Kconfig stuff works, but I spent
>> longer than I care to admit trying to get the ath11k support to show
>> up in menuconfig.
>> The issue was CONFIG_CRYPT_MICHAEL_MIC was not set, which removed
>> the ath11k driver from menuconfig because of:
>> depends on CRYPTO_MICHAEL_MIC
>> Maybe there was a good reason (again, I don't know much about
>> Kconfig), but should/could this use "select" to automatically enable
>> CRYPTO_MICHAEL_MIC?
>> Thanks,
>> James
>
> + ath11k list to see if there is any history on this topic

I checked the history and this dependency was added by commit
243874c64c81 ("ath11k: handle RX fragments") back in 2020, the commit
message doesn't specify why 'depends on' was used instead of 'select'.

Further investigation shows that ath11k and ath12k are the only who use
'depends on' with CRYPTO_MICHAEL_MIC:

./drivers/net/wireless/intel/ipw2x00/Kconfig:	select CRYPTO_MICHAEL_MIC
./drivers/net/wireless/intersil/hostap/Kconfig:	select CRYPTO_MICHAEL_MIC
./drivers/net/wireless/intersil/orinoco/Kconfig:	select CRYPTO_MICHAEL_MIC
./drivers/net/wireless/ath/ath11k/Kconfig:	depends on CRYPTO_MICHAEL_MIC
./drivers/net/wireless/ath/ath12k/Kconfig:	depends on CRYPTO_MICHAEL_MIC
./drivers/staging/rtl8192e/Kconfig:	select CRYPTO_MICHAEL_MIC
./drivers/staging/ks7010/Kconfig:	select CRYPTO_MICHAEL_MIC

So switching ath11k and ath12k to use 'select' should be the best thing
to do. Patches welcome :)

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
