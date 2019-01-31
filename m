Return-Path: <SRS0=jXAT=QH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20AB5C169C4
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 16:56:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB186218AF
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 16:56:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="M8aGXDbo";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="lyEydgd5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731099AbfAaQ4e (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Jan 2019 11:56:34 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:60018 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727022AbfAaQ4d (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Jan 2019 11:56:33 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id CB38760A08; Thu, 31 Jan 2019 16:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548953792;
        bh=Dh7ziWrPn+PtdPEjZJiFZAnq8APoTdoY76JPdb4lFhg=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=M8aGXDbopXjHCqmOvwjHN3czFsbx1IlYqKHNoDrGjilM1ecFdcCuyFRhOj1zVuNqY
         C3r52BNvlgwNBRmGLAvGmDXkbuOzWgmg1vs0e8c+ArgdAfaJglJ8EuOgbTRsOtBYVm
         62ub1+BjxtB3zX0rCXcyGpwJI6wv5LKMT9GIU4kE=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0844860907;
        Thu, 31 Jan 2019 16:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548953792;
        bh=Dh7ziWrPn+PtdPEjZJiFZAnq8APoTdoY76JPdb4lFhg=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=lyEydgd5xROr8bPz1KIHDmyFX8ufjUqgDbGifQD4uSiPcUuCQ3dMrWWjeVt/mXGFC
         jmoWjcxOq3jKPk4r+VY2pbsj6yg8Tiunqury7nd1pTAP/0+ba5z0oaEvMx8vGDT1oQ
         6Ut5GUn3lT9Y2IHI1ypCFWXEw7+AZUTA5scPxZT4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0844860907
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH wireless-drivers] mt76x0: eeprom: fix chan_vs_power map in
 mt76x0_get_power_info
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <44789d3d0dee6e2e0bb7d75f755927d415aa56d4.1548587542.git.lorenzo.bianconi@redhat.com>
References: <44789d3d0dee6e2e0bb7d75f755927d415aa56d4.1548587542.git.lorenzo.bianconi@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     linux-wireless@vger.kernel.org, nbd@nbd.name, sgruszka@redhat.com
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190131165632.CB38760A08@smtp.codeaurora.org>
Date:   Thu, 31 Jan 2019 16:56:32 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:

> Report correct eeprom per channel power value.
> Fix chan_vs_power map in mt76x0_get_power_info routine
> 
> Fixes: f2a2e819d672 ("mt76x0: remove eeprom dependency from mt76x0_get_power_info")
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

Patch applied to wireless-drivers.git, thanks.

05672636b339 mt76x0: eeprom: fix chan_vs_power map in mt76x0_get_power_info

-- 
https://patchwork.kernel.org/patch/10782801/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

