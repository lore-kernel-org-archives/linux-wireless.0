Return-Path: <SRS0=Ms0V=QP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 148BAC169C4
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 15:27:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4C622075C
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 15:27:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="B/8SRHDZ";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="NiiSK8ys"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727629AbfBHP1w (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Feb 2019 10:27:52 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:32770 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727559AbfBHP1v (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Feb 2019 10:27:51 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C9CBD60ADA; Fri,  8 Feb 2019 15:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549639671;
        bh=YzZLORCB1iHky3AJNLJ64WVtr/SfaGaASyQPSqNiHFA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=B/8SRHDZBNnYU0uiSbholwQo6HsuRf7r+CsYKJ1CDj2DifIjw8vn6EJbYBPsJyfNB
         KPzUfJJaJK6mSp3d3Ol8NE2w5Syvle0Tpfkfbh5nE/QkQTCshNJUhRqjpM8fndAnxu
         rRPaLlGKIXac3ZVbWBS0Bpecc8x5wRbOMWnoURgU=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DBBCA6092B;
        Fri,  8 Feb 2019 15:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549639668;
        bh=YzZLORCB1iHky3AJNLJ64WVtr/SfaGaASyQPSqNiHFA=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=NiiSK8yss3eLQGEyFkvsUk/2ZDMaAWEPWiRs4IxJNxAoIVPakPy6Etw3Zcc/oyuhN
         TUAhF1397gfAxY4xWFTujMVbQW46jpF0thSBF2nxRHRSUg03tMtfbTZmTuKE8bvY2r
         C6IiEiHeePZK7nnKfi/tYKEX4Tf0Sz/JEahKiKh0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DBBCA6092B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V2] brcmfmac: support monitor frames with the
 hardware/ucode header
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190208064230.27775-1-zajec5@gmail.com>
References: <20190208064230.27775-1-zajec5@gmail.com>
To:     =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190208152750.C9CBD60ADA@smtp.codeaurora.org>
Date:   Fri,  8 Feb 2019 15:27:50 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rafał Miłecki wrote:

> From: Rafał Miłecki <rafal@milecki.pl>
> 
> So far there were two monitor frame formats:
> 1) 802.11 frames (with frame (sub)type & all addresses)
> 2) 802.11 frames with the radiotap header
> 
> Testing the latest FullMAC firmwares for 4366b1/4366c0 resulted in
> discovering a new format being used. It seems (almost?) identical to the
> one known from ucode used in SoftMAC devices which is most likely the
> same codebase anyway.
> 
> While new firmwares will /announce/ radiotap header support using the
> "rtap" fw capability string it seems no string was added for the new
> ucode header format.
> 
> All above means that:
> 1) We need new format support when dealing with a received frame
> 2) A new feature bit & mapping quirks have to be added manually
> 
> As for now only an empty radiotap is being created. Adding support for
> extracting some info (band, channel, signal, etc.) is planned for the
> future.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Patch applied to wireless-drivers-next.git, thanks.

e665988be29c brcmfmac: support monitor frames with the hardware/ucode header

-- 
https://patchwork.kernel.org/patch/10802433/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

