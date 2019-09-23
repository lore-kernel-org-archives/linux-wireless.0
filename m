Return-Path: <SRS0=1g4v=XS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B8D7C3A5A6
	for <linux-wireless@archiver.kernel.org>; Mon, 23 Sep 2019 07:53:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE27E20882
	for <linux-wireless@archiver.kernel.org>; Mon, 23 Sep 2019 07:53:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="HTLIfscg";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="GjaQOR5n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390911AbfIWHxG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 23 Sep 2019 03:53:06 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:34316 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390655AbfIWHxG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Sep 2019 03:53:06 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 104ED6119D; Mon, 23 Sep 2019 07:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569225185;
        bh=I79m02xDyW5CliHu2Z1WS1pNrLeERSGoF4CKm+RP2Ng=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=HTLIfscgdxl2AeHp6Y2IbsVnGBgBLf7botldkLdoBvwi0Pu5I0CQ9pLzybKpMwbbI
         eZAyfj/Pu5SMOp5bVCIJ+ml9jpj7v0vij1aL78bpORIE8yKvxIfEEhKsSMs/85ZrL5
         EjZpx0pnfED519ww/uLXzgI60J4DjgphqYCZf2yc=
Received: from x230.qca.qualcomm.com (37-136-106-186.rev.dnainternet.fi [37.136.106.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 820AC60740;
        Mon, 23 Sep 2019 07:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569225184;
        bh=I79m02xDyW5CliHu2Z1WS1pNrLeERSGoF4CKm+RP2Ng=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=GjaQOR5nMLJ64hNs6vi9NsWchbg3TP0MtT9ytE4ZwgSL6yuq94tG8MYCDcmr8pv3r
         jWQPx7aeT+AdD1cZAUQ9eSrGEb4ouq/BO1ISqNNvAfw/7IdgRQ+172u5tqZeMDI2sc
         1lQwIT5/1PKuByIAcGiun3wupAyUgS1phbGlCa7o=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 820AC60740
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Abhishek Ambure <aambure@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH 2/2] ath10k: correct wmi_tlv command params to enable pktlog for WCN3990
References: <1558087516-666-3-git-send-email-aambure@codeaurora.org>
        <20190918134502.91240614C3@smtp.codeaurora.org>
Date:   Mon, 23 Sep 2019 10:53:00 +0300
In-Reply-To: <20190918134502.91240614C3@smtp.codeaurora.org> (Kalle Valo's
        message of "Wed, 18 Sep 2019 13:45:02 +0000 (UTC)")
Message-ID: <87impja1pf.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Kalle Valo <kvalo@codeaurora.org> writes:

> Abhishek Ambure <aambure@codeaurora.org> wrote:
>
>> PKT log enable command expects pdev id in enable params which is missing
>> in current configuration. Fill pdev id in pkt log enable wmi command for
>> correct configuration.
>> 
>> Fixes: ca996ec56608 ("ath10k: implement wmi-tlv backend")
>> Tested HW: WCN3990
>> Tested FW: WLAN.HL.3.1-00963-QCAHLSWMTPL-1
>> 
>> Signed-off-by: Abhishek Ambure <aambure@codeaurora.org>
>> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
>
> How do I know this doesn't break QCA6174/QCA9377?

Abhishek mentioned me privately that he is checking this.

-- 
Kalle Valo
