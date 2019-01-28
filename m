Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0000C282CB
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 09:00:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD2BE207E0
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 09:00:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="SEXnVXqG";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="M1u19KHF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbfA1JAj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 04:00:39 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:54492 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726648AbfA1JAj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 04:00:39 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 0E24560DA9; Mon, 28 Jan 2019 09:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548666039;
        bh=8V2rpsmdeVLNqWFALs4ttUFIKhnp0Xr8tB6zgeKzc8s=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=SEXnVXqG5ANc4rwUXCYdnDfL6jN1knU0onYuOQ99s4VdzHBi6oRvSRpbWZlxJcepT
         gDsFROuiFm6TZeBNvv9fGSufiQbXl2UsKFHZvNFdkRqvU0QxYEP0a4uuJ/JgrZ0opP
         NFa2YOmL+5uHNY+ASCB1ysYmsBC3OWVcNGpI9jp8=
Received: from x230.qca.qualcomm.com (87-93-85-88.bb.dnainternet.fi [87.93.85.88])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D4C5860D89;
        Mon, 28 Jan 2019 09:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548666023;
        bh=8V2rpsmdeVLNqWFALs4ttUFIKhnp0Xr8tB6zgeKzc8s=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=M1u19KHFTQdS1fqXaHQhs1ZLpfVHpPIi8HYfgEBgU91+4j1HNpoxIo1F4RBWUGtMF
         y41kMnGnuiPdqMrbETlTvAJ/8B1NhVtM8cUJ8quy3/eONj+Jk18f5I+QV+tnChtOzi
         9NGgbVULnsDp8iNiz/FmESUdCaBrtlDQO6ZF89oc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D4C5860D89
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Luca Coelho <luca@coelho.fi>
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: Re: [PATCH 17/17] iwlwifi: mvm: add an option to dereference vif by id
References: <20190125201305.5616-1-luca@coelho.fi>
        <20190125201305.5616-18-luca@coelho.fi>
Date:   Mon, 28 Jan 2019 11:00:19 +0200
In-Reply-To: <20190125201305.5616-18-luca@coelho.fi> (Luca Coelho's message of
        "Fri, 25 Jan 2019 22:13:05 +0200")
Message-ID: <87pnsh17j0.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Luca Coelho <luca@coelho.fi> writes:

> From: Sara Sharon <sara.sharon@intel.com>
>
> Currently whenever we get firmware notification with mac id,
> we iterate over all the interfaces to find the ID. This is a
> bit cumbersome. Instead, adding an array of RCU pointers, like
> we have for station IDs. This is not expensive space wise
> since we have only up to 4 active MACs, and not complicated
> code wise, since we have a clear point to init and de-init it.
>
> Signed-off-by: Sara Sharon <sara.sharon@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>

[...]

> +static inline struct ieee80211_vif *
> +iwl_mvm_rcu_dereference_vif_id(struct iwl_mvm *mvm, u8 vif_id, bool rcu)
> +{
> +	if (WARN_ON(vif_id >= ARRAY_SIZE(mvm->vif_id_to_mac)))
> +		return NULL;
> +
> +	if (rcu)
> +		return rcu_dereference(mvm->vif_id_to_mac[vif_id]);
> +
> +	return rcu_dereference_protected(mvm->vif_id_to_mac[vif_id],
> +					 lockdep_is_held(&mvm->mutex));
> +}

No need to change anything, but IMHO foo(bar) and foo_protected(bar) is
a lot easier to read than foo(bar, true) and foo(bar, false).

-- 
Kalle Valo
