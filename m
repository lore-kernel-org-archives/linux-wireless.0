Return-Path: <SRS0=gYL7=SO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	SUBJ_ALL_CAPS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E6F2C10F13
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 02:15:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6CD0D2084D
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 02:15:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="XEKEHVpi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbfDLCPE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Apr 2019 22:15:04 -0400
Received: from [208.74.158.174] ([208.74.158.174]:53468 "EHLO
        mail3.candelatech.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1726656AbfDLCPE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Apr 2019 22:15:04 -0400
Received: from [192.168.1.47] (104-235-164-208.evrt.wa.frontiernet.net [104.235.164.208])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 2D61313C2B9;
        Thu, 11 Apr 2019 19:15:03 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 2D61313C2B9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1555035303;
        bh=m/ERFgYMPU5FbyBrAYcR+gTgrVwCm/5aA/fRNoyUQKo=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=XEKEHVpi/Mhf3L+oinM9UzAtJl5vT636+ZGicGUASgJVPyxaJddiUJ/NryxCn9XWs
         KnVPg01DwHoLk1jteg55kcHmcpoVSlyQhkalGMQlAMhONswzucTtOlUg8S4GUFubhO
         5iGcfZhRmndW99DRvVF9L4tePG1AQXXieZNQ89V0=
Subject: Re: NL80211_SCAN_FLAG_RANDOM_ADDR ?
To:     Denis Kenzior <denkenz@gmail.com>, linux-wireless@vger.kernel.org
References: <e09a9bc7-9774-334b-53e8-13e1d781bee3@gmail.com>
 <913e7464-ea6e-bb22-141a-ab76019bed3f@candelatech.com>
 <fcd9fcc2-86dd-8cd7-1822-efb7df498cf8@candelatech.com>
 <ce4f4f2b-ad34-fbf6-6fcb-0b95cf9b9d24@gmail.com>
From:   Ben Greear <greearb@candelatech.com>
Message-ID: <56af141b-80c4-4256-21d5-cb6c39a327e8@candelatech.com>
Date:   Thu, 11 Apr 2019 19:15:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <ce4f4f2b-ad34-fbf6-6fcb-0b95cf9b9d24@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



On 04/11/2019 06:26 PM, Denis Kenzior wrote:
> Hi Ben,
>
> On 04/11/2019 06:20 PM, Ben Greear wrote:
>> On 4/11/19 4:19 PM, Ben Greear wrote:
>>> On 4/11/19 3:30 PM, Denis Kenzior wrote:
>>>> Hi,
>>>>
>>>> I've been poking around at how this flag is used and I noticed this check in net/wireless/nl80211.c:
>>>>
>>>> nl80211_check_scan_flags()
>>>>
>>>>          if (*flags & NL80211_SCAN_FLAG_RANDOM_ADDR) {
>>>>                  int err;
>>>>
>>>>                  if (!(wiphy->features & randomness_flag) ||
>>>>                      (wdev && wdev->current_bss))
>>>>                          return -EOPNOTSUPP;
>>>>
>>>>
>>>> The above disallows the use of RANDOM_ADDR for scans while connected. The nl80211.h uapi header seems to concur:
>>>>
>>>>   "@NL80211_FEATURE_SCAN_RANDOM_MAC_ADDR: This device/driver supports using a random MAC address during scan (if the device is unassociated);"
>>>>
>>>> However, if I create a P2P Device (in addition to the default STA device), the kernel happily lets me scan on the wdev while the STA interface is connected.
>>>>
>>>> sudo iw phy0 interface add p2p type __p2pdev
>>>> sudo iw wdev 0x2 p2p start
>>>> sudo iw wdev 0x2 scan randomize
>>>>
>>>> So the immediate question I have is, should the RANDOM_ADDR flag indeed be limited to unassociated STA interfaces?  It would seem the hardware is capable randomizing even when connected? Please educate me :)
>>>
>>> You can be sure that each driver/hardware has its own bugs and limitations related to this.
>>>
>>> Ath10k wave 1 and wave 2 that I am aware of would ignore and/or not ACK probe responses
>>> sent back to an MAC address that is not that of the station itself.  And changing the mac of a station
>>> would require complete re-association AFAIK.  That is likely just one of the many issues.
>
> Yes, I understand that some hardware would not support this.  But the question is does this check belong at the nl80211 layer (e.g. no hardware can do this) vs somewhere at the driver layer + additional feature bit as needed.
>
>>
>> I should add:  If you really want to scan in this manner, you could just create a new station vdev with
>> random addr and have it do the scanning, then delete it when done?  The original station will continue on
>> its way unmolested.
>>
>
> So you mean something like:
> sudo iw phy0 interface add sta2 type station
> sudo iw dev sta2 scan randomize
> command failed: Network is down (-100)
> sudo ifconfig sta2 up
> SIOCSIFFLAGS: Device or resource busy
>
> I guess I'm running into this:
>
>     valid interface combinations:
>          * #{ managed } <= 1, #{ AP, P2P-client, P2P-GO } <= 1, #{ P2P-device } <= 1,
>            total <= 3, #channels <= 2
>
> Or did you mean something else?

You got my meaning, I guess your driver cannot support it.  It should work with ath10k,
at least the versions I use.


Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
