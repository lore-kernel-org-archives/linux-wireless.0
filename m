Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5DC8C65C20
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 14:17:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 971C820841
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 14:17:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 971C820841
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbeJHV25 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 17:28:57 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:56434 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726056AbeJHV25 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 17:28:57 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1g9WLD-0007wA-Aj; Mon, 08 Oct 2018 16:16:59 +0200
Message-ID: <1539008207.3687.53.camel@sipsolutions.net>
Subject: Re: [PATCH 02/19] wilc: add coreconfigurator.c
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Ajay Singh <ajay.kathat@microchip.com>,
        linux-wireless@vger.kernel.org
Cc:     kvalo@codeaurora.org, gregkh@linuxfoundation.org,
        ganesh.krishna@microchip.com, aditya.shankar@microchip.com,
        venkateswara.kaja@microchip.com, claudiu.beznea@microchip.com,
        adham.abozaeid@microchip.com
Date:   Mon, 08 Oct 2018 16:16:47 +0200
In-Reply-To: <1537957525-11467-3-git-send-email-ajay.kathat@microchip.com> (sfid-20180926_122540_337510_C34E9097)
References: <1537957525-11467-1-git-send-email-ajay.kathat@microchip.com>
         <1537957525-11467-3-git-send-email-ajay.kathat@microchip.com>
         (sfid-20180926_122540_337510_C34E9097)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 (3.26.6-1.fc27) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


> +static inline u16 get_beacon_period(u8 *data)
> +{
> +	u16 bcn_per;
> +
> +	bcn_per  = data[0];
> +	bcn_per |= (data[1] << 8);
> +
> +	return bcn_per;
> +}

Remove and use get_unaligned_le16().

> +static inline u32 get_beacon_timestamp_lo(u8 *data)
> +{
> +	u32 time_stamp = 0;
> +	u32 index    = MAC_HDR_LEN;
> +
> +	time_stamp |= data[index++];
> +	time_stamp |= (data[index++] << 8);
> +	time_stamp |= (data[index++] << 16);
> +	time_stamp |= (data[index]   << 24);
> +
> +	return time_stamp;
> +}

get_unaligned_le32()

> +static inline u32 get_beacon_timestamp_hi(u8 *data)
> +{
> +	u32 time_stamp = 0;
> +	u32 index    = (MAC_HDR_LEN + 4);
> +
> +	time_stamp |= data[index++];
> +	time_stamp |= (data[index++] << 8);
> +	time_stamp |= (data[index++] << 16);
> +	time_stamp |= (data[index]   << 24);
> +
> +	return time_stamp;
> +}

get_unaligned_le32()

> +static inline enum sub_frame_type get_sub_type(u8 *header)
> +{
> +	return ((enum sub_frame_type)(header[0] & 0xFC));
> +}

remove, use include/linux/ieee80211.h.

> +static inline u8 get_to_ds(u8 *header)
> +{
> +	return (header[1] & 0x01);
> +}
> +
> +static inline u8 get_from_ds(u8 *header)
> +{
> +	return ((header[1] & 0x02) >> 1);
> +}

dito

> +static inline void get_address1(u8 *msa, u8 *addr)
> +{
> +	memcpy(addr, msa + 4, 6);
> +}
> +
> +static inline void get_address2(u8 *msa, u8 *addr)
> +{
> +	memcpy(addr, msa + 10, 6);
> +}
> +
> +static inline void get_address3(u8 *msa, u8 *addr)

you probably shouldn't memcpy() here, that's expensive.

> +static inline void get_bssid(u8 *data, u8 *bssid)
> +{
> +	if (get_from_ds(data) == 1)
> +		get_address2(data, bssid);
> +	else if (get_to_ds(data) == 1)
> +		get_address1(data, bssid);
> +	else
> +		get_address3(data, bssid);
> +}

I just noticed we don't have this in ieee80211.h, but perhaps we should.

I think you should just return a pointer though, there's no point in
memcpy().

> +static inline void get_ssid(u8 *data, u8 *ssid, u8 *p_ssid_len)
> +{
> +	u8 i, j, len;
> +
> +	len = data[TAG_PARAM_OFFSET + 1];
> +	j   = TAG_PARAM_OFFSET + 2;
> +
> +	if (len >= MAX_SSID_LEN)
> +		len = 0;
> +
> +	for (i = 0; i < len; i++, j++)
> +		ssid[i] = data[j];
> +
> +	ssid[len] = '\0';

SSIDs are *NOT* strings, don't pretend they are.

> +	*p_ssid_len = len;
> +}

Uh, no, we have helper functions for finding elements.

Again, return something, don't just fill out parameters.

> +static inline u16 get_cap_info(u8 *data)
> +{
> +	u16 cap_info = 0;
> +	u16 index    = MAC_HDR_LEN;
> +	enum sub_frame_type st;
> +
> +	st = get_sub_type(data);
> +
> +	if (st == BEACON || st == PROBE_RSP)
> +		index += TIME_STAMP_LEN + BEACON_INTERVAL_LEN;
> +
> +	cap_info  = data[index];
> +	cap_info |= (data[index + 1] << 8);
> +
> +	return cap_info;
> +}

Umm, no, ieee80211.h.

> +static inline u16 get_asoc_status(u8 *data)
> +{
> +	u16 asoc_status;
> +
> +	asoc_status = data[3];
> +	return (asoc_status << 8) | data[2];
> +}

I'll just stop here - you need to replace almost all of this file with
ieee80211.h stuff instead.

johannes
