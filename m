Return-Path: <SRS0=r36G=NP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0A1DC32789
	for <linux-wireless@archiver.kernel.org>; Sun,  4 Nov 2018 15:43:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75D6A2082A
	for <linux-wireless@archiver.kernel.org>; Sun,  4 Nov 2018 15:43:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="raH1+OT1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 75D6A2082A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730608AbeKEA6c (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 4 Nov 2018 19:58:32 -0500
Received: from mail-wr1-f41.google.com ([209.85.221.41]:38507 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730531AbeKEA6b (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 4 Nov 2018 19:58:31 -0500
Received: by mail-wr1-f41.google.com with SMTP id d10-v6so6764346wrs.5
        for <linux-wireless@vger.kernel.org>; Sun, 04 Nov 2018 07:43:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=reply-to:to:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=9Ch9b9RrZRGhCom52W3RQtc/PsHaX+6RXAxU/RqX1GE=;
        b=raH1+OT1W5ASoFr3/DksW7xDspnVQyTTnBUw9EZFfC7bHDECcyvE7rmde54QgHz/aO
         JlsGsPYasqFF63sAKJ35bjCS9v63cir/lo7BeiPXaMW33CxRmQlIJOnFsQ/RaSl43IK0
         4sQTGCECDcTMkGRcekrdRTOpis9n37UvK2wQCH3OzRrzweWMLJio4PR7jnT7eqvaaZ5t
         7hKVsAaqf6ohAwoyIHk4bWzH/SfCKO03YpDobEJ0wNTa/CSVDR9+/hwKAu2Kdfn02d08
         nJPQ1wdFWhlm2TxpQCZN94g1hz0vCtb6GuEPyeXlGZtETrtdNkXRDSoCQhZSxlW+pzaT
         Gmpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:to:from:subject:message-id:date
         :user-agent:mime-version:content-transfer-encoding:content-language;
        bh=9Ch9b9RrZRGhCom52W3RQtc/PsHaX+6RXAxU/RqX1GE=;
        b=iwEf1ashSm1Ln+aSNHhGV1qfwt6obtivdLP+zorU6NTLFZ0bC/jDZbMhw1AFBC4Xx9
         3GxBiudR/f4wfkrupgE2wz27fzv2wbuHU83/IPAndoA/wmut3wtpST+c0TbKgHe9axAC
         yWHG7E6gsVRHiFOkkeESicqS9WPsr7TdNKivwVKbLQnH3WIRhie0Cv+DmwqPtlGHpc14
         p3uFe69xDD48OIf6v9Dey5Ee1Y1IKuhpwsW8Ej+HW+NtMXBY5YMskiZzo+bbUzjGf5Hm
         clHsk07R0KUI3x9QwjfYvnMw4nzV0LTP32GTPelaSnvwpUJ3RIToEvASDceksXnUFGvy
         rZYA==
X-Gm-Message-State: AGRZ1gJfpE0qP6M+iemv4Crj4ZuoNYOMTdMi/WdzOBqXatJuy46pUZ7E
        naoZlAlcEVzE1USkNHe+X0pYIz3F
X-Google-Smtp-Source: AJdET5cUNpuqFHQZF9KJbS+f7VI6sWUFKjI+hNe6FF/h9M8lzW2qotwEin27NudEL/FgLAkBUHxfcQ==
X-Received: by 2002:adf:fbc6:: with SMTP id d6-v6mr12592142wrs.241.1541346186050;
        Sun, 04 Nov 2018 07:43:06 -0800 (PST)
Received: from [192.168.1.215] (host109-156-61-147.range109-156.btcentralplus.com. [109.156.61.147])
        by smtp.gmail.com with ESMTPSA id p16-v6sm12675629wro.29.2018.11.04.07.43.05
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 04 Nov 2018 07:43:05 -0800 (PST)
Reply-To: tjcw@cantab.net
To:     linux-wireless@vger.kernel.org
From:   Chris Ward <tjcw01@gmail.com>
Subject: Driver for RealTek RTL8811AU dual-band USB WiFi adapter
Message-ID: <fed00b53-2468-55ea-fa98-0a324a469075@gmail.com>
Date:   Sun, 4 Nov 2018 15:43:04 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

I recently bought one of these 
https://www.amazon.co.uk/gp/product/B07C4JQZSP/ref=oh_aui_detailpage_o01_s01?ie=UTF8&psc=1 
;
a dual-band wifi adapter. It came with source for a Linux driver, which 
required some patching to get it to work with the
4.19 kernel. Can I interest a kernel developer to integrate this into 
kernel.org ? It would save me
effort at further patching if someone else kept it current as the kernel 
changes.

The driver from Amazon is here 
https://drive.google.com/open?id=1AYmjFk2l5jTpnAzLPNpetSGefm4khEBi
and my patch is here 
http://tjcw.freeshell.org/Patches/rawhide-20181031.patch .

The Amazon driver is stated to be GPL, and I am content for my work to 
be GPL also.

If you need further information, please email me (tjcw at cantab.net)

-- 
Chris Ward

