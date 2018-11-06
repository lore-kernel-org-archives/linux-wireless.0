Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46018C32789
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 16:23:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DC8C2085B
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 16:23:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="aLleG/sZ";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="eXPWTmVW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0DC8C2085B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389259AbeKGBtc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 20:49:32 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:60492 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387685AbeKGBtc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 20:49:32 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D750760591; Tue,  6 Nov 2018 16:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541521414;
        bh=OAWpQjHsTX3vd3PEAzRMwR+F9prsRI/qT9DILglQOYw=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=aLleG/sZE4quZIwyiD9bNVs0LwMWU7phoVvA6f/qev+2391Qnn+MVfcGgGjsNRPcc
         zUSSNQULb5XwnZ1b2inMKuKG0yxBUseZ08o9RazMJE3pLVTRVSmz9ljvS9E/DcOWVS
         BpYRwup8pjX2uqG7idgpV1BYDsquI/RzBHWuxFkU=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id EFE48603D2;
        Tue,  6 Nov 2018 16:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541521414;
        bh=OAWpQjHsTX3vd3PEAzRMwR+F9prsRI/qT9DILglQOYw=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=eXPWTmVWZN+GEG6AU6bN/fWkZMm7xT5vAkyVRyL8zwtII/FMoUkkhfo5FNs0/y/S5
         1MT6AX93s7Jo+ihm3SRATTCp5VcZ42TdOfYKAt6kaUPGEgWMJcP/bhvrexIgoQUUPX
         tm/XqttnHLt5ds0rMabzTT6NMGgFMLPetj/hBK4c=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org EFE48603D2
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/3] ath10k: assign 'n_cipher_suites' for WCN3990
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181102171749.38680-1-briannorris@chromium.org>
References: <20181102171749.38680-1-briannorris@chromium.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Rakesh Pillai <pillair@qti.qualcomm.com>,
        Govind Singh <govinds@qti.qualcomm.com>,
        <linux-kernel@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181106162334.D750760591@smtp.codeaurora.org>
Date:   Tue,  6 Nov 2018 16:23:34 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Brian Norris <briannorris@chromium.org> wrote:

> Commit 2ea9f12cefe4 ("ath10k: add new cipher suite support") added a new
> n_cipher_suites HW param with a fallback value and a warning log. Commit
> 03a72288c546 ("ath10k: wmi: add hw params entry for wcn3990") later
> added WCN3990 HW entries, but it missed the n_cipher_suites.
> 
> Rather than seeing this warning every boot
> 
>   ath10k_snoc 18800000.wifi: invalid hw_params.n_cipher_suites 0
> 
> let's provide the appropriate value.
> 
> Cc: Rakesh Pillai <pillair@qti.qualcomm.com>
> Cc: Govind Singh <govinds@qti.qualcomm.com>
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

3 patches applied to ath-next branch of ath.git, thanks.

2bd345cd2bfc ath10k: assign 'n_cipher_suites' for WCN3990
79169f148655 ath10k: don't assume this is a PCI dev in generic code
cea04e3d8e37 ath10k: fix struct init whitespace in SNOC driver

-- 
https://patchwork.kernel.org/patch/10665915/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

