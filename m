Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF719C64EBD
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 03:23:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9BAED2082A
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 03:23:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="gxd03F2t";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="HfFzDm9J"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9BAED2082A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbeJCKKC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 06:10:02 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:41986 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726162AbeJCKKC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 06:10:02 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 76C2760C62; Wed,  3 Oct 2018 03:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538537013;
        bh=py7kFnqyWkSsGhsaheeS0tJaUPIuNb8CPY/LogdFZv0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gxd03F2tDXyHmp/7IOi3NSYlRADoARACuAvPyOPLF8VozdzbRy+TgWRVsopAt6yPT
         kvfVwDp84GkSnyxBAF8biQq7Pdiy9TGzOggGIuPmImf9UF5CRK/AVZ11wuHjuhRUol
         0qCUMOHQWrO7oJVnonqIzCCvE060tQZa7sSPPHM0=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id D874860B0D;
        Wed,  3 Oct 2018 03:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538537012;
        bh=py7kFnqyWkSsGhsaheeS0tJaUPIuNb8CPY/LogdFZv0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HfFzDm9J8tZgzdTfyppOYwzAaMd+dw5hzGzknU8Icizo1THeC+jb4nLwhEwWergyI
         bI1fYpjZzrBdzOMwhqqPFI+ZL/lV0aPLwGGEp/6PJE5hjnefPia5jH7I5CWqhYrmMY
         K4dANN7nF4saZihKMrtbeJlj0BOttbokw/a4dYEk=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 03 Oct 2018 08:53:32 +0530
From:   Sriram R <srirrama@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] ath10k: Add support for configuring management packet
 rate
In-Reply-To: <20181001144822.BE46A60A98@smtp.codeaurora.org>
References: <1537853898-3793-1-git-send-email-srirrama@codeaurora.org>
 <20181001144822.BE46A60A98@smtp.codeaurora.org>
Message-ID: <ea6abd28b85950debd45acaa0f6be254@codeaurora.org>
X-Sender: srirrama@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-10-01 20:18, Kalle Valo wrote:
> Sriram R <srirrama@codeaurora.org> wrote:
> 
>> By default the firmware uses 1Mbps and 6Mbps rate for management 
>> packets
>> in 2G and 5G bands respectively. But when the user selects different
>> basic rates from the userspace, we need to send the management
>> packets at the lowest basic rate selected by the user.
>> 
>> This change makes use of WMI_VDEV_PARAM_MGMT_RATE param for 
>> configuring the
>> management packets rate to the firmware.
>> 
>> Chipsets Tested : QCA988X, QCA9887, QCA9984
>> FW Tested 	: 10.2.4-1.0-41, 10.4-3.6.104
>> 
>> Signed-off-by: Sriram R <srirrama@codeaurora.org>
> 
> Really sorry, I missed this and accidentally applied v1. Can you
> submit a followup
> patch with the changes you made in v2, please? That way the final code 
> is still
> the same.
Hi Kalle,
  I've raised a followup patch with the delta in v2.
        https://patchwork.kernel.org/patch/10624227/
Thanks,
Sriram.R
