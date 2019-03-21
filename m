Return-Path: <SRS0=G8on=RY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 220D5C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Mar 2019 17:06:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3DFE218B0
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Mar 2019 17:06:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Klc4kkP4";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Klc4kkP4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728013AbfCURGE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Mar 2019 13:06:04 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:57876 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727138AbfCURGE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Mar 2019 13:06:04 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C83B46156F; Thu, 21 Mar 2019 17:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553187963;
        bh=/gdXfMeOlvTWg62nR02TOe80CqkE7W0v7b/nuENVl7M=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Klc4kkP4+qMzwY0PsW23bFIIOweC6QEeVbivgmVBYTINyK4pG/JxTk1846IAZN3JY
         4rs2oP6UbCMce6Ng+2bjznOpU36NnWUA/4Q+D1T37esEsT655WMaOtAB0PA4umvBQL
         yar54BzSzw4XwiLyJEmJ5ei39xLBQBn9VEjhIfh0=
Received: from x230.qca.qualcomm.com (unknown [195.39.71.253])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7CCE561A6F;
        Thu, 21 Mar 2019 17:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553187963;
        bh=/gdXfMeOlvTWg62nR02TOe80CqkE7W0v7b/nuENVl7M=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Klc4kkP4+qMzwY0PsW23bFIIOweC6QEeVbivgmVBYTINyK4pG/JxTk1846IAZN3JY
         4rs2oP6UbCMce6Ng+2bjznOpU36NnWUA/4Q+D1T37esEsT655WMaOtAB0PA4umvBQL
         yar54BzSzw4XwiLyJEmJ5ei39xLBQBn9VEjhIfh0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7CCE561A6F
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     Anthony Wong <anthony.wong@canonical.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        ath10k@lists.infradead.org
Subject: Re: Ath10k on XPS 9380 regularly disconnects
References: <042C2903-585B-47BA-8657-8819D225EEA8@canonical.com>
Date:   Thu, 21 Mar 2019 19:05:59 +0200
In-Reply-To: <042C2903-585B-47BA-8657-8819D225EEA8@canonical.com> (Kai-Heng
        Feng's message of "Tue, 19 Mar 2019 13:35:07 +0800")
Message-ID: <87pnqknonc.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

+ ath10k list
- netdev & linux-kernel

Kai-Heng Feng <kai.heng.feng@canonical.com> writes:

> There=E2=80=99s an issue that ath10k disconnects at regular basis [1], on
> Linux kernel 4.18.
>
> Unfortunately I can=E2=80=99t reproduce the issue on XPS 9380 at my hand.
>
> Is there already a fix in upstream kernel?

I'm not aware of any fixes related to this. Is this a regression? In
other words, is there a known version of ath10k or firmware which didn't
have this problem?

> [1] https://bugs.launchpad.net/bugs/1818881

Relevant information from dmesg:

[   19.346810] ath10k_pci 0000:02:00.0: qca6174 hw3.2 target 0x05030000 chi=
p_id 0x00340aff sub 1a56:143a
[   19.346812] ath10k_pci 0000:02:00.0: kconfig debug 0 debugfs 1 tracing 1=
 dfs 0 testmode 0
[   19.347136] ath10k_pci 0000:02:00.0: firmware ver WLAN.RM.4.4.1-00132-QC=
ARMSWP-1 api 6 features wowlan,ignore-otp,mfp crc32 79f4db86

[...]

[77451.338339] WARNING: CPU: 4 PID: 0 at /build/linux-hwe-9KJ07q/linux-hwe-=
4.18.0/drivers/net/wireless/ath/ath10k/htt_rx.c:46 ath10k_htt_rx_pop_paddr.=
isra.29+0xd9/0xf0 [ath10k_core]

[...]

[81254.857667] WARNING: CPU: 1 PID: 0 at /build/linux-hwe-9KJ07q/linux-hwe-=
4.18.0/drivers/net/wireless/ath/ath10k/htt_rx.c:46 ath10k_htt_rx_pop_paddr.=
isra.29+0xd9/0xf0 [ath10k_core]

[...]

[81390.186167] WARNING: CPU: 2 PID: 0 at /build/linux-hwe-9KJ07q/linux-hwe-=
4.18.0/drivers/net/wireless/ath/ath10k/htt_rx.c:46 ath10k_htt_rx_pop_paddr.=
isra.29+0xd9/0xf0 [ath10k_core]

--=20
Kalle Valo
