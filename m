Return-Path: <SRS0=SE/f=NZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A8D3C43441
	for <linux-wireless@archiver.kernel.org>; Wed, 14 Nov 2018 10:57:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E53B2145D
	for <linux-wireless@archiver.kernel.org>; Wed, 14 Nov 2018 10:57:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="PCBIHK4C"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4E53B2145D
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732516AbeKNVAE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 14 Nov 2018 16:00:04 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:44717 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732506AbeKNVAC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Nov 2018 16:00:02 -0500
Received: by mail-pl1-f193.google.com with SMTP id s5-v6so7605098plq.11
        for <linux-wireless@vger.kernel.org>; Wed, 14 Nov 2018 02:57:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=+0kev6KKv3umPQyL8BzmKKXIu+p2jc3jeSkckIj2if4=;
        b=PCBIHK4CV8Bq+wIaZSVfnJOKTyEDdgVVs+uxBppBWsLSJmQMdHL5Q2MRaJ/vxr9I2E
         ig3Mq5auhy0t58v6OTevE4/nWvhcLAXTZt0V6kd55SeJjEjtxGSakL6LHAgRRmBOaRXg
         ulFHILlLb5DaQdet867LrCRnkYIfj1nVaAGaI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=+0kev6KKv3umPQyL8BzmKKXIu+p2jc3jeSkckIj2if4=;
        b=LCoD+2Jop3TzvruDJNYiHQ/cP3yjt8Q9gzKwJdZ8PICCh78EWwMKB5MOvATgKqL7HR
         0JEWHCLSl/1zRhimX82CqruK2MtWoQOQwyNwrKbQUz9TI0G+3Ycd0QASrwoH7IC+SsD0
         KHg6zdEQRu/daMBCxa/6xUfSN0bHmddntAXbgKWISLsH5drHIMN5ru7OcW2abb7gKj8A
         h0faQdI9zzjtct20caxaANIBjdBAqtuU8njmrC4ZT6LI2DwzwD2rkPFhXWgVktEzMPLY
         /hEnmmzIlzxefoH+4gEoaTTyCaTchE4QB7Cp8Fy73CtjfGN192ieBAChyBVv6WUPlpkZ
         pPWQ==
X-Gm-Message-State: AGRZ1gKEhSzdd/kg2M4TJj7LTR7vEW4jM1XIx7RwEvU5aIhvDgHss975
        TTGmC121wr8FYelzkLN8e8RTU5F7VTqo8g==
X-Google-Smtp-Source: AJdET5e9izSgcyXcwoKpOaO58Vqt++gpMjtDa5uu0ri0h8u3PY38iYt31OfvaZcYgmyUTYbVbs7aiA==
X-Received: by 2002:a17:902:33c1:: with SMTP id b59-v6mr1390228plc.71.1542193037112;
        Wed, 14 Nov 2018 02:57:17 -0800 (PST)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id l72-v6sm27148193pfi.149.2018.11.14.02.57.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Nov 2018 02:57:16 -0800 (PST)
Subject: Re: [PATCH] brcmfmac: Use standard SKB list accessors in
 brcmf_sdiod_sglist_rw.
To:     Andy Duan <fugang.duan@nxp.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20181110.163402.130407398146253939.davem@davemloft.net>
 <VI1PR0402MB36009CD578B9CDBF4449130FFFC30@VI1PR0402MB3600.eurprd04.prod.outlook.com>
 <9667eb4f-36a1-0439-867b-1defc5946bc2@broadcom.com>
 <VI1PR0402MB3600F31F8665EB1BDAFBAE36FFC30@VI1PR0402MB3600.eurprd04.prod.outlook.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <6679c7f3-9df2-1eb0-6f0d-725717460a82@broadcom.com>
Date:   Wed, 14 Nov 2018 11:57:13 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <VI1PR0402MB3600F31F8665EB1BDAFBAE36FFC30@VI1PR0402MB3600.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 11/14/2018 11:54 AM, Andy Duan wrote:
> From: Arend van Spriel [mailto:arend.vanspriel@broadcom.com] Sent: 2018年11月14日 16:40
>> To: Andy Duan <fugang.duan@nxp.com>; David Miller
>> <davem@davemloft.net>; netdev@vger.kernel.org
>> Cc: linux-wireless@vger.kernel.org
>> Subject: Re: [PATCH] brcmfmac: Use standard SKB list accessors in
>> brcmf_sdiod_sglist_rw.
>>
>> On 11/14/2018 4:28 AM, Andy Duan wrote:
>>> From: David Miller <davem@davemloft.net> Sent: 2018年11月11日 8:34
>>>> [ As I am trying to remove direct SKB list pointer accesses I am
>>>>   committing this to net-next.  If this causes a lot of grief I
>>>>   can and will revert, just let me know. ]
>>
>> [...]
>>
>>>
>>> I just have bcm4339 in hands, test the patch on i.MX7D sdb board with
>> bcm4339, it works fine with iperf testing.
>>>
>>> Tested-by: Fugang Duan <fugang.duan@nxp.com>
>>
>> Thanks, Andy
>>
>> Can you do one more check? Please insert brcmfmac with module parameter
>> debug=2 and let me know if the following log message is seen:
>>
>> brcmfmac: brcmf_sdiod_sgtable_alloc: nents=X
>>
>> If not seen, the driver does not go through the patched code.
> My kernel don't enable debug and DEBUG and CONFIG_BRCM_TRACING, I add the debug info in the brcmf_sdiod_sgtable_alloc(), and the log show the driver go through the sg path:
> Log: brcmf_sdiod_sgtable_alloc: max_segs:128, sg_support:1, nents=35

Thanks, Andy

Works for me ;-)

Regards,
Arend

