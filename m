Return-Path: <SRS0=BviI=RB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E20DAC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 07:27:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3FAE213A2
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 07:27:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O4QuLL8M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbfBZH1h (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Feb 2019 02:27:37 -0500
Received: from mail-yb1-f193.google.com ([209.85.219.193]:43179 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbfBZH1h (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Feb 2019 02:27:37 -0500
Received: by mail-yb1-f193.google.com with SMTP id e200so3155742ybc.10;
        Mon, 25 Feb 2019 23:27:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=qBlMH40Plgz63l2W1u/VtjZ/wAgnZUhuK9hJGySITk8=;
        b=O4QuLL8MOOV6dqJy4hyrqGc0ppnClbFJnNtMg+L3X9isygnGWHeHCDc4tiYpU5dXhG
         +eVBm/CbVKprG3woY26ivEKE5RBNN2Xc5cD//dIb6H5O3yCeO52cSZeQYYwGefxCOsgb
         7Anu6VPTJGVfkHD6srbosmLFzVl02C3LDkdjMiuvSi+POh9l5HObPdngYGKvO4VEMiao
         KRYWMFOSTY/AmHZz6mIBRwp2UL+QHOocrmaobMufPAVJ1/Tha4/elhTDR1ZPM3aqOXJD
         N2YDf3eVtmyeZ8XzNRnaKHFXGvlGjW7mEKGuSlqR6qJtxrjKSiKJTyTWAj58przL3kiQ
         yZsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=qBlMH40Plgz63l2W1u/VtjZ/wAgnZUhuK9hJGySITk8=;
        b=JLMWptlqkOLDbCVmv8lj2vhZynxmz/gPJVl/FKzZ+GmOysh2orY+0czB0hHsV0nOvN
         KYrKhFXmVF4dR39gsKVH394iQTtldSb3+DIXG8FiQW4vjw1N74sx0XaI6Y3DJKyOkM7T
         GqbngkEXOEs/VZOIMiAUOPa7zOLY+R6fpMb+lp1HqtgqhcErbG6rzgVexFpS5dck2TKU
         JUqKs+s1nifVsG+tUktFIa31dPhQN7SlYb56qGMLczAVQsJTnDNykBSFprvk/3DY6PU+
         YzHkvtbBQNcLOdThLHinIpaee3QNo32EWSv/HZJsp8TbLD9QF70OE6IfIPSGmcjqJs+h
         HiOQ==
X-Gm-Message-State: AHQUAubeEb7UGIhz23VNcEzIEh+qBXyha7y0zciLyCuU4w1E5MwsG7Rq
        P7Yc6d7ATtZNTUNOC1SFXV0=
X-Google-Smtp-Source: AHgI3IaK43gl0bTQh49f1csjh6JSoDeeyZk1aM/1zIHXzyyByZg9s9+2dfgWp7ufxTYrXEpL3881TA==
X-Received: by 2002:a25:8542:: with SMTP id f2mr3680052ybn.52.1551166056183;
        Mon, 25 Feb 2019 23:27:36 -0800 (PST)
Received: from yubo-2 ([191.101.9.198])
        by smtp.gmail.com with ESMTPSA id r31sm5921675ywa.0.2019.02.25.23.27.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 25 Feb 2019 23:27:36 -0800 (PST)
Date:   Tue, 26 Feb 2019 02:27:34 -0500
From:   YU Bo <tsu.yubo@gmail.com>
To:     Ajay.Kathat@microchip.com
Cc:     Adham.Abozaeid@microchip.com, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, yuzibode@126.com
Subject: Re: [PATCH] staging: wilc1000: Fix incorrent type in assignment
Message-ID: <20190226072733.vdxcqmwglz3kxd72@yubo-2>
Mail-Followup-To: Ajay.Kathat@microchip.com, Adham.Abozaeid@microchip.com,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        yuzibode@126.com
References: <20190226032825.26171-1-tsu.yubo@gmail.com>
 <d71296ff-1de3-3af7-7ade-02e4ced08e7e@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
In-Reply-To: <d71296ff-1de3-3af7-7ade-02e4ced08e7e@microchip.com>
User-Agent: NeoMutt/20180512-62-03f98a
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Feb 26, 2019 at 06:39:28AM +0000, Ajay.Kathat@microchip.com wrote:
>
>
>On 2/26/2019 8:58 AM, Bo YU wrote:
>> The patch fixes following sparse warning:
>>
>> drivers/staging/wilc1000/host_interface.c:450:30: warning: incorrect type in assignment (different base types)
>> drivers/staging/wilc1000/host_interface.c:450:30:    expected restricted __le16 [usertype] beacon_period
>> drivers/staging/wilc1000/host_interface.c:450:30:    got unsigned short [usertype] beacon_interval
>> drivers/staging/wilc1000/host_interface.c:451:25: warning: incorrect type in assignment (different base types)
>> drivers/staging/wilc1000/host_interface.c:451:25:    expected restricted __le16 [usertype] cap_info
>> drivers/staging/wilc1000/host_interface.c:451:25:    got unsigned short [usertype] capability
>>
>> Signed-off-by: Bo YU <tsu.yubo@gmail.com>
>> ---
>> I have no hardware to test it and just to compile it
>
>Thanks for submitting the patch.
>
>The correct way to fix above spare warning is by using cpu_to_le16()
>while filing the information in ->beacon_period and ->cap_info because
>wilc1000 module expects the data in _le_ byte order.
>
>Please changes the below lines in host_interface.c and resubmit the patch.
>	param->beacon_period = bss->beacon_interval;
>	param->cap_info = bss->capability;
>to
>	param->beacon_period = cpu_to_le16(bss->beacon_interval);
>	param->cap_info = cpu_to_le16(bss->capability);
Ok, done, thank you,
Bo
>
>> ---
>>  drivers/staging/wilc1000/host_interface.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
>> index 50dc2dd942f5..cdcb52aec779 100644
>> --- a/drivers/staging/wilc1000/host_interface.c
>> +++ b/drivers/staging/wilc1000/host_interface.c
>> @@ -106,10 +106,10 @@ struct wilc_join_bss_param {
>>  	u8 ssid_terminator;
>>  	u8 bss_type;
>>  	u8 ch;
>> -	__le16 cap_info;
>> +	u16 cap_info;
>>  	u8 sa[ETH_ALEN];
>>  	u8 bssid[ETH_ALEN];
>> -	__le16 beacon_period;
>> +	u16 beacon_period;
>>  	u8 dtim_period;
>>  	u8 supp_rates[WILC_MAX_RATES_SUPPORTED + 1];
>>  	u8 wmm_cap;
>>
>
>Regards,
>Ajay
