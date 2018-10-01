Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FD4EC43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 15:39:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1ADAE208D9
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 15:39:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="kZzmUgvv";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="VUj2a22C"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1ADAE208D9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725985AbeJAWRz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 18:17:55 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:41356 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725266AbeJAWRz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 18:17:55 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 6AF7D60A98; Mon,  1 Oct 2018 15:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538408372;
        bh=oruiY8HtEwCf55n1U1GP7fLjKgj1HY8Fz4U8DUyxNXo=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=kZzmUgvvatEl2cnjUrotfLUHOIVDltHZPujVA+ITwcPKKVRHhgOixdwCI5qNXeit+
         l7D4W8LOSH5AkAV+sya3WkU4eDSDQMU55k/q0d9gGpJpuWgEb0B8L2xzmLD4cpebd4
         c5tmB9lGKJNcCvTDZyr+PCsUgLF6y+5LX0yF35Kc=
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 14355601A0;
        Mon,  1 Oct 2018 15:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538408372;
        bh=oruiY8HtEwCf55n1U1GP7fLjKgj1HY8Fz4U8DUyxNXo=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=VUj2a22CaruXSc/mbSYx7IZ1Zl3hmlM+NldN8UnM9OfAdX7xbUaPsG0s/T7k7iPcm
         u6MSZ/nOgkMAmzj5be+2dlQkji58ytYOjvfi98FSNbA/sG6XMdpM4zmZegUQvb6yZL
         7MSqsxpQfXtJJqEhAzAmNIuQFsVxqHpNYnResFD4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 14355601A0
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/5] rt2800: move usb specific txdone/txstatus routines to
 rt2800lib
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1537957497-7790-2-git-send-email-sgruszka@redhat.com>
References: <1537957497-7790-2-git-send-email-sgruszka@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     linux-wireless@vger.kernel.org,
        Daniel Golle <daniel@makrotopia.org>,
        Mathias Kresin <dev@kresin.me>, Felix Fietkau <nbd@nbd.name>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181001153932.6AF7D60A98@smtp.codeaurora.org>
Date:   Mon,  1 Oct 2018 15:39:32 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Stanislaw Gruszka <sgruszka@redhat.com> wrote:

> In order to reuse usb txdone/txstatus routines for mmio, move them
> to common rt2800lib.c file.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

5 patches applied to wireless-drivers-next.git, thanks.

5c656c71b1bf rt2800: move usb specific txdone/txstatus routines to rt2800lib
0b0d556e0ebb rt2800mmio: use txdone/txstatus routines from lib
5022efb50f62 rt2x00: do not check for txstatus timeout every time on tasklet
adf26a356f13 rt2x00: use different txstatus timeouts when flushing
0240564430c0 rt2800: flush and txstatus rework for rt2800mmio

-- 
https://patchwork.kernel.org/patch/10615575/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

