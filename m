Return-Path: <SRS0=IMqP=SN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	SUBJ_ALL_CAPS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DE35C10F13
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Apr 2019 23:19:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4E3020693
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Apr 2019 23:19:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="JLj50wF5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbfDKXTr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Apr 2019 19:19:47 -0400
Received: from [208.74.158.174] ([208.74.158.174]:48108 "EHLO
        mail3.candelatech.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1726800AbfDKXTq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Apr 2019 19:19:46 -0400
Received: from [192.168.100.195] (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 58CFE13C2B9;
        Thu, 11 Apr 2019 16:19:46 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 58CFE13C2B9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1555024786;
        bh=YDh7J6ydGFQriM/fsZM1q1uPanltTL7zRcpPofv2aYk=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=JLj50wF5VmfGz0YVYZlWRopE0T4Mq/hq0qwY2ze2qnN6/muiRx8eCFgJvcMpPoq/4
         3mll9LV2sRy9xypsJFR/INxezS+9TfBTsFXMFc9/zRaQIP6gP+UAQlT6C2cboQeive
         QzmVBxMHQJKRCsKT77+etOFvj5MBzdJFloy3zyiU=
Subject: Re: NL80211_SCAN_FLAG_RANDOM_ADDR ?
To:     Denis Kenzior <denkenz@gmail.com>, linux-wireless@vger.kernel.org
References: <e09a9bc7-9774-334b-53e8-13e1d781bee3@gmail.com>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <913e7464-ea6e-bb22-141a-ab76019bed3f@candelatech.com>
Date:   Thu, 11 Apr 2019 16:19:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <e09a9bc7-9774-334b-53e8-13e1d781bee3@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 4/11/19 3:30 PM, Denis Kenzior wrote:
> Hi,
> 
> I've been poking around at how this flag is used and I noticed this check in net/wireless/nl80211.c:
> 
> nl80211_check_scan_flags()
> 
>          if (*flags & NL80211_SCAN_FLAG_RANDOM_ADDR) {
>                  int err;
> 
>                  if (!(wiphy->features & randomness_flag) ||
>                      (wdev && wdev->current_bss))
>                          return -EOPNOTSUPP;
> 
> 
> The above disallows the use of RANDOM_ADDR for scans while connected. The nl80211.h uapi header seems to concur:
> 
>   "@NL80211_FEATURE_SCAN_RANDOM_MAC_ADDR: This device/driver supports using a random MAC address during scan (if the device is unassociated);"
> 
> However, if I create a P2P Device (in addition to the default STA device), the kernel happily lets me scan on the wdev while the STA interface is connected.
> 
> sudo iw phy0 interface add p2p type __p2pdev
> sudo iw wdev 0x2 p2p start
> sudo iw wdev 0x2 scan randomize
> 
> So the immediate question I have is, should the RANDOM_ADDR flag indeed be limited to unassociated STA interfaces?  It would seem the hardware is capable 
> randomizing even when connected? Please educate me :)

You can be sure that each driver/hardware has its own bugs and limitations related to this.

Ath10k wave 1 and wave 2 that I am aware of would ignore and/or not ACK probe responses
sent back to an MAC address that is not that of the station itself.  And changing the mac of a station
would require complete re-association AFAIK.  That is likely just one of the many issues.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

