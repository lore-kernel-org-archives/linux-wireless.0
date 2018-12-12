Return-Path: <SRS0=wq86=OV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49BA0C65BAF
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Dec 2018 17:55:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02DFE20839
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Dec 2018 17:55:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IM0lZFhO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 02DFE20839
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lwfinger.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727912AbeLLRzj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 12 Dec 2018 12:55:39 -0500
Received: from mail-oi1-f178.google.com ([209.85.167.178]:36165 "EHLO
        mail-oi1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727881AbeLLRzj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Dec 2018 12:55:39 -0500
Received: by mail-oi1-f178.google.com with SMTP id x23so15751229oix.3
        for <linux-wireless@vger.kernel.org>; Wed, 12 Dec 2018 09:55:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=pi+e+ZA4uDMDyBcSjdCnp8I6Gg+K8FFN3owfcey1Jd0=;
        b=IM0lZFhOovzc2z1HjfPkK0oSa5FsPTr79UuZFFTmq0cgtuSmaB6pKqAjUluYiPw5F/
         mnqM4J/mKxl5yitqDR0fi5Kg+H/+p3FWkR86ZlaOuLzz+AwGiSq8TSbuNrEA01j2U9ke
         e1Opa5oQMdUO6ZKifre/AQNBnoLdyPUin3k5vbXhyDklS7tDz+co43wquRVM3AwwL0vW
         PZRTsqlQ0MYfO/2gTSofGjIo/IfQva0fF7SWkBR+Ih07ht5GtwbuvA7vsILg3mafNc6x
         qItmzLy7JMwrrnOYYa6DavrivwwzZP24GymsvphQKkJxBRjarm8NINyXW6tYlImrivQc
         In3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:to:cc:from:subject:message-id:date
         :user-agent:mime-version:content-language:content-transfer-encoding;
        bh=pi+e+ZA4uDMDyBcSjdCnp8I6Gg+K8FFN3owfcey1Jd0=;
        b=ITdygR01OJ2cnOHSFqXg7sPHm/Kz8iMmNipBqL+bQq2RIdM7FZmE0h2q4auEjIu0uB
         2t/2qeQh7FKI9c4/d31UGta2hgK1RIkfYiZGojeymK+VOFn5dk/OZrlF9dGKDmjOc6ur
         FCXey2B/wI8NP58zWACWi/o4kXiBJTcqFb29g4GKii7LQm3bAR8MkmDjCTeqj3dF3i5m
         MKhz+GiqzUHhWN65hk/BNfcTazhPjvc2BMJ9TLtOLjnJ9SiUoh7JGaJnmH6KkYotUgyv
         P4SLo2d7wDBsT6bFepQUIQbLZ0U3yblya9/nWHvLQpqwfPGJ9ZvZ6zrhHgB97Ko6spEG
         bS9A==
X-Gm-Message-State: AA+aEWaveMEfR2pwdTPYkh9XA8vu4cMXs/6GcidRlqNYO5TBYSZm6zK7
        86KZMlHuzv3j8TtsW+j7RPa4p0ra
X-Google-Smtp-Source: AFSGD/UXZ1e9ZAZ4YBmPswxQd7RQWKiOot7UE+2TfAXgGkVKJ9IfLRULTqs+ZuKNmZX+f3ApGmzi6g==
X-Received: by 2002:a05:6808:202:: with SMTP id l2mr1693965oie.63.1544637337747;
        Wed, 12 Dec 2018 09:55:37 -0800 (PST)
Received: from [192.168.1.103] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id k13sm18962591otj.19.2018.12.12.09.55.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Dec 2018 09:55:36 -0800 (PST)
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Subject: Critical fix for rtlwifi
Message-ID: <e419ff31-d9fe-feed-9f40-4a7d4b82a44e@lwfinger.net>
Date:   Wed, 12 Dec 2018 11:55:36 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Kalle,

On November 18th, I submitted a patch entitles "[PATCH 4.20] rtlwifi: Fix leak 
of skb when processing C2H_BT_INFO" that fixes an skb memory leak.

I just checked, and this one-line patch is still sitting in patchwork with a 
status of "NEW". Why is this the case? The reports and testing of the fix took 
place in a GitHub issue thread, but that should not keep a critical fix from 
being handled fairly quickly. Meanwhile users of unpatched kernels are having 
their systems run out of memory! This problem is present in kernels 4.18+!

Larry
