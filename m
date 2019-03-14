Return-Path: <SRS0=QiZU=RR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69586C4360F
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Mar 2019 13:16:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B6A421852
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Mar 2019 13:16:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Pk9TYiY6";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="byKyxjAn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbfCNNQk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Mar 2019 09:16:40 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:47864 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726193AbfCNNQk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Mar 2019 09:16:40 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 3819760767; Thu, 14 Mar 2019 13:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552569399;
        bh=jo9pe66jaamYZnQ5lg6IBwaBgp3wAxGqI9I8uIJdCYM=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Pk9TYiY6QEremnrQ9+qKxo0kgV15aVGeGOnJ38bEkIyRoCE7HWbKflJ3YN3lEeVxR
         34xbkGeuxVLeRmEt2ouy7NoJ4dh1X4fIuQOwce6XgEyUkaSaMYeJTCvX8qgiMFDTb6
         mpA9WAtnMHKgT04Ia9AIowjdm/sbauYgK90svIxI=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0CB0F6013C;
        Thu, 14 Mar 2019 13:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552569398;
        bh=jo9pe66jaamYZnQ5lg6IBwaBgp3wAxGqI9I8uIJdCYM=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=byKyxjAnzwJ7YIVKxn9U+pJUpCo7rQtm0Ct72E4TEP2jqj2DYG6xgAQvCNkn5TQDX
         BKrlKV6/Shd5ebIlRFzd65F6uab3y4ZBvEp/kkQzJOvADKaDi54xvbw9y93Fs8qSOD
         NhZXX+izv1Bn3XfDbwx4PExJFuCeoBCK2U2TrZww=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0CB0F6013C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Fenghua Yu <fenghua.yu@intel.com>
Cc:     "Thomas Gleixner" <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, "H Peter Anvin" <hpa@zytor.com>,
        "Dave Hansen" <dave.hansen@intel.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "Ashok Raj" <ashok.raj@intel.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Xiaoyao Li " <xiaoyao.li@intel.com>,
        "Michael Chan" <michael.chan@broadcom.com>,
        "Ravi V Shankar" <ravi.v.shankar@intel.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "x86" <x86@kernel.org>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v5 03/18] wlcore: simplify/fix/optimize reg_ch_conf_pending operations
References: <1552431636-31511-1-git-send-email-fenghua.yu@intel.com>
        <1552431636-31511-4-git-send-email-fenghua.yu@intel.com>
Date:   Thu, 14 Mar 2019 15:16:33 +0200
In-Reply-To: <1552431636-31511-4-git-send-email-fenghua.yu@intel.com> (Fenghua
        Yu's message of "Tue, 12 Mar 2019 16:00:21 -0700")
Message-ID: <87a7hxzjda.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fenghua Yu <fenghua.yu@intel.com> writes:

> From: Paolo Bonzini <pbonzini@redhat.com>
>
> Bitmaps are defined on unsigned longs, so the usage of u32[2] in the
> wlcore driver is incorrect.  As noted by Peter Zijlstra, casting arrays
> to a bitmap is incorrect for big-endian architectures.
>
> When looking at it I observed that:
>
> - operations on reg_ch_conf_pending is always under the wl_lock mutex,
> so set_bit is overkill
>
> - the only case where reg_ch_conf_pending is accessed a u32 at a time is
> unnecessary too.
>
> This patch cleans up everything in this area, and changes tmp_ch_bitmap
> to have the proper alignment.
>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>

[...]

>  int wlcore_cmd_regdomain_config_locked(struct wl1271 *wl)
>  {
>  	struct wl12xx_cmd_regdomain_dfs_config *cmd = NULL;
>  	int ret = 0, i, b, ch_bit_idx;
> -	u32 tmp_ch_bitmap[2];
> +	u32 tmp_ch_bitmap[2] __aligned(sizeof(unsigned long));
>  	struct wiphy *wiphy = wl->hw->wiphy;
>  	struct ieee80211_supported_band *band;
>  	bool timeout = false;

[...]

> @@ -1754,8 +1751,8 @@ int wlcore_cmd_regdomain_config_locked(struct wl1271 *wl)
>  		goto out;
>  	}
>  
> -	cmd->ch_bit_map1 = cpu_to_le32(tmp_ch_bitmap[0]);
> -	cmd->ch_bit_map2 = cpu_to_le32(tmp_ch_bitmap[1]);
> +	cmd->ch_bit_map1 = tmp_ch_bitmap[0];
> +	cmd->ch_bit_map2 = tmp_ch_bitmap[1];

Will sparse still be happy? AFAICS you are now assigning u32 to __le32:

struct wl12xx_cmd_regdomain_dfs_config {
       struct wl1271_cmd_header header;

       __le32 ch_bit_map1;
       __le32 ch_bit_map2;

Also this doesn't depend on anything else from this patchset, right? So
I could apply this directly?

-- 
Kalle Valo
