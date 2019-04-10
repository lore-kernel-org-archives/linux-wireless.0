Return-Path: <SRS0=qAu2=SM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9A4AC10F11
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Apr 2019 11:47:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96AE32054F
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Apr 2019 11:47:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="aqaX0irR";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="aqaX0irR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730920AbfDJLrf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Apr 2019 07:47:35 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:45362 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730373AbfDJLrf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Apr 2019 07:47:35 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 6161C60DB4; Wed, 10 Apr 2019 11:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554896854;
        bh=aN7o25lzsWE4WFY3Tr1gkJh2OiyubV+L4CY95vvoaXc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aqaX0irR4zjR117DzBdvIbN0NE4m/W16XULrm0zc4OmjQcfQfzPba2BBQFg2JtWqz
         PRMncprg16yxLU1AztR5EZWJqydBzfQA/QCgNG0wocgeLlgyrqqDE7JwxG4PAwuM45
         kWTfMk2ypE2XHDzjtK0JRJniXhu4jUHTyt1Tv0Ak=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id DCFAE60746;
        Wed, 10 Apr 2019 11:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554896854;
        bh=aN7o25lzsWE4WFY3Tr1gkJh2OiyubV+L4CY95vvoaXc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aqaX0irR4zjR117DzBdvIbN0NE4m/W16XULrm0zc4OmjQcfQfzPba2BBQFg2JtWqz
         PRMncprg16yxLU1AztR5EZWJqydBzfQA/QCgNG0wocgeLlgyrqqDE7JwxG4PAwuM45
         kWTfMk2ypE2XHDzjtK0JRJniXhu4jUHTyt1Tv0Ak=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 10 Apr 2019 17:17:33 +0530
From:   Surabhi Vishnoi <svishnoi@codeaurora.org>
To:     Adrian Chadd <adrian@freebsd.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k: Fix the wrong value of enums for wmi tlv stats id
In-Reply-To: <CAJ-VmoncvErDWb4a2CNE38ECt2_8-vYr3sZ+AcjiPGCaPGuoCQ@mail.gmail.com>
References: <1554792193-22535-1-git-send-email-svishnoi@codeaurora.org>
 <CAJ-VmoncvErDWb4a2CNE38ECt2_8-vYr3sZ+AcjiPGCaPGuoCQ@mail.gmail.com>
Message-ID: <5e133105e60e45a48986c54a814b5a60@codeaurora.org>
X-Sender: svishnoi@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2019-04-09 12:18, Adrian Chadd wrote:
> What about QCA6174 that uses TLV? Does this change its behaviour?
> 
> -a
> 

No, it will not break QCA6174, as earlier also same enum values 
(wmi_stats_id) were used for TLV targets,
enum wmi_stats_id {
         WMI_STAT_PEER = BIT(0),
         WMI_STAT_AP = BIT(1),
         WMI_STAT_PDEV = BIT(2),
         WMI_STAT_VDEV = BIT(3),
         WMI_STAT_BCNFLT = BIT(4),
         WMI_STAT_VDEV_RATE = BIT(5),
};

In the change f40a307eb92c ("ath10k: Fill rx duration for each peer in 
fw_stats for WCN3990), enum values for wmi_tlv_stats_id were wrongly 
added.

Thanks,
Surabhi Vishnoi


> On Mon, 8 Apr 2019 at 23:43, Surabhi Vishnoi <svishnoi@codeaurora.org>
> wrote:
> 
>> The enum value for WMI_TLV_STAT_PDEV, WMI_TLV_STAT_VDEV
>> and WMI_TLV_STAT_PEER is wrong, due to which the vdev stats
>> are not received from firmware in wmi_update_stats event.
>> 
>> Fix the enum values for above stats to receive all stats
>> from firmware in WMI_TLV_UPDATE_STATS_EVENTID.
>> 
>> Tested HW: WCN3990
>> Tested FW: WLAN.HL.3.1-00784-QCAHLSWMTPLZ-1
>> 
>> Fixes: f40a307eb92c ("ath10k: Fill rx duration for each peer in
>> fw_stats for WCN3990)
>> Signed-off-by: Surabhi Vishnoi <svishnoi@codeaurora.org>
>> ---
>> drivers/net/wireless/ath/ath10k/wmi.h | 7 ++++---
>> 1 file changed, 4 insertions(+), 3 deletions(-)
>> 
>> diff --git a/drivers/net/wireless/ath/ath10k/wmi.h
>> b/drivers/net/wireless/ath/ath10k/wmi.h
>> index e1c40bb..12f57f9 100644
>> --- a/drivers/net/wireless/ath/ath10k/wmi.h
>> +++ b/drivers/net/wireless/ath/ath10k/wmi.h
>> @@ -4535,9 +4535,10 @@ enum wmi_10_4_stats_id {
>> };
>> 
>> enum wmi_tlv_stats_id {
>> -       WMI_TLV_STAT_PDEV       = BIT(0),
>> -       WMI_TLV_STAT_VDEV       = BIT(1),
>> -       WMI_TLV_STAT_PEER       = BIT(2),
>> +       WMI_TLV_STAT_PEER       = BIT(0),
>> +       WMI_TLV_STAT_AP         = BIT(1),
>> +       WMI_TLV_STAT_PDEV       = BIT(2),
>> +       WMI_TLV_STAT_VDEV       = BIT(3),
>> WMI_TLV_STAT_PEER_EXTD  = BIT(10),
>> };
>> 
>> --
>> 1.9.1
