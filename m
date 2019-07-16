Return-Path: <SRS0=+CNY=VN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10587C76188
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Jul 2019 11:11:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC1002173B
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Jul 2019 11:11:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="O7e+4YnP";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="O7e+4YnP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387471AbfGPLLK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Jul 2019 07:11:10 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:47168 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733200AbfGPLLK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Jul 2019 07:11:10 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id AB5FF602BC; Tue, 16 Jul 2019 11:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1563275469;
        bh=AwUC+LM8/riRJGQoLNOrWtgsd/Ac5UEZd3qogrwSnE8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=O7e+4YnPo0K5iyfWJRbDHkOZcMA6pZHpy3ju5Nu8H151w97bifGvNGHz3i0wv5QNH
         HxHFqHezy81W+FnqckZfWCdK8fOajlI1Ym8n1aWQow5GiexLUlOYpo1xEpYAE2g5q7
         ZsrDZ/ZuzP6zM6FgJIKLNeyG4wy4ImgMlkOpydSI=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2075060FEB;
        Tue, 16 Jul 2019 11:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1563275469;
        bh=AwUC+LM8/riRJGQoLNOrWtgsd/Ac5UEZd3qogrwSnE8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=O7e+4YnPo0K5iyfWJRbDHkOZcMA6pZHpy3ju5Nu8H151w97bifGvNGHz3i0wv5QNH
         HxHFqHezy81W+FnqckZfWCdK8fOajlI1Ym8n1aWQow5GiexLUlOYpo1xEpYAE2g5q7
         ZsrDZ/ZuzP6zM6FgJIKLNeyG4wy4ImgMlkOpydSI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2075060FEB
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Sid Hayn <sidhayn@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: [PATCH] mt76: mt76x0u: add support to TP-Link T2UHP
References: <dfb97adb52811bed530449c22a172724ed992771.1562353065.git.lorenzo@kernel.org>
        <CAM0KTbBU7-BTTR_R9b7VNQuqRpd=rMk8nAQANQ7shns+XGahdw@mail.gmail.com>
Date:   Tue, 16 Jul 2019 14:11:05 +0300
In-Reply-To: <CAM0KTbBU7-BTTR_R9b7VNQuqRpd=rMk8nAQANQ7shns+XGahdw@mail.gmail.com>
        (Sid Hayn's message of "Mon, 15 Jul 2019 11:38:01 -0400")
Message-ID: <87ims2s08m.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Sid Hayn <sidhayn@gmail.com> writes:

> I saw you accept this patch, thanks.  Any chance of pushing this
> simple fix in 5.1.x and 5.2.x?  I've tested and confirmed this
> hardware works fine.

Actually you can ask that yourself:

https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

Especially check option 2.

-- 
Kalle Valo
