Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6994EC43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 14:40:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 18F0C208AE
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 14:40:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="WumHJ+G9";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="l0447nTa"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 18F0C208AE
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729455AbeJAVS5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 17:18:57 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:51652 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728979AbeJAVS5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 17:18:57 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 0D6D46079B; Mon,  1 Oct 2018 14:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538404849;
        bh=JwVSc1aL2RTeWxsEa8NU9eR1IvFYaKHLNBVJe6KPfCA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=WumHJ+G96Ypd7fz+zEaFTcryRARFJ0KK2A6xnaZQyvzNzCDLGVHRnfsgYQ28i260U
         HZkg/YNxl+rPFMJEvukaBA0/jmv4d1DqP1RuxmjE5wUTylDnTfAuM+zOOT1VRPNxRR
         28eSbcghPDherV9nR6eatmj+mOAixNgS4eoxxG6s=
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DCB116021C;
        Mon,  1 Oct 2018 14:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538404848;
        bh=JwVSc1aL2RTeWxsEa8NU9eR1IvFYaKHLNBVJe6KPfCA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=l0447nTawyQy3QDOKE/LSG7C3RKnv1++fWRjKTiZ4RqNlBYSeIxCosfSobSYQV5By
         xhrq1XLVkWUZHvIdem/oRzmuGONSFB2oCQp5R80pZ8uyqpdJo7IKOEcl4pvW0C4DTC
         8Wov7GcJ3mji6lzeZ62I+FeI5jeGBNJrsF4DaE9k=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DCB116021C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     kbuild test robot <lkp@intel.com>
Cc:     Balaji Pothunoori <bpothuno@codeaurora.org>,
        linux-wireless@vger.kernel.org, kbuild-all@01.org,
        ath10k@lists.infradead.org
Subject: Re: [PATCH v3] ath10k: management tx ack rssi capability check
References: <1536560670-4292-1-git-send-email-bpothuno@codeaurora.org>
        <201809111249.14EbLF2t%fengguang.wu@intel.com>
Date:   Mon, 01 Oct 2018 17:40:44 +0300
In-Reply-To: <201809111249.14EbLF2t%fengguang.wu@intel.com> (kbuild test
        robot's message of "Tue, 11 Sep 2018 12:05:12 +0800")
Message-ID: <87sh1pk9w3.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

kbuild test robot <lkp@intel.com> writes:

> Hi Balaji,
>
> Thank you for the patch! Yet something to improve:
>
> [auto build test ERROR on ath6kl/ath-next]
> [cannot apply to v4.19-rc3 next-20180910]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
>
> url:    https://github.com/0day-ci/linux/commits/Balaji-Pothunoori/ath10k-management-tx-ack-rssi-capability-check/20180911-105502
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git ath-next
> config: xtensa-allmodconfig (attached as .config)
> compiler: xtensa-linux-gcc (GCC) 8.1.0
> reproduce:
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         GCC_VERSION=8.1.0 make.cross ARCH=xtensa 
>
> All errors (new ones prefixed by >>):
>
>    drivers/net/wireless/ath/ath10k/mac.c: In function 'ath10k_mac_register':
>>> drivers/net/wireless/ath/ath10k/mac.c:8485:11: error:
>> 'NL80211_EXT_FEATURE_ACK_SIGNAL_SUPPORT' undeclared (first use in
>> this function); did you mean
>> 'NL80211_EXT_FEATURE_DATA_ACK_SIGNAL_SUPPORT'?
>               NL80211_EXT_FEATURE_ACK_SIGNAL_SUPPORT);
>               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>               NL80211_EXT_FEATURE_DATA_ACK_SIGNAL_SUPPORT
>    drivers/net/wireless/ath/ath10k/mac.c:8485:11: note: each undeclared identifier is reported only once for each function it appears in

This is expected as this depends on a cfg80211 patch not yet in my
ath.git tree:

9c06602b1b92 cfg80211: clarify frames covered by average ACK signal report

Currently in net-next.

-- 
Kalle Valo
