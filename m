Return-Path: <SRS0=g+pd=SV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C031AC282DF
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Apr 2019 03:58:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7BC1C217F9
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Apr 2019 03:58:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Da+oTkgf";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Da+oTkgf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727254AbfDSD6E (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Apr 2019 23:58:04 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:52940 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727159AbfDSD6D (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Apr 2019 23:58:03 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id CDEDE6155F; Fri, 19 Apr 2019 03:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555646282;
        bh=UtWtGxKnDEBCQM/OriVcWGoTGXu5gIGvFN1B194Eyqo=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Da+oTkgfmaUcJGtptDCB2Vqq+1La0w6xvRWWxGpr02H5Te8UNBRBm8OyZMIDeSxH4
         L6N0h8nWvSKVxgUOQ+Mg479T3xle8S7madgCJT7Nm9In40XWEAQVpd+utI7djSFqPn
         hG8/vPoPzdi27+loG2jtVcbiXGl9Ti2cTTrJFXnE=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 361CF6141D;
        Fri, 19 Apr 2019 03:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555646282;
        bh=UtWtGxKnDEBCQM/OriVcWGoTGXu5gIGvFN1B194Eyqo=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Da+oTkgfmaUcJGtptDCB2Vqq+1La0w6xvRWWxGpr02H5Te8UNBRBm8OyZMIDeSxH4
         L6N0h8nWvSKVxgUOQ+Mg479T3xle8S7madgCJT7Nm9In40XWEAQVpd+utI7djSFqPn
         hG8/vPoPzdi27+loG2jtVcbiXGl9Ti2cTTrJFXnE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 361CF6141D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     David Miller <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull-request: wireless-drivers-next 2019-04-18
References: <87sguf2zmj.fsf@kamboji.qca.qualcomm.com>
        <20190418.111444.1325343486196462539.davem@davemloft.net>
Date:   Fri, 19 Apr 2019 06:57:58 +0300
In-Reply-To: <20190418.111444.1325343486196462539.davem@davemloft.net> (David
        Miller's message of "Thu, 18 Apr 2019 11:14:44 -0700 (PDT)")
Message-ID: <87o9521wah.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> From: Kalle Valo <kvalo@codeaurora.org>
> Date: Thu, 18 Apr 2019 16:48:20 +0300
>
>> here's a pull request to net-next for v5.2, more info below. But do note
>> that this time we have two trivial conflicts in iwlwifi, here are
>> Stephen's example resolutions:
>> 
>> https://lkml.kernel.org/r/20190415120133.40c0f343@canb.auug.org.au
>> 
>> https://lkml.kernel.org/r/20190415120853.39e0e46a@canb.auug.org.au
>> 
>> The only change to Stephen's resolution I recommend is to have in drv.c
>> an empty line between group 0x2723 and group 0x1a56, but that's just
>> cosmetic anyway so it doesn't matter really in the end.
>> 
>> As always, please do let me know if there any problems.
>
> Pulled, please double check my work.

I checked, your resolution is identical to my test resolution which I
made before sending you the pull request. Next time I'll push my
resolution to my tree so that you can immediately compare them.

Thanks!

-- 
Kalle Valo
