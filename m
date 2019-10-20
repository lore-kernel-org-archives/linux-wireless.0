Return-Path: <SRS0=wsxy=YN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7216CA9EA0
	for <linux-wireless@archiver.kernel.org>; Sun, 20 Oct 2019 18:11:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B384521929
	for <linux-wireless@archiver.kernel.org>; Sun, 20 Oct 2019 18:11:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=mojatatu-com.20150623.gappssmtp.com header.i=@mojatatu-com.20150623.gappssmtp.com header.b="xIRXpq8f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbfJTSLI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 20 Oct 2019 14:11:08 -0400
Received: from mail-io1-f43.google.com ([209.85.166.43]:34942 "EHLO
        mail-io1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbfJTSLI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 20 Oct 2019 14:11:08 -0400
Received: by mail-io1-f43.google.com with SMTP id t18so9075887iog.2
        for <linux-wireless@vger.kernel.org>; Sun, 20 Oct 2019 11:11:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=WwwOJG6cLnG5xe3kjsXT2ilCOHWGZRdMg+j74Vw53t4=;
        b=xIRXpq8f/TDXgDmgVcZmBmcpBA1YW2MqqLg1daMjdWhX29XZxDpk+kWpAbHEc9I9ak
         QvZk0TsCqH8w+tGANCynHQASn8DjmWLsCvql3TAMT6Sl4YSOJHhZ0Ubr2XRydLZW2b8S
         uX2+tIPVXTRL6jA8P5UDWJhIlmSC4FBNjJFWJOpADWdR6+A/LhT7sDXrSsYGLUdXmCcM
         svh6WrY1AREuxupY5jZaNQFUWvYL+0HmIlkPpg4b4OADBTPojBAlotOydJHDMiqAE6Fz
         +IOFGJPqAFYRPBlE/p4t+f9EWrOeiYNhfmctDfjwzMIZEVUN6YHBHDRgIClvdY/G5yBN
         jloA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=WwwOJG6cLnG5xe3kjsXT2ilCOHWGZRdMg+j74Vw53t4=;
        b=Bq6n7WctOD3P2j0FcPqUkmAflhuRgfNXHy7wnVKKrAnkNBOrI2i/wIvln5PeagsI+S
         uszhUTM4lT/utlsKvs2fjqETEcvML3lS+lrwuwNRkoL0OHewKCzm0EzQ1XEiwktC43YW
         UzIeuLP3uhX70x8mFf/SU97sh0XrVz4r0ml3ihoPQpX3OmuJfa0xltYAwn1AwQpgLh2O
         TAOsEYO39jkJOYnsgzt1W4Bt0Oca1Rxc98YCMszmmMBPYq9aT2wOL+fbaK1Qel4CFPuT
         TnKiT/wPIPOO4Y5q7KPlUUKe6YxFzDWt8oqh9VoSwwu+To48abc6mBe7iMkNoJjkuKhF
         CLaw==
X-Gm-Message-State: APjAAAUDDnyRD/sqldwfgwhuyh2WFNJ/ne84Sy17KN6Gm1eoMvBEVFru
        QiSqE8R9tYVNxMoXi5ZEirtlxw==
X-Google-Smtp-Source: APXvYqy+g0dW6i2W+ZwUWXvHoX5E4PThQJkpc6ElQkdeecg/jBrJXQlBfbZsm0QTf+vurjU7oUVUGA==
X-Received: by 2002:a6b:d812:: with SMTP id y18mr859466iob.151.1571595066005;
        Sun, 20 Oct 2019 11:11:06 -0700 (PDT)
Received: from [192.168.0.124] (198-84-204-252.cpe.teksavvy.com. [198.84.204.252])
        by smtp.googlemail.com with ESMTPSA id x4sm4448657ilm.57.2019.10.20.11.11.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 20 Oct 2019 11:11:05 -0700 (PDT)
To:     people <people@netdevconf.org>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Subject: CFS for Netdev 0x14 open!
Cc:     netfilter-devel@vger.kernel.org, linux-wireless@vger.kernel.org,
        lwn@lwn.net, netdev@vger.kernel.org, netfilter@vger.kernel.org,
        lartc@vger.kernel.org
Message-ID: <65cebdca-7ed1-2bb5-450a-0bb8de7b6ff3@mojatatu.com>
Date:   Sun, 20 Oct 2019 14:11:03 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



We are pleased to announce the opening of Call For
Submissions(CFS) for Netdev 0x14.

For overview of topics, submissions and requirements
please visit:
https://netdevconf.info/0x14/submit-proposal.html

For all submitted sessions, we employ a blind
review process carried out by the Program Committee.
Please refer to:
https://www.netdevconf.info/0x14/pc_review.html

Important dates:
Closing of CFS: Wed, January 15, 2020.
Notification by: Mon, January 20, 2020
Conference dates:  Tue, March 17 to Fri, March 20, 2020.

cheers,
jamal
