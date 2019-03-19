Return-Path: <SRS0=Jk3u=RW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C4EDC4360F
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 15:36:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D69420651
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 15:36:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="W7jrHeSD";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="hjva2Xub"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727508AbfCSPgH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Mar 2019 11:36:07 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:54290 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726831AbfCSPgE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Mar 2019 11:36:04 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 4EDE0611C5; Tue, 19 Mar 2019 15:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553009763;
        bh=knbhwOWFu3QV5d1kmN28ioDQtmIZn9z0Tb/5RU4XZQg=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=W7jrHeSDr7Xgxt0NJlayEwupem7Po7CCDgjAyFjhKje0mBmqv9/eSxpo0bB5vbn16
         OjOTEyUb3h55uENUAxCMbMkT8rs+GUyN7Ye6H/SYmzvLeJNQyyamgAB0+Xs+l4pFFB
         lDjI68Kfm3mmO3+AGKaTXEth3zHXUdOy02dSeQt4=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B88D060DB3;
        Tue, 19 Mar 2019 15:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553009762;
        bh=knbhwOWFu3QV5d1kmN28ioDQtmIZn9z0Tb/5RU4XZQg=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=hjva2XubzWJA3l73iZlh2GqVnDZwbHS17ll9hv4gS2JEASeAfrfNbWFdPSOHy64Ow
         4IB6ajVFdOOmKHQv6csJLQSg/UTLb1kqpufoS75fOED7LFoVc5LxlZ+YIzjsOHo6jM
         l8TvDf9oTQ1+LgBOqQtOWlltSCLHOpRWZWewaEcY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B88D060DB3
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mt76: mt7603: use the correct hweight8() function
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190311130953.61869-1-nbd@nbd.name>
References: <20190311130953.61869-1-nbd@nbd.name>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190319153603.4EDE0611C5@smtp.codeaurora.org>
Date:   Tue, 19 Mar 2019 15:36:03 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Felix Fietkau <nbd@nbd.name> wrote:

> __sw_hweight8() is only defined if CONFIG_GENERIC_HWEIGHT is enabled.
> The function that works on all architectures is hweight8().
> 
> Signed-off-by: Felix Fietkau <nbd@nbd.name>

Patch applied to wireless-drivers.git, thanks.

f2a00a821aac mt76: mt7603: use the correct hweight8() function

-- 
https://patchwork.kernel.org/patch/10847433/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

