Return-Path: <SRS0=J0pC=NX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47B37C43441
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 04:10:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10B6120871
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 04:10:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=newmedia-net.de header.i=@newmedia-net.de header.b="YHeq0bK7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 10B6120871
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=newmedia-net.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731003AbeKLOCG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 12 Nov 2018 09:02:06 -0500
Received: from webmail.newmedia-net.de ([185.84.6.166]:46907 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730691AbeKLOCF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Nov 2018 09:02:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=newmedia-net.de; s=mikd;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:References:Cc:To:From:Subject; bh=gkOFW2viWL7CU8HEqP+LxQFMhrmRgkUXqUbN3rp7jNw=;
        b=YHeq0bK7FmL5E1UhlgQP6Ej+ivoXovgEpFxrtS+9uQXZBuCQBPlqdR7rj/2XAFEXyN7B5PsTt2Y9mb1rylWB5C/xRP/i6wOk1n6VoNHTGy/p7XIiMaxmE1kAKYAV4gfBuRm69cIEYUQF+2AR4SYlw9Y1vUlwzdaF9kZ5NEh6eG4=;
Subject: Re: [EXTERNAL] Re: [PATCH] ath10k: Disable 4addr source port learning
 in 10.4 FW by default
From:   Sebastian Gottschall <s.gottschall@newmedia-net.de>
To:     murugana@codeaurora.org, ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org
References: <20181109061121.4184-1-murugana@codeaurora.org>
 <0d74b002-e36d-8169-34e8-59338eac6918@newmedia-net.de>
 <00fd01d4798e$1c0d2f10$54278d30$@codeaurora.org>
 <18df2020-f8c4-b9f7-cf9c-63802ea02429@newmedia-net.de>
Message-ID: <cc8040a6-47f8-c8f0-0451-2e220d91d62c@newmedia-net.de>
Date:   Mon, 12 Nov 2018 05:10:33 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <18df2020-f8c4-b9f7-cf9c-63802ea02429@newmedia-net.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Received:  from [2003:c9:3f20:e600:8105:73f2:3f4c:36e7]
        by webmail.newmedia-net.de with esmtpsa (TLSv1:AES128-SHA:128)
        (Exim 4.72)
        (envelope-from <s.gottschall@newmedia-net.de>)
        id 1gM3Yf-0002LV-Ge; Mon, 12 Nov 2018 05:10:41 +0100
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

i tested my proposal now and it fixes the issue. the submitted patch was 
simply broken at that small point

Am 12.11.2018 um 03:44 schrieb Sebastian Gottschall:
> hint for a possible fix
>
>
> disable_4addr_src_lrn is not set in 10_4 vdev parameter map. so this 
> feature cannot work
>
>
> --- wmi.c       (Revision 4214)
> +++ wmi.c       (Arbeitskopie)
> @@ -972,6 +972,7 @@
>         .meru_vc = WMI_VDEV_PARAM_UNSUPPORTED,
>         .rx_decap_type = WMI_VDEV_PARAM_UNSUPPORTED,
>         .bw_nss_ratemask = WMI_VDEV_PARAM_UNSUPPORTED,
> +       .disable_4addr_src_lrn = WMI_VDEV_PARAM_UNSUPPORTED,
>  };
>
>  static struct wmi_vdev_param_map wmi_10_4_vdev_param_map = {
> @@ -1049,6 +1050,7 @@
>         .bw_nss_ratemask = WMI_10_4_VDEV_PARAM_BW_NSS_RATEMASK,
>         .inc_tsf = WMI_10_4_VDEV_PARAM_TSF_INCREMENT,
>         .dec_tsf = WMI_10_4_VDEV_PARAM_TSF_DECREMENT,
> +       .disable_4addr_src_lrn = 
> WMI_10_4_VDEV_PARAM_DISABLE_4_ADDR_SRC_LRN,
>  };
>
> Am 11.11.2018 um 08:13 schrieb murugana@codeaurora.org:
>> Hi Sebastian,
>>
>>> after tested 2 WDS devices (one WDS AP, one WDS STA) with 9984 (netgear
>>> r7800) i found out that the issue persists. gtk rekeying fails, so 
>>> disconnect and
>>> reconnect after 60 minutes.
>> Are you using the latest FW 10.4-3.6.0.1-00003 for 9984 ( mainly on 
>> the AP side ) ?
>>
>> (https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/commit/?id=a00e61b9203186561dc90de1ff7ed4d5f5e920d5) 
>>
>>
>> Thanks,
>> Sathishkumar
>>
>>
>>
