Return-Path: <SRS0=pQzZ=MS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11A2AC65C31
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 12:34:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC02E2084D
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 12:34:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="IW65JSZg";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="IW65JSZg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BC02E2084D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727790AbeJFThh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 6 Oct 2018 15:37:37 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:51246 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727161AbeJFThg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 6 Oct 2018 15:37:36 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C43B06035F; Sat,  6 Oct 2018 12:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538829269;
        bh=tOA9SC+6Hjo+LabCUBADWRBMAe6bhMymPPI+vw94+20=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=IW65JSZg+tt76LLhh8MuVlTtKW6s2tlvuxpYh6h6w/KOO/+uMw3k2+1Kbmzva+D5u
         PrnWAwrn/ck1oHqoB5e0bKzOS0YQZS0UYhoWT0E2bjKeRKEapnzkU1VrtgMYoaLj2Q
         NXWbV1bMKmi+2vN/KMoAZdp1n8+Q/ldNvMBoM2f4=
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A052C6035F;
        Sat,  6 Oct 2018 12:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538829269;
        bh=tOA9SC+6Hjo+LabCUBADWRBMAe6bhMymPPI+vw94+20=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=IW65JSZg+tt76LLhh8MuVlTtKW6s2tlvuxpYh6h6w/KOO/+uMw3k2+1Kbmzva+D5u
         PrnWAwrn/ck1oHqoB5e0bKzOS0YQZS0UYhoWT0E2bjKeRKEapnzkU1VrtgMYoaLj2Q
         NXWbV1bMKmi+2vN/KMoAZdp1n8+Q/ldNvMBoM2f4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A052C6035F
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     yhchuang@realtek.com, Larry.Finger@lwfinger.net,
        pkshih@realtek.com, tehuang@realtek.com,
        linux-wireless@vger.kernel.org
Subject: Re: [RFC v2 06/12] rtw88: fw and efuse files
References: <1538553748-26364-1-git-send-email-yhchuang@realtek.com>
        <1538553748-26364-7-git-send-email-yhchuang@realtek.com>
        <20181004104929.GA16819@redhat.com>
Date:   Sat, 06 Oct 2018 15:34:25 +0300
In-Reply-To: <20181004104929.GA16819@redhat.com> (Stanislaw Gruszka's message
        of "Thu, 4 Oct 2018 12:49:45 +0200")
Message-ID: <874ldzfe3y.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Stanislaw Gruszka <sgruszka@redhat.com> writes:

> On Wed, Oct 03, 2018 at 04:02:22PM +0800, yhchuang@realtek.com wrote:
>
>> +void rtw_add_rsvd_page(struct rtw_dev *rtwdev, enum rtw_rsvd_packet_type type,
>> +		       bool txdesc)
>> +{
>> +	struct rtw_rsvd_page *rsvd_pkt;
>> +
>> +	list_for_each_entry(rsvd_pkt, &rtwdev->rsvd_page_list, list) {
>> +		if (rsvd_pkt->type == type)
>> +			return;
>> +	}
>> +
>> +	rsvd_pkt = kmalloc(sizeof(*rsvd_pkt),
>> +			   in_interrupt() ? GFP_ATOMIC : GFP_KERNEL);
>
> It's never called from interrupt. You have to check kmalloc output value.

My recommendation is to always avoid in_interrupt().

-- 
Kalle Valo
