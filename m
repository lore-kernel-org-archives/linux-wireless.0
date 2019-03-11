Return-Path: <SRS0=FsXk=RO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75E72C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 13:17:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 34FA520657
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 13:17:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="emSJz9F6";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="emSJz9F6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbfCKNRd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Mar 2019 09:17:33 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:52656 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726826AbfCKNRd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Mar 2019 09:17:33 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id CC33C602F8; Mon, 11 Mar 2019 13:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552310252;
        bh=wSmf3TIOMbKS7pEPSL98LXIQWuU5fndVOFDKTdTrxLo=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=emSJz9F64fqo3xzn1WEGreZ/0BDNdnP9TT2zbfwtmdB8tmWOS6um+Wf0uzA89Bx2C
         gGl14WvHqoA119Mk7k6Q6tfUriReLyKwWs/YRcRhT8eESI7ViK8Kck5WdliiawmFG9
         aeCx0LPSqQhPfwt2FbKboqMgc8Ytv90gmwcCONYk=
Received: from x230.qca.qualcomm.com (87-95-203-65.bb.dnainternet.fi [87.95.203.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 84EBE602F8;
        Mon, 11 Mar 2019 13:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552310252;
        bh=wSmf3TIOMbKS7pEPSL98LXIQWuU5fndVOFDKTdTrxLo=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=emSJz9F64fqo3xzn1WEGreZ/0BDNdnP9TT2zbfwtmdB8tmWOS6um+Wf0uzA89Bx2C
         gGl14WvHqoA119Mk7k6Q6tfUriReLyKwWs/YRcRhT8eESI7ViK8Kck5WdliiawmFG9
         aeCx0LPSqQhPfwt2FbKboqMgc8Ytv90gmwcCONYk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 84EBE602F8
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mt76: mt7603: use the correct hweight8() function
References: <20190311130953.61869-1-nbd@nbd.name>
Date:   Mon, 11 Mar 2019 15:17:29 +0200
In-Reply-To: <20190311130953.61869-1-nbd@nbd.name> (Felix Fietkau's message of
        "Mon, 11 Mar 2019 14:09:53 +0100")
Message-ID: <87wol58s9i.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Felix Fietkau <nbd@nbd.name> writes:

> __sw_hweight8() is only defined if CONFIG_GENERIC_HWEIGHT is enabled.
> The function that works on all architectures is hweight8().
>
> Signed-off-by: Felix Fietkau <nbd@nbd.name>

This should go to 5.1, right?

-- 
Kalle Valo
