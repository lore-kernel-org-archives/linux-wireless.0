Return-Path: <SRS0=6eO7=TB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52B74C43219
	for <linux-wireless@archiver.kernel.org>; Wed,  1 May 2019 07:20:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D68021734
	for <linux-wireless@archiver.kernel.org>; Wed,  1 May 2019 07:20:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ohr5dRFj";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ohr5dRFj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726022AbfEAHUD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 1 May 2019 03:20:03 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:35568 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbfEAHUD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 May 2019 03:20:03 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id BAECF607DF; Wed,  1 May 2019 07:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556695202;
        bh=J3iYLEnQcPcmeOXn16+DGhfwHJNVhBVI5TebS9xsYe8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ohr5dRFjSnr84UJC6/mkMdLCjBHJBRkBQT65WtRVo7AsaO9hCDntLxGpXDsj/iH15
         YU27sPM0hyrx56WernkqgaJ3o+uXHC2/1EQI0y2ORps35UBkDjBL25Ja81qhLIdHQo
         dAJiCg62iWH6o3QgvlmoEFaMhf64PUe6TrSVT7bA=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B660E602F8;
        Wed,  1 May 2019 07:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556695202;
        bh=J3iYLEnQcPcmeOXn16+DGhfwHJNVhBVI5TebS9xsYe8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ohr5dRFjSnr84UJC6/mkMdLCjBHJBRkBQT65WtRVo7AsaO9hCDntLxGpXDsj/iH15
         YU27sPM0hyrx56WernkqgaJ3o+uXHC2/1EQI0y2ORps35UBkDjBL25Ja81qhLIdHQo
         dAJiCg62iWH6o3QgvlmoEFaMhf64PUe6TrSVT7bA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B660E602F8
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     whiteheadm@acm.org
Cc:     Christian Lamparter <chunkeey@googlemail.com>,
        linux-wireless@vger.kernel.org
Subject: Re: carl9170 crash
References: <CAP8WD_bTvWWTeh6BP_qgByiuWLbSN==CTBY1KD-v8XpWZkf_Rw@mail.gmail.com>
Date:   Wed, 01 May 2019 10:19:59 +0300
In-Reply-To: <CAP8WD_bTvWWTeh6BP_qgByiuWLbSN==CTBY1KD-v8XpWZkf_Rw@mail.gmail.com>
        (tedheadster@gmail.com's message of "Tue, 30 Apr 2019 22:46:49 -0400")
Message-ID: <87k1fawsio.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

tedheadster <tedheadster@gmail.com> writes:

>   I am getting this crash for the carl9170 in recent kernels, though I
> have not yet bisected it. It hangs the networking system completely
> (ifconfig -a never returns) and it prevents a reboot. I have to use
> sysrq-b to 'cleanly' reboot the system.
>
> I can apply and test any patches.

What was the last working version?

-- 
Kalle Valo
