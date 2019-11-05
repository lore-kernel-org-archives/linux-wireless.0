Return-Path: <SRS0=b/BL=Y5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C9DCC17460
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Nov 2019 14:56:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03F0921929
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Nov 2019 14:56:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Jf6/H67c";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="BohYEjMZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389032AbfKEOz7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 5 Nov 2019 09:55:59 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:53332 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727889AbfKEOz7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Nov 2019 09:55:59 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 3583C61644; Tue,  5 Nov 2019 14:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572965758;
        bh=Yv9myWA+u+uyWopfvSs5Jb5TMhvPHTeXBHGnfrqVZKU=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Jf6/H67cwNh5Lxj4BlWPSsLRdE0mGad/xBTRMISJ4sQTrOwFWBG9XuTj5oEuzxemM
         LILfKiVJPnIN5G3MspLOLvM7kqyEzWYnv9bEpeRPpuIheANbTqw+TfvBBLZu+rl8al
         Oxq+PqzO8P21+yzLR0a0xwJ3UScOtJqZZvku6cdU=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7E4986162A;
        Tue,  5 Nov 2019 14:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572965757;
        bh=Yv9myWA+u+uyWopfvSs5Jb5TMhvPHTeXBHGnfrqVZKU=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=BohYEjMZ7vMw+tWk2YG8cVb5ACqsIuBt5PaHUHmKFI0+XFMgKxcoX9FZHkRPgZApV
         yEwyoZaJhJJrAsFaXQcuEq5RA2EsH8FYLkJUuUBNZp18Is0TkmrpjBAzHUXoMAKMdU
         QivbTzjgJrSpJtaO2D3hdp3Twc1d9Wf0Xl1zhDyM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7E4986162A
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        ath11k@lists.infradead.org
Subject: Re: [PATCH v2 01/49] dt: bindings: net: add qcom,ath11k.yaml
References: <1571565847-10338-1-git-send-email-kvalo@codeaurora.org>
        <1571565847-10338-2-git-send-email-kvalo@codeaurora.org>
        <20191025213028.GA5117@bogus>
        <874kzu9v2g.fsf@kamboji.qca.qualcomm.com>
        <CAL_JsqLD5UfSfYtvp62aGJSDC-Cm4ifk_YmNPRNAXQMnJ2CzVA@mail.gmail.com>
Date:   Tue, 05 Nov 2019 16:55:54 +0200
In-Reply-To: <CAL_JsqLD5UfSfYtvp62aGJSDC-Cm4ifk_YmNPRNAXQMnJ2CzVA@mail.gmail.com>
        (Rob Herring's message of "Sun, 27 Oct 2019 15:56:29 -0500")
Message-ID: <871rum74p1.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rob Herring <robh@kernel.org> writes:

> On Sun, Oct 27, 2019 at 8:28 AM Kalle Valo <kvalo@codeaurora.org> wrote:
>>
>> Rob Herring <robh@kernel.org> writes:
>>
>> > On Sun, Oct 20, 2019 at 01:03:19PM +0300, Kalle Valo wrote:
>> >> ath11k is a driver for Qualcomm IEEE 802.11ax devices. Add a
>> >> bindings document for the driver, first documenting IPQ8074 which is the
>> >> only device ath11k currently supports.
>> >>
>> >> Signed-off-by: Anilkumar Kolli <akolli@codeaurora.org>
>> >> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
>> >> ---
>> >>  .../bindings/net/wireless/qcom,ath11k.yaml         | 277 +++++++++++++++++++++
>> >>  1 file changed, 277 insertions(+)
>> >>
>> >> diff --git
>> >> a/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml
>> >> b/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml
>> >> new file mode 100644
>> >> index 000000000000..5d25542f85f8
>> >> --- /dev/null
>> >> +++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml
>> >> @@ -0,0 +1,277 @@
>> >> +# SPDX-License-Identifier: BSD-3-Clause-Clear
>> >
>> > (GPL-2.0-only OR BSD-2-Clause) please.
>>
>> I chose BSD-3-Clause-Clear because ath11k uses that license and I would
>> prefer to use the same license throughout the driver.
>
> The schema is not the driver.
>
>> Also it's
>> categorised as a preferred license:
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/LICENSES/preferred
>
> So are the 2 I listed. (GPL-2.0 is the deprecated version of GPL-2.0-only).
>
>> Any specific reason why you want to change the license?
>
> So that we have some sort of consistency between schemas. It's been a
> free-for-all for licensing dts files, headers and bindings til now,
> and I'm trying to address some of that as we add schema.

Yeah, makes sense. I'll change the license in the next version. Thanks
for the review.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
