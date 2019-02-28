Return-Path: <SRS0=yJNj=RD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 194DDC43381
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 08:38:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D56672184A
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 08:38:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="LhA8HfvX";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="d4SpvJ0k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731171AbfB1Ii2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 Feb 2019 03:38:28 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:58452 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731152AbfB1Ii1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Feb 2019 03:38:27 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id F38D960A43; Thu, 28 Feb 2019 08:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551343107;
        bh=gbUlB4/e8yezWEaXNKwA6YANcDQN/hTVX+72EvHmkug=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=LhA8HfvXnY9+yoXsg1nXn1+Lj8P0Eb03sv90hSeQvmlOEL/FdwX2APoH1Cz1NbZBu
         06RXr2FF2Yy3sIDXP1eN5rv1n++y3oykzCYt8Jf6VESG3l6DpS9AROmIgN5tURWuuG
         q3akj3JGRklb4HPnNuyeKH6odz9CcYuZOP2+vhlY=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 78B58608CE;
        Thu, 28 Feb 2019 08:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551343106;
        bh=gbUlB4/e8yezWEaXNKwA6YANcDQN/hTVX+72EvHmkug=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=d4SpvJ0k7fe2FInvK+0XMX7avs9ldxf8PyAhLE2d7gSweSPrCTDO73cc25xV28+Ut
         HrFyVJIhJN9QuXiT+QucYwUtDXSj8X5R/2/Efd1c2/sddvb+1tgvQ2yMy6jPgjHyPl
         e2RH55IojK7PbH95mELa6WsnCyuOe2Wkl2zo+C+s=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 78B58608CE
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/8] rtlwifi: Fix errors in spacing in wifi.h
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190221193115.30848-2-Larry.Finger@lwfinger.net>
References: <20190221193115.30848-2-Larry.Finger@lwfinger.net>
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190228083826.F38D960A43@smtp.codeaurora.org>
Date:   Thu, 28 Feb 2019 08:38:26 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Larry Finger <Larry.Finger@lwfinger.net> wrote:

> Checkpatch.pl report problems in wifi.h where spaces are missing, as well
> as extraneous spaces.
> 
> There are no changes in the generated code.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

8 patches applied to wireless-drivers-next.git, thanks.

6e5d9041525a rtlwifi: Fix errors in spacing in wifi.h
d3da329c1d8c rtlwifi: Fix problems with block comments in wifi.h
1dc89bb93c42 rtlwifi: Fix alignment errors in wifi.h
93665097ea23 rtlwifi: Fix blank line errors in main header files
b16abaafea47 rtlwifi: Fix all blank line irregularities in main code files
2973af748d4d rtlwifi: rtl8192ce: Fix missing blank lines
6d255202a272 rtlwifi: rtl8192cu: Fix problems with blank lines
52f886571263 rtlwifi: rtl8192com: Fix blank line problems

-- 
https://patchwork.kernel.org/patch/10824687/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

