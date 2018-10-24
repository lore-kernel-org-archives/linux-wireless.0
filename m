Return-Path: <SRS0=AjP+=NE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD0DDC004D3
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 08:35:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 733762075D
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 08:35:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ZyeBfAL0";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ZyeBfAL0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 733762075D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727458AbeJXRCg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 24 Oct 2018 13:02:36 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:35684 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726920AbeJXRCg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Oct 2018 13:02:36 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 84DBC60C5F; Wed, 24 Oct 2018 08:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540370126;
        bh=kvjjrGest8LFvk+c2QW+d3xOkjLbmNnfvTE2xzjp4zI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ZyeBfAL03Lg+SJKlEPxVHPY1lARxcrTHj0daPE7Gjcm1qvLFLFM0vP/4/DdEd+9qc
         nsM59HUx9OgV+rWZTR+KYX6I86GALLwpaN6q9PVDKbdTrIupDfmtj96fHUSkZVcbs6
         OlUt7seqG5i82g4fnnvSDzk7+wjc9/KxWsAtJtPk=
Received: from x230.qca.qualcomm.com (87-93-79-96.bb.dnainternet.fi [87.93.79.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0E7FC60C1B;
        Wed, 24 Oct 2018 08:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540370126;
        bh=kvjjrGest8LFvk+c2QW+d3xOkjLbmNnfvTE2xzjp4zI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ZyeBfAL03Lg+SJKlEPxVHPY1lARxcrTHj0daPE7Gjcm1qvLFLFM0vP/4/DdEd+9qc
         nsM59HUx9OgV+rWZTR+KYX6I86GALLwpaN6q9PVDKbdTrIupDfmtj96fHUSkZVcbs6
         OlUt7seqG5i82g4fnnvSDzk7+wjc9/KxWsAtJtPk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0E7FC60C1B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Rajkumar Manoharan <rmanohar@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        Kan Yan <kyan@google.com>
Subject: Re: [PATCH 6/6] ath10k: reporting estimated tx airtime for fairness
References: <1540033534-11211-1-git-send-email-rmanohar@codeaurora.org>
        <1540033534-11211-7-git-send-email-rmanohar@codeaurora.org>
Date:   Wed, 24 Oct 2018 11:35:22 +0300
In-Reply-To: <1540033534-11211-7-git-send-email-rmanohar@codeaurora.org>
        (Rajkumar Manoharan's message of "Sat, 20 Oct 2018 04:05:34 -0700")
Message-ID: <875zxru4hh.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rajkumar Manoharan <rmanohar@codeaurora.org> writes:

> Transmit airtime will be estimated from last tx rate used.
> Firmware report tx rate by peer stats. Airtime is computed
> on tx path and the same will be reported to mac80211 upon
> tx completion.
>
> Signed-off-by: Kan Yan <kyan@google.com>
> Signed-off-by: Rajkumar Manoharan <rmanohar@codeaurora.org>

Same comments as in patch 5 about "From:" and Co-developed-by tags.

-- 
Kalle Valo
