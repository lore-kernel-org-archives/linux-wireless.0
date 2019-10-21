Return-Path: <SRS0=EcM/=YO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22C2ACA9EAF
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Oct 2019 20:53:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DDA8F2084B
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Oct 2019 20:53:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="YW32VXPa";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="YW32VXPa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730155AbfJUUxz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 21 Oct 2019 16:53:55 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:55346 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729869AbfJUUxy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Oct 2019 16:53:54 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 45636606CF; Mon, 21 Oct 2019 20:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571691232;
        bh=ikBlLAXjuPjJKKZAogZN3uYAQw2bdK9WZzTszkpUbu0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YW32VXPaQDzeQOor7aAd9eGUE1Xuo5R05I5JzTGEmW01F2W2F+xO7iCSxuvcOPJpV
         VSIKvcz05wdGJrfEyALf570Pc5TNS5MofymtBnG3TVBWkr8zKR34GIBfT6Mmcx1ngX
         2htcKhmp5udKexcB2HcwxNhOgfxXEkEzJVSohydc=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id E97FF60716;
        Mon, 21 Oct 2019 20:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571691232;
        bh=ikBlLAXjuPjJKKZAogZN3uYAQw2bdK9WZzTszkpUbu0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YW32VXPaQDzeQOor7aAd9eGUE1Xuo5R05I5JzTGEmW01F2W2F+xO7iCSxuvcOPJpV
         VSIKvcz05wdGJrfEyALf570Pc5TNS5MofymtBnG3TVBWkr8zKR34GIBfT6Mmcx1ngX
         2htcKhmp5udKexcB2HcwxNhOgfxXEkEzJVSohydc=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 21 Oct 2019 13:53:51 -0700
From:   Jeff Johnson <jjohnson@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        ath11k@lists.infradead.org
Subject: Re: [PATCH v2 02/49] ath11k: add Kconfig
In-Reply-To: <1571565847-10338-3-git-send-email-kvalo@codeaurora.org>
References: <1571565847-10338-1-git-send-email-kvalo@codeaurora.org>
 <1571565847-10338-3-git-send-email-kvalo@codeaurora.org>
Message-ID: <6ffc215251b54d562496d978bdbbcead@codeaurora.org>
X-Sender: jjohnson@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2019-10-20 03:03, Kalle Valo wrote:
> [...snip...]
> +config ATH11K_TRACING
> +	bool "ath11k tracing support"
> +	depends on ATH11K && EVENT_TRACING
> +	---help---
> +	  Select this to ath11k use tracing infrastructure.

Help text does not parse
