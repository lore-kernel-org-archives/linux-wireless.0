Return-Path: <SRS0=pyzf=O5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56A64C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 12:09:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23A3C2176F
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 12:09:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ax0ZlFwD";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="hRT63x43"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731509AbeLTMJf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 20 Dec 2018 07:09:35 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:48510 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731327AbeLTMJe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Dec 2018 07:09:34 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 45E66605A5; Thu, 20 Dec 2018 12:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545307774;
        bh=dqdD+RmKFF+2dTsrex+AEvi3AloS91FyuV2R77Db2N4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ax0ZlFwDRXxps02aFvoqK11vvGxBiU0tmOCZScI39c9Z/uavTAy0H/TBPqsoXxAhk
         0cyP8ExfM7StbfLcJDweox6HkGEVHs3lFyv4hrxYy1FyuNXztXf460/dNKFVWBMaYl
         lIX+Ni5XxsAMUijUvbCUq6JQMeXFT2qUcneYrLIE=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B5F416074E;
        Thu, 20 Dec 2018 12:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545307773;
        bh=dqdD+RmKFF+2dTsrex+AEvi3AloS91FyuV2R77Db2N4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=hRT63x43YMo/dLKZtBCDyAZ+weVUr6y/NDmUXn0mH4GgfCYsDaTrIIgP2ymTEJCwU
         BIK7gebEXDPTKDTzqnWLDJwM6bQbnBl2Vl1M98ptjUiRrz72ZB1K3XqdrIWDAiEg38
         51/iTiT8S6qR/MrxZ/OswMZMIXAkrFhH/KdpX3+A=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B5F416074E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Bhagavathi Perumal S <bperumal@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k: Fix warning due to msdu limit error
References: <1542613703-9704-1-git-send-email-bperumal@codeaurora.org>
Date:   Thu, 20 Dec 2018 14:09:30 +0200
In-Reply-To: <1542613703-9704-1-git-send-email-bperumal@codeaurora.org>
        (Bhagavathi Perumal S.'s message of "Mon, 19 Nov 2018 13:18:23 +0530")
Message-ID: <87tvj8tn5x.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Bhagavathi Perumal S <bperumal@codeaurora.org> writes:

> Some hardwares variants(QCA99x0) are limiting msdu deaggregation with
> some threshold value(default limit in QCA99x0 is 64 msdus), it was introduced to
> avoid excessive MSDU-deaggregation in error cases. When number of sub frames
> exceeds the limit, target hardware will send all msdus starting from present
> msdu in RAW format as a single msdu packet and it will be indicated with
> error status bit "RX_MSDU_END_INFO0_MSDU_LIMIT_ERR" set in rx descriptor.
> This msdu frame is a partial raw MSDU and does't have first msdu and ieee80211
> header. It caused below warning message.
>
> [  320.151332] ------------[ cut here ]------------
> [  320.155006] WARNING: CPU: 0 PID: 3 at drivers/net/wireless/ath/ath10k/htt_rx.c:1188
>
> In our issue case, MSDU limit error happened due to FCS error and generated
> this warning message.
>
> This fixes the warning by handling the MSDU limit error. If msdu limit error
> happens, driver adds first MSDU's ieee80211 header and sets A-MSDU present bit
> in QOS header so that upper layer processes this frame if it is valid or drop it
> if FCS error set. And removed the warning message, hence partial msdus without
> first msdu is expected in msdu limit error cases.
>
> Tested on QCA9984, Firmware 10.4-3.6-00104
>
> Signed-off-by: Bhagavathi Perumal S <bperumal@codeaurora.org>

This introduced a new checkpatch warning:

drivers/net/wireless/ath/ath10k/rx_desc.h:681: please, no space before tabs

I fixed that in the pending branch.

-- 
Kalle Valo
