Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8923DC0044C
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 20:42:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 447F22085A
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 20:42:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=mojatatu-com.20150623.gappssmtp.com header.i=@mojatatu-com.20150623.gappssmtp.com header.b="xBSiYjSD"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 447F22085A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730174AbeKFGEK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 01:04:10 -0500
Received: from mail-it1-f173.google.com ([209.85.166.173]:50798 "EHLO
        mail-it1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727049AbeKFGEJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 01:04:09 -0500
Received: by mail-it1-f173.google.com with SMTP id k206-v6so14790767ite.0
        for <linux-wireless@vger.kernel.org>; Mon, 05 Nov 2018 12:42:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=RBbZAIJiYvaC+fbCGumClM9nVTr1O7LuSKAdUMfVlj0=;
        b=xBSiYjSD3iaISO8BmyH7AjjVf4+6XNpbdbLM2pr3KrkpG/Z0ZilDfR5fB9Drvx6Ojr
         KiDkuUGWK41yIcERp3DHJ3CEl0Got55VNMiXZwvvq66eILXaXdBqXkoHTE7RYiFjnkw8
         kw6HdR+1oS31HuxomIaeGuVoGfpgktUjtTJdV9vv1LDBfBDJM9NFkrlMT2s7qjtcudO5
         znE7Z54lioAZSnw1ABwUPx9SfSOAdQOgS3tK4k8MCAJzPMKFyV6ZmaAKU/fS/8dTJEHc
         kMoqE3lqnwn9zcZOoY6cz6n30DRf1ZCKnFaDXRENCdrcHz6JydQkyfG7LReCsBlLDECw
         6x4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=RBbZAIJiYvaC+fbCGumClM9nVTr1O7LuSKAdUMfVlj0=;
        b=FUmAfa1Az7fVHZCksaCoch/YqV3KPqbn9uKJXEaW8swZTitaUpehp0z4+CpMR4E28u
         9jQifwThgQjLrFEt0MGi6x2QfeVdEUQDcBbmBbbzoUILXD75RPwG+pTLuSExUAAODqXa
         R9lfxiar0Jc2/0SmaXLQkU/i4XoZBGk8yjbd7Ep1gqTh0C0VQJe6f6cK4ztXVc3tqpaP
         /x1ZfZ0RhbFxmMyXLWAnbH7kbFT1coHj/Yr6lN5tu3nBwGmL4xz9adVpbZbRuHgm+STw
         bK2qzmWeyJCRBLDe6djkA1I6ZkEhnpOYN+zu/9/6E3+CLnQfa/2MC7gtdxpB0Y6uLfBZ
         RiaA==
X-Gm-Message-State: AGRZ1gJyldjJxdu6b6UreDkvI6efsn1cef/1GlDenSS1g5su0Ucd7Dp6
        OUXvAw5qsftziv2Zk6xDfpEIm8jPXa0=
X-Google-Smtp-Source: AJdET5f8w1ZhjDCHFTqn9HbTTaWGHJ8JlD8Otm2OTFUbtSDOrbKXx1ZeEr9nfaL9MAuU9ODQ6cs7cg==
X-Received: by 2002:a24:b244:: with SMTP id h4-v6mr7532963iti.11.1541450560191;
        Mon, 05 Nov 2018 12:42:40 -0800 (PST)
Received: from [10.0.0.131] ([64.26.149.125])
        by smtp.googlemail.com with ESMTPSA id w134-v6sm15812722itc.12.2018.11.05.12.42.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Nov 2018 12:42:39 -0800 (PST)
To:     people <people@netdevconf.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>, lwn@lwn.net
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Subject: CFS for Netdev 0x13 open!
Message-ID: <4b4c923f-a39a-4ff0-0de4-2ffd565d8ba2@mojatatu.com>
Date:   Mon, 5 Nov 2018 15:42:21 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



We are pleased to announce the opening of call for submissions(CFS)
for Netdev 0x13.
For overview of topics, submissions and requirements please visit:
https://netdevconf.org/0x13/submit-proposal.html

Sessions are selected via a blind review process carried out by
the Program Committee and Shepherd. Please refer to:
https://www.netdevconf.org/0x13/pc_review.html

Important dates:
Closing of CFS: Tue, January 15, 2019.
Acceptance or rejection notification by: Fri, January 18, 2019
Conference dates:  Wed, March 20 to Fri, March 22.

cheers,
jamal
