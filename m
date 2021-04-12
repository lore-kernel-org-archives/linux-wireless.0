Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 388E7C433ED
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Apr 2021 08:37:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D824661206
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Apr 2021 08:37:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237361AbhDLIhW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 12 Apr 2021 04:37:22 -0400
Received: from lpdvacalvio01.broadcom.com ([192.19.229.182]:47822 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237270AbhDLIhV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Apr 2021 04:37:21 -0400
Received: from bld-lvn-bcawlan-34.lvn.broadcom.net (bld-lvn-bcawlan-34.lvn.broadcom.net [10.75.138.137])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 79FDFE5;
        Mon, 12 Apr 2021 01:37:03 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 79FDFE5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1618216623;
        bh=jBfh6npb0yL/ex1Q8+Ymfh38WXrBk7BsfPIs8dfyMI8=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=OWkDQ8M8bmCw5yEVCEj1CMx4mweMsTgxJvhbSK+24d6oG8rb9n6rRs9txz5ynlb5b
         BB8Hd+unvW3RMzpW3dKEvZ+/CiveypsiUhVRVV9t6rzs3/02lTwPU2AOt25jHBmWyu
         s4+NXyiiF4dfFPfHIAqlUtHoMbjUd63dq24X+/lE=
Received: from [10.230.42.155] (unknown [10.230.42.155])
        by bld-lvn-bcawlan-34.lvn.broadcom.net (Postfix) with ESMTPSA id 1A58E1874BD;
        Mon, 12 Apr 2021 01:36:55 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: Add support for BCM43596 PCIe Wi-Fi
To:     Konrad Dybcio <konrad.dybcio@somainline.org>,
        phone-devel@vger.kernel.org
Cc:     ~postmarketos/upstreaming@lists.sr.ht, martin.botka@somainline.org,
        angelogioacchino.delregno@somainline.org,
        marijn.suijten@somainline.org,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210307113550.7720-1-konrad.dybcio@somainline.org>
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5e7b575a-7820-3d10-8617-36911d49f4a9@broadcom.com>
Date:   Mon, 12 Apr 2021 10:36:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210307113550.7720-1-konrad.dybcio@somainline.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 07-03-2021 12:35, Konrad Dybcio wrote:
> Add support for BCM43596 dual-band AC chip, found in
> SONY Xperia X Performance, XZ and XZs smartphones (and
> *possibly* other devices from other manufacturers).
> The chip doesn't require any special handling and seems to work
> just fine OOTB.
> 
> PCIe IDs taken from: https://github.com/sonyxperiadev/kernel/commit/9e43fefbac8e43c3d7792e73ca52a052dd86d7e3.patch

I don't see 4359 firmware in linux-firmware repo so what are you using?

Regards,
Arend
