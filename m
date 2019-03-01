Return-Path: <SRS0=sb9s=RE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64413C10F03
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Mar 2019 15:29:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 296CE20851
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Mar 2019 15:29:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="LNJAK1RA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387586AbfCAP3k (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Mar 2019 10:29:40 -0500
Received: from mail2.candelatech.com ([208.74.158.173]:48922 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727952AbfCAP3k (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Mar 2019 10:29:40 -0500
Received: from [192.168.100.195] (firewall.candelatech.com [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail2.candelatech.com (Postfix) with ESMTPSA id 6229340A955;
        Fri,  1 Mar 2019 07:29:37 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail2.candelatech.com 6229340A955
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1551454177;
        bh=6wmiCvopAZ73soO2kw754M3SobXN1qImTULRpYOqxbQ=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=LNJAK1RAynJY9G34hVNf9dWZzRcr9Clozp30ukVF4A5uuEfEeuM5h8K+0OJYBaKTr
         WXvPdYb/Sv+VE+TDzDHTxMuJ0gt260WB7nWbbFc0l09s98Bg4JLMOysr2Y1o4Tnxzy
         grn9unjAiBld2XM8yr1akK8VkL4v0y7C51wgpGVE=
Subject: Re: [PATCH] mac80211: do not call driver wake_tx_queue op during
 reconfig
To:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net, stable@vger.kernel.org
References: <20190301134837.88087-1-nbd@nbd.name>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <09a12ed0-dd86-2077-9ecb-c62a52186952@candelatech.com>
Date:   Fri, 1 Mar 2019 07:29:37 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190301134837.88087-1-nbd@nbd.name>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 3/1/19 5:48 AM, Felix Fietkau wrote:
> There are several scenarios in which mac80211 can call drv_wake_tx_queue
> after ieee80211_restart_hw has been called and has not yet completed.
> Driver private structs are considered uninitialized until mac80211 has
> uploaded the vifs, stations and keys again, so using private tx queue
> data during that time is not safe.
> 
> The driver can also not rely on drv_reconfig_complete to figure out when
> it is safe to accept drv_wake_tx_queue calls again, because it is only
> called after all tx queues are woken again.
> 
> To fix this, bail out early in drv_wake_tx_queue if local->in_reconfig
> is set.

This reminded me of a patch I posted back in 2016.  The discussion just sort of
ended on it, but curious if you have a new opinion on it after debugging the
issue in this patch:

https://patchwork.kernel.org/patch/9457709/

For what its worth, I've been using the patch above since I posted it, and
it seems to work well for ath9k and ath10k.

Thanks,
Ben


> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> ---
>   net/mac80211/driver-ops.h | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
> index 28d022a3eee3..ae4f0be3b393 100644
> --- a/net/mac80211/driver-ops.h
> +++ b/net/mac80211/driver-ops.h
> @@ -1195,6 +1195,9 @@ static inline void drv_wake_tx_queue(struct ieee80211_local *local,
>   {
>   	struct ieee80211_sub_if_data *sdata = vif_to_sdata(txq->txq.vif);
>   
> +	if (local->in_reconfig)
> +		return;
> +
>   	if (!check_sdata_in_driver(sdata))
>   		return;
>   
> 


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

