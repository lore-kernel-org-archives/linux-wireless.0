Return-Path: <SRS0=Lwp6=R5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18421C10F11
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Mar 2019 07:55:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8E7720856
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Mar 2019 07:55:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="DChi02bh";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="TIXozBzw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731336AbfCZHzh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Mar 2019 03:55:37 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:59474 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726175AbfCZHzh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Mar 2019 03:55:37 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1884560DB4; Tue, 26 Mar 2019 07:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553586936;
        bh=g4S0i5dvyZ22w0F8xBZyNOt510QlGaxzGA/D3ELUe90=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=DChi02bhuC0sTwZwp8g3dLJOIe3yvW50jKblCnd8yB71BJ51hoIZoCialeR8V5ZKZ
         jZf7iFck6fxL/XcrDkcNyzpH14ygWPAQI/npzigjDTB576SzdCTy65zrP3ZtnHzroz
         gYi3Vrw8FC4iuRkHcdPBSf1Zpf85MBqf8X2liVoA=
Received: from x230.qca.qualcomm.com (176-93-125-176.bb.dnainternet.fi [176.93.125.176])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5F5F460A4E;
        Tue, 26 Mar 2019 07:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553586935;
        bh=g4S0i5dvyZ22w0F8xBZyNOt510QlGaxzGA/D3ELUe90=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=TIXozBzwfBJCxtnOpEqk6WGKdaipm0WXrns0Trr/HHbbOpE5uze+NwgS8QDB/ZX4O
         zT9w8YLA+npZ0NlFtMBdUnZbj/ozvDXtUudLtzCQsXfwHVh8WDJMWNvQPB+97cVv8D
         vXKJiXGAJ2CVMVeiBLhCX27wcZUHfhLPlqwEcaeA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5F5F460A4E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Fenghua Yu <fenghua.yu@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, H Peter Anvin <hpa@zytor.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Ravi V Shankar <ravi.v.shankar@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v5 03/18] wlcore: simplify/fix/optimize reg_ch_conf_pending operations
References: <1552431636-31511-1-git-send-email-fenghua.yu@intel.com>
        <1552431636-31511-4-git-send-email-fenghua.yu@intel.com>
        <87a7hxzjda.fsf@purkki.adurom.net>
        <20190314231614.GA41447@romley-ivt3.sc.intel.com>
        <02f06de8-ebb2-24ff-27e1-f697cadc02c4@redhat.com>
Date:   Tue, 26 Mar 2019 09:55:29 +0200
In-Reply-To: <02f06de8-ebb2-24ff-27e1-f697cadc02c4@redhat.com> (Paolo
        Bonzini's message of "Fri, 15 Mar 2019 18:17:06 +0100")
Message-ID: <877ecmjci6.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 15/03/19 00:16, Fenghua Yu wrote:
>> Hi, Valo,
>> 
>> On Thu, Mar 14, 2019 at 03:16:33PM +0200, Kalle Valo wrote:
>>> Fenghua Yu <fenghua.yu@intel.com> writes:
>>>
>>>> From: Paolo Bonzini <pbonzini@redhat.com>
>>>>
>>>> Bitmaps are defined on unsigned longs, so the usage of u32[2] in the
>>>> wlcore driver is incorrect.  As noted by Peter Zijlstra, casting arrays
>>>> to a bitmap is incorrect for big-endian architectures.
>>>>
>>>> When looking at it I observed that:
>>>>
>>>> - operations on reg_ch_conf_pending is always under the wl_lock mutex,
>>>> so set_bit is overkill
>>>>
>>>> - the only case where reg_ch_conf_pending is accessed a u32 at a time is
>>>> unnecessary too.
>>>>
>>>> This patch cleans up everything in this area, and changes tmp_ch_bitmap
>>>> to have the proper alignment.
>>>>
>>>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>>>> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
>>>
>>> [...]
>>>
>>>>  int wlcore_cmd_regdomain_config_locked(struct wl1271 *wl)
>>>>  {
>>>>  	struct wl12xx_cmd_regdomain_dfs_config *cmd = NULL;
>>>>  	int ret = 0, i, b, ch_bit_idx;
>>>> -	u32 tmp_ch_bitmap[2];
>>>> +	u32 tmp_ch_bitmap[2] __aligned(sizeof(unsigned long));
>>>>  	struct wiphy *wiphy = wl->hw->wiphy;
>>>>  	struct ieee80211_supported_band *band;
>>>>  	bool timeout = false;
>>>
>>> [...]
>>>
>>>> @@ -1754,8 +1751,8 @@ int wlcore_cmd_regdomain_config_locked(struct wl1271 *wl)
>>>>  		goto out;
>>>>  	}
>>>>  
>>>> -	cmd->ch_bit_map1 = cpu_to_le32(tmp_ch_bitmap[0]);
>>>> -	cmd->ch_bit_map2 = cpu_to_le32(tmp_ch_bitmap[1]);
>>>> +	cmd->ch_bit_map1 = tmp_ch_bitmap[0];
>>>> +	cmd->ch_bit_map2 = tmp_ch_bitmap[1];
>>>
>>> Will sparse still be happy? AFAICS you are now assigning u32 to __le32:
>>>
>>> struct wl12xx_cmd_regdomain_dfs_config {
>>>        struct wl1271_cmd_header header;
>>>
>>>        __le32 ch_bit_map1;
>>>        __le32 ch_bit_map2;
>> 
>> Discussion between Peter and Paolo (https://lkml.org/lkml/2019/3/4/521)
>> may answer your question.
>
> No, Kalle is right.  You do need to change
>
> -	u32 tmp_ch_bitmap[2];
> +	u32 tmp_ch_bitmap[2] __aligned(sizeof(unsigned long));
>
> into
>
> -	u32 tmp_ch_bitmap[2];
> +	__le32 tmp_ch_bitmap[2] __aligned(sizeof(unsigned long));
>
> The assignment from wl->reg_ch_conf_pending to tmp_ch_bitmap is fine
> because it goes through memcpy.

Thanks for confirming, I'll then drop patch 3 and wait for a new
version. IMHO it would be easier to submit this patch separately to
linux-wireless, no need to have within this bigger patchset.

-- 
Kalle Valo
