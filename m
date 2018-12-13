Return-Path: <SRS0=opxv=OW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E077C67839
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 14:58:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE2DB2086D
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 14:58:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="QvoJyDy0";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="OyavkH5H"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BE2DB2086D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728822AbeLMO6i (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 13 Dec 2018 09:58:38 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:48216 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728584AbeLMO6i (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Dec 2018 09:58:38 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id DDF176071A; Thu, 13 Dec 2018 14:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544713117;
        bh=d8K2DVzj1Fvv6RUuYDU2nvujuPUCDmEMQMf7ndYNT8E=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=QvoJyDy0k38f+d5O8DVmdJcoEmojBvzX8sxPPu8SaIkJIzg5ag3e+ap59Z2Fj3riu
         4CYnMi9ejgFb4Qum6zIa2Hb2/0UJ4qXnPxICnK18puJeclwSAMffF0MF/NYJx5P+9+
         2A/NT+udwNO8LMl+pA928T0pzO7i5dyENEG8O/mg=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 683FA601D7;
        Thu, 13 Dec 2018 14:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544713117;
        bh=d8K2DVzj1Fvv6RUuYDU2nvujuPUCDmEMQMf7ndYNT8E=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=OyavkH5H5F822EgxYi4wPnrmfyWAzTQ2zB8WEvIPthtX/+qy/qFrinkf+atAih9hE
         vlSfje0xLJ2IpMQ4re+kLIQri0Z902iJ5oWJllpAo0nveRa35fiLb599+wy6p7Calb
         hLN6aeo/Up520y/UU8CaOdUkS7k4zs4wduBpApR4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 683FA601D7
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH V4 1/8] brcmfmac: add 4354 raw pcie device id
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1542786800-146083-2-git-send-email-chi-hsien.lin@cypress.com>
References: <1542786800-146083-2-git-send-email-chi-hsien.lin@cypress.com>
To:     Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Winnie Chang <Winnie.Chang@cypress.com>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181213145837.DDF176071A@smtp.codeaurora.org>
Date:   Thu, 13 Dec 2018 14:58:37 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com> wrote:

> From: Winnie Chang <winnie.chang@cypress.com>
> 
> Add the raw 4354 PCIe device ID for unprogrammed Cypress boards.
> 
> Reviewed-by: Arend Van Spriel <arend@broadcom.com>
> Signed-off-by: Winnie Chang <winnie.chang@cypress.com>
> Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>

8 patches applied to wireless-drivers-next.git, thanks.

eb6b33bfb8f5 brcmfmac: add 4354 raw pcie device id
e1a08730eeb0 brcmfmac: set F2 watermark to 256 for 4373
58e4bbea0c1d brcmfmac: set SDIO F1 MesBusyCtrl for CYW4373
35cb51b2162a brcmfmac: add support for CYW43012 SDIO chipset
b021a6bc1175 brcmfmac: allow GCI core enumuration
f95a8d9c6aca brcmfmac: update 43012 F2 watermark setting to fix DMA Error during UDP RX Traffic
2f2d389efda4 brcmfmac: 4373 save-restore support
29f6589140a1 brcmfmac: disable command decode in sdio_aos

-- 
https://patchwork.kernel.org/patch/10692071/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

