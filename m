Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CDFFC282C2
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 09:11:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1F26218B0
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 09:10:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="hiuVE8B6";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="hiuVE8B6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbfBGJK7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 04:10:59 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:44466 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726294AbfBGJK6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 04:10:58 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 3C790607F5; Thu,  7 Feb 2019 09:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549530658;
        bh=ZgKBnpoKoK9oe+kX0qYjC7VNTgluvbayZ+AU60fXVGI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=hiuVE8B6U3M2lPjlPqFNZxrLdl8ku5BZ1DS2tXcV+tSv0bU6bZP24tun+0rcuieCz
         MtC+M9MOTOzWCsCt2LLfDnT2K+ORVSMGdq4KXiLDxY2kzMjivP0H0eopQEEYFBekxi
         yk49NiQ/kixnzRpjvw6jzRJxZlaHkRq8V+OKgy+w=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 008946032C;
        Thu,  7 Feb 2019 09:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549530658;
        bh=ZgKBnpoKoK9oe+kX0qYjC7VNTgluvbayZ+AU60fXVGI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=hiuVE8B6U3M2lPjlPqFNZxrLdl8ku5BZ1DS2tXcV+tSv0bU6bZP24tun+0rcuieCz
         MtC+M9MOTOzWCsCt2LLfDnT2K+ORVSMGdq4KXiLDxY2kzMjivP0H0eopQEEYFBekxi
         yk49NiQ/kixnzRpjvw6jzRJxZlaHkRq8V+OKgy+w=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 008946032C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Surabhi Vishnoi <svishnoi@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH] ath10k: Fill tx_duration for each peer in Tx stats per STA
References: <1548999390-25576-1-git-send-email-svishnoi@codeaurora.org>
        <8736p3effe.fsf@kamboji.qca.qualcomm.com>
        <ad4c09475713750aa1c6d2db30178de8@codeaurora.org>
Date:   Thu, 07 Feb 2019 11:10:54 +0200
In-Reply-To: <ad4c09475713750aa1c6d2db30178de8@codeaurora.org> (Surabhi
        Vishnoi's message of "Wed, 06 Feb 2019 19:23:02 +0530")
Message-ID: <87h8dg9d5t.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

+ lists

Surabhi Vishnoi <svishnoi@codeaurora.org> writes:

> On 2019-02-04 21:03, Kalle Valo wrote:
>> Surabhi Vishnoi <svishnoi@codeaurora.org> writes:
>>
>>> Firmware sends the tx_duration for each in HTT_T2H_MSG_TYPE_PEER_STATS
>>> msg. Fill the tx_duration sent by firmware in the tx stats information
>>> per STA.
>>>
>>> Tested HW: WCN3990
>>> Tested FW: WLAN.HL.2.0
>>
>> Same here, please let me know the firmware version so I can add it.
>
>
> Hi Kalle,
>
> The Fw version tested are:
> Tested FW: WLAN.HL.3.1-00784-QCAHLSWMTPLZ-1,
>            WLAN.HL.2.0-01617-QCAHLSWMTPLZ-1

Thanks. I'll add these.

-- 
Kalle Valo
