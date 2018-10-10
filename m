Return-Path: <SRS0=yLyd=MW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C43C9C43441
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 20:15:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74F912086E
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 20:15:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 74F912086E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727593AbeJKDip (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Oct 2018 23:38:45 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:46342 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726911AbeJKDip (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Oct 2018 23:38:45 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gAKsl-0001Rq-5M; Wed, 10 Oct 2018 22:14:59 +0200
Message-ID: <1539202484.3687.188.camel@sipsolutions.net>
Subject: Re: [PATCH 04/19] wilc: add host_interface.c
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Ajay Singh <ajay.kathat@microchip.com>,
        linux-wireless@vger.kernel.org
Cc:     kvalo@codeaurora.org, gregkh@linuxfoundation.org,
        ganesh.krishna@microchip.com, aditya.shankar@microchip.com,
        venkateswara.kaja@microchip.com, claudiu.beznea@microchip.com,
        adham.abozaeid@microchip.com
Date:   Wed, 10 Oct 2018 22:14:44 +0200
In-Reply-To: <1537957525-11467-5-git-send-email-ajay.kathat@microchip.com> (sfid-20180926_122554_993494_C8703D81)
References: <1537957525-11467-1-git-send-email-ajay.kathat@microchip.com>
         <1537957525-11467-5-git-send-email-ajay.kathat@microchip.com>
         (sfid-20180926_122554_993494_C8703D81)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 (3.26.6-1.fc27) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Looking at all this wid_list stuff again,

> +	wid_list[wid_cnt].id = WID_SUCCESS_FRAME_COUNT;
> +	wid_list[wid_cnt].type = WID_INT;
> +	wid_list[wid_cnt].size = sizeof(u32);
> +	wid_list[wid_cnt].val = (s8 *)(&(dummyval));
> +	wid_cnt++;

Doesn't that have endian issues?

> +	wid_list[wid_cnt].id = WID_RECEIVED_FRAGMENT_COUNT;
> +	wid_list[wid_cnt].type = WID_INT;
> +	wid_list[wid_cnt].size = sizeof(u32);
> +	wid_list[wid_cnt].val = (s8 *)(&(dummyval));
> +	wid_cnt++;

But I'm not really sure what the pointer does, tbh.

> +	wid_list[wid_cnt].id = WID_JOIN_REQ_EXTENDED;
> +	wid_list[wid_cnt].type = WID_STR;
> +	wid_list[wid_cnt].size = 112;
> +	wid_list[wid_cnt].val = kmalloc(wid_list[wid_cnt].size, GFP_KERNEL);

I think you should declare a structure for these 112 bytes, clearly it's
something like

> +	if (conn_attr->ssid) {
> +		memcpy(cur_byte, conn_attr->ssid, conn_attr->ssid_len);
> +		cur_byte[conn_attr->ssid_len] = '\0';
> +	}
> +	cur_byte += MAX_SSID_LEN;

u8 ssid[32];

> +	*(cur_byte++) = INFRASTRUCTURE;

u8 type;

> +
> +	if (conn_attr->ch >= 1 && conn_attr->ch <= 14) {
> +		*(cur_byte++) = conn_attr->ch;
> +	} else {
> +		netdev_err(vif->ndev, "Channel out of range\n");
> +		*(cur_byte++) = 0xFF;
> +	}

u8 channel;

> +	*(cur_byte++)  = (bss_param->cap_info) & 0xFF;
> +	*(cur_byte++)  = ((bss_param->cap_info) >> 8) & 0xFF;

__le16 cap_info;

> +	if (conn_attr->bssid)
> +		memcpy(cur_byte, conn_attr->bssid, 6);
> +	cur_byte += 6;

u8 bssid[ETH_ALEN];

> +	if (conn_attr->bssid)
> +		memcpy(cur_byte, conn_attr->bssid, 6);
> +	cur_byte += 6;

again?

> +	*(cur_byte++)  = (bss_param->beacon_period) & 0xFF;
> +	*(cur_byte++)  = ((bss_param->beacon_period) >> 8) & 0xFF;

__le16 beacon_period;

> +	*(cur_byte++)  =  bss_param->dtim_period;

u8 dtim_period;

etc.

Declaring it as a struct also means you don't have to do all the
put_le16_unaligned() or whatever, but can just fill the struct properly.

johannes
