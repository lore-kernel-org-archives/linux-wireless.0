Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77CF9C77B75
	for <linux-wireless@archiver.kernel.org>; Wed, 17 May 2023 08:19:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbjEQITN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 May 2023 04:19:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbjEQITK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 May 2023 04:19:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98EEE10EF
        for <linux-wireless@vger.kernel.org>; Wed, 17 May 2023 01:19:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E4AE61774
        for <linux-wireless@vger.kernel.org>; Wed, 17 May 2023 08:19:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DFBFC433D2;
        Wed, 17 May 2023 08:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684311548;
        bh=La1MuPZ/2qVLr9ylXbwJw83v1motV4uLHA32QcWjphE=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=pjkOMK8mjdsHwGQyCnyWrhd6uJXdle0Ld1hUetsbd/kNIZ881yzN6OuiwIHCyaWk2
         mbkXyp1+NgjXhq7V9ckLvkWgF5BPzHs3LTT0E+1Q2PkVYhFgDySdLOSBxOo2l0MwgU
         l6TOwXmCURxKIGmGeNGffpW9GJGmThPImp8GEldf7DhZ5wrwKCm23KSp8Io28+YmpV
         OwXAkd5v+TvtboC7cjYDolOzFLSQMQG1532WpOvbLOjf4YO2le1esNXvxxD2UOgkBk
         Bc6RMwja1WLZ6pvSXlRBbxse4TS18T9d4b52m4pDNDK2iEqHp+VgQwj297WBY/fR+0
         H5wBFCYSOu8NQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/2] ath11k: Relocate the func
 ath11k_mac_bitrate_mask_num_ht_rates() and change hweight16 to hweight8
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230504092033.3542456-2-quic_mkenna@quicinc.com>
References: <20230504092033.3542456-2-quic_mkenna@quicinc.com>
To:     Maharaja Kennadyrajan <quic_mkenna@quicinc.com>
Cc:     <ath11k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        Maharaja Kennadyrajan <quic_mkenna@quicinc.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <168431154238.15787.9973143615337740761.kvalo@kernel.org>
Date:   Wed, 17 May 2023 08:19:07 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Maharaja Kennadyrajan <quic_mkenna@quicinc.com> wrote:

> Relocate the function ath11k_mac_bitrate_mask_num_ht_rates() definition
> to call this function from other functions which helps to avoid the
> compilation error (function not defined).
> 
> ht_mcs[] is 1 byte array and it is enough to use hweight8() instead
> of hweight16(). Hence, fixed the same.
> 
> Tested on: Compile tested only.
> 
> Signed-off-by: Maharaja Kennadyrajan <quic_mkenna@quicinc.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

2 patches applied to ath-next branch of ath.git, thanks.

570eec3d4050 wifi: ath11k: Relocate the func ath11k_mac_bitrate_mask_num_ht_rates() and change hweight16 to hweight8
df8e3729ffc0 wifi: ath11k: Send HT fixed rate in WMI peer fixed param

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230504092033.3542456-2-quic_mkenna@quicinc.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

