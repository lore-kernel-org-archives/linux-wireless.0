Return-Path: <SRS0=7415=NL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75305ECDE44
	for <linux-wireless@archiver.kernel.org>; Wed, 31 Oct 2018 18:49:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00B8D2080A
	for <linux-wireless@archiver.kernel.org>; Wed, 31 Oct 2018 18:49:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CP+k9s+D"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 00B8D2080A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lwfinger.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730720AbeKADsm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 31 Oct 2018 23:48:42 -0400
Received: from mail-ot1-f44.google.com ([209.85.210.44]:37456 "EHLO
        mail-ot1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730228AbeKADsm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Oct 2018 23:48:42 -0400
Received: by mail-ot1-f44.google.com with SMTP id o14so15548029oth.4
        for <linux-wireless@vger.kernel.org>; Wed, 31 Oct 2018 11:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=BRnO7/KWsMT5885w+goNh451ptW0c35zLwH5yNdoaew=;
        b=CP+k9s+DN6odJR1ST7Xh/F6dQhbBK81DoSwQdsfynytgb8NZu6QdjnZOo0vlu7XeyO
         I7nArUOLcGvgYnhiFqI6bVFgcVtr4hD7hbhvG4jxz1uMJCEktBE6F8KgmjzuCKODxp72
         md7H27+X9CwJYp3fhsPNeyppdA/GxcbkCeW7GwVP9OOE3eHz8vzavdT/fQeUcbHiuJww
         6h29Ef4wzhPbdQ3B2ade1W3lcwbMI0F2XUTP1+5REVquyzVfQwQQtBr3ZbcZ8GHdAU0B
         Pq0jljue5c9Nx4dZ9/69fpw5y+ubW188P3rpymQKnj3HuBpP2FBrem9Z9xA/J3GNavAi
         xb0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:to:cc:from:subject:message-id:date
         :user-agent:mime-version:content-language:content-transfer-encoding;
        bh=BRnO7/KWsMT5885w+goNh451ptW0c35zLwH5yNdoaew=;
        b=fPYJWf4HdLoaKp4pVb5tKa9wHnC1Zv1gdykeh+6suavZY+whwi74rju7zj8+et1JUo
         KcseAXw9FK0rzxbt6VzfA1tknUa7eEFWJmAUnp6r0mgoW26sdcbxlX+Q4LGjswdA6tyn
         urnxn5eK5bohk4UDXKBT8tuIchNylC1QEW3JKMRc2hWZnOM4femJf7d62eQjNIO3GjFk
         ortIdeBEBFekIfI32s/BEOImQgOUhgAm9CGGW2po68VhULCO+XFgZEYAvEMF+o/1V/wU
         VddsMlzDdAlGT6vaG9TI4OXczG57UP8xR1K5QUzAxBkHEeFR5aIMCBkJLCav1aD5NrdY
         1w0w==
X-Gm-Message-State: AGRZ1gIsGjjqP91nRUt8JzgiwNJX3JY57/nwa+c/+2TOfETN1gA4b0eE
        /p6VJYEsUFSN7YJPBWR5OLpl3Gzv
X-Google-Smtp-Source: AJdET5d13XGYRvXBSjJ0OMhb2EP+HUo52zucFrnjc+BCqfZOmWd1+4bwmi4r+evPjkS3fXl1BYF00g==
X-Received: by 2002:a9d:ed1:: with SMTP id 75mr2786407otj.137.1541011764764;
        Wed, 31 Oct 2018 11:49:24 -0700 (PDT)
Received: from [192.168.1.118] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id 71sm1541455ote.26.2018.10.31.11.49.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Oct 2018 11:49:23 -0700 (PDT)
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Subject: Fix for memory leak in the wireless extensions layer
Message-ID: <e0ce06aa-9a9a-d763-4b29-57e976dc1cc4@lwfinger.net>
Date:   Wed, 31 Oct 2018 13:49:21 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Greg,

Is the fix for a memory leak in the wext compat layer queued for stable? It is 
in kernel:HEAD as commit 848e616e66d4592fe9afc40743d3504deb7632b4 ("cfg80211: 
fix wext-compat memory leak")

I just receiv3ed a complaint about a leak for a system that is running Ubuntu's 
kernel 4.19.

Unfortunately, this commit has a "fixes" line, but not a Cc for Stable.

Larry

