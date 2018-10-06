Return-Path: <SRS0=pQzZ=MS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B216DC65C30
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 12:54:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 60E912147D
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 12:54:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="gyCpkG7C";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="nKvm4DIT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 60E912147D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727713AbeJFT5Z (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 6 Oct 2018 15:57:25 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:55584 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726792AbeJFT5Z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 6 Oct 2018 15:57:25 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 94A9C60791; Sat,  6 Oct 2018 12:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538830453;
        bh=dbe6+KD2D+7VzRnb7d7mMDn04/2SOEF1pomZIUohZbw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=gyCpkG7Cf1xQghzYPIaUNCkYPd8KYfiMpO5v+USMcC3PmYjbQFly1fFpm/lNPTv4s
         VjJgKARwtDH/wcdy1n/H4T+QeaYTqgJ5RQ6XUCTXOn6F6yrn8PEdS7pJG+EL2Zqrp3
         J1KuoJstr0xv7lQ7+aH6+Oy0dtftv3mp1egPRWpU=
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8184B607BD;
        Sat,  6 Oct 2018 12:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538830452;
        bh=dbe6+KD2D+7VzRnb7d7mMDn04/2SOEF1pomZIUohZbw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=nKvm4DITfGMByQH0EukXYPL5G5mjEN4fbeJVdD/PbfV5EJBU3gSqRkdoJS6sdXWsi
         DbJ56ICXZ91riIWBGcLagimrXMTCQq82n12LsMQqOotS37ihLZJzj+WPqwHpmuRfEx
         z3tsKP768XHIgkG0ltU7DvXhCMY1coj+22S+4dzM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8184B607BD
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Julia Lawall <julia.lawall@lip6.fr>
Cc:     YueHaibing <yuehaibing@huawei.com>,
        Maya Erez <merez@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] wil6210: fix debugfs_simple_attr.cocci warnings
References: <1538737646-118337-1-git-send-email-yuehaibing@huawei.com>
        <877eiw1wol.fsf@codeaurora.org>
        <alpine.DEB.2.20.1810051629140.3364@hadrien>
        <87pnwnff65.fsf@kamboji.qca.qualcomm.com>
        <alpine.DEB.2.21.1810061422030.2363@hadrien>
Date:   Sat, 06 Oct 2018 15:54:08 +0300
In-Reply-To: <alpine.DEB.2.21.1810061422030.2363@hadrien> (Julia Lawall's
        message of "Sat, 6 Oct 2018 14:22:58 +0200 (CEST)")
Message-ID: <87va6fdymn.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Julia Lawall <julia.lawall@lip6.fr> writes:

> On Sat, 6 Oct 2018, Kalle Valo wrote:
>
>> Julia Lawall <julia.lawall@lip6.fr> writes:
>>
>> > On Fri, 5 Oct 2018, Kalle Valo wrote:
>> >
>> >> YueHaibing <yuehaibing@huawei.com> writes:
>> >>
>> >> > Use DEFINE_DEBUGFS_ATTRIBUTE rather than DEFINE_SIMPLE_ATTRIBUTE
>> >> > for debugfs files.
>> >> >
>> >> > Semantic patch information:
>> >> > Rationale: DEFINE_SIMPLE_ATTRIBUTE + debugfs_create_file()
>> >> > imposes some significant overhead as compared to
>> >> > DEFINE_DEBUGFS_ATTRIBUTE + debugfs_create_file_unsafe().
>> >> >
>> >> > Generated by: scripts/coccinelle/api/debugfs/debugfs_simple_attr.cocci
>> >>
>> >> Just out of curiosity, what kind of overhead are we talking about here?
>> >
>> > The log message on the commit introducing the semantic patch says the
>> > following:
>> >
>> >     In order to protect against file removal races, debugfs files created via
>> >     debugfs_create_file() now get wrapped by a struct file_operations at their
>> >     opening.
>> >
>> >     If the original struct file_operations are known to be safe against removal
>> >     races by themselves already, the proxy creation may be bypassed by creating
>> >     the files through debugfs_create_file_unsafe().
>> >
>> >     In order to help debugfs users who use the common
>> >       DEFINE_SIMPLE_ATTRIBUTE() + debugfs_create_file()
>> >     idiom to transition to removal safe struct file_operations, the helper
>> >     macro DEFINE_DEBUGFS_ATTRIBUTE() has been introduced.
>> >
>> >     Thus, the preferred strategy is to use
>> >       DEFINE_DEBUGFS_ATTRIBUTE() + debugfs_create_file_unsafe()
>> >     now.
>>
>> I admit that I didn't have time to investigate this is detail but I'm
>> still not understanding where is that "significant overhead" coming from
>> and how big of overhead are we talking about? I guess it has something
>> to do with full_proxy_open() vs open_proxy_open()?
>>
>> Not that I'm against this patch, just curious when I see someone
>> claiming "significant overhead" which is not obvious for me.
>
> The message with the semantic patch doesn't really talk about significant
> overhead.  Maybe YueHaibing can discuss with the person who proposed the
> semantic patch what the actual issue is, and when the proposed change is
> actually applicable.

Actually commit 5103068eaca2 mentions "significant overhead":

--- /dev/null
+++ b/scripts/coccinelle/api/debugfs/debugfs_simple_attr.cocci
@@ -0,0 +1,67 @@
+/// Use DEFINE_DEBUGFS_ATTRIBUTE rather than DEFINE_SIMPLE_ATTRIBUTE
+/// for debugfs files.
+///
+//# Rationale: DEFINE_SIMPLE_ATTRIBUTE + debugfs_create_file()
+//# imposes some significant overhead as compared to
+//# DEFINE_DEBUGFS_ATTRIBUTE + debugfs_create_file_unsafe().

But I'll anyway apply this patch as I don't see anything wrong with it.
I was just trying to learn where this overhead is :)

-- 
Kalle Valo
