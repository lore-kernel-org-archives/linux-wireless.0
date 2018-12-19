Return-Path: <SRS0=qpxp=O4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A456C43387
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Dec 2018 13:32:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 38CDA21841
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Dec 2018 13:32:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="UkA8f46m";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="EGZejvjE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729309AbeLSNci (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 19 Dec 2018 08:32:38 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:39248 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729019AbeLSNci (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Dec 2018 08:32:38 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 20B3C61B98; Wed, 19 Dec 2018 13:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545226357;
        bh=FGJ+Az+lPQ1/Q1Xbj6GwZxaQGOIi+lsWAQ1ejAYhuX0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=UkA8f46m6vkMmnm2mu9epUy+gPt1n9g68E8AUpU7COkuBkgKFETGnZwsYh4WYtsFf
         AHL33na055EfjOGPscZyfogUg+tW6EOaD6D+3b8LEcL3om+DMCoaJEdUi+3txQSnwK
         z++0auhLxzRuW0IVwEzmlezwDwXZJohxEjCg5QBs=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A2CAB61AD2;
        Wed, 19 Dec 2018 13:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545226355;
        bh=FGJ+Az+lPQ1/Q1Xbj6GwZxaQGOIi+lsWAQ1ejAYhuX0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=EGZejvjEUXBMRgfdYkEDPlowXJ0iO6PLi80lMzvkvNAQ0Iw8nuY034LP8i24ZSwBS
         njWCv67jnB0o0UtWk2KDde040SfbYHN1H/42eZCifxit2uwSVKX+GvGxJPHFP3zYId
         EMpAnAGADmmi9KR/Ca8i/TVhyl2MzEqjELWb0BIo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A2CAB61AD2
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Rakesh Pillai <pillair@codeaurora.org>
Cc:     Govind Singh <govinds@codeaurora.org>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH v2] ath10k: skip sending quiet mode cmd for WCN3990
References: <1544782666-24837-1-git-send-email-kvalo@codeaurora.org>
        <87ftv0xqwp.fsf@kamboji.qca.qualcomm.com>
        <b243c620f222584ac175a92e8f7a39d2@codeaurora.org>
Date:   Wed, 19 Dec 2018 15:32:32 +0200
In-Reply-To: <b243c620f222584ac175a92e8f7a39d2@codeaurora.org> (Rakesh
        Pillai's message of "Fri, 14 Dec 2018 18:29:47 +0530")
Message-ID: <87ftutvdzj.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

(fixing top posting, PLEASE do not top post)

Rakesh Pillai <pillair@codeaurora.org> writes:

> On 2018-12-14 17:26, Kalle Valo wrote:
>> Kalle Valo <kvalo@codeaurora.org> writes:
>>
>>> From: Rakesh Pillai <pillair@codeaurora.org>
>>>
>>> HL2.0 firmware does not support setting quiet mode.  If the host
>>> driver sends
>>> the quiet mode setting command to the HL2.0 firmware, it crashes
>>> with the below
>>> signature.
>>>
>>> fatal error received: err_qdi.c:456:EX:wlan_process:1:WLAN
>>> RT:207a:PC=b001b4f0
>>>
>>> The quiet mode command support is exposed by the firmware via
>>> thermal throttle
>>> wmi service. Enable ath10k thermal support if thermal throttle wmi
>>> service bit
>>> is set.  10.x firmware versions support this feature by default, but
>>> unfortunately do not advertise the support via service flags, hence
>>> have to
>>> manually set the service flag in ath10k_core_compat_services().
>>>
>>> Compile tested only.
>>
>> I'm planning to queue this for 4.20 as wcn3990 support won't work
>> otherwise. But I wasn't able to test this so can someone help,
>> please?
>
> I tested this patch on WCN3990 and did basic STA mode sanity. I do not
> see any crash with this fix.

Thanks. I now tested this with firmware 10.2.4.70.9-2 on QC988X. I'll
update the commit log accordingly.

-- 
Kalle Valo
