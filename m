Return-Path: <SRS0=Ms0V=QP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FDD3C169C4
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 08:17:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F63B21916
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 08:17:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="a4/RptSL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727253AbfBHIR2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Feb 2019 03:17:28 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:44270 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727235AbfBHIR1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Feb 2019 03:17:27 -0500
Received: by mail-ed1-f67.google.com with SMTP id y56so2015977edd.11
        for <linux-wireless@vger.kernel.org>; Fri, 08 Feb 2019 00:17:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=U4Pe4fNw6L+fcGv+PWkNUOC0Egc3QA4HuB9QNya1M4s=;
        b=a4/RptSLeES4diwtDNX3umeqDxKhny/uM8T+oQJLfP/LfUbphCzduZJ6aI8CxzvmJS
         H/l17XTc7HijJTujDYK4hluGqEejmDMWtnWdClHNL8WaHr3FjMlOUUvyQp0eY3ENw+cZ
         2tJljGoYahnhclje05olxRYkgM3wcPJz79Z8M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=U4Pe4fNw6L+fcGv+PWkNUOC0Egc3QA4HuB9QNya1M4s=;
        b=L3ZjAmtjoNJiiRWLXO69zk2cMVe+/1DLfe2SnsH6Qz5p22UVmZ4SxAq8B1C/Dnq6SB
         srgJZIqC/96ejWD9tyiNoyGLoPh2wVUulPqaNnVxlGMp0thjQvhQWLED+pvMAZENAkeN
         33VeambrTB8lCkNpGyCQ3h3LgWVsoTqrQt95IiH7IyCwr+orfpqjjGv3eVO6gHlLaKcp
         Y3y9NsBCLqdX80n6S+/VDsbX6V6KqkPm1h3Zq/HhFkkRZQXzPQxJJHQ+5Kms4+Df2EkP
         1sLxnJ/0+XKrdfk+OAVJUSM2qcgALandZvi0rInhFMMMHprjBcs8qVSJ7kLeNqdP2TRz
         c8MQ==
X-Gm-Message-State: AHQUAuZ/DkM7J9+gpc70mZnGGznUJENhb2D9hr+0R1jhFDU6e17qCwip
        6QjTVksc62lOhZSikJdAZ28gEA==
X-Google-Smtp-Source: AHgI3IaTtMeUMTuqVO3BuNyWjholOyq8Urop+MhGRRV5oNcAWOq/FCJLn8R9muSnrZZyqkpmcdzqPw==
X-Received: by 2002:a17:906:57c7:: with SMTP id u7mr2764432ejr.35.1549613845502;
        Fri, 08 Feb 2019 00:17:25 -0800 (PST)
Received: from [192.168.178.129] (f140230.upc-f.chello.nl. [80.56.140.230])
        by smtp.gmail.com with ESMTPSA id g31sm440203eda.96.2019.02.08.00.17.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Feb 2019 00:17:24 -0800 (PST)
Subject: Re: [PATCH V2] brcmfmac: support monitor frames with the
 hardware/ucode header
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20190122110858.12993-1-zajec5@gmail.com>
 <20190208064230.27775-1-zajec5@gmail.com>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <c91f2fa5-7344-3b60-b203-963b75f33660@broadcom.com>
Date:   Fri, 8 Feb 2019 09:17:24 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190208064230.27775-1-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2/8/2019 7:42 AM, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> So far there were two monitor frame formats:
> 1) 802.11 frames (with frame (sub)type & all addresses)
> 2) 802.11 frames with the radiotap header
> 
> Testing the latest FullMAC firmwares for 4366b1/4366c0 resulted in
> discovering a new format being used. It seems (almost?) identical to the
> one known from ucode used in SoftMAC devices which is most likely the
> same codebase anyway.
> 
> While new firmwares will /announce/ radiotap header support using the
> "rtap" fw capability string it seems no string was added for the new
> ucode header format.
> 
> All above means that:
> 1) We need new format support when dealing with a received frame
> 2) A new feature bit & mapping quirks have to be added manually
> 
> As for now only an empty radiotap is being created. Adding support for
> extracting some info (band, channel, signal, etc.) is planned for the
> future.

