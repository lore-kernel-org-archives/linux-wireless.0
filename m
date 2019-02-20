Return-Path: <SRS0=0XaW=Q3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFB7FC43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 13:25:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8EA042086D
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 13:25:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=mojatatu-com.20150623.gappssmtp.com header.i=@mojatatu-com.20150623.gappssmtp.com header.b="KHJ/Ur72"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728029AbfBTNY5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Feb 2019 08:24:57 -0500
Received: from mail-it1-f173.google.com ([209.85.166.173]:34863 "EHLO
        mail-it1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726531AbfBTNY5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Feb 2019 08:24:57 -0500
Received: by mail-it1-f173.google.com with SMTP id v72so15384717itc.0
        for <linux-wireless@vger.kernel.org>; Wed, 20 Feb 2019 05:24:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=BgGMsu2ZmHT0mzyx1aMHzvb90nh68+fMeDsNeea8Ttw=;
        b=KHJ/Ur72mUYt3wWNjKm88CGEEFk7Y/S/Ivvg6ZO4H+pugvCpA2CTGsZWdcysIrxewI
         2aCJEYyFbP3qxBmmN2ebqx3LyNaIFROPo5flhkcDCZMfJ9q5dZipZZA3BqVXLhloYIZo
         gVbReRljdXdyhkvjWtedJKNQM0AF2fHZe+v0cnk1HZYNzZk4kdOmcdQ8KfGyZ4b06WJI
         JHFXndZJ79ulnGg9zeCDNUyOBhMCsJTEVlY6ByQvozVhTCk7Zte3EAZe1o55DW6KCvfq
         ww0yudYHa6XZOMChW8+LdnK+5U8U17Wwac0pf89YFeVtbNDkteyqGvG0+Th2diaT30Ad
         b8vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=BgGMsu2ZmHT0mzyx1aMHzvb90nh68+fMeDsNeea8Ttw=;
        b=pfbluKVUVNOkJ6comh3Iuxt7LW29pL+JkHK/Rb3B6LAqf1eubfT5ejZ5FsJ7cbexKY
         uvOlxvwJtaq9ZkLGuty5WG0EGAUsNvOgnAZOv3OhwKJFazh6/04py0tUC9he7ggYGig9
         eSo40gyIGyUX57+f/nZrziEq3In0vndXGonN/OI1MGFMPeo1V8/eHnMAtiBTJat6VODu
         bs+5CiC59q/gEB7rj4nZpNmGI60NzZzCLAc2U0DEp7DGLoEXXPdk6F57i98D4YZyYTUs
         3wZ5bUnqHhN0ecNkguvGqJvkJPw9dwcHqHmAdW4n3WCSbsro39HrG1fSzigLN5hZbyx9
         0XmQ==
X-Gm-Message-State: AHQUAuafsjcAjZ/5/b8ENXLBSVAKr5SgWiUgyhaFTAjsJi7y27cykosJ
        dmXZkLQS6PKy5klzgcYfHpj/kQ==
X-Google-Smtp-Source: AHgI3IZ4cRmCvNpekOORE23K5+q4xUNs7sk0Hk2qs1johWBuh9a/9UxOoa/88CCAg/HASfHHF4kfvQ==
X-Received: by 2002:a24:4a95:: with SMTP id k143mr5207068itb.77.1550669096723;
        Wed, 20 Feb 2019 05:24:56 -0800 (PST)
Received: from [10.0.0.135] (24-212-162-241.cable.teksavvy.com. [24.212.162.241])
        by smtp.googlemail.com with ESMTPSA id p18sm2558816itp.10.2019.02.20.05.24.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Feb 2019 05:24:55 -0800 (PST)
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        lartc@vger.kernel.org
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Subject: update on netdev 0x13 conference
Message-ID: <e2934422-87e3-5096-0a35-ec514247d45e@mojatatu.com>
Date:   Wed, 20 Feb 2019 08:24:54 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This is a small update to the community on the Netdev 0x13 conference
(March 20-22, in Prague, Czech Republic)
https://www.netdevconf.org/0x13

Early registration fees end today at 23:59 EST.
To Register: https://www.netdevconf.org/0x13/registration.html

Our bursaries are also going to close today at 23:59 EST.
Any member of the community may request for a bursary (sponsorship) to
attend.
https://www.netdevconf.org/0x13/bursaries.html

Many hours of exciting working discussions and talks.
https://www.netdevconf.org/0x13/accepted-sessions.html
https://www.netdevconf.org/0x13/schedule.html

Because the schedule is packed we will be providing lunch
this time at the conference location.

For regular updates, please subscribe to people@lists.netdevconf.org
(more info at: https://lists.netdevconf.org/cgi-bin/mailman/listinfo/people)

If twitter is your thing then follow us: @netdev01
and use hashtag #netdevconf

cheers,
jamal
