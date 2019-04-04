Return-Path: <SRS0=xyYy=SG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6AFBC4360F
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 20:45:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 925B0206C0
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 20:45:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="Cch7lFka"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731190AbfDDUpS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Apr 2019 16:45:18 -0400
Received: from [208.74.158.174] ([208.74.158.174]:38254 "EHLO
        mail3.candelatech.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1730337AbfDDUpS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Apr 2019 16:45:18 -0400
Received: from [192.168.100.195] (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id C1C4527C29
        for <linux-wireless@vger.kernel.org>; Thu,  4 Apr 2019 13:45:16 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com C1C4527C29
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1554410716;
        bh=wTXyLn0jtWbfkKdoMXQSb+1xAc2Zhl03kSlom67uSqo=;
        h=Subject:From:To:References:Date:In-Reply-To:From;
        b=Cch7lFkasVM/1ZaRKc2ncKoP26Yj4XvVBiXOfkWLVZwIwUE6xfUjjhQi/AZioFm4U
         FdMJiZ1yL8W7MgNSUFJEhuRJCBZxvRfYAYQ2Vg9ALNreeZ3JIN7bdMEBUB5KyagiYt
         13/TFjwwFKU8G84iwoR76FUfIX8WzXO4eqS+IWEc=
Subject: Re: ath10k and min_gcd + adhoc issues in 4.20 kernel
From:   Ben Greear <greearb@candelatech.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <3dfff3d9-a070-f3a3-723c-d1442ec06bc5@candelatech.com>
Organization: Candela Technologies
Message-ID: <5475c4c5-e30d-f254-e3b8-43b52b83a198@candelatech.com>
Date:   Thu, 4 Apr 2019 13:45:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <3dfff3d9-a070-f3a3-723c-d1442ec06bc5@candelatech.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello,

Any comments on this below?

Thanks,
Ben

On 1/15/19 3:29 PM, Ben Greear wrote:
> I just updated to 4.20 and ported forward my ath10k patches.  Now the driver
> will not register with mac80211 because this warning hits in net/wireless/core.c:
> 
>              /*
>               * This isn't well-defined right now. If you have an
>               * IBSS interface, then its beacon interval may change
>               * by joining other networks, and nothing prevents it
>               * from doing that.
>               * So technically we probably shouldn't even allow AP
>               * and IBSS in the same interface, but it seems that
>               * some drivers support that, possibly only with fixed
>               * beacon intervals for IBSS.
>               */
>              if (WARN_ON(types & BIT(NL80211_IFTYPE_ADHOC) &&
>                      c->beacon_int_min_gcd)) {
>                  return -EINVAL;
>              }
> 
> 
> It looks like this was triggered by:
> 
> Commit 0c317a02ca982ca093e71bf07cb562265ba40032
> Author: Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
> Date:   Wed Oct 12 18:26:51 2016 +0530
> 
>      cfg80211: support virtual interfaces with different beacon intervals
> 
> and
> 
> commit 8ebee73b574ad3dd1f14d461f65ceaffbd637650
> Author: Anilkumar Kolli <akolli@codeaurora.org>
> Date:   Wed Mar 28 12:19:40 2018 +0300
> 
>      ath10k: advertize beacon_int_min_gcd
> 
> 
> To be honest, I don't see why that check for beacon_int_min_gcd is in the registration
> logic.  Having it be '1' means that the driver/nic/firmware is flexible on pretty much
> any combination of beacon interval, so why should that trigger the WARN_ON case?
> 
> Thanks,
> Ben
> 


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

