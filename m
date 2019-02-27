Return-Path: <SRS0=HoYG=RC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82C26C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Feb 2019 17:41:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51C1720C01
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Feb 2019 17:41:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ULFLxxit";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="F6SwPBAR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730297AbfB0RlS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Feb 2019 12:41:18 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:59792 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730269AbfB0RlS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Feb 2019 12:41:18 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 521106156F; Wed, 27 Feb 2019 17:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551289277;
        bh=YHKynvS5yUVcQboDhLqyuiX3XNyrvS91yuRdhaH+YUo=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ULFLxxitmobPBaAOGuZXkHTKtkj169l64mC9x3Bf+wRVLhMRcXgSpISlnJT3ib/hY
         pL54sNIOzTTO2HgVDAsoPzCDnO86dr5tsOK+qyFZrezlG8roD0CzJHla8Btr9vGyjq
         BhXw2BOckM8Kz3odXnDOJt0Ff8pEzTBLlTbIeRkc=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CC921614DB;
        Wed, 27 Feb 2019 17:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551289272;
        bh=YHKynvS5yUVcQboDhLqyuiX3XNyrvS91yuRdhaH+YUo=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=F6SwPBAR6hzf3GFeeLdIPPBJlzYatDJPjH4qrAgcWXryQaK3pqQzoK8Y4FSVR4zGX
         zTUEBaF3Tfrcvys2vSoYMa10HuELIknQSX+pZtBL59ZHF1wqS2j33KcjgsDH32tkr8
         mChNejYWEbck7wY3VYBHMgbS43jAw21EG08O1pvc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org CC921614DB
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: pull request: mt76 2019-02-26 v2
References: <11927365-0cd5-1fbc-c895-254b2e5c73e7@nbd.name>
Date:   Wed, 27 Feb 2019 19:41:08 +0200
In-Reply-To: <11927365-0cd5-1fbc-c895-254b2e5c73e7@nbd.name> (Felix Fietkau's
        message of "Tue, 26 Feb 2019 12:41:59 +0100")
Message-ID: <87h8cpjfij.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Felix Fietkau <nbd@nbd.name> writes:

> Hi Kalle,
>
> here's another pull request for 5.1
> v2: add two missing patches, fix bisect issues
>
> - Felix
>
> The following changes since commit bd16693f359bbab8776541c06a6df32f3996638e:
>
>   net: fix double-free in bpf_lwt_xmit_reroute (2019-02-24 22:24:50 -0800)
>
> are available in the Git repository at:
>
>   https://github.com/nbd168/wireless tags/mt76-for-kvalo-2019-02-26
>
> for you to fetch changes up to c8846e1015022d2531ac4c895783e400b3e5babe:
>
>   mt76: add driver for MT7603E and MT7628/7688 (2019-02-26 12:29:56 +0100)
>
> ----------------------------------------------------------------
> mt76 patches for 5.1
>
> * add driver for MT7603E/MT7628
> * fix ED/CCA issues
> * fix USB issues
> * more code unification
> * fix beacon timer issues
> * fix recovery from MCU timeout issues
>
> ----------------------------------------------------------------

Pulled, thanks.

-- 
Kalle Valo
