Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37372C282C2
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 16:36:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0391D218D3
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 16:36:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="mt0yEsc1";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="dSFSIy59"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbfBGQgj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 11:36:39 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:59762 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbfBGQgj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 11:36:39 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 63271607DD; Thu,  7 Feb 2019 16:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549557398;
        bh=EjyutQgfk+AGr9nw2DasFL6T5CLoUUw8zacHWRnlwoQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=mt0yEsc1ijxsWvOmm4emB9W5WvOnZglnHSbeVfJotuacDaspt6scTjrfflQqfM8Vm
         nwGhyMmnBq0wsvv+bz6wke2AXZ976quE4RRgPXSn780rwBGqS659V8YHjSkQhcbVWL
         dRsgPRWVq8+ndFFZtMkf7AKvLRWR+AbMD/Lu8vuk=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9FC5460134;
        Thu,  7 Feb 2019 16:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549557398;
        bh=EjyutQgfk+AGr9nw2DasFL6T5CLoUUw8zacHWRnlwoQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=dSFSIy59kjU5slz69Ib1NUy5rhiskjXRl48iA5qD6KIonZpERKbvDHR6eVzqnUI/Q
         Aj07HsP8pa9vkzA5dmJXILFs9lkzoOqw2y07kTNXHaksclmK0Hy+wrtqFVkRwSaKSi
         nFntKxJs6Aj1aqZKM8Uit50+7ItNL2S4veQNzUTg=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9FC5460134
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] brcmfmac: support monitor frames with hardware/ucode
 header
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190122110858.12993-1-zajec5@gmail.com>
References: <20190122110858.12993-1-zajec5@gmail.com>
To:     =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190207163638.63271607DD@smtp.codeaurora.org>
Date:   Thu,  7 Feb 2019 16:36:38 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rafał Miłecki wrote:

> From: Rafał Miłecki <rafal@milecki.pl>
> 
> The new FullMAC firmwares for 4366b1/4366c0 were supposed to provide
> monitor frames with radiotap header but it doesn't seem to be the case.
> Testing the latest release resulted in discovering a new format being
> used. It seems (almost?) identical to the one known from ucode used in
> SoftMAC devices which is most likely the same codebase anyway.
> 
> While radiotap support was meant to be announced with the "rtap" fw
> capability string it seems no alternative was added for the hw/ucode
> format. It means each firmware requires a feature mapping quirk.
> 
> As for now only an empty radiotap is being created. Adding support for
> extracting some info (band, channel, signal, etc.) is planned for the
> future.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>

It's unclear what I should do with this patch, take it?

-- 
https://patchwork.kernel.org/patch/10775371/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

