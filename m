Return-Path: <SRS0=DNYG=S3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 614CCC10F03
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 09:38:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 234CD20685
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 09:38:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="D6hFztBP";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="PE7XdFP7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728523AbfDYJhu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Apr 2019 05:37:50 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:51812 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728102AbfDYJht (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Apr 2019 05:37:49 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1533460AA8; Thu, 25 Apr 2019 09:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556185068;
        bh=KgXcuXfaWLbFmje1PenHbl2yXkpk48ORe9PaxDvKv4c=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=D6hFztBP3H+thgNEmvemff6Jz5Ctss4HVIDyroLx6lWxY0DfY3PQA0B3fDrnz5QX4
         7ECLwzUgXN4coKfGvlEGA/EIryuu/Lfa0UTlZ1wBcZhgpOQpi6bk3ZsRAJp8dnaIUy
         AOOl/RRPq9CIC6Bn7D++NBQf0aYg5eACezVU++bo=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9ACA360AA8;
        Thu, 25 Apr 2019 09:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556185067;
        bh=KgXcuXfaWLbFmje1PenHbl2yXkpk48ORe9PaxDvKv4c=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=PE7XdFP7Hi02zWS3dKkwOyO0TIAEXP4SJY1ZFHTaj8mMIWG2BnlsXOsJ3Kzu3SvYg
         EX0mk/uFez+XRb8DRSfHzZFcKv2IxsspLqt8Vhkt/oKqRVNksOag5LTpJWwjNSuEe+
         GTfDi7ENPfzxIu6I1pmyEy/rIp/ehKh4aRdaefuo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9ACA360AA8
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v2 wireless-drivers-next] rtlwifi: rtl8723ae: Fix missing break in switch statement
References: <20190416151722.GA31598@embeddedor>
        <6056eaca-5120-ec0f-6e72-2e1bfbde52a9@embeddedor.com>
Date:   Thu, 25 Apr 2019 12:37:42 +0300
In-Reply-To: <6056eaca-5120-ec0f-6e72-2e1bfbde52a9@embeddedor.com> (Gustavo A.
        R. Silva's message of "Wed, 24 Apr 2019 17:17:12 -0500")
Message-ID: <87zhoewhll.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

"Gustavo A. R. Silva" <gustavo@embeddedor.com> writes:

> Hi all,
>
> Friendly ping:
>
> Who can take this?

It's in my queue.

-- 
Kalle Valo
