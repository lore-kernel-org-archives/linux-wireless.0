Return-Path: <SRS0=AjP+=NE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45451C004D3
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 05:51:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D37C22075D
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 05:50:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="JsFtR28T";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="JsFtR28T"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D37C22075D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbeJXORd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 24 Oct 2018 10:17:33 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:55082 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726224AbeJXORd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Oct 2018 10:17:33 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id CD0F460C64; Wed, 24 Oct 2018 05:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540360257;
        bh=4RC3w8KIu76dvbYvnP3VtSAAw7VePnLpKcPqaGpiC1c=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=JsFtR28TxwVwTwOoPURFm0iiChvvgv8qdDJHSvKfx5rq/X6+/5Oke5dSLI5jJd7hr
         MUVaoWwMWzu14HH/QzuAW/D2KbyxQ7Ptqx+4B/u6tBzb5I3g4yUMH9sZRa/s5xEVGY
         fc4ujZswvsBj3JVgsMvruSIdbHMhFAv4cUzCgyZQ=
Received: from x230.qca.qualcomm.com (vpn.espressohouse.com [31.216.224.152])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id EFDCE60C4F;
        Wed, 24 Oct 2018 05:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540360257;
        bh=4RC3w8KIu76dvbYvnP3VtSAAw7VePnLpKcPqaGpiC1c=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=JsFtR28TxwVwTwOoPURFm0iiChvvgv8qdDJHSvKfx5rq/X6+/5Oke5dSLI5jJd7hr
         MUVaoWwMWzu14HH/QzuAW/D2KbyxQ7Ptqx+4B/u6tBzb5I3g4yUMH9sZRa/s5xEVGY
         fc4ujZswvsBj3JVgsMvruSIdbHMhFAv4cUzCgyZQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org EFDCE60C4F
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] ath9k: Fix a locking bug in ath9k_add_interface()
References: <20181019200842.7qclbjs547sm7mbn@kili.mountain>
Date:   Wed, 24 Oct 2018 08:50:52 +0300
In-Reply-To: <20181019200842.7qclbjs547sm7mbn@kili.mountain> (Dan Carpenter's
        message of "Fri, 19 Oct 2018 23:08:43 +0300")
Message-ID: <87tvlbuc3n.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Dan Carpenter <dan.carpenter@oracle.com> writes:

> We tried to revert commit d9c52fd17cb4 ("ath9k: fix tx99 with monitor
> mode interface") but accidentally missed part of the locking change.
>
> The lock has to be held earlier so that we're holding it when we do
> "sc->tx99_vif = vif;" and also there in the current code there is a
> stray unlock before we have taken the lock.
>
> Fixes: 6df0580be8bc ("ath9k: add back support for using active monitor interfaces for tx99")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

commit 6df0580be8bc is on it's way to v4.20 so should I also queue this
to v4.20?

-- 
Kalle Valo
