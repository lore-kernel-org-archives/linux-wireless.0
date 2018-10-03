Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0610AC64EBC
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 09:07:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE08020835
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 09:07:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="G7jcA9EO";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="GfAVSQp5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BE08020835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727482AbeJCPyY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 11:54:24 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:50814 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727188AbeJCPyX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 11:54:23 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 2297760C60; Wed,  3 Oct 2018 09:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538557614;
        bh=3qrMMukJmK0GcH05zaf6D7WUwfzJs5ARgL0COF+qIsY=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=G7jcA9EO9gEut0L8KecThG3vU+/IWyo4RYtCEZUM8I1mVf2I1Ds6J7WBuAUA+RR2V
         Dd7AWoXmIM11Ou/c6Qhb6h0XspeUsnL+hxDYxDP2ilA03LkcYKMPuxlz5MfLItqJ30
         E1301CYmMgEOZu0oLBIeIe8MC8WfqWM5eDNFnr8E=
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4F17760B26;
        Wed,  3 Oct 2018 09:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538557613;
        bh=3qrMMukJmK0GcH05zaf6D7WUwfzJs5ARgL0COF+qIsY=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=GfAVSQp5PhnjD3xsdNoFzW8kDHbxhIEyH6v5pu507eLqr3Wo9g+P1o5i90MKbios0
         1uBTh/8o9lGGlb3ZeRY26Z7nCxtGTeP6rCiuCR3fODQERzq8x0YFp1xjpXP24Jkd/3
         R1SnzEFp+++JxIidFDJfV3vMiKxi6pfm8jtaLFX4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4F17760B26
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Lance Roy <ldr709@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Daniel Drake <dsd@gentoo.org>,
        Ulrich Kunitz <kune@deine-taler.de>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 08/16] wireless: Replace spin_is_locked() with lockdep
References: <20181003053902.6910-1-ldr709@gmail.com>
        <20181003053902.6910-9-ldr709@gmail.com>
Date:   Wed, 03 Oct 2018 12:06:48 +0300
In-Reply-To: <20181003053902.6910-9-ldr709@gmail.com> (Lance Roy's message of
        "Tue, 2 Oct 2018 22:38:54 -0700")
Message-ID: <877eizjt5j.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Lance Roy <ldr709@gmail.com> writes:

> lockdep_assert_held() is better suited to checking locking requirements,
> since it won't get confused when someone else holds the lock. This is
> also a step towards possibly removing spin_is_locked().
>
> Signed-off-by: Lance Roy <ldr709@gmail.com>
> Cc: Daniel Drake <dsd@gentoo.org>
> Cc: Ulrich Kunitz <kune@deine-taler.de>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: <linux-wireless@vger.kernel.org>
> Cc: <netdev@vger.kernel.org>
> ---
>  drivers/net/wireless/zydas/zd1211rw/zd_mac.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Should I take this or is it going through some other tree?

If it goes to via some other tree:

Acked-by: Kalle Valo <kvalo@codeaurora.org>

-- 
Kalle Valo
