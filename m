Return-Path: <SRS0=TQ1a=2J=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D97A4C2D0C1
	for <linux-wireless@archiver.kernel.org>; Thu, 19 Dec 2019 13:32:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AEB69218AC
	for <linux-wireless@archiver.kernel.org>; Thu, 19 Dec 2019 13:32:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="ddfzqMEh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbfLSNcJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 19 Dec 2019 08:32:09 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:44806 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726744AbfLSNcH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Dec 2019 08:32:07 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1576762327; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=41W5xZgEpVmLUelbR692YUsa8fLldV9N+l6CsEx5uLU=; b=ddfzqMEhHpUz+/Z8ykzwpaSNjs7wBeIEwNhTEiHNN0qeGO/7g5BjIdhIpjIv2Q4QBttLTmB8
 x2GAVDZQcxueRDXJA8+9DgQMgvJKMcGO2n9DrAoP9OFpheamu3ElTaXYw6X3Iy2EhiRDFy+k
 th9ksTLen96soa462t56jsb9lOw=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5dfb7bd3.7fb3768398f0-smtp-out-n03;
 Thu, 19 Dec 2019 13:32:03 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id C2FBCC4479F; Thu, 19 Dec 2019 13:32:03 +0000 (UTC)
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 84FA8C433A2;
        Thu, 19 Dec 2019 13:32:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 84FA8C433A2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-wireless@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        ath11k@lists.infradead.org
Subject: Re: [PATCH] ath11k: Remove unnecessary enum scan_priority
References: <20191211192252.35024-1-natechancellor@gmail.com>
        <CAKwvOdmQp+Rjgh49kbTp1ocLCjv4SUACEO4+tX5vz4stX-pPpg@mail.gmail.com>
Date:   Thu, 19 Dec 2019 15:31:59 +0200
In-Reply-To: <CAKwvOdmQp+Rjgh49kbTp1ocLCjv4SUACEO4+tX5vz4stX-pPpg@mail.gmail.com>
        (Nick Desaulniers's message of "Thu, 12 Dec 2019 11:34:42 -0800")
Message-ID: <87a77o786o.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Nick Desaulniers <ndesaulniers@google.com> writes:

> On Wed, Dec 11, 2019 at 11:23 AM Nathan Chancellor
> <natechancellor@gmail.com> wrote:
>>
>> Clang warns:
>>
>> drivers/net/wireless/ath/ath11k/wmi.c:1827:23: warning: implicit
>> conversion from enumeration type 'enum wmi_scan_priority' to different
>> enumeration type 'enum scan_priority' [-Wenum-conversion]
>>         arg->scan_priority = WMI_SCAN_PRIORITY_LOW;
>>                            ~ ^~~~~~~~~~~~~~~~~~~~~
>> 1 warning generated.
>>
>> wmi_scan_priority and scan_priority have the same values but the wmi one
>> has WMI prefixed to the names. Since that enum is already being used,
>> get rid of scan_priority and switch its one use to wmi_scan_priority to
>> fix this warning.
>>
>> Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
>> Link: https://github.com/ClangBuiltLinux/linux/issues/808
>> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
>
> Further, it looks like the member `scan_priority` in `struct
> wmi_start_scan_arg` and `struct wmi_start_scan_cmd` should probably
> use `enum wmi_scan_priority`, rather than `u32`.

struct wmi_start_scan_cmd is sent to firmware and that's why it has u32
to make sure that the size is exactly 32 bits.

> Also, I don't know if the more concisely named enum is preferable?

I didn't get this comment.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
