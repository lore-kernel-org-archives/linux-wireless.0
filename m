Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E854C282C2
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 14:51:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0BAC021872
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 14:51:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="OkErhOd+";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="RFcNv6bx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbfBGOvn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 09:51:43 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:54714 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726348AbfBGOvn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 09:51:43 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 9714460247; Thu,  7 Feb 2019 14:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549551102;
        bh=r54P4UdAAxS94c7R1GR6rInY7sRWYJpGKzbIDH9haAg=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=OkErhOd+k9J7yJ9VMka4j3Ja648scPM2Dyy8JtUxhpAN3o0ljBf2x78evxMTsg7JJ
         zHxb6xl/SJgYp/JfxxLlsSfwhuT+4RGYO5pAWmXcbPV3wohk8xZLRkE6+M6ul+H+Zz
         y1+y+zIlXfPxw1MDGsHHcjXA60UFwReBy3L4DVBw=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D810B60247;
        Thu,  7 Feb 2019 14:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549551101;
        bh=r54P4UdAAxS94c7R1GR6rInY7sRWYJpGKzbIDH9haAg=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=RFcNv6bxQ1lSdrVgyI65V63Q3LqRjY0OPX7l7Y743iT1KutSybixqLKVviZEQqIk2
         APNYB8O5gzNtFvqQaSxT5hfywwoWqEAAu6ia2+aSW8/ENbCs46boc4wfhLsJM6O/ns
         5tC7+e7r9HTlV4Tlo/Y5R4jGv1v4eKdbnCsSqFOk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D810B60247
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: Fix hw-restart crash inject mode for WCN3990
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1548753967-2233-1-git-send-email-pillair@codeaurora.org>
References: <1548753967-2233-1-git-send-email-pillair@codeaurora.org>
To:     Rakesh Pillai <pillair@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Rakesh Pillai <pillair@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190207145142.9714460247@smtp.codeaurora.org>
Date:   Thu,  7 Feb 2019 14:51:42 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rakesh Pillai <pillair@codeaurora.org> wrote:

> The hw-restart crash inject mode is a special mode, where
> there is no crash generated in the firmware, but instead
> the driver restarts the firmware. In order to restart WCN3990
> firmware, the driver needs to send qmi_wlan_disable message
> followed by the qmi_wlan_enable message to the WCN3990 firmware.
> 
> Currently the qmi_wlan_disable message is not sent to
> the WCN3990 firmware when hw-restart crash is injected,
> which causes the firmware to crash when the driver sends
> qmi_wlan_enable message during ath10k_restart.
> 
> Send qmi_wlan_disable to the WCN3990 firmware when the
> hw-restart crash is injected via debugfs.
> 
> Tested HW: WCN3990
> Tested FW: WLAN.HL.2.0-01188-QCAHLSWMTPLZ-1
> 
> Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

cdb78e5af491 ath10k: fix hw-restart crash inject mode for WCN3990

-- 
https://patchwork.kernel.org/patch/10785855/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

