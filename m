Return-Path: <SRS0=gYL7=SO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6C59C10F0E
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 03:56:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2EE32084D
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 03:56:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="aQY/aFt6";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="i41pdbyR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbfDLD4T (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Apr 2019 23:56:19 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:59084 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726678AbfDLD4T (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Apr 2019 23:56:19 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 787E4611D1; Fri, 12 Apr 2019 03:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555041378;
        bh=x6wUotf755a3r5J8+npRu6kzu1g4fz+FwLHyISP+udI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=aQY/aFt6xeXPaMQDdl8xqqz2qeuiciEe6CV8cuhvUdz4n9y0lLzON6nV9OEAULO4x
         XLqFiDoq/mJPEnR1Kc17EZmKOemiDbi00VE1oLsNMfqSGJMmsa4SEez71rxUEakViR
         wZs/WSqnFHnoG6QonoDmlBtAAcy57qyIlYa9tPf4=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 482AA61132;
        Fri, 12 Apr 2019 03:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555041377;
        bh=x6wUotf755a3r5J8+npRu6kzu1g4fz+FwLHyISP+udI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=i41pdbyRZgWYg2t8o5GfUMwLAfLgR7Gasy7lbifeUx41aFKv6TeAkefRdwPRD/s8l
         AIjQkUpKSY0LhrFzBdQoqrtw/F5DoQevTwsl+qfoO87OqYk31tzpX9YKIr5EC/DKhf
         zpPqGWpngyBAQHOsEsRAOSAQzSmn/wInJbI5ckH0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 482AA61132
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     John Crispin <john@phrozen.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org,
        Srini Kode <skode@qti.qualcomm.com>,
        Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
        Shashidhar Lakkavalli <slakkavalli@datto.com>,
        Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Subject: Re: [RFC V4 2/2] ath10k: add tx hw 802.11 encapusaltion offloading support
References: <20190410073514.12794-1-john@phrozen.org>
        <20190410073514.12794-3-john@phrozen.org>
        <87ef69yizo.fsf@purkki.adurom.net>
        <3ffaff0b-3d5c-1413-3f95-13d8430a62fc@phrozen.org>
Date:   Fri, 12 Apr 2019 06:56:12 +0300
In-Reply-To: <3ffaff0b-3d5c-1413-3f95-13d8430a62fc@phrozen.org> (John
        Crispin's message of "Thu, 11 Apr 2019 20:36:46 +0200")
Message-ID: <875zrjho6b.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

John Crispin <john@phrozen.org> writes:

> On 10/04/2019 17:31, Kalle Valo wrote:
>> John Crispin <john@phrozen.org> writes:
>>
>>> From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
>>>
>>> This patch adds support for ethernet rxtx mode to the driver. The feature
>>> is enabled via a new module parameter. If enabled to driver will enable
>>> the feature on a per vif basis if all other requirements were met.
>>>
>>> Testing on a IPQ4019 based hardware shows a increase in TCP throughput
>>> of ~20% when the feature is enabled.
>>>
>>> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
>>> Signed-off-by: John Crispin <john@phrozen.org>
>> Looks good to me.
>>
>> BTW, for ath10k patches (patchsets including ath10k patches) please try
>> to CC also the ath10k list. Easier to find ath10k patches that way.
>>
> Hi,
>
> Thanks Kalle, I'll be sending a V5 tomorrow with a small improvement
> on the hw crypto part, that unbreaks wpa3. can I add your Acked-by on
> the ath10k part ?

Adding my Acked-by is not necessary as I will be applying the ath10k
patch anyway. In these cases we usually do so that Johannes applies the
mac80211 part, he then assigns the driver patches to me in patchwork,
and once mac80211 commits are in my tree, I'll apply the driver part.

-- 
Kalle Valo
