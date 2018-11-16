Return-Path: <SRS0=ZGUU=N3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CC23C43441
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Nov 2018 07:00:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E5F4B20818
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Nov 2018 07:00:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="VsjcGnCM";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Wd6kMrPw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E5F4B20818
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbeKPRLk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 16 Nov 2018 12:11:40 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:47124 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727380AbeKPRLk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Nov 2018 12:11:40 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 52E766085F; Fri, 16 Nov 2018 07:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542351632;
        bh=mywOIvUMnj6eiOLWZfPFWaWoDxxWD97muw0JSwPubqs=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=VsjcGnCMXYzAINY/rJeNLwwKhYzN5IZ7fUfjzHOLBsrJkIUGxPqyjUjayAJx83taR
         6BOxeyNer0TecGAQEBNmm2GsdlB61BNmYoACxNIeMW1koIcpw5qhFq5D47rzRnYQD9
         WToIggSzwrz8XJzrwQIacSb1ZkW0ImoFKjDzshwM=
Received: from x230.qca.qualcomm.com (87-95-226-75.bb.dnainternet.fi [87.95.226.75])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 439C360452;
        Fri, 16 Nov 2018 07:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542351631;
        bh=mywOIvUMnj6eiOLWZfPFWaWoDxxWD97muw0JSwPubqs=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Wd6kMrPwi0nx/RIJihFRa3LM5r2QmKv+fJ46ynE6MpoQOzrLwd9Dse0uMlHZt5IVz
         kgF16O2d/IsVTPWSWtaaOjb9sxxP1E4wke0dzE77CPP61mwG7VRK5lzNfZoqdeADas
         5K9/Hl3/4XcyiOOI7d64x5fHc75gpyFwZVZ3Aaqo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 439C360452
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     Wen Gong <wgong@qti.qualcomm.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k\@lists.infradead.org" <ath10k@lists.infradead.org>,
        Wen Gong <wgong@codeaurora.org>
Subject: Re: [PATCH] ath10k: support PCIe enter L1 state
References: <1542163848-837-1-git-send-email-wgong@codeaurora.org>
        <20181115002836.GA71934@google.com>
        <c94346b26a6d4b11a045a176ca854051@aptaiexm02f.ap.qualcomm.com>
        <20181115184333.GA87504@google.com>
Date:   Fri, 16 Nov 2018 09:00:27 +0200
In-Reply-To: <20181115184333.GA87504@google.com> (Brian Norris's message of
        "Thu, 15 Nov 2018 10:43:33 -0800")
Message-ID: <87va4x8q2c.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Brian Norris <briannorris@chromium.org> writes:
> On Thu, Nov 15, 2018 at 06:38:25AM +0000, Wen Gong wrote:
>> > 
>> > Is there some reason L1 was disabled in the first place? Was it known to be
>> > unreliable?
>>
>> Hi Brian,
>> It is a BUG for power, and it is not considered this BUG before.
>> So this change will fix the bug.
>
> I understand that the existing behavior is suboptimal for power, but on
> the other hand, code that goes out of its way to *clear* the L1 flag
> doesn't just pop up out of nowhere. Somebody clearly wrote that! If it
> just meant "we didn't verify L1 at first", then maybe it's fine to
> enable it unconditionally and see what happens, but if it meant "we
> tried L1 on some old chip XXXX and it caused problems", then it would be
> nice to know what those problems were.
>
> Or maybe that is hard to figure out, given there's no public git history
> tracking the original code, and we just need to try it out.

Yeah, it seems L1 was disabled already on the first ath10k commit:

5e3dd157d7e70 (Kalle Valo                2013-06-12 20:52:10 +0300 2404)        pcie_config_flags &= ~PCIE_CONFIG_FLAG_ENABLE_L1;

I don't remember anymore why but my guess is that the proprietary driver
at the time didn't support it with QCA998X. Or maybe QCA988X doesn't
even support L1? Michal, do you remember?

Related to QCA988X supporting L1 state also the commit log is misleading
as it only talks QCA6174/QCA9377, and has been only tested on QCA6174,
but the actual change enables L1 on _all_ PCI and AHB devices. So this
patch needs a lot more testing so that we have confidence that no
existing setups break.

-- 
Kalle Valo
