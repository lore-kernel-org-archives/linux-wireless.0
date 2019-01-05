Return-Path: <SRS0=nI2m=PN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D139C43387
	for <linux-wireless@archiver.kernel.org>; Sat,  5 Jan 2019 16:02:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C4EF20868
	for <linux-wireless@archiver.kernel.org>; Sat,  5 Jan 2019 16:02:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WKTDZLzS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726279AbfAEQC1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 5 Jan 2019 11:02:27 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:39645 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726249AbfAEQC1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 Jan 2019 11:02:27 -0500
Received: by mail-oi1-f195.google.com with SMTP id i6so32680235oia.6;
        Sat, 05 Jan 2019 08:02:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8gau+ZTyFfmhuEvQgtmN7kJRLZQIRssOJ6EMgyNoPjI=;
        b=WKTDZLzSnI5lwfxuxfabhGk6NQwX1xVi0CUQDE2Ujczfz8h4GOnzBK24T3cCJfS8QO
         Yxhnsb0YFX72gP+LdYyFUx+zfAKuyOR5zyRD2yi8ld9GbdRwWvXMNA8iICX9Wynn+ibf
         nqRXltUXdDazVqNnLuDQVpsKzbXm2dN6haBf/edWVUNkwkXysnCGCvdwBug+4l9xovcy
         1o4Jac7sWePZNDpvNd0zzxuh+QTGwPRRoxPESE3P0eO7Epa0LfDv1UZBNeqi+TUBXj6s
         66aoCbuvCGPhItT1lQbRnwdou8y1jkw4vAITNCtlHP43wRIrWSwQ+wquuhegRtOzLtlJ
         QwFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8gau+ZTyFfmhuEvQgtmN7kJRLZQIRssOJ6EMgyNoPjI=;
        b=fuY1Ya3r4fEF3bSlDxsBVWLXR/3jMBDmLXj2K4avFiZhPLspMNL9V5o+xa7NbFA39S
         EsgF3vQMSEpGqN9bw5ey6muvf6VT3Nwrfogy8WlJQbDrA+TRXFoTXT7HBmzhM86+fvEp
         lyiw02+/ZsEHAvoklitmhaoKIWG+a4mVfgjiilFVRSvb9EI1OhL+YbQCb2UGS38EAnpT
         uJV0yvXAbgcWaSBalrfO8xD1mYrBo51jxK/GG7oBMRnJy6TWqjtBPuFDOab95Ye0/+WR
         SvOq2xbXADjGYOpSeoYzbfkIUX+s8OrzVn/GevI4bIkX2fS6KeQ6dAqkTn/WwZZF3l2X
         eomQ==
X-Gm-Message-State: AJcUukesq5gVVIm+hy7BD+OXaIfNNPrUhH/9VmLlxH+QTEj+FCRZeFn1
        eXHoxa+cMG57PR/PWJVQbHk=
X-Google-Smtp-Source: ALg8bN59LKy+c2RC4RQ0EWyPFT6NAL/M7K9y27AIZ6rvIX6fBdTyIzT7pJ6LH5S5GVjW0438ayXGjw==
X-Received: by 2002:aca:2dc8:: with SMTP id t191mr3608262oit.235.1546704145501;
        Sat, 05 Jan 2019 08:02:25 -0800 (PST)
Received: from [192.168.1.102] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id e6sm29184569otp.68.2019.01.05.08.02.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 05 Jan 2019 08:02:24 -0800 (PST)
Subject: Re: [PATCH v2] staging: wilc1000: fix cast to restricted __le32
To:     =?UTF-8?Q?J=c3=balius_Milan?= <jmilan.dev@gmail.com>,
        linux-kernel@vger.kernel.org
Cc:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        gregkh@linuxfoundation.org, ajay.kathat@microchip.com,
        adham.abozaeid@microchip.com
References: <20190105091025.GA28917@localhost.localdomain>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <61a272a5-3c6f-4e69-2ce9-b7c58b427750@lwfinger.net>
Date:   Sat, 5 Jan 2019 10:02:23 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <20190105091025.GA28917@localhost.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 1/5/19 3:10 AM, Július Milan wrote:
> Fixes the following sparse warnings:
> 
> drivers/staging/wilc1000/host_interface.c:2360:30: warning:
>   incorrect type in assignment (different base types)
>      expected restricted __le32 [addressable] [assigned] [usertype] frame_type
>      got restricted __le16 [usertype] <noident>
> 
> Fixes: 147ccfd451024 ("staging: wilc1000: handle mgmt_frame_register ops from cfg82011 context")
> Signed-off-by: Július Milan <jmilan.dev@gmail.com>
> ---
>   drivers/staging/wilc1000/host_interface.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
> index 5dae6e7155d3..07c3d6293573 100644
> --- a/struct wilc_reg_frame
> +++ b/drivers/staging/wilc1000/host_interface.c
> @@ -2357,7 +2357,7 @@ void wilc_frame_register(struct wilc_vif *vif, u16 frame_type, bool reg)
>   	default:
>   		break;
>   	}
> -	reg_frame.frame_type = cpu_to_le16(frame_type);
> +	reg_frame.frame_type = cpu_to_le32(frame_type);
>   	result = wilc_send_config_pkt(vif, WILC_SET_CFG, &wid, 1,
>   				      wilc_get_vif_idx(vif));
>   	if (result)

Before you send V3, are you sure this is the correct fix? As "frame_type" is 
input as u16, it seems to me that the frame_type member of struct wilc_reg_frame 
should be __le16, not __le32.

Larry
