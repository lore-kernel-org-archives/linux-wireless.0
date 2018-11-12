Return-Path: <SRS0=J0pC=NX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6516C43441
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 16:26:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABE0A223AE
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 16:26:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="NRMMoODs";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="NRMMoODs"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ABE0A223AE
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729730AbeKMCUh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 12 Nov 2018 21:20:37 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:58474 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728103AbeKMCUh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Nov 2018 21:20:37 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 9795760722; Mon, 12 Nov 2018 16:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542039999;
        bh=jgvQodXF52L/kSjpB6J2CFidvekverOBUV7VzXtLV+Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NRMMoODsIftuPW74VDj1qzL+36OJtCglcvhHPL8n3vSCDZDIx5ThBoT6DYGSUAOFL
         +UixvNCSKgNOmRHaEiiZo4pxcGfT0e8Iw3OyZHfg/vwUKwI/81GY4LJUhR+/iROO8q
         YmqG5x7uZH0NyfhOam1rQcyTihw0L7LgDeBDX3tU=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 3AEDB60242;
        Mon, 12 Nov 2018 16:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542039999;
        bh=jgvQodXF52L/kSjpB6J2CFidvekverOBUV7VzXtLV+Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NRMMoODsIftuPW74VDj1qzL+36OJtCglcvhHPL8n3vSCDZDIx5ThBoT6DYGSUAOFL
         +UixvNCSKgNOmRHaEiiZo4pxcGfT0e8Iw3OyZHfg/vwUKwI/81GY4LJUhR+/iROO8q
         YmqG5x7uZH0NyfhOam1rQcyTihw0L7LgDeBDX3tU=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 12 Nov 2018 21:56:39 +0530
From:   Balaji Pothunoori <bpothuno@codeaurora.org>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org
Subject: Re: [PATCH v5] iw: ack signal support for tx ack packets
In-Reply-To: <1532010590-475-1-git-send-email-bpothuno@codeaurora.org>
References: <1532010590-475-1-git-send-email-bpothuno@codeaurora.org>
Message-ID: <092e18e05296d9e2e7e8580603ac8b1d@codeaurora.org>
X-Sender: bpothuno@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Johannes,

Now that corresponding driver patches are merged, could you please let 
me know if anything is left from our end for merging this patch?

Regards,
Balaji.

On 2018-07-19 19:59, Balaji Pothunoori wrote:
> This patch is to display the average ack signal,
> last ack signal of tx ack packets.
> 
> Signed-off-by: Balaji Pothunoori <bpothuno@codeaurora.org>
> ---
> v5:
>  * Rebased, No changes
> v4:
>  * Changed the subject
>  * Added last ack signal support and renamed avg ack signal macro
> v3:
>  * Added version no
> v2:
>  * Removed nl80211.h changes and modified the commit log
> 
>  station.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/station.c b/station.c
> index 38c5f91..fd38043 100644
> --- a/station.c
> +++ b/station.c
> @@ -308,6 +308,8 @@ static int print_sta_handler(struct nl_msg *msg, 
> void *arg)
>  		[NL80211_STA_INFO_TID_STATS] = { .type = NLA_NESTED },
>  		[NL80211_STA_INFO_BSS_PARAM] = { .type = NLA_NESTED },
>  		[NL80211_STA_INFO_RX_DURATION] = { .type = NLA_U64 },
> +		[NL80211_STA_INFO_ACK_SIGNAL] = {.type = NLA_U8 },
> +		[NL80211_STA_INFO_ACK_SIGNAL_AVG] = { .type = NLA_U8 },
>  	};
>  	char *chain;
> 
> @@ -409,6 +411,14 @@ static int print_sta_handler(struct nl_msg *msg, 
> void *arg)
>  		printf("\n\trx duration:\t%lld us",
>  		       (unsigned long 
> long)nla_get_u64(sinfo[NL80211_STA_INFO_RX_DURATION]));
> 
> +	if (sinfo[NL80211_STA_INFO_ACK_SIGNAL])
> +		printf("\n\tlast ack signal:%d dBm",
> +			(int8_t)nla_get_u8(sinfo[NL80211_STA_INFO_ACK_SIGNAL]));
> +
> +	if (sinfo[NL80211_STA_INFO_ACK_SIGNAL_AVG])
> +		printf("\n\tavg ack signal:\t%d dBm",
> +			(int8_t)nla_get_u8(sinfo[NL80211_STA_INFO_ACK_SIGNAL_AVG]));
> +
>  	if (sinfo[NL80211_STA_INFO_EXPECTED_THROUGHPUT]) {
>  		uint32_t thr;
