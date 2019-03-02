Return-Path: <SRS0=UNZO=RF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FF6BC4360F
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Mar 2019 01:46:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E101620815
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Mar 2019 01:46:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZLdnBn+9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbfCBBql (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Mar 2019 20:46:41 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:45076 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726007AbfCBBqk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Mar 2019 20:46:40 -0500
Received: by mail-ot1-f66.google.com with SMTP id i12so1517289otp.12;
        Fri, 01 Mar 2019 17:46:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0EOKD+tge+5GZtEzmSYbhOX+UjfkXXhiwhiyqi8FI50=;
        b=ZLdnBn+9LH49v8so8G5C0cWGIxDgYsoK63qn5ENNKEl1eNOIiTh0rmnhFo44D24MFL
         rnYGpItG5QSUOyLUpaCSqWt4wRXb1T8DjauZdChcc1OZJoYBV9reW5R6X99WGMde+vLy
         Z1RE7istzUuIfQeY5idRv3cxMu8b1MFS2Jwz22UciExU36oNPcE76LxnK6XfRD7539e/
         oazuPQMR29gn+UrGt/96GIZ+I/me3Sj9Hcrq09EeVztd6WQq3a9UewWBmUKxn8CDRngT
         pKt9M3wQ21YoWpHFkj6pXXOQcz3nU8XYVe+uhTFe5RW3kuQomp5zCbKw+Z3V1dvsF1df
         hZZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0EOKD+tge+5GZtEzmSYbhOX+UjfkXXhiwhiyqi8FI50=;
        b=mP5Te8FSk0WBEYwIqiY4acoGJfKiE7M2I7gb0182Le0fRIajFnXE8n3e2Q3D4gjgpg
         cJNtjpvdESO9bzobzLQ2rgiZBdyYTL29+LBC8d6bboMJWZpHXcw4ZCpb2rP7pBRi+pAI
         gSBttDE4cAaJLKac1BVfvXST6i09mzUWGuc7KepBN3e2IdXx3QcTvzn1SgUoaD6S0wml
         3jxLiIYA9hf+DzgjROubijbxdJVfRYBYdFLG+iKjjNUCc14GkzhxWqCfW0HtnMAJ3kU3
         6ieDZyxEE51i7BXPtzU7tp1KIyJAcU0Vum90/FRPMSQ9g0OPLAN+C7UJjSB4fr6dfm5F
         g/vQ==
X-Gm-Message-State: APjAAAXT6ECwkQg8d3SGeG958HNCF65dniAik31sEtkRjfpi3GV5khqB
        nc/6nV27grwjiIiksJwfyDA0VID2
X-Google-Smtp-Source: APXvYqyi9Pf1RpXCIuqhvRGyanVvF4aSLv+9DGsO10StBESNkd2DtJs1GP4+JKu0bPo6nJd7kM9ZlQ==
X-Received: by 2002:a9d:6945:: with SMTP id p5mr5551409oto.40.1551491199710;
        Fri, 01 Mar 2019 17:46:39 -0800 (PST)
Received: from [192.168.1.112] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id c131sm9679943oif.3.2019.03.01.17.46.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 01 Mar 2019 17:46:38 -0800 (PST)
Subject: Re: Realtek r8822be kernel module does not negotiate 802.11ac
 connection
To:     "David R. Bergstein" <david.r.bergstein@gmail.com>,
        Tony Chuang <yhchuang@realtek.com>
Cc:     Pkshih <pkshih@realtek.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <51d62a31-7cde-e815-bdee-4ef5433007aa@gmail.com>
 <F7CD281DE3E379468C6D07993EA72F84D17AF74C@RTITMBSVM04.realtek.com.tw>
 <b0518665-d5ca-7c94-9808-7cc0cf565814@gmail.com>
 <e68c6aae-8d71-266a-81fe-d078ac1ef38c@lwfinger.net>
 <6eb7af74-b1a8-d112-e027-6c14252af994@gmail.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <487c350c-c455-b490-8de5-1d68760aa3dc@lwfinger.net>
Date:   Fri, 1 Mar 2019 19:46:37 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <6eb7af74-b1a8-d112-e027-6c14252af994@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 3/1/19 4:26 PM, David R. Bergstein wrote:
> Larry,
> 
> Thanks for the response and detailed instructions, which allowed me to
> build and install the rtw88 kernel module.  I cannot however seem to get
> my system to actually use the module.  Just to recap this is an HP Omen
> laptop with secure boot disabled.  Upon boot-up both the new rtw88 and
> old r8822be modules are loaded.  If I unload the r8822be module the wifi
> network connection gets terminated, even if I unload/reload the rtw88
> module.
> 
> Is there something else I should be doing prior to invoking rtw88, e.g.,
> blacklisting the old module?

Yes, r8822be must be blacklisted. Use the lsmod command to see what modules are 
actually loaded. You load/unload rtw88 using the rtwpci module.

Larry

