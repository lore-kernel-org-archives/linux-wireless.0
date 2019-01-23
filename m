Return-Path: <SRS0=ZHYo=P7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7D33C282C0
	for <linux-wireless@archiver.kernel.org>; Wed, 23 Jan 2019 05:11:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2D4F21019
	for <linux-wireless@archiver.kernel.org>; Wed, 23 Jan 2019 05:11:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="N/LsYhtb";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="OCCT8G6k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726039AbfAWFLx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 23 Jan 2019 00:11:53 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:52106 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbfAWFLw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Jan 2019 00:11:52 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 06CCB6034E; Wed, 23 Jan 2019 05:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548220312;
        bh=eQESTIb1iEa96C1mKZSAGrS0Fs7ciC1OA85fpD2WVQ4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=N/LsYhtbtt4ZTSn4sYxqofXVZacwUpQbLgjA8pz5Ef9mj0rrcPm7lLbizIpc2z+ap
         GShGBgvgi5zOazoELCBTBLS8n3EjQ+U4kgOaSR6YrBXZZfDLJZiSsVZR4G27L4/13N
         E14oyhFME1EvvISsIukNUh1gtwS9jlYHOhmLdNbA=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 22E926024C;
        Wed, 23 Jan 2019 05:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548220311;
        bh=eQESTIb1iEa96C1mKZSAGrS0Fs7ciC1OA85fpD2WVQ4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=OCCT8G6kt+QCUI5K3tittmP/FTZg+qe2N8vO7D2EdX9kovJjknPQEXlb9YMv+5w++
         LEGGZv9Bc+jSG6TeBHffhAa/N/mRMt2ZdWAbZ/jjAet/0KWkE44MDOhjoVF9GBJdbZ
         diID3g7Ddsp8+WsWQi11trWEm28zDE3v4ImtnaKY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 22E926024C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
Subject: Re: [PATCH] brcm80211: no need to check return value of debugfs_create functions
References: <20190122152151.16139-32-gregkh@linuxfoundation.org>
        <530d2424-d679-c81a-9d11-02b2d7631bea@broadcom.com>
Date:   Wed, 23 Jan 2019 07:11:46 +0200
In-Reply-To: <530d2424-d679-c81a-9d11-02b2d7631bea@broadcom.com> (Arend Van
        Spriel's message of "Tue, 22 Jan 2019 21:07:48 +0100")
Message-ID: <8736pklzzh.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Arend Van Spriel <arend.vanspriel@broadcom.com> writes:

> The prefix should be 'brcmsmac'.

I can fix that during commit.

-- 
Kalle Valo
