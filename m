Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26390C00449
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 09:09:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC6FE20835
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 09:09:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="R/+EDATy";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="R/+EDATy"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CC6FE20835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727485AbeJCP4u (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 11:56:50 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:52044 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727347AbeJCP4t (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 11:56:49 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id CAF2560C67; Wed,  3 Oct 2018 09:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538557759;
        bh=k+Kb+UYuSDYGovz1TKuNUL7gBiQvUO8f/MhXx78Lkzo=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=R/+EDATyImTjMAZ0XxEOAPYGz3lX8JSgfJinCf7rndBrvSiXkpEI65/acTs0TFJme
         uBlNCdhBqg803Lpbks+aSQgu1CTwodYrCU3ZuZchbg67LjrHh9cR4xXpeed/t6ipU1
         CyEeMkP1swXz0o1eNgxNcyknnUXQ91Di86aQ+ovQ=
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8CF7760C61;
        Wed,  3 Oct 2018 09:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538557759;
        bh=k+Kb+UYuSDYGovz1TKuNUL7gBiQvUO8f/MhXx78Lkzo=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=R/+EDATyImTjMAZ0XxEOAPYGz3lX8JSgfJinCf7rndBrvSiXkpEI65/acTs0TFJme
         uBlNCdhBqg803Lpbks+aSQgu1CTwodYrCU3ZuZchbg67LjrHh9cR4xXpeed/t6ipU1
         CyEeMkP1swXz0o1eNgxNcyknnUXQ91Di86aQ+ovQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8CF7760C61
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Sriram R <srirrama@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] ath10k: Add support for configuring management packet rate
References: <1537853898-3793-1-git-send-email-srirrama@codeaurora.org>
        <20181001144822.BE46A60A98@smtp.codeaurora.org>
        <ea6abd28b85950debd45acaa0f6be254@codeaurora.org>
Date:   Wed, 03 Oct 2018 12:09:16 +0300
In-Reply-To: <ea6abd28b85950debd45acaa0f6be254@codeaurora.org> (Sriram R.'s
        message of "Wed, 03 Oct 2018 08:53:32 +0530")
Message-ID: <8736tnjt1f.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Sriram R <srirrama@codeaurora.org> writes:

> On 2018-10-01 20:18, Kalle Valo wrote:
>> Sriram R <srirrama@codeaurora.org> wrote:
>>
>>> By default the firmware uses 1Mbps and 6Mbps rate for management
>>> packets
>>> in 2G and 5G bands respectively. But when the user selects different
>>> basic rates from the userspace, we need to send the management
>>> packets at the lowest basic rate selected by the user.
>>>
>>> This change makes use of WMI_VDEV_PARAM_MGMT_RATE param for
>>> configuring the
>>> management packets rate to the firmware.
>>>
>>> Chipsets Tested : QCA988X, QCA9887, QCA9984
>>> FW Tested 	: 10.2.4-1.0-41, 10.4-3.6.104
>>>
>>> Signed-off-by: Sriram R <srirrama@codeaurora.org>
>>
>> Really sorry, I missed this and accidentally applied v1. Can you
>> submit a followup
>> patch with the changes you made in v2, please? That way the final
>> code is still
>> the same.
>
>  I've raised a followup patch with the delta in v2.
>        https://patchwork.kernel.org/patch/10624227/

Great, thanks for this and sorry for the mess.

-- 
Kalle Valo
