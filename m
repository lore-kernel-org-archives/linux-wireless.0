Return-Path: <SRS0=42gb=XG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6740AC5ACAE
	for <linux-wireless@archiver.kernel.org>; Wed, 11 Sep 2019 14:22:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A7DF2075C
	for <linux-wireless@archiver.kernel.org>; Wed, 11 Sep 2019 14:22:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ncentric-com.20150623.gappssmtp.com header.i=@ncentric-com.20150623.gappssmtp.com header.b="RuUUnhhk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727576AbfIKOWD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 11 Sep 2019 10:22:03 -0400
Received: from mail-ed1-f41.google.com ([209.85.208.41]:33636 "EHLO
        mail-ed1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726058AbfIKOWD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Sep 2019 10:22:03 -0400
Received: by mail-ed1-f41.google.com with SMTP id o9so20855157edq.0
        for <linux-wireless@vger.kernel.org>; Wed, 11 Sep 2019 07:22:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ncentric-com.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=sArSpBkf+4qlRMOhVCj4DTH+DjrtuWHKyImMKkgWsSI=;
        b=RuUUnhhkmhbxz7dI/bhyFlXpVvysOjcsTjKeE6NKfVEIIRkKGyyXUHhjcLZIbkF9yd
         sfPosM1u/HjqtcWsycz01Ifw6rKYMa1r8hSkF697AMG2Q2CA0g7vAz5vURm2QqHT79GE
         UI56O8n8wXRhuj81rQdaMWbwzIzGKfVvqsk+6N4V1Y5JQlV3O/oRfXeNDsDevlPnwoME
         aHABp1qkDCEw/LxbvZwXUh4T+A7qVebmRaoFKoaw0mvxCwqxbRp0wQRYGGbntHkNAwFi
         oqhYmKG1dfCjQznpGNN07kCAv2w4/45dWph5bX9ugSYfupkKwOSRFbivD+4Dm41Z7EIB
         uFaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=sArSpBkf+4qlRMOhVCj4DTH+DjrtuWHKyImMKkgWsSI=;
        b=j5s6HDC0V2+yGtQAwVzHFVn5BLoHSwebrhF17JtJ7XKGgJZ9NGRK3mdnmUj40ytt8C
         6f/CGjJabtTSNvVnrVbaANIxhlApQfJbrhDmCYiJ6CTCimbUJ4yWLp5md9e2LUkEcIPM
         xEoxsQVzqqyMQCWfNdytrBBq3I8Ija57RheoPFRM4m9FdIpfFcL5Nwb+d5D9msUGs3v/
         6kReVT91pMpArIGkwqfRJTDABtWPYQTOVCJ9i7/chRcXKwwGjf5oGcOli6gEvOysQ3zW
         /GLYwbxNpwPdtfMSdcjaewHa5XhS/jlezs11get/2DDEGOKEasL1tfjvpuSHfrpUySrj
         NHmQ==
X-Gm-Message-State: APjAAAUr/4Rxz3yELJYqOnZsYKxUwaXBX//E0bhCzGj6UHXJleo7nrQG
        u/MtQELhUMzIeGW9IQJZsW8e1xPANQs=
X-Google-Smtp-Source: APXvYqy7x18zjzgVWZ52wMAnrGh9V/EVVqLyZWMUY5A5fmxJgAaKy8xRbzRSYCULP8z0MH03j1hO8Q==
X-Received: by 2002:a05:6402:b0d:: with SMTP id bm13mr24278552edb.125.1568211720915;
        Wed, 11 Sep 2019 07:22:00 -0700 (PDT)
Received: from [192.168.3.176] (d515300d8.static.telenet.be. [81.83.0.216])
        by smtp.gmail.com with ESMTPSA id e20sm2434163eja.75.2019.09.11.07.22.00
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Sep 2019 07:22:00 -0700 (PDT)
To:     linux-wireless@vger.kernel.org
From:   Koen Vandeputte <koen.vandeputte@ncentric.com>
Subject: sta_info - sta_info_get_by_idx()
Message-ID: <1704e157-bb11-0aa8-ec8b-e95a3007fa0c@ncentric.com>
Date:   Wed, 11 Sep 2019 16:21:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi All,

Within sta_info.c, there is a function named sta_info_get_by_idx().

- In sta_info.h, it is marked as BROKEN

- in cfg.c it's actively used in function function ieee80211_dump_station()


So is it broken? or not? :-)

Thanks,

Koen

