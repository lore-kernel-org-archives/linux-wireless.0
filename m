Return-Path: <SRS0=X78v=DI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5901AC4727C
	for <linux-wireless@archiver.kernel.org>; Thu,  1 Oct 2020 13:29:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E0D020759
	for <linux-wireless@archiver.kernel.org>; Thu,  1 Oct 2020 13:29:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="dBG1ROtT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732230AbgJAN26 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 1 Oct 2020 09:28:58 -0400
Received: from m42-4.mailgun.net ([69.72.42.4]:10807 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732016AbgJAN25 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Oct 2020 09:28:57 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1601558937; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=fE++3/ie3cIRDvVj3xrUA5Hv0AvaLq6A86WkYmYj+60=;
 b=dBG1ROtTy/UFy7x9DvVVgaHCccNwhhJ9ShXXArea5PcZKa9gV1DEnB5Fyt4Uv99Ln06HP+sO
 uUH+/SPyVDfSWM/IrVpQtwQzO5z7Bdqw1Jyq62ibHLFZQ//LQM6NQCBeA8qmXKGty2PhBUjf
 clb1G2mv5OlGOpsdqoJxR5jvtb4=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 5f75d999f4f360f889b1a70d (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 01 Oct 2020 13:28:57
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 57A09C433C8; Thu,  1 Oct 2020 13:28:56 +0000 (UTC)
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5A6A9C433CA;
        Thu,  1 Oct 2020 13:28:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5A6A9C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] rtw88: pci: Power cycle device during shutdown
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200928165508.20775-1-kai.heng.feng@canonical.com>
References: <20200928165508.20775-1-kai.heng.feng@canonical.com>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     yhchuang@realtek.com, briannorris@chromium.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org (open list:REALTEK WIRELESS DRIVER
        (rtw88)), netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20201001132856.57A09C433C8@smtp.codeaurora.org>
Date:   Thu,  1 Oct 2020 13:28:56 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Kai-Heng Feng <kai.heng.feng@canonical.com> wrote:

> There are reports that 8822CE fails to work rtw88 with "failed to read DBI
> register" error. Also I have a system with 8723DE which freezes the whole
> system when the rtw88 is probing the device.
> 
> According to [1], platform firmware may not properly power manage the
> device during shutdown. I did some expirements and putting the device to
> D3 can workaround the issue.
> 
> So let's power cycle the device by putting the device to D3 at shutdown
> to prevent the issue from happening.
> 
> [1] https://bugzilla.kernel.org/show_bug.cgi?id=206411#c9
> 
> BugLink: https://bugs.launchpad.net/bugs/1872984
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>

Patch applied to wireless-drivers-next.git, thanks.

44492e70adc8 rtw88: pci: Power cycle device during shutdown

-- 
https://patchwork.kernel.org/patch/11804271/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