Probably V1 was missing an ACK hence the confusion so to be sure...

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
> V2: Update commit message (only):
>      1) Don't say the new firmwares were expected to provide radiotap
>         frames. That was my misinterpretation of adding "rtap" string.
>      2) List all monitor frame formats as it apparently got a bit
>         confusing at this point (there are 3 different ones!).
> ---
>   .../broadcom/brcm80211/brcmfmac/core.c        | 55 +++++++++++++++++++
>   .../broadcom/brcm80211/brcmfmac/feature.c     |  4 ++
>   .../broadcom/brcm80211/brcmfmac/feature.h     |  4 +-
>   3 files changed, 62 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> index 860a4372cb56..e772c0845638 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> @@ -43,6 +43,36 @@
>   
>   #define BRCMF_BSSIDX_INVALID			-1
>   
> +#define	RXS_PBPRES				BIT(2)
> +
> +#define	D11_PHY_HDR_LEN				6
> +
> +struct d11rxhdr_le {
> +	__le16 RxFrameSize;
> +	u16 PAD;
> +	__le16 PhyRxStatus_0;
> +	__le16 PhyRxStatus_1;
> +	__le16 PhyRxStatus_2;
> +	__le16 PhyRxStatus_3;
> +	__le16 PhyRxStatus_4;
> +	__le16 PhyRxStatus_5;
> +	__le16 RxStatus1;
> +	__le16 RxStatus2;
> +	__le16 RxTSFTime;
> +	__le16 RxChan;
> +	u8 unknown[12];
> +} __packed;
> +
> +struct wlc_d11rxhdr {
> +	struct d11rxhdr_le rxhdr;
> +	__le32 tsf_l;
> +	s8 rssi;
> +	s8 rxpwr0;
> +	s8 rxpwr1;
> +	s8 do_rssi_ma;
> +	s8 rxpwr[4];
> +} __packed;
> +
>   char *brcmf_ifname(struct brcmf_if *ifp)
>   {
>   	if (!ifp)
> @@ -409,6 +439,31 @@ void brcmf_netif_mon_rx(struct brcmf_if *ifp, struct sk_buff *skb)
>   {
>   	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_MONITOR_FMT_RADIOTAP)) {
>   		/* Do nothing */
> +	} else if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_MONITOR_FMT_HW_RX_HDR)) {
> +		struct wlc_d11rxhdr *wlc_rxhdr = (struct wlc_d11rxhdr *)skb->data;
> +		struct ieee80211_radiotap_header *radiotap;
> +		unsigned int offset;
> +		u16 RxStatus1;
> +
> +		RxStatus1 = le16_to_cpu(wlc_rxhdr->rxhdr.RxStatus1);
> +
> +		offset = sizeof(struct wlc_d11rxhdr);
> +		/* MAC inserts 2 pad bytes for a4 headers or QoS or A-MSDU
> +		 * subframes
> +		 */
> +		if (RxStatus1 & RXS_PBPRES)
> +			offset += 2;
> +		offset += D11_PHY_HDR_LEN;
> +
> +		skb_pull(skb, offset);
> +
> +		/* TODO: use RX header to fill some radiotap data */
> +		radiotap = skb_push(skb, sizeof(*radiotap));
> +		memset(radiotap, 0, sizeof(*radiotap));
> +		radiotap->it_len = cpu_to_le16(sizeof(*radiotap));
> +
> +		/* TODO: 4 bytes with receive status? */
> +		skb->len -= 4;
>   	} else {
>   		struct ieee80211_radiotap_header *radiotap;
>   
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
> index 4c5a3995dc35..b91b7ecbfedf 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
> @@ -103,6 +103,10 @@ static const struct brcmf_feat_fwfeat brcmf_feat_fwfeat_map[] = {
>   	{ "01-6cb8e269", BIT(BRCMF_FEAT_MONITOR) },
>   	/* brcmfmac4366b-pcie.bin from linux-firmware.git commit 52442afee990 */
>   	{ "01-c47a91a4", BIT(BRCMF_FEAT_MONITOR) },
> +	/* brcmfmac4366b-pcie.bin from linux-firmware.git commit 211de1679a68 */
> +	{ "01-801fb449", BIT(BRCMF_FEAT_MONITOR_FMT_HW_RX_HDR) },
> +	/* brcmfmac4366c-pcie.bin from linux-firmware.git commit 211de1679a68 */
> +	{ "01-d2cbb8fd", BIT(BRCMF_FEAT_MONITOR_FMT_HW_RX_HDR) },
>   };
>   
>   static void brcmf_feat_firmware_overrides(struct brcmf_pub *drv)
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h
> index 0b4974df353a..5e88a7f16ad2 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h
> @@ -35,6 +35,7 @@
>    * FWSUP: Firmware supplicant.
>    * MONITOR: firmware can pass monitor packets to host.
>    * MONITOR_FMT_RADIOTAP: firmware provides monitor packets with radiotap header
> + * MONITOR_FMT_HW_RX_HDR: firmware provides monitor packets with hw/ucode header
>    */
>   #define BRCMF_FEAT_LIST \
>   	BRCMF_FEAT_DEF(MBSS) \
> @@ -52,7 +53,8 @@
>   	BRCMF_FEAT_DEF(GSCAN) \
>   	BRCMF_FEAT_DEF(FWSUP) \
>   	BRCMF_FEAT_DEF(MONITOR) \
> -	BRCMF_FEAT_DEF(MONITOR_FMT_RADIOTAP)
> +	BRCMF_FEAT_DEF(MONITOR_FMT_RADIOTAP) \
> +	BRCMF_FEAT_DEF(MONITOR_FMT_HW_RX_HDR)
>   
>   /*
>    * Quirks:
> 
