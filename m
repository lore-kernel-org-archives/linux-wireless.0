Return-Path: <SRS0=ht5v=ND=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97D23C46475
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Oct 2018 13:56:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B66B20652
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Oct 2018 13:56:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rdPXoYAA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4B66B20652
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lwfinger.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728130AbeJWWUL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Oct 2018 18:20:11 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:37300 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726953AbeJWWUL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Oct 2018 18:20:11 -0400
Received: by mail-ot1-f66.google.com with SMTP id o14so1439454oth.4
        for <linux-wireless@vger.kernel.org>; Tue, 23 Oct 2018 06:56:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gMPXzy6GdKrIJsXO7VrxyzZDWdrbP2g5JUvxMboE1Lw=;
        b=rdPXoYAAxDbD/K5Cpb+UH+oUEluf5UhgbyrXtYZMnSUi7vjx3uHrjrOraTP/B+zbhP
         2UCE/cQxy5JaX9vw4jwRJOf6BnGM58+M8XfNDmWC18Wt7lp3gzMKNDh9leoziRiYdMmu
         xnNEVwG5KaiCFayBDPWqMomVNansetSggMf00saLUE5v/WxUZDEdRX3kII0kQC8AFM+X
         9WOYph3H/3pC/Y1WSclolAglGX8LkVCHL5Y2HM4JhQN+n5GKamVqE55+3pn4InkbAsil
         71VVD5vy3ZGY3Ag6VdUvAzZ4CKOUaNfmwu/5uql/YzlSoaPMSWXYq5VPwjkJMTKYe8tT
         MdLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gMPXzy6GdKrIJsXO7VrxyzZDWdrbP2g5JUvxMboE1Lw=;
        b=nJ/S7HHyUzpk7j6+/jvXULvfU/fnN4gnNx80Dxnb0jhForkWn3h8KuZI/Ku7xleFD0
         ISRhcwWx4inj17w/pLpyDFtgj/gXOhXxHEeh+asVISVeJ+bKhauTO/3cm3EmL+hxamAG
         1Lp1W2foANZhUgjCEZqGs/7h+sr2GhAL2jbMYMH36aYniAPuCdw6kwvvLJTgj7MOePQd
         chJU3IH480RR2pdzt/jK9I/KVvsiFgt5dlPcR9y6g6FbWmvu45c4GONJf8CeeFM/75zf
         0OCIksiUstmKSZ8K64Xm/a3Z+XgPYV51xFi2R0KrBKWjdPY7ZO6okekObTc1dVdCtyJw
         cg2A==
X-Gm-Message-State: AGRZ1gKVRUX+5dLygYzSfcOERTWDAyhIihK/HEqxy0i3oP7JeG3MUHdF
        hMmygJGyPCqF5dpdq2GK1GXT2KX2
X-Google-Smtp-Source: AJdET5ctETnJpWohMKkzyWkKT+U3bMd/ILgqQZ/vdDchpIxcE9e/dq1gQcR+fU1qk7QsNMAOxEY5Zw==
X-Received: by 2002:a9d:6509:: with SMTP id i9mr3752483otl.338.1540302996703;
        Tue, 23 Oct 2018 06:56:36 -0700 (PDT)
Received: from [192.168.1.107] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id d7sm431715otf.17.2018.10.23.06.56.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Oct 2018 06:56:36 -0700 (PDT)
Subject: Re: [PATCH] mac80211: fix GFP_KERNEL under tasklet context
To:     yhchuang@realtek.com, johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org
References: <1540265084-13808-1-git-send-email-yhchuang@realtek.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <d723a62c-96b1-70c6-1125-05056fb4a62f@lwfinger.net>
Date:   Tue, 23 Oct 2018 08:56:35 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <1540265084-13808-1-git-send-email-yhchuang@realtek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 10/22/18 10:24 PM, yhchuang@realtek.com wrote:
> From: Yan-Hsuan Chuang <yhchuang@realtek.com>
> 
> cfg80211_sta_opmode_change_notify needs a gfp_t flag to hint the nl80211
> stack when allocating new skb, but it is called under tasklet context
> here with GFP_KERNEL and kernel will yield a warning about it.
> 
> Fixes: ff84e7bfe176 ("mac80211: Add support to notify ht/vht opmode modification.")
> Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
> ---

ACKed-by: Larry Finger <Larry.Finger@lwfinger.net>

Just in case a "Fixes" is not enough, please add

Cc: Stable <stable@vger.kernel.org> # v4.17+

Larry

>   net/mac80211/rx.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index 64742f2..03d3964f 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -3028,7 +3028,7 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
>   			cfg80211_sta_opmode_change_notify(sdata->dev,
>   							  rx->sta->addr,
>   							  &sta_opmode,
> -							  GFP_KERNEL);
> +							  GFP_ATOMIC);
>   			goto handled;
>   		}
>   		case WLAN_HT_ACTION_NOTIFY_CHANWIDTH: {
> @@ -3065,7 +3065,7 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
>   			cfg80211_sta_opmode_change_notify(sdata->dev,
>   							  rx->sta->addr,
>   							  &sta_opmode,
> -							  GFP_KERNEL);
> +							  GFP_ATOMIC);
>   			goto handled;
>   		}
>   		default:
> 

