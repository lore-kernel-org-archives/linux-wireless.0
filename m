Return-Path: <SRS0=UNZO=RF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 185E0C00319
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Mar 2019 18:39:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1B1E20838
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Mar 2019 18:39:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T6DvPdiY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbfCBSjM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 2 Mar 2019 13:39:12 -0500
Received: from mail-oi1-f174.google.com ([209.85.167.174]:34368 "EHLO
        mail-oi1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726368AbfCBSjM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Mar 2019 13:39:12 -0500
Received: by mail-oi1-f174.google.com with SMTP id g16so824906oib.1;
        Sat, 02 Mar 2019 10:39:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5ydMXTOgR5VLSA0eQdZRLW2LaxV3fAtpkkyyvuJtn0A=;
        b=T6DvPdiYaCUtHjIkgy3LWPo0nixdZeaSUKkmBVmZ+5wwboi995nyrlQA5y9KyW+jyo
         RY70KCtg+AjAGQICGZkrCFPwFfhJplLdpHD3Yqfd++/NZcz0L66VJdirQIL/uL7SyF+G
         3Zn+NEvocv5CixGpZnffxWzXeSv5GMQXatb69U8FjdOIsNU1/Z6PkZYGxgqgSkeb1Eg8
         83X3XnLpWlp9hOf3sVMxwNp3+FlurDQW1SKqZ8WF40zQPv4ThYGuci6D+s3jdd0qgBjt
         DvS0ZkDNl9A7cx32DaA5wWQiUTWWRWwbhhRkjTLYPKWkzD/u5ueCqHRfvp/4LvNIoGQg
         Q0jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5ydMXTOgR5VLSA0eQdZRLW2LaxV3fAtpkkyyvuJtn0A=;
        b=fLudNwNzd3zDmEbOQtLJ6R4QNSWpK+tTBGlBv7qa+e2gPUm5drcF8hquXt8yvmAd0w
         2CbxEOvnWlgsrwtdGlrUzF846l3Os1gq42tqyxOtG1TSFgIgrhqiTuIAWxEdjm2cN9QY
         i3ZiETOU0NZ7/Fb6IjUaBS+3UPXExP43NjXB0/aygmjMbiPdOhBQ3VsPKoq2QmLa3pKr
         KsBZ3kLXvQOCSzEh79pHSSB6/blMoGxUMVGbXWf8pWTcz9R8JSd7JjmaT0d1eeTe+qcJ
         Nw6a+J6jIM5Mlikf+TvYslNzTJOtoMKY3TptnE8JVfI48ElA4b8LeMiHoU4zOEx/U46O
         58KQ==
X-Gm-Message-State: AHQUAua5x25g/GaG6DhSw3z5tMNwvIa2WKaSpIlbRukv0D9x2zyLCSZJ
        XjhOchIiGVoGCSaA7a6MrwxJAIq/
X-Google-Smtp-Source: AHgI3IZ5HZWd/4TULDc/41LKGbZv3o21sX4zXKVI5u7pOyStWQwArPDhQsNmPFOczChXcp+tlxhgGg==
X-Received: by 2002:aca:55d0:: with SMTP id j199mr7370278oib.110.1551551950593;
        Sat, 02 Mar 2019 10:39:10 -0800 (PST)
Received: from [192.168.1.112] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id e12sm549448otr.1.2019.03.02.10.39.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 02 Mar 2019 10:39:09 -0800 (PST)
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
 <487c350c-c455-b490-8de5-1d68760aa3dc@lwfinger.net>
 <2e39892d-d206-e87f-c802-d427c54277cf@gmail.com>
 <8706d34c-1fac-84ba-759d-18d96750636b@gmail.com>
 <27e1a339-023a-360b-1e5d-1a156fc5edd2@gmail.com>
 <c64c435c-fda7-9356-0205-093182fb1398@lwfinger.net>
 <96c5b6c4-61fe-570d-ba2d-7721b1be7cca@gmail.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <20331a61-7d3d-7368-8c11-dbecde52c968@lwfinger.net>
Date:   Sat, 2 Mar 2019 12:39:09 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <96c5b6c4-61fe-570d-ba2d-7721b1be7cca@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 3/2/19 12:09 PM, David R. Bergstein wrote:
> Larry,
> 
> I tried using iw but it gives the same reading for bit rate.  In regard
> to the firmware, it was not installed via "make install" so I did it
> manually.

David,

There was a typo in the Makefile. 'make install' now installs the firmware 
correctly.

Larry


