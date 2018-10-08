Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 952DEC65C20
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 14:31:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B9C52075C
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 14:31:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5B9C52075C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbeJHVna (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 17:43:30 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:56528 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726078AbeJHVna (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 17:43:30 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1g9WZD-0008AR-JA; Mon, 08 Oct 2018 16:31:27 +0200
Message-ID: <1539009076.3687.64.camel@sipsolutions.net>
Subject: Re: [PATCH 04/19] wilc: add host_interface.c
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Ajay Singh <ajay.kathat@microchip.com>,
        linux-wireless@vger.kernel.org
Cc:     kvalo@codeaurora.org, gregkh@linuxfoundation.org,
        ganesh.krishna@microchip.com, aditya.shankar@microchip.com,
        venkateswara.kaja@microchip.com, claudiu.beznea@microchip.com,
        adham.abozaeid@microchip.com
Date:   Mon, 08 Oct 2018 16:31:16 +0200
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


> +	*currbyte = (u32)0 & DRV_HANDLER_MASK;

You do this a few times, not sure what it's supposed to achieve?

> +	if (param->flag & RETRY_LONG) {
> +		u16 limit = param->long_retry_limit;
> +
> +		if (limit > 0 && limit < 256) {
> +			wid_list[i].id = WID_LONG_RETRY_LIMIT;
> +			wid_list[i].val = (s8 *)&param->long_retry_limit;
> +			wid_list[i].type = WID_SHORT;
> +			wid_list[i].size = sizeof(u16);
> +			hif_drv->cfg_values.long_retry_limit = limit;
> +		} else {
> +			netdev_err(vif->ndev, "Range(1~256) over\n");
> +			goto unlock;
> +		}
> +		i++;
> +	}

So ... can anyone tell me why there's a complete driver-internal
messaging infrastructure in this, that even suppresses errors like here
(out of range just results in a message rather than returning an error
to wherever it originated)?

It almost *seems* like it's a to-device infrastructure, but it can't be
since it uses host pointers everywhere?

I think this code would be far better off without the "bounce in driver
to resolve host pointers" step.

> +	if (conn_attr->ssid) {
> +		memcpy(cur_byte, conn_attr->ssid, conn_attr->ssid_len);
> +		cur_byte[conn_attr->ssid_len] = '\0';
> +	}
> +	cur_byte += MAX_SSID_LEN;

again, SSIDs are not 0-terminated strings

> +static void host_int_fill_join_bss_param(struct join_bss_param *param, u8 *ies,
> +					 u16 *out_index, u8 *pcipher_tc,
> +					 u8 *auth_total_cnt, u32 tsf_lo,
> +					 u8 *rates_no)
> +{
> +	u8 ext_rates_no;
> +	u16 offset;
> +	u8 pcipher_cnt;
> +	u8 auth_cnt;
> +	u8 i, j;
> +	u16 index = *out_index;
> +
> +	if (ies[index] == WLAN_EID_SUPP_RATES) {
> +		*rates_no = ies[index + 1];
> +		param->supp_rates[0] = *rates_no;
> +		index += 2;
> +
> +		for (i = 0; i < *rates_no; i++)
> +			param->supp_rates[i + 1] = ies[index + i];
> +
> +		index += *rates_no;
> +	} else if (ies[index] == WLAN_EID_EXT_SUPP_RATES) {
> +		ext_rates_no = ies[index + 1];
> +		if (ext_rates_no > (MAX_RATES_SUPPORTED - *rates_no))
> +			param->supp_rates[0] = MAX_RATES_SUPPORTED;
> +		else
> +			param->supp_rates[0] += ext_rates_no;
> +		index += 2;
> +		for (i = 0; i < (param->supp_rates[0] - *rates_no); i++)
> +			param->supp_rates[*rates_no + i + 1] = ies[index + i];
> +
> +		index += ext_rates_no;
> +	} else if (ies[index] == WLAN_EID_HT_CAPABILITY) {
> +		param->ht_capable = true;
> +		index += ies[index + 1] + 2;
> +	} else if ((ies[index] == WLAN_EID_VENDOR_SPECIFIC) &&
> +		   (ies[index + 2] == 0x00) && (ies[index + 3] == 0x50) &&
> +		   (ies[index + 4] == 0xF2) && (ies[index + 5] == 0x02) &&
> +		   ((ies[index + 6] == 0x00) || (ies[index + 6] == 0x01)) &&
> +		   (ies[index + 7] == 0x01)) {
> +		param->wmm_cap = true;
> +
> +		if (ies[index + 8] & BIT(7))
> +			param->uapsd_cap = true;
> +		index += ies[index + 1] + 2;
> +	} else if ((ies[index] == WLAN_EID_VENDOR_SPECIFIC) &&
> +		 (ies[index + 2] == 0x50) && (ies[index + 3] == 0x6f) &&
> +		 (ies[index + 4] == 0x9a) &&
> +		 (ies[index + 5] == 0x09) && (ies[index + 6] == 0x0c)) {
> +		u16 p2p_cnt;
> +
> +		param->tsf = tsf_lo;
> +		param->noa_enabled = 1;
> +		param->idx = ies[index + 9];
> +
> +		if (ies[index + 10] & BIT(7)) {
> +			param->opp_enabled = 1;
> +			param->ct_window = ies[index + 10];
> +		} else {
> +			param->opp_enabled = 0;
> +		}
> +
> +		param->cnt = ies[index + 11];
> +		p2p_cnt = index + 12;
> +
> +		memcpy(param->duration, ies + p2p_cnt, 4);
> +		p2p_cnt += 4;
> +
> +		memcpy(param->interval, ies + p2p_cnt, 4);
> +		p2p_cnt += 4;
> +
> +		memcpy(param->start_time, ies + p2p_cnt, 4);
> +
> +		index += ies[index + 1] + 2;
> +	} else if ((ies[index] == WLAN_EID_RSN) ||
> +		 ((ies[index] == WLAN_EID_VENDOR_SPECIFIC) &&
> +		  (ies[index + 2] == 0x00) &&
> +		  (ies[index + 3] == 0x50) && (ies[index + 4] == 0xF2) &&
> +		  (ies[index + 5] == 0x01))) {
> +		u16 rsn_idx = index;
> +
> +		if (ies[rsn_idx] == WLAN_EID_RSN) {
> +			param->mode_802_11i = 2;
> +		} else {
> +			if (param->mode_802_11i == 0)
> +				param->mode_802_11i = 1;
> +			rsn_idx += 4;
> +		}
> +
> +		rsn_idx += 7;
> +		param->rsn_grp_policy = ies[rsn_idx];
> +		rsn_idx++;
> +		offset = ies[rsn_idx] * 4;
> +		pcipher_cnt = (ies[rsn_idx] > 3) ? 3 : ies[rsn_idx];
> +		rsn_idx += 2;
> +
> +		i = *pcipher_tc;
> +		j = 0;
> +		for (; i < (pcipher_cnt + *pcipher_tc) && i < 3; i++, j++) {
> +			u8 *policy =  &param->rsn_pcip_policy[i];
> +
> +			*policy = ies[rsn_idx + ((j + 1) * 4) - 1];
> +		}
> +
> +		*pcipher_tc += pcipher_cnt;
> +		rsn_idx += offset;
> +
> +		offset = ies[rsn_idx] * 4;
> +
> +		auth_cnt = (ies[rsn_idx] > 3) ? 3 : ies[rsn_idx];
> +		rsn_idx += 2;
> +		i = *auth_total_cnt;
> +		j = 0;
> +		for (; i < (*auth_total_cnt + auth_cnt); i++, j++) {
> +			u8 *policy =  &param->rsn_auth_policy[i];
> +
> +			*policy = ies[rsn_idx + ((j + 1) * 4) - 1];
> +		}
> +
> +		*auth_total_cnt += auth_cnt;
> +		rsn_idx += offset;
> +
> +		if (ies[index] == WLAN_EID_RSN) {
> +			param->rsn_cap[0] = ies[rsn_idx];
> +			param->rsn_cap[1] = ies[rsn_idx + 1];
> +			rsn_idx += 2;
> +		}
> +		param->rsn_found = true;
> +		index += ies[index + 1] + 2;
> +	} else {
> +		index += ies[index + 1] + 2;
> +	}
> +
> +	*out_index = index;
> +}

Again, use actual kernel infrastructure for much of this.

> +	cur_byte = wid.val;
> +	*cur_byte++ = (param->interval & 0xFF);
> +	*cur_byte++ = ((param->interval >> 8) & 0xFF);
> +	*cur_byte++ = ((param->interval >> 16) & 0xFF);
> +	*cur_byte++ = ((param->interval >> 24) & 0xFF);

put_unaligned_le32().

> +	*cur_byte++ = param->aid & 0xFF;
> +	*cur_byte++ = (param->aid >> 8) & 0xFF;

and so on

but then again, I just suggested to not have these "pack" functions to
start with, or at least not in this way, since it just means you first
pack everything into host structs, and then repack everything again into
firmware format ...


So far I guess I'd say:
 * use more kernel infra, in particular {get,put}_unaligned_le{16,32}
 * name your device/driver-specific constants better, rather than things
   like "SET_CFG" which leave everyone wondering if it's specific to
   this driver or something from elsewhere

johannes
