Return-Path: <SRS0=AjP+=NE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99EF0C004D3
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 08:38:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 45F09206B5
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 08:38:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="DNmlmTia";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="DNmlmTia"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 45F09206B5
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727146AbeJXRF4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 24 Oct 2018 13:05:56 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:36476 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726732AbeJXRFz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Oct 2018 13:05:55 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id CAC3660C48; Wed, 24 Oct 2018 08:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540370325;
        bh=7+vpWhRb5JQet/H1B1YalUqwgArQvqWbtuRaJ0Ja0jE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=DNmlmTiaKZqBxzNYO4dtAV0f9pigwyOnzGGJOhwmJmQOjpck4p41oXFrelxmbltXM
         5O4sufR+PgzziVW2E0KMAVTpr6vUESamJuWkdooCgXfqrknS5wG1rcn994iYy/I2+r
         hgO6Yig0k5YJMjeVkiNk7TGyYTxnK9ri0X8431oc=
Received: from x230.qca.qualcomm.com (87-93-79-96.bb.dnainternet.fi [87.93.79.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B1C58601A0;
        Wed, 24 Oct 2018 08:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540370325;
        bh=7+vpWhRb5JQet/H1B1YalUqwgArQvqWbtuRaJ0Ja0jE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=DNmlmTiaKZqBxzNYO4dtAV0f9pigwyOnzGGJOhwmJmQOjpck4p41oXFrelxmbltXM
         5O4sufR+PgzziVW2E0KMAVTpr6vUESamJuWkdooCgXfqrknS5wG1rcn994iYy/I2+r
         hgO6Yig0k5YJMjeVkiNk7TGyYTxnK9ri0X8431oc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B1C58601A0
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Wei Yongjun <weiyongjun1@huawei.com>
Cc:     Govind Singh <govinds@codeaurora.org>,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org,
        ath10k@lists.infradead.org
Subject: Re: [PATCH net-next] ath10k: fix copy-paste error in ath10k_qmi_setup_msa_resources()
References: <1539657316-35629-1-git-send-email-weiyongjun1@huawei.com>
Date:   Wed, 24 Oct 2018 11:38:41 +0300
In-Reply-To: <1539657316-35629-1-git-send-email-weiyongjun1@huawei.com> (Wei
        Yongjun's message of "Tue, 16 Oct 2018 02:35:16 +0000")
Message-ID: <871s8fu4by.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Wei Yongjun <weiyongjun1@huawei.com> writes:

> The return value from devm_memremap() is not checked correctly.
> The test is done against a wrong variable. This patch fix it.
>
> Fixes: ba94c753ccb4 ("ath10k: add QMI message handshake for wcn3990 client")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Please don't mark wireless patches for net-next, by default ath10k
patches go to ath-next branch of my ath.git tree. But no need to resend
because of this.

-- 
Kalle Valo
