Return-Path: <SRS0=f1+T=PQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFBE3C43387
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 20:21:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92F3F20675
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 20:21:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="Q7F7mrj7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728632AbfAHUVH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 8 Jan 2019 15:21:07 -0500
Received: from mail2.candelatech.com ([208.74.158.173]:55082 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728015AbfAHUVH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Jan 2019 15:21:07 -0500
Received: from [192.168.100.195] (firewall.candelatech.com [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail2.candelatech.com (Postfix) with ESMTPSA id 4A9A140B24A;
        Tue,  8 Jan 2019 12:21:04 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail2.candelatech.com 4A9A140B24A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1546978864;
        bh=pI9mZhOMxYElyXrdZbE7CxdJl7Pcd1Hvwkrm32x1gLI=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=Q7F7mrj77fnNeNTyTZBdUoMuCnolqSL4fAVnwGE+GdJ+5qMXBoJydrFjqEjSkHkKO
         mLx2Ke9YtQP63Ih00gOJeHfOvnW7r/rpTyneXbHMsthQInDhabVvkBsFyafyRr/yW7
         C2Ympa0Vd0fTwwAgXQ/ExOni973AANMQy/1gUIiQ=
Subject: Re: [PATCH] nl80211/cfg80211: Add support to send tx frames at
 specified rate
To:     vamsin@codeaurora.org
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, jouni@codeaurora.org
References: <1543838646-3574-1-git-send-email-vamsin@codeaurora.org>
 <89e6532daf4011de2ad0df3dcb8accc42334f31e.camel@sipsolutions.net>
 <899698ca-d8b5-45b1-5689-58096e2f0291@candelatech.com>
 <63224d0fc1e978624de9887cb7349c02@codeaurora.org>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <441f9a6c-b08e-c115-b11c-f1b3f0d020cd@candelatech.com>
Date:   Tue, 8 Jan 2019 12:21:03 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <63224d0fc1e978624de9887cb7349c02@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 1/8/19 9:49 AM, vamsin@codeaurora.org wrote:
> On 2018-12-18 19:15, Ben Greear wrote:
>> On 12/18/2018 05:12 AM, Johannes Berg wrote:
>>> On Mon, 2018-12-03 at 17:34 +0530, vamsi krishna wrote:
>>>> NL80211_CMD_FRAME is used to send frames from userspace. Add support to
>>>> transmit the frames at a rate specified by userspace when needed.
>>>> The drivers shall indicate the support to send frames at rate specified
>>>> by userspace by setting %NL80211_EXT_FEATURE_CMD_FRAME_TXRATE flag in
>>>> wiphy capabilities. The userspace can specify the rate within
>>>> %NL80211_ATTR_RATE_INFO attribute while sending %NL80211_CMD_FRAME.
>>>>
>>>> NL80211_ATTR_RATE_INFO is a nested attribute and encapsulates the
>>>> attributes defined in &enum nl80211_rate_info.
>>>
>>> It'd be good if you were to repost this with a driver that uses it.
> Unfortunately, the driver that I am working now is not upstreamed. I would like to check with Ben if he likes to propose a patch ath10k driver that he is 
> working on as I see he is also interested in this feature. Please let me know if it is mandatory or good to have driver implementation.

Kalle will not accept any of my patches that enable my firmware, though my ath10k-ct
driver/firmware is in OpenWRT if that is upstream enough.

>>> Also, please explain why you think userspace needs this? It's not like
>>> it can make better rate decisions than the rate control algorithm,
>>> right?
> Yes, you are correct. Rate control algorithm will continue to be in the lower layers only. This is mostly for testing and experimenting purposes.
> 
>>>
>>>>      [NL80211_ATTR_SCHED_SCAN_MIN_RSSI] = { .type = NLA_NESTED },
>>>> +    [NL80211_ATTR_RATE_INFO] = { .type = NLA_NESTED },
>>>
>>> This should use NLA_POLICY_NESTED(nl80211_rate_info_policy)
> Thanks for pointing out this MACRO, I used it in my new version of the patch.
> 
>>
>> I missed the first posting of this patch.  Here are some of my own
>> suggestions.
>>
>> The wave-2 ath10k firmware has an option to specify tx-power, preamble
>> (CCK, OFDM, HT, VHT), bandwidth, mcs, nss and retry-count on a per-packet
>> basis.  This is not enabled in the ath10k driver, and I am not certain QCA
>> firmware compiles in this option, but I have both ath10k-ct driver and firmware
>> able to do this currently.
>>
>> For HT and VHT, the mcs is fairly obvious I think.  For CCK and OFDM, the
>> mcs is treated as an index into the CCK and OFDM rate tables.
>>
>> So, maybe the patch could use these basic constructs instead of the
>> different flags/rates for MCS vs VHT_MCS vs HE_MCS?
> I am not sure if I understand your comment correctly. If you are proposing to remove the different attribute ids for MCS, VHT_MCS and HE_MCS, I think that will 
> lead to unnecessary confusion especially as we have duplicate indices between different modes(for example between HT and VHT). I believe it is better to keep 
> this similar to reporting tx and rx rates in NL80211_CMD_GET_STATION in order to avoid problems with future technologies like EHT.

Here is the API that I have in my modified ath10k-ct driver (and the ath10k-ct wave-2 firmware handles it accordingly):

/* Create a rate-info object that (some) 10.4 CT firmware
  * can understand.
  */
u32 ath10k_convert_hw_rate_to_rate_info(u8 tpc, u8 mcs, u8 sgi, u8 nss, u8 pream_type,
					u8 num_retries, u8 bw, u8 dyn_bw)

	/* Re-use logic from 10.4 firmware */
	struct __ath10k_rate_info {
		u32     power              : 6,   /* units of the power field is dbm */
			unused             : 1,   /* Room for growth */
			sgi                : 1,   /* Enable SGI or not, checked when valid_rate is enabled. */
			mcs                : 4,    /* mcs = 0 ~ 9 */
			nss                : 2,    /* 0 = 1 nss, 1 = 2 nss, 2 = 3 nss, 3 = 4 nss */
			pream_type         : 2,    /* 0 = WIFI_RATECODE_PREAM_OFDM,
						      1 = WIFI_RATECODE_PREAM_CCK,
						      2 = WIFI_RATECODE_PREAM_HT ,
						      3 = WIFI_RATECODE_PREAM_VHT */
			num_retries        : 4,    /* 0 ~ 15:  0 means no-ack */
			dyn_bw             : 1,    /* 0 = static bw, 1 = dynamic bw */
			bw                 : 3,    /* valid only if dyn_bw == 0 (static bw).
						      (0 = 20 mhz, 1 = 40 mhz, 2 = 80 mhz, 3 = 160 mhz , 4 = 80+80mhz) */
			valid_power        : 1,   /*  power info field has valid power. */
			valid_rate         : 1,    /*  mcs,nss,pream_type fields have valid rates. */
			valid_num_retries  : 1,    /*  num_retries field has valid value */
			valid_dyn_bw       : 1,    /*  dyn_bw field has valid value */
			valid_bw           : 1,    /*   bw field has valid value */

			any_valid          : 1,    /* 1 : htt_tx_msdu_desc_t contains valid tx meta data */
			key_id             : 2;    /* key index 0 to 3 for per packet key rotation */
	};
...

So, the best API for me would allow me to specify all of this from user-space.  pream-type could have a new 'HE'
in the upper stacks, ath10k would just ignore it.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

