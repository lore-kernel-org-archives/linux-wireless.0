Return-Path: <SRS0=DbkN=SR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB0D2C10F0E
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 17:08:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC12E218EA
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 17:08:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="qCR56X9l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727373AbfDORIJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Apr 2019 13:08:09 -0400
Received: from [208.74.158.174] ([208.74.158.174]:44600 "EHLO
        mail3.candelatech.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1726740AbfDORII (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Apr 2019 13:08:08 -0400
Received: from [192.168.100.195] (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 8789213755B
        for <linux-wireless@vger.kernel.org>; Mon, 15 Apr 2019 10:08:07 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 8789213755B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1555348087;
        bh=Co+Xa75p/kKLqGsNBFeQWzOMHIz9DaNs/BErtLkVzmk=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=qCR56X9lOSvx9q/M2GrDrhVmIrTkfNZupCSsdlVInshhf+WXPrLsHaXzKCNg/3yFp
         S3IGMuHdStiqTOMPST2YBEXgWTK6VFgUCgZZp/omCY6KOcUWlu1ZTgO9u7b2foJGL/
         sa5PlC1bBFyVbOyKUa14+NbWSTUswHO5VSCkMN1k=
Subject: Re: [PATCH-v2 2/2] mac80211: add assoc-at-ms support.
To:     linux-wireless@vger.kernel.org
References: <20190415170543.21728-1-greearb@candelatech.com>
 <20190415170543.21728-2-greearb@candelatech.com>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <87cc1a06-97ce-13a3-7301-b8739bfcfcbe@candelatech.com>
Date:   Mon, 15 Apr 2019 10:08:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190415170543.21728-2-greearb@candelatech.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Please ignore, I edited the wrong files.

Go Monday!

Ben

On 4/15/19 10:05 AM, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> Report when sta becomes associated.
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
>   net/mac80211/sta_info.c | 3 +++
>   net/mac80211/sta_info.h | 2 ++
>   2 files changed, 5 insertions(+)
> 
> diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
> index 044120c45950..6dab7abe1603 100644
> --- a/net/mac80211/sta_info.c
> +++ b/net/mac80211/sta_info.c
> @@ -1980,6 +1980,7 @@ int sta_info_move_state(struct sta_info *sta,
>   		break;
>   	case IEEE80211_STA_AUTHORIZED:
>   		if (sta->sta_state == IEEE80211_STA_ASSOC) {
> +			sta->auth_at_ms = ktime_to_ms(ktime_get_real());
>   			ieee80211_vif_inc_num_mcast(sta->sdata);
>   			set_bit(WLAN_STA_AUTHORIZED, &sta->_flags);
>   			ieee80211_check_fast_xmit(sta);
> @@ -2197,6 +2198,7 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo,
>   			 BIT_ULL(NL80211_STA_INFO_STA_FLAGS) |
>   			 BIT_ULL(NL80211_STA_INFO_BSS_PARAM) |
>   			 BIT_ULL(NL80211_STA_INFO_CONNECTED_TIME) |
> +			 BIT_ULL(NL80211_STA_INFO_AUTH_AT_MS) |
>   			 BIT_ULL(NL80211_STA_INFO_RX_DROP_MISC);
>   
>   	if (sdata->vif.type == NL80211_IFTYPE_STATION) {
> @@ -2205,6 +2207,7 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo,
>   	}
>   
>   	sinfo->connected_time = ktime_get_seconds() - sta->last_connected;
> +	sinfo->auth_at_ms = sta->auth_at_ms;
>   	sinfo->inactive_time =
>   		jiffies_to_msecs(jiffies - ieee80211_sta_last_active(sta));
>   
> diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
> index c5d557032be5..97777978b8f5 100644
> --- a/net/mac80211/sta_info.h
> +++ b/net/mac80211/sta_info.h
> @@ -455,6 +455,7 @@ struct ieee80211_sta_rx_stats {
>    *	the station when it leaves powersave or polls for frames
>    * @driver_buffered_tids: bitmap of TIDs the driver has data buffered on
>    * @txq_buffered_tids: bitmap of TIDs that mac80211 has txq data buffered on
> + * @auth_at_ms: time (in ms) of last assoc -> auth transition
>    * @last_connected: time (in seconds) when a station got connected
>    * @last_seq_ctrl: last received seq/frag number from this STA (per TID
>    *	plus one for non-QoS frames)
> @@ -531,6 +532,7 @@ struct sta_info {
>   	unsigned long driver_buffered_tids;
>   	unsigned long txq_buffered_tids;
>   
> +	unsigned long auth_at_ms;
>   	long last_connected;
>   
>   	/* Updated from RX path only, no locking requirements */
> 


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

