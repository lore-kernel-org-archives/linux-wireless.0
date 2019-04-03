Return-Path: <SRS0=OUAD=SF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21F96C4360F
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 12:46:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E637C20830
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 12:46:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="GoVsFwgA";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="km7gGuvZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726183AbfDCMqz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Apr 2019 08:46:55 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:33614 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbfDCMqy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Apr 2019 08:46:54 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C9C9960ADE; Wed,  3 Apr 2019 12:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554295613;
        bh=TxQoXv/i3BtIyXBofYhol/tqfvvtAgYV8a1AdfLX15Q=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=GoVsFwgANdYhM5tKQy7UhUnK15lMsCwmkQZFWFRnMlICLa37WPYUWmuOcJcDbFLCW
         YgIINLFQYbWj7l5wVwGUzE4hq5hQebIao5VAa1vAOOggdcawk3QHE5WwZwaXuZASpo
         y2jJulLfHEXfeDFUi+kAF4OzIEFGrA1Pcv+/7tOc=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AE72160ADE;
        Wed,  3 Apr 2019 12:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554295613;
        bh=TxQoXv/i3BtIyXBofYhol/tqfvvtAgYV8a1AdfLX15Q=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=km7gGuvZPPbKRjBzu+7Co34uEymm0XviDvEwXvaj/Jdby4S7Ohd40U/dQg0wJDddZ
         RLtviijl2PERisy1Ib6fI3CyOkhvKQzI/iSC8nWDzh28ry7qhbCQGmwCgEVnf6gVzQ
         rs6CALvp0ZZIjLKybWQJNg/OCSxYQKN5Yfst3JEY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org AE72160ADE
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 16/21] wil6210: fix report of rx packet checksum in edma
 mode
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1550845279-16103-17-git-send-email-merez@codeaurora.org>
References: <1550845279-16103-17-git-send-email-merez@codeaurora.org>
To:     Maya Erez <merez@codeaurora.org>
Cc:     Ahmad Masri <amasri@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        Maya Erez <merez@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190403124653.C9C9960ADE@smtp.codeaurora.org>
Date:   Wed,  3 Apr 2019 12:46:53 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Maya Erez <merez@codeaurora.org> wrote:

> Update the rx packet checksum of received packet according to edma
> HW spec:
> 
> No need to calculate checksum in the following cases:
> L4_status=0 and L3_status=0 - No L3 and no L4 known protocols found
> L4_status=0 and L3_status=1 - L3 was found, and checksum check passed.
> No known L4 protocol was found.
> L4_status=1 - L4 was found, and checksum check passed.
> 
> Recalculate checksum in the following cases:
> L4_status=3 and L3_status=1 - It means that L3 protocol was found,
> and checksum passed, but L4 checksum failed.
> L4_status=3 and L3_status=2	- Both L3 and L4 checksum check failed.
> 
> Signed-off-by: Ahmad Masri <amasri@codeaurora.org>
> Signed-off-by: Maya Erez <merez@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

6 patches applied to ath-next branch of ath.git, thanks.

4bf019865cf3 wil6210: fix report of rx packet checksum in edma mode
49122ec42634 wil6210: fix return code of wmi_mgmt_tx and wmi_mgmt_tx_ext
1683a001d5bf wil6210: prevent access to RGF_CAF_ICR in Talyn
8454e72a3644 wil6210: add support for ucode tracing
b4a967b7d0f5 wil6210: reset buff id in status message after completion
fa0b735414f9 wil6210: print error in FW and board files load failures

-- 
https://patchwork.kernel.org/patch/10826135/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

