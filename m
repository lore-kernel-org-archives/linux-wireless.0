Return-Path: <SRS0=SE/f=NZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0E48C43441
	for <linux-wireless@archiver.kernel.org>; Wed, 14 Nov 2018 08:39:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C5F521582
	for <linux-wireless@archiver.kernel.org>; Wed, 14 Nov 2018 08:39:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="XLWlAoLP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9C5F521582
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731746AbeKNSlu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 14 Nov 2018 13:41:50 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33569 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727558AbeKNSlt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Nov 2018 13:41:49 -0500
Received: by mail-wr1-f68.google.com with SMTP id u9-v6so16283427wrr.0
        for <linux-wireless@vger.kernel.org>; Wed, 14 Nov 2018 00:39:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=MLEqtjGmBwdQ1JHCMyJgmAIKQZLLyq2I47cv1xXR34M=;
        b=XLWlAoLPDQBafTe/tWFOxwAUyzrToN0ynsm9BoFMwPIZr7CKr2i+Yk8fk8eayiM4d0
         zdiEphAZ4RQlPWUcUUMbGyGyA9r2hN28cRaVPpNtZ5XD84OCaC3+U5Os8Eyf2KGSUJPd
         QAsuGsMLvdzTVIitqNWG/g0j4WD5R6gLqHTm0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=MLEqtjGmBwdQ1JHCMyJgmAIKQZLLyq2I47cv1xXR34M=;
        b=P7OQI/50TAEyUHi2vY6PLBPr4i8RnUYiGe76TrEjutlh6veRCSyPXMKsLVc6qHKtob
         PwYvpTf1UNqZjNohfg+VHbRKZwQ+XIpy1AhuGolTo9sJ0EqsWwh5c9WTed3+nKz2LRWb
         g93p5AVpdLx6niydNIXxeJA0kyGCiFqQCjLdAF/c4o4scyHgyODJGMbsgI5Gg733V1O+
         dNDiZ2gI2e6gDebpDONe+i4fcRrzPqugw+rAvd7WMSm7qB+6C/uxqk87uHH/JMmGOU1w
         3xmV+ybA4Tl8lKmaplFDQIPobkA1MXZ8XPuHiVCk1Su8Dvi/sL8+EIgx8WyNmj8AMeVk
         TWUg==
X-Gm-Message-State: AGRZ1gI/c1mYq8Ep+gAsuSHTkZPFoYhB2ZT4pozQBiZmrBNTpgBrZxzA
        DTtQlLpOErHikAPG/Pe1LDmcupOFFH4IoQ==
X-Google-Smtp-Source: AJdET5eEUOD+EoVBy9E+Eg+c8fSY295/RCWDuQKt/saUEwd8lwAyeDIvx1xyYnhy1lozMfsSIQtEaQ==
X-Received: by 2002:adf:fd49:: with SMTP id h9-v6mr970215wrs.280.1542184772641;
        Wed, 14 Nov 2018 00:39:32 -0800 (PST)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id h4sm5404825wrt.66.2018.11.14.00.39.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Nov 2018 00:39:31 -0800 (PST)
Subject: Re: [PATCH] brcmfmac: Use standard SKB list accessors in
 brcmf_sdiod_sglist_rw.
To:     Andy Duan <fugang.duan@nxp.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20181110.163402.130407398146253939.davem@davemloft.net>
 <VI1PR0402MB36009CD578B9CDBF4449130FFFC30@VI1PR0402MB3600.eurprd04.prod.outlook.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <9667eb4f-36a1-0439-867b-1defc5946bc2@broadcom.com>
Date:   Wed, 14 Nov 2018 09:39:30 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <VI1PR0402MB36009CD578B9CDBF4449130FFFC30@VI1PR0402MB3600.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 11/14/2018 4:28 AM, Andy Duan wrote:
> From: David Miller <davem@davemloft.net> Sent: 2018年11月11日 8:34
>> [ As I am trying to remove direct SKB list pointer accesses I am
>>   committing this to net-next.  If this causes a lot of grief I
>>   can and will revert, just let me know. ]

[...]

>
> I just have bcm4339 in hands, test the patch on i.MX7D sdb board with bcm4339, it works fine with iperf testing.
>
> Tested-by: Fugang Duan <fugang.duan@nxp.com>

Thanks, Andy

Can you do one more check? Please insert brcmfmac with module parameter 
debug=2 and let me know if the following log message is seen:

brcmfmac: brcmf_sdiod_sgtable_alloc: nents=X

If not seen, the driver does not go through the patched code.

Regards,
Arend

