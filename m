Return-Path: <SRS0=nAss=VM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 116A8C7618F
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Jul 2019 17:53:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2949206B8
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Jul 2019 17:53:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="LFxO1yF7";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="cDwpdQkD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731866AbfGORxW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Jul 2019 13:53:22 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:39402 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729941AbfGORxW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Jul 2019 13:53:22 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id CE23960DAB; Mon, 15 Jul 2019 17:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1563213200;
        bh=k3ChXNGFsdifjWHghdc8vll8SaEiy7GjD6ulRqw0jUI=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=LFxO1yF75FS88d5JZ3LUAa0SmYA2pEpKmFPCJrgCLmworScqTo8JW+wc64doREbdv
         oDWunoFpjRAH6aE+YWyLkT78+6pDlWYrEyP00af0PGtTphGXhNDK6BqoBsW2Gqi5Ub
         P+pvw0N4ztcpUMLCoeTJKhkzLKuuAv9RQ8ffn9Fg=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2DA126021C;
        Mon, 15 Jul 2019 17:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1563213200;
        bh=k3ChXNGFsdifjWHghdc8vll8SaEiy7GjD6ulRqw0jUI=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=cDwpdQkDT5wTNPfSYWupIoTmE1U4CZ2+pArU4+dPINW+6BDPBL5Jee68BnoWy8OSX
         42eDWNAbZGj/IiKj1aRiHpnRPhyY0kUpT32+DtvMPiRAUpFh8QxlASn1zatL8UiT+N
         VYtXYcLnkllOaLFhNFW+HKo+FojFrVEBfa6FLDCk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2DA126021C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 1/2] rt2x00usb: fix rx queue hang
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190701105314.9707-1-smoch@web.de>
References: <20190701105314.9707-1-smoch@web.de>
To:     Soeren Moch <smoch@web.de>
Cc:     Stanislaw Gruszka <sgruszka@redhat.com>,
        Soeren Moch <smoch@web.de>, stable@vger.kernel.org,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190715175320.CE23960DAB@smtp.codeaurora.org>
Date:   Mon, 15 Jul 2019 17:53:20 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Soeren Moch <smoch@web.de> wrote:

> Since commit ed194d136769 ("usb: core: remove local_irq_save() around
>  ->complete() handler") the handler rt2x00usb_interrupt_rxdone() is
> not running with interrupts disabled anymore. So this completion handler
> is not guaranteed to run completely before workqueue processing starts
> for the same queue entry.
> Be sure to set all other flags in the entry correctly before marking
> this entry ready for workqueue processing. This way we cannot miss error
> conditions that need to be signalled from the completion handler to the
> worker thread.
> Note that rt2x00usb_work_rxdone() processes all available entries, not
> only such for which queue_work() was called.
> 
> This patch is similar to what commit df71c9cfceea ("rt2x00: fix order
> of entry flags modification") did for TX processing.
> 
> This fixes a regression on a RT5370 based wifi stick in AP mode, which
> suddenly stopped data transmission after some period of heavy load. Also
> stopping the hanging hostapd resulted in the error message "ieee80211
> phy0: rt2x00queue_flush_queue: Warning - Queue 14 failed to flush".
> Other operation modes are probably affected as well, this just was
> the used testcase.
> 
> Fixes: ed194d136769 ("usb: core: remove local_irq_save() around ->complete() handler")
> Cc: stable@vger.kernel.org # 4.20+
> Signed-off-by: Soeren Moch <smoch@web.de>
> Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>

Patch applied to wireless-drivers.git, thanks.

41a531ffa4c5 rt2x00usb: fix rx queue hang

-- 
https://patchwork.kernel.org/patch/11025561/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

