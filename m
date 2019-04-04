Return-Path: <SRS0=xyYy=SG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A1CFC4360F
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 12:11:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37DB1206B7
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 12:11:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="P7Z6lV5t";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Mb0aoHio"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729003AbfDDMLO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Apr 2019 08:11:14 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:41944 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727310AbfDDMLN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Apr 2019 08:11:13 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 3F4AA60A42; Thu,  4 Apr 2019 12:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554379873;
        bh=KYaaBlV/CAjDlVvm2RtokbQpLt21l4wkZz7tMtboaFg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=P7Z6lV5tC8K+3KsZMM8ggfyyNsvoKoAQEYSVcqKVJX7VKW1g6Io2x+RTorII1TfFt
         /EVNqg/38u0cbli+ql5QDPuHqu8Q0jeh37VgZgkz6nj7+VXA/xQ5GtAQbau0Ys4tC/
         nnt8HqGH0hjSjJZJfi7lkLsAFJEt0aAIhJ6ILqgw=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id E408F60909;
        Thu,  4 Apr 2019 12:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554379872;
        bh=KYaaBlV/CAjDlVvm2RtokbQpLt21l4wkZz7tMtboaFg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Mb0aoHioxSIc/8jUNbINU1HnYqyjeS7GdYWJGmW0AF7zXYgM4fxLrfY+LoXcbSBd/
         puEi1GJTzs5l0QZ+uUM2raQQUor91+l7t7zGVEA4SOYIwV13/kSXmKc136tEOJySUh
         SCdj1Qt2NB7xcwoWfx1VJKmBIoIJuZM+eBtUtRew=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 04 Apr 2019 17:41:12 +0530
From:   Rakesh Pillai <pillair@codeaurora.org>
To:     peter.oh@bowerswilkins.com
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: FW: [PATCH v2] ath10k: Report low ack rssi based on the reason
 code
In-Reply-To: <8c3110f20aec4c4a90bb679c4551b1fc@aphydexm01b.ap.qualcomm.com>
References: <1554276181-7879-1-git-send-email-pillair@codeaurora.org>
 <5f25f471-5753-7d4a-91f8-9a3986117580@bowerswilkins.com>
 <8c3110f20aec4c4a90bb679c4551b1fc@aphydexm01b.ap.qualcomm.com>
Message-ID: <73e869e8f82a3395cfefaf1272d07906@codeaurora.org>
X-Sender: pillair@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

>> diff --git a/drivers/net/wireless/ath/ath10k/wmi.h 
>> b/drivers/net/wireless/ath/ath10k/wmi.h
>> index e1c40bb..3ccd79e 100644
>> --- a/drivers/net/wireless/ath/ath10k/wmi.h
>> +++ b/drivers/net/wireless/ath/ath10k/wmi.h
>> @@ -6797,6 +6797,8 @@ struct wmi_vdev_start_ev_arg {
>> 
>>   struct wmi_peer_kick_ev_arg {
>>   	const u8 *mac_addr;
>> +	u32 reason;
>> +	bool reason_code_valid;
>>   };
>> 
> Adding extra members to this structure breaks structure consistency
> between FW and host driver since FW doesn't have such members.
> 
> Peter
> _______________________________________________
> ath10k mailing list
> ath10k@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath10k

struct wmi_peer_sta_kickout_event is used for parsing event from non-tlv 
firmwares and
struct wmi_tlv_peer_sta_kickout_event  is used for parsing event from 
tlv firmwares.
Both of the above structures maintain consistency with the respective 
FW.

struct wmi_peer_kick_ev_arg is used only for internal ath10k operations 
only.

Thanks,
Rakesh Pillai.
