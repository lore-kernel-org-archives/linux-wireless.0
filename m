Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC5F0C64EBC
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 09:10:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7060F2098A
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 09:10:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="W3t1h0OO";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="RXRdFL8N"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7060F2098A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727754AbeJCP6M (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 11:58:12 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:54488 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727347AbeJCP6M (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 11:58:12 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 3AFF460BE8; Wed,  3 Oct 2018 09:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538557841;
        bh=F+BXYmSVaUTNu4BN1bSv1S9lV/leQUPHCsLSMS14s0k=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=W3t1h0OOevh8KDdSmnov+jgDCIXgZGgxMJhJgn6RtAv9HGiAnsTcddQOaiYzICXUl
         VHBG5Npy0OZEpQ9PAv8KRBz+WAAJtlaeYn3c4rIoCN3nRPelVbJ8MI6nULxM28NsUK
         FGodjtpvXb4tbugYF1P1psWK1rVACq6cEh1c9HJ8=
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1085D60B26;
        Wed,  3 Oct 2018 09:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538557840;
        bh=F+BXYmSVaUTNu4BN1bSv1S9lV/leQUPHCsLSMS14s0k=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=RXRdFL8NoVi41JkngoJOF0VM0ZfAkObROM4WossOcczORYRf3L+r4GXEozyTp20zB
         nDOQc8Rx243y/6Nk8jzUh/0b9DyWf830IoJ40kXCUoaAFWaaP+9AfQ9C+RumCUg7rz
         WmMv+wSAWX0+9zqnQVV5M9Q++zcAUabrmFQ2wfO0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1085D60B26
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     linux-kernel@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RESEND] [PATCH 3/3] iwlwifi: Load firmware exclusively for Intel WiFi
References: <20181003073556.28154-1-kai.heng.feng@canonical.com>
        <20181003073556.28154-3-kai.heng.feng@canonical.com>
Date:   Wed, 03 Oct 2018 12:10:35 +0300
In-Reply-To: <20181003073556.28154-3-kai.heng.feng@canonical.com> (Kai-Heng
        Feng's message of "Wed, 3 Oct 2018 15:35:56 +0800")
Message-ID: <87y3bfiees.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Kai-Heng Feng <kai.heng.feng@canonical.com> writes:

> To avoid the firmware loading race between Bluetooth and WiFi on Intel
> 8260, load firmware exclusively when BT_INTEL is enabled.
>
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>

Still the commit log tells nothing about the actual problem which makes
review impossible.

-- 
Kalle Valo
