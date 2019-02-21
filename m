Return-Path: <SRS0=z+ld=Q4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D16BC43381
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 10:45:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCDCB2085A
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 10:45:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="PA7KkR3H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbfBUKp0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Feb 2019 05:45:26 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:42706 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725823AbfBUKpZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Feb 2019 05:45:25 -0500
Received: by mail-pl1-f193.google.com with SMTP id s1so13977906plp.9
        for <linux-wireless@vger.kernel.org>; Thu, 21 Feb 2019 02:45:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=B1FYgD6YqLHUb8d7A6suTAx7w6ab+0a8MawAQ3i1XJg=;
        b=PA7KkR3HHnwz6px2/9mioObO1OPEJZjIpiXBcpgEgMsXuAon5zU01jwOY+x746pW+4
         glwUq4YtTOIuEoIKKP7Eg/ZsbMcIfIRXcpFxv/3/V1K0DE/CtoRKQ7v6x1dQWxltZU1O
         1tsuvGjIwoCpXSZ0YrXGrzeMgy5MAwNN+gtH0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=B1FYgD6YqLHUb8d7A6suTAx7w6ab+0a8MawAQ3i1XJg=;
        b=chI6Qz+v2orXm262F142/Q1iJ/DcIeIdsNcPUFQueo/NRsuy9i/RYiVEqm/ZfFaw6j
         jmykNdOrsqtbF9nSCDncCBGp2iyw0/ctY+XeWVPHd47F5FZ9F4H2zS1gkuYWKZW7slEL
         67tMWUdc1PoHZYag2PiPd8aBJXZk3Cx5gGZ8a/dCSPJ/3yxNsrhwL/OkMOuOw0fyZ44h
         G+44KBEKsPb7BOSlnbA/7/K0H8F1GCwigQPUuMP3O++hH6qtUSXL6OP5EJKmu4ntL15i
         yxQQsvkt0RkuSsKaYY+CBBvjpnf+GoZjJrBx/bw/C3Vfnoj1bYHIZp84u9W/hMYaW7Fz
         RO+g==
X-Gm-Message-State: AHQUAuaM6G80x/HHfqABRRksESSjZ7GBTVmeaJSv5QIViqs4gQ3BMR66
        rbMZwt1YencitX4QWD6ovvDzfcS51Kdq6Q==
X-Google-Smtp-Source: AHgI3IZzeophGRa5zJWmUlL5vAAa9hVF8bOm7Ug95a45EQYoY3qqiTd7CyDjy42WcMcyYVu0o4g59w==
X-Received: by 2002:a17:902:5a5:: with SMTP id f34mr42139825plf.161.1550745924787;
        Thu, 21 Feb 2019 02:45:24 -0800 (PST)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id y6sm35170985pfd.104.2019.02.21.02.45.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 Feb 2019 02:45:24 -0800 (PST)
Subject: Re: [PATCH wireless-drivers-next 2/2] brcmfmac: print firmware
 reported general status errors
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20190221103325.28228-1-zajec5@gmail.com>
 <20190221103325.28228-2-zajec5@gmail.com>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <e644a5b7-c70d-056a-740e-997c931863c2@broadcom.com>
Date:   Thu, 21 Feb 2019 11:45:20 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190221103325.28228-2-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



On 2/21/2019 11:33 AM, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> Firmware may report general errors using a special message type. Add
> basic support for it by simply decoding & printing an error number.
> 
> A sample situation in which firmware reports a buf error:
> CONSOLE: 027084.733 no host response IOCTL buffer available..so fail the request
> will now produce a "Firmware reported general error: 9" on the host.

Could have meaningful message instead of a number. I can do that in 
follow up patch if you do not have the information.

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
>   .../broadcom/brcm80211/brcmfmac/msgbuf.c      | 24 +++++++++++++++++++
>   1 file changed, 24 insertions(+)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
> index d711dc8ed606..d3780eae7f19 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
> @@ -134,6 +134,14 @@ struct msgbuf_completion_hdr {
>   	__le16				flow_ring_id;
>   };
>   
> +/* Data struct for the MSGBUF_TYPE_GEN_STATUS */
> +struct msgbuf_gen_status {
> +	struct msgbuf_common_hdr	msg;
> +	struct msgbuf_completion_hdr	compl_hdr;
> +	__le16				write_idx;
> +	__le32				rsvd0[3];
> +};
> +
>   /* Data struct for the MSGBUF_TYPE_RING_STATUS */
>   struct msgbuf_ring_status {
>   	struct msgbuf_common_hdr	msg;
> @@ -1194,6 +1202,18 @@ brcmf_msgbuf_process_rx_complete(struct brcmf_msgbuf *msgbuf, void *buf)
>   	brcmf_netif_rx(ifp, skb);
>   }
>   
> +static void brcmf_msgbuf_process_gen_status(struct brcmf_msgbuf *msgbuf,
> +					    void *buf)
> +{
> +	struct msgbuf_gen_status *gen_status = buf;
> +	struct brcmf_pub *drvr = msgbuf->drvr;
> +	int err;
> +
> +	err = le16_to_cpu(gen_status->compl_hdr.status);
> +	if (err)
> +		bphy_err(drvr, "Firmware reported general error: %d\n", err);
> +}
> +
>   static void brcmf_msgbuf_process_ring_status(struct brcmf_msgbuf *msgbuf,
>   					     void *buf)
>   {
> @@ -1273,6 +1293,10 @@ static void brcmf_msgbuf_process_msgtype(struct brcmf_msgbuf *msgbuf, void *buf)
>   
>   	msg = (struct msgbuf_common_hdr *)buf;
>   	switch (msg->msgtype) {
> +	case MSGBUF_TYPE_GEN_STATUS:
> +		brcmf_dbg(MSGBUF, "MSGBUF_TYPE_GEN_STATUS\n");
> +		brcmf_msgbuf_process_gen_status(msgbuf, buf);
> +		break;
>   	case MSGBUF_TYPE_RING_STATUS:
>   		brcmf_dbg(MSGBUF, "MSGBUF_TYPE_RING_STATUS\n");
>   		brcmf_msgbuf_process_ring_status(msgbuf, buf);
> 
