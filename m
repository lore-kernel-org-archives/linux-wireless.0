Return-Path: <SRS0=TVdy=PP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44779C43612
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Jan 2019 13:33:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 14B8B206B6
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Jan 2019 13:33:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Pm8xTDeg";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Q6HwPujf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727654AbfAGNdC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 7 Jan 2019 08:33:02 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:38296 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726886AbfAGNdC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Jan 2019 08:33:02 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 359E660593; Mon,  7 Jan 2019 13:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1546867982;
        bh=BwXqca18cf3Jzd2q6qFYRtz1Q1b0eGsEv5GDzrt9S38=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Pm8xTDegaLxNzkOeh0OclgtiLsBaAUnQIAjfjTzqCyk4MWdDi4mNqrjgm2hyANnDL
         aSv2eY/CyifClseVGfKV8CrlzkU3EAMHB1rjPPuGxxklQNPEnwUrUxLFXJunGMgh6B
         +1sCm1Gw47/URqtcbN/L6QxTqn5qlr9/c9o6yS58=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 640C6601D1;
        Mon,  7 Jan 2019 13:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1546867981;
        bh=BwXqca18cf3Jzd2q6qFYRtz1Q1b0eGsEv5GDzrt9S38=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Q6HwPujf4MS3PPhHTJQt6BuPikNSJNWhg0nscxMEnlH33jWxlHE56aPbsXyb3N9n9
         eODllMAtUkRYsHwSMF2Gb89EJShurGiPJd+viJvw80+qpJ6r2MWM6v/9FZnekHKNb1
         ndL6syDEQpEYij1+iGVWHeP6eICu7DOycnU4GR3M=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 640C6601D1
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     kbuild test robot <lkp@intel.com>
Cc:     Luca Coelho <luciano.coelho@intel.com>, kbuild-all@01.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: ERROR: "ieee80211_hdrlen" [drivers/net/wireless/intel/iwlwifi/iwlwifi.ko] undefined!
References: <201901071217.9zkGKNxN%fengguang.wu@intel.com>
Date:   Mon, 07 Jan 2019 15:32:58 +0200
In-Reply-To: <201901071217.9zkGKNxN%fengguang.wu@intel.com> (kbuild test
        robot's message of "Mon, 7 Jan 2019 12:53:59 +0800")
Message-ID: <87o98ssid1.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

+ linux-wireless

kbuild test robot <lkp@intel.com> writes:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> head:   574823bfab82d9d8fa47f422778043fbb4b4f50e
> commit: aca432f06b8a60a92b27fb46e6518a19b28ca93f iwlwifi: make MVM and
> DVM depend on MAC80211
> date:   3 weeks ago
> config: x86_64-randconfig-i1-01061720 (attached as .config)
> compiler: gcc-7 (Debian 7.3.0-1) 7.3.0
> reproduce:
>         git checkout aca432f06b8a60a92b27fb46e6518a19b28ca93f
>         # save the attached .config to linux build tree
>         make ARCH=x86_64 
>
> All errors (new ones prefixed by >>):
>
>>> ERROR: "ieee80211_hdrlen"
>>> [drivers/net/wireless/intel/iwlwifi/iwlwifi.ko] undefined!
>>> ERROR: "ieee80211_channel_to_frequency"
>>> [drivers/net/wireless/intel/iwlwifi/iwlwifi.ko] undefined!
>>> ERROR: "reg_query_regdb_wmm"
>>> [drivers/net/wireless/intel/iwlwifi/iwlwifi.ko] undefined!

Luca, I guess you will send a fix for 5.0?

-- 
Kalle Valo
