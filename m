Return-Path: <SRS0=wKjL=YJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFE5CC4360C
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Oct 2019 07:12:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 998CF2082C
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Oct 2019 07:12:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="XXE95LgP";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="oyLIOyxI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbfJPHME (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 16 Oct 2019 03:12:04 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:45842 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726405AbfJPHMD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Oct 2019 03:12:03 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 04D6560D51; Wed, 16 Oct 2019 07:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571209923;
        bh=DAJOxJsHCKRj3D7/6TWyxq40yDW7JwHNCCFfU0e7sv8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=XXE95LgP4cXY0FB00QyjMnyoCgiL8tYR+/jcwk2+N54PDa8nX/kv019zVybQRV1s1
         yeZrgTSfpH182N1/TxfymL7YHkd0krUvzEZPyXpUXgn4jx4Y9JUKLPEeS6tydZ5dbx
         fZOsl+RRWCrf1wanoYml4AS72kwAH703g9nQWFps=
Received: from x230.qca.qualcomm.com (176-93-78-119.bb.dnainternet.fi [176.93.78.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CA63F60D51;
        Wed, 16 Oct 2019 07:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571209921;
        bh=DAJOxJsHCKRj3D7/6TWyxq40yDW7JwHNCCFfU0e7sv8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=oyLIOyxIeKeJvV0TIQLD5UAMUNlbAIVcnmV/0GPD90Cr8MavL0oIjJUSZ0mDDTiAM
         /IJRpHphq6KE3LWuEy0xfHvIk8HCurL0I6MiuvcXwC20KAWkZ1uxpAO0VEl6yYqLFY
         hX/9YZx9PITzW4ocfMaYgJJ+UAnW1eZdY1Fd2lzc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org CA63F60D51
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Luca Coelho <luca@coelho.fi>
Cc:     linux-wireless@vger.kernel.org
Subject: Re: [PATCH 05/13] iwlwifi: dbg: prefer struct copy to memcpy()
References: <20191012162924.19848-1-luca@coelho.fi>
        <20191012192536.797f1ede5077.Ice818674f107105ae05a6f561263c0896d49de2c@changeid>
Date:   Wed, 16 Oct 2019 10:11:58 +0300
In-Reply-To: <20191012192536.797f1ede5077.Ice818674f107105ae05a6f561263c0896d49de2c@changeid>
        (Luca Coelho's message of "Sat, 12 Oct 2019 19:29:16 +0300")
Message-ID: <87lftlkvup.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Luca Coelho <luca@coelho.fi> writes:

> From: Johannes Berg <johannes.berg@intel.com>
>
> ifxes=Ic930239af4832ecb04afbf92840c99dfd726eebe
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>

Quite cryptic commit log :)

-- 
Kalle Valo
