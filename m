Return-Path: <SRS0=AjP+=NE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 313EEECDE46
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 18:37:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EFB152075D
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 18:37:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="u/OsT2Wb"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EFB152075D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbeJYDGm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 24 Oct 2018 23:06:42 -0400
Received: from mail-qt1-f177.google.com ([209.85.160.177]:43894 "EHLO
        mail-qt1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726521AbeJYDGl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Oct 2018 23:06:41 -0400
Received: by mail-qt1-f177.google.com with SMTP id q41-v6so6764133qtq.10
        for <linux-wireless@vger.kernel.org>; Wed, 24 Oct 2018 11:37:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=849gYOPLvGumEURaC1uq4M8hsGkZhwnwwM7FLCNW2fM=;
        b=u/OsT2WbvJVYJXXqsTNerIndrL9L4rBwo7KRdFYWkDD5Z22Zf9kUCy5ZOArzaU8n5H
         EQBP0ZlXtoh1P373Shcro9r6iYQYx5UfEqIPrXsDDPJ4ymLj4CQK12C7UwyDxgmgPGL3
         1LYu1FCP41vyPX2WkHNR1dFpMjWJE+9kc6DUnyL3qnru7kTd6kLl/dgiWAZMWROUC8Br
         u/PBrQcpdjZAPo6/RJl3Ep+BrS56r/IBq0ydXHaVGkr8rI8XPcp1y0VpbuoFcWUWfCoC
         ClIrT0gIkjFhnxPXl4/NOjKdCICPcYmH2n09Q6FU8cDTxyfASBTINinOm3Yzk9DxVSDx
         AKPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=849gYOPLvGumEURaC1uq4M8hsGkZhwnwwM7FLCNW2fM=;
        b=qh13+coNovJ/NixEaisoJ1zHUfIKExYkAPRNiXpB7dKms25k+kooWRWDcOJZRpROnN
         hgAroEdC8RRAP0rYMzRDeqVFS87XKAFSHkafixic2YQ+mo3G9p8kqr9P30pEs0v96ywH
         sI2o9CfAKg2hFbHZBln0XBdgLUxke6N48buGrfmqv5Px/hSfljn/f20eni+9kUQtYN6+
         1zM9qAUTWDuJ6jgCL7nE8L/atkh6BfsDRN+ekixewU+qQO91Uh9/AqMik3fJzOvTxwP9
         BKd6ghieo/Lc92zMGyFcCBmGsZxfYyKQAWBWr72B8rwlVWo7qGiyeDqwKiu2acA1Okgr
         Hd4w==
X-Gm-Message-State: AGRZ1gLkS7wtVjDGiJz0SlyzDkj+oJHmbQ60z3ipo3gFVs57KqqKmuFg
        80o9kFmOGXokoH+UHxaVU1OEBOzG
X-Google-Smtp-Source: AJdET5cpRVhud33oyecKFwhNiCHmlJYB2l5WDLplM6LKtZfgbfMHFVKpFB25SzU8Y8ke/E7PHZwtwg==
X-Received: by 2002:ac8:901:: with SMTP id t1-v6mr3526123qth.335.1540406251822;
        Wed, 24 Oct 2018 11:37:31 -0700 (PDT)
Received: from ?IPv6:2001:470:1d:7b6::245? ([2001:470:1d:7b6::245])
        by smtp.googlemail.com with ESMTPSA id k18-v6sm4227859qtc.54.2018.10.24.11.37.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Oct 2018 11:37:30 -0700 (PDT)
Subject: Re: ath9k driver may be broken on ARM64 ?
To:     Tom Psyborg <pozega.tomislav@gmail.com>
Cc:     linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
References: <ecb743be-ec4f-0f80-c598-c71826492b30@gmail.com>
 <CAKR_QV+xitANRgaH=_wEkRgizFU7fsqyY8JY7f+AzQTdgjQ1cg@mail.gmail.com>
From:   Ellie Revves <ellierevves@gmail.com>
Message-ID: <caf394ef-dc52-b19b-6b31-77b92158f389@gmail.com>
Date:   Wed, 24 Oct 2018 14:39:09 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Firefox/52.0 SeaMonkey/2.49.4
MIME-Version: 1.0
In-Reply-To: <CAKR_QV+xitANRgaH=_wEkRgizFU7fsqyY8JY7f+AzQTdgjQ1cg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,
sure, I enabled atheros wireless debugging in my kernel and am 
rebuilding it. After this is done, should I set ath9k.debug= on the 
cmdline ? It is built as module, but my filesystem is read-only so no 
modprobe.d snippet can be added.
Thanks

Tom Psyborg a écrit :
> Hi
>
> There was similar issue reported in forum recently:
> https://forum.openwrt.org/t/wireless-card-atheros-ar9565/23608
>
> Could you enable ath9k debug and post output?

