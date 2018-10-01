Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD010C43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 13:56:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 93A7B208AE
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 13:56:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="i9VKB6CL";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="isxqdPfW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 93A7B208AE
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729332AbeJAUes (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 16:34:48 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:53044 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729134AbeJAUes (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 16:34:48 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 9038260AD8; Mon,  1 Oct 2018 13:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538402212;
        bh=tPgcqRFtiBweNyOpzZ/vThPsL+dCA4fSA5zVvcNpzR4=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=i9VKB6CL8RyYtytAh6LGcHs6bYBafAsMRlq+83kEG+mtZsnf4s4IYnHONsixkTofM
         xi5z+87v75+5E54FK+NORP+9Nr43ZF/0fq1aUEtKgq42+SRRoh6uqEnkA6niKl2Cmr
         k1jJx9PfBVJjx+AUxriosG2mVQeocH69C95deR+w=
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 220116079B;
        Mon,  1 Oct 2018 13:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538402212;
        bh=tPgcqRFtiBweNyOpzZ/vThPsL+dCA4fSA5zVvcNpzR4=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=isxqdPfWg4YB9HSfI80Xi3TX/cygUhSFVjj7ltu/TGdJ0J3uVMW2tnzMv2ax7EZS0
         D2UJXkKZAtbqmLsTz+Rt65M6eh/elDuLsqkUj6U433mB/eTbphgtFOLlKQKLoUzhBX
         4jIURsw+oQQNnDVtCFBvo57BnUKU8W2KiLiu+qhk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 220116079B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: Add support for configuring management packet rate
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1536557980-11895-1-git-send-email-srirrama@codeaurora.org>
References: <1536557980-11895-1-git-send-email-srirrama@codeaurora.org>
To:     Sriram R <srirrama@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Sriram R <srirrama@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181001135652.9038260AD8@smtp.codeaurora.org>
Date:   Mon,  1 Oct 2018 13:56:52 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Sriram R <srirrama@codeaurora.org> wrote:

> By default the firmware uses 1Mbps and 6Mbps rate for management packets
> in 2G and 5G bands respectively. But when the user selects different
> basic rates from the userspace, we need to send the management
> packets at the lowest basic rate selected by the user.
> 
> This change makes use of WMI_VDEV_PARAM_MGMT_RATE param for configuring the
> management packets rate to the firmware.
> 
> Chipsets Tested : QCA988X, QCA9887, QCA9984
> FW Tested 	: 10.2.4-1.0-41, 10.4-3.6.104
> 
> Signed-off-by: Sriram R <srirrama@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

f279294e9ee2 ath10k: add support for configuring management packet rate

-- 
https://patchwork.kernel.org/patch/10593571/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

