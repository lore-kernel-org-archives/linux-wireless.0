Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E254C43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 14:48:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0578E20C0A
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 14:48:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ZcWmt+A0";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="WcD02eBu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0578E20C0A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729463AbeJAV0d (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 17:26:33 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:55860 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729420AbeJAV0d (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 17:26:33 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id EA8986081B; Mon,  1 Oct 2018 14:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538405302;
        bh=US77tWh7/1VhnT3Cr27k+5TEn3Lb2qUV/QrqjwhqP34=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=ZcWmt+A0wwnlnga1YG/uPdLNJRjM76Vy4p4f4A+9A+3uXvh8Clobb+nhwL3S7kC3r
         H4bOi/lUaehzzkO2mlCijrhJzs8hNv3XfnDMCINHLp/LS6Wo1jMHIQsRRiKGdMp8vN
         /nBd80YNRG+WHTbzpSTklOCzWTnVgOC3c28BmW+o=
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 72CA96035F;
        Mon,  1 Oct 2018 14:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538405302;
        bh=US77tWh7/1VhnT3Cr27k+5TEn3Lb2qUV/QrqjwhqP34=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=WcD02eBuOYXnlQAEgBXtOMTaqFz3qIsitNCBwQt2+2lGM34yfasN7WuXWm6OT5+tQ
         F1MjNmp3ltsZCUfgPMBTwEIW935dZuJUeAmBEsLNCNXgd35LX++X0NnZyrkiJZYsp+
         kC7fhNWsbJfsoY2Sy+wvh74dAIYp7mx5vBgHpcFE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 72CA96035F
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] ath10k: Add support for configuring management packet
 rate
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1537853898-3793-1-git-send-email-srirrama@codeaurora.org>
References: <1537853898-3793-1-git-send-email-srirrama@codeaurora.org>
To:     Sriram R <srirrama@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Sriram R <srirrama@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181001144822.EA8986081B@smtp.codeaurora.org>
Date:   Mon,  1 Oct 2018 14:48:22 +0000 (UTC)
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

Really sorry, I missed this and accidentally applied v1. Can you submit a followup
patch with the changes you made in v2, please? That way the final code is still
the same.

-- 
https://patchwork.kernel.org/patch/10613355/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

