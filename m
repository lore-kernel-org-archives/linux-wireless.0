Return-Path: <SRS0=qAu2=SM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D45D3C10F11
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Apr 2019 09:17:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A15962077C
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Apr 2019 09:17:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cogentembedded-com.20150623.gappssmtp.com header.i=@cogentembedded-com.20150623.gappssmtp.com header.b="oP3PRsaW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728844AbfDJJRz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Apr 2019 05:17:55 -0400
Received: from mail-lj1-f177.google.com ([209.85.208.177]:35130 "EHLO
        mail-lj1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726494AbfDJJRz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Apr 2019 05:17:55 -0400
Received: by mail-lj1-f177.google.com with SMTP id t4so1438772ljc.2
        for <linux-wireless@vger.kernel.org>; Wed, 10 Apr 2019 02:17:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ID6XPzG2MmfoFKHRThuc5MXUtsCkXKVWeH8YUFlCGPE=;
        b=oP3PRsaWBHUV3dltNkexKYxRaONV6R3FwrSMBe3y7+54qSALQVCsp2oG8+5uz1hu4G
         n7h0Ul+sg30TPHK0rZdjvN+GDJ6u0+kP6hFWyFPgDRb2ISMWG6u8JW2x1RT5QewSEpcr
         K8mmzBoSYO2ooTNtYpjO98Va9Te4EXUI6OANplB/MnrIz5BVykXke6WYdVCIhqXXGXzV
         +2iz0DoUfGs2jc8WRGvaEGGH/0QO6zWHwsXMCPvG2FP5P9yTOu0NoopVcpUQcWKY0fZY
         0BLgQhioV1Nh9MKa8OIfe+NjE7DFAtxDxHte868/dwEkWjZv3PI6+zUIfFpeLl7b8CvE
         BSIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ID6XPzG2MmfoFKHRThuc5MXUtsCkXKVWeH8YUFlCGPE=;
        b=QJDg/qfJksjlXp4x0I3OdNPGKOiSoAR34J5qVf23pffoYDw0V18fgTxsAsqSnjGkNv
         pKYJ6vvyck9TKcKOBn7Yw61lHIKhiaLPL1iK1P4JD5TEXx2u1UlCzi+gF3P4PWcpb0Yt
         IhCUDY4M3nk+2ph5DkeLfHV/ZTYJ59aCcJyM/mJ/1eI+BtpQcyp+K+dgz3KnA1KiMBJw
         OLrdGostG445cM7/5+aoQP20+NYzg/8L/G3RxFc2bn0KYaizn6mIsRbVV20+Ffx/vBlF
         nqMMRmoqR6LbQq5Xh9FSb7RC9tBRnuH/zf/QdZzbBsmT4G/i/zWJ8UE7xksDemTy0SHi
         GMaQ==
X-Gm-Message-State: APjAAAWt+3HaiWCiwJUAeO3xnmtjR3BJY8KNBbQ54zMvpha7fyeFfQJN
        MCRwsdwCjkRJqRzoJEHv75s8/Q==
X-Google-Smtp-Source: APXvYqx2tocWjRIdlcvj+15sXwP9Fw80PJM1lCElkDWIWPrcsXBDE9yLx995DjbeiSQZQFYZgrYJsA==
X-Received: by 2002:a2e:b01a:: with SMTP id y26mr5800176ljk.38.1554887873181;
        Wed, 10 Apr 2019 02:17:53 -0700 (PDT)
Received: from [192.168.0.199] ([31.173.86.11])
        by smtp.gmail.com with ESMTPSA id d13sm867441lfa.40.2019.04.10.02.17.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Apr 2019 02:17:52 -0700 (PDT)
Subject: Re: [PATCH][V2] brcmfmac: fix leak of mypkt on error return path
To:     Colin King <colin.king@canonical.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190409114333.24342-1-colin.king@canonical.com>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <1cf38a7d-ddc8-bfe2-3c6b-8298facc6d1d@cogentembedded.com>
Date:   Wed, 10 Apr 2019 12:17:46 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190409114333.24342-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 09.04.2019 14:43, Colin King wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently if the call to brcmf_sdiod_set_backplane_window fails then
> then error return path leaks mypkt. Fix this by returning by a new

    One "then" is enough. :-)

> error path labelled 'out' that calls brcmu_pkt_buf_free_skb to free
> mypkt.  Also remove redundant check on err before calling
> brcmf_sdiod_skbuff_write.
> 
> Addresses-Coverity: ("Resource Leak")
> Fixes: a7c3aa1509e2 ("brcmfmac: Remove brcmf_sdiod_addrprep()")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
[...]

MBR, Sergei
