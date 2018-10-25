Return-Path: <SRS0=+bZT=NF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2358CC46475
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Oct 2018 04:24:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC40C20831
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Oct 2018 04:24:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aFGpW3TM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BC40C20831
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbeJYMzk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Oct 2018 08:55:40 -0400
Received: from mail-qk1-f182.google.com ([209.85.222.182]:38621 "EHLO
        mail-qk1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726465AbeJYMzk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Oct 2018 08:55:40 -0400
Received: by mail-qk1-f182.google.com with SMTP id p3-v6so4908789qkb.5
        for <linux-wireless@vger.kernel.org>; Wed, 24 Oct 2018 21:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=yvNFctruVgpN/w//n5tQy226jCfvDLzNw1uAYb7d7VM=;
        b=aFGpW3TMBgRpHEgVwLxOk5TTLNETC+f7W3pM88toqYv+3IAyhuyT1IVcM2UjcuQnDv
         23oaWi8CRWI82FrnNwBA5JaCBnxV0axDkmLlEaeLR4aJADOvAl4EPwVFyy8Lw3t4Zb/9
         JFZkcFXe5b8e4k26afQy0umNvluDcJT6vWm0MkFQUmsouojrmPR4oOidCwzehWJwmx0U
         0egraVGlTBFvsjSq8w3mHyeZhxff+jd/UIVBs0L+RNtNWWMY+l81efN/yoIbaKhLamUd
         hOhy77pfcH2xA4uyxKpNiM4LBU6oOmAVWOS5dXZEZbRVL/7TzOnzjAYUisxk56lu+f9B
         m/GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=yvNFctruVgpN/w//n5tQy226jCfvDLzNw1uAYb7d7VM=;
        b=cgzuhFe7GozPJ9vrGEa2BqeGSiefxDyFgatxesGrld06zc5tNGFo70D7pmgHufolwz
         hWGURNToGBUUixjJe6wuU1HSDeZgklZPpCMCS56+IaRoYA/ou3y8RfHv0kTLvXPYoelu
         h2BJDsCTks/Et3PgUvgJhdvsR81+QUjGQyQ67mcUz1OAYI04lDmijKuSaoLntJLxFLAU
         U7efknLn0T30HtwP0f+wUK2gT/+VHHLmetewO0FgohVBDMoCJQ1GCiM+Fl8nQ3dCLqgR
         ZQc5cZ8IqQcbS0ca2GFAzqSEHWQ1WfRDSwzrboGgdbHQAaMTdapg+xXxYfIiEEBRwFXO
         0MeQ==
X-Gm-Message-State: AGRZ1gLWDC1tIyqEzRiVC1ybIHSYhkobad7jFEWvtat8cd5ydfZNi0J7
        r6Kr0xOqQWLVUiKjzDfGkW0=
X-Google-Smtp-Source: AJdET5eJgfvVrMh11Lq2P30D1iA6wv+7DsZ44f+m9lD/J0nB5JavsccjM2s4hnCDeDTYdqZJL/Of0w==
X-Received: by 2002:a37:2cc1:: with SMTP id s184-v6mr13970qkh.28.1540441482655;
        Wed, 24 Oct 2018 21:24:42 -0700 (PDT)
Received: from ?IPv6:2001:470:1d:7b6::245? ([2001:470:1d:7b6::245])
        by smtp.googlemail.com with ESMTPSA id x40-v6sm4726980qtj.45.2018.10.24.21.24.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Oct 2018 21:24:41 -0700 (PDT)
Subject: Re: ath9k driver may be broken on ARM64 ?
To:     Tom Psyborg <pozega.tomislav@gmail.com>
Cc:     linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
References: <ecb743be-ec4f-0f80-c598-c71826492b30@gmail.com>
 <CAKR_QV+xitANRgaH=_wEkRgizFU7fsqyY8JY7f+AzQTdgjQ1cg@mail.gmail.com>
 <caf394ef-dc52-b19b-6b31-77b92158f389@gmail.com>
 <6c59ee97-cad9-46bb-be0c-6daa6f614a61@gmail.com>
 <CAKR_QVK1t=Fc4F7F+4bNKM+TH3hS6uH_WgfsbK3jmrqSgZGTNg@mail.gmail.com>
 <5aeab3c9-27d7-e0e6-400a-a5373703dff9@gmail.com>
 <CAKR_QVJ1smqU3nr1w4f4SUGjrmcLa0KiAzZn2O6RAyN4MRZ=sQ@mail.gmail.com>
From:   Ellie Revves <ellierevves@gmail.com>
Message-ID: <52a059ac-fadc-18c9-92a5-e36f64b63ff9@gmail.com>
Date:   Thu, 25 Oct 2018 00:26:20 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Firefox/52.0 SeaMonkey/2.49.4
MIME-Version: 1.0
In-Reply-To: <CAKR_QVJ1smqU3nr1w4f4SUGjrmcLa0KiAzZn2O6RAyN4MRZ=sQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Here's another boot log along with some commands after the system booted 
up to show what I did. I don't think I did anything wrong, and yet this 
is no different, debug option appears to be completely useless.
http://ix.io/1pY0
Thanks

Tom Psyborg a écrit :
> if your system is read-only then you should make a build with debug
> option enabled:
>
> inside your buildroot create this path: files/etc/modules.d/ and put
> file named ath9k there which should contain "ath9k debug=0xffffffff"
> (more info: https://openwrt.org/docs/guide-developer/build-system/use-buildsystem#custom_files)
>
> rebuild and try boot again capturing bootlog

