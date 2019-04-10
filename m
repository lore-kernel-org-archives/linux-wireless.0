Return-Path: <SRS0=qAu2=SM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 469ADC10F11
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Apr 2019 15:31:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11C3920818
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Apr 2019 15:31:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="APiNOpGS";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="APiNOpGS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730350AbfDJPbp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Apr 2019 11:31:45 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:54194 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729295AbfDJPbo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Apr 2019 11:31:44 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 5713D60E5A; Wed, 10 Apr 2019 15:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554910304;
        bh=iogtYs1v2q++pedQONw8Mz1EZ/vbvQ4THbOmCRtS5j0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=APiNOpGSXiyjXfuZZwTM3dEZlHE8mh29FCZdjGI9qWYBfjx4nshymc7tonivwVFv3
         pEJAZeGwP62Y+EyllsKRNdIt2XrMqhGOxH1AeTbkxsuR40Q4E0Cb3uW49je1u0/haX
         ClN32UUXDDTaZDx6zzFVhgDDTSJb9EEjXjZ8gG3c=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D23D2608FC;
        Wed, 10 Apr 2019 15:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554910304;
        bh=iogtYs1v2q++pedQONw8Mz1EZ/vbvQ4THbOmCRtS5j0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=APiNOpGSXiyjXfuZZwTM3dEZlHE8mh29FCZdjGI9qWYBfjx4nshymc7tonivwVFv3
         pEJAZeGwP62Y+EyllsKRNdIt2XrMqhGOxH1AeTbkxsuR40Q4E0Cb3uW49je1u0/haX
         ClN32UUXDDTaZDx6zzFVhgDDTSJb9EEjXjZ8gG3c=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D23D2608FC
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     John Crispin <john@phrozen.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org,
        Srini Kode <skode@qti.qualcomm.com>,
        Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
        Shashidhar Lakkavalli <slakkavalli@datto.com>,
        Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Subject: Re: [RFC V4 2/2] ath10k: add tx hw 802.11 encapusaltion offloading support
References: <20190410073514.12794-1-john@phrozen.org>
        <20190410073514.12794-3-john@phrozen.org>
Date:   Wed, 10 Apr 2019 18:31:39 +0300
In-Reply-To: <20190410073514.12794-3-john@phrozen.org> (John Crispin's message
        of "Wed, 10 Apr 2019 09:35:14 +0200")
Message-ID: <87ef69yizo.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

John Crispin <john@phrozen.org> writes:

> From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
>
> This patch adds support for ethernet rxtx mode to the driver. The feature
> is enabled via a new module parameter. If enabled to driver will enable
> the feature on a per vif basis if all other requirements were met.
>
> Testing on a IPQ4019 based hardware shows a increase in TCP throughput
> of ~20% when the feature is enabled.
>
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
> Signed-off-by: John Crispin <john@phrozen.org>

Looks good to me.

BTW, for ath10k patches (patchsets including ath10k patches) please try
to CC also the ath10k list. Easier to find ath10k patches that way.

-- 
Kalle Valo
