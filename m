Return-Path: <SRS0=0pM2=P6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64AEDC282C3
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 15:45:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35EA020844
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 15:45:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D7GFl0XG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728945AbfAVPpv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Jan 2019 10:45:51 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:43945 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728683AbfAVPpv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Jan 2019 10:45:51 -0500
Received: by mail-oi1-f195.google.com with SMTP id u18so17724999oie.10;
        Tue, 22 Jan 2019 07:45:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7AXTiJ+PI1paWxcCtGYrxQmtleuHLj1fKPHB01K/gow=;
        b=D7GFl0XGQp8AcNqsc6+0iHCU7aVrEtD3461MuJj6Lsu5p9X38pfWSxipkcBr+1wKYg
         8YXEG+Xa5r/V/zDw64DQe10DzpQfSbXX0XL6KqPzGFOZ0CB2TukH9u9BRdAVzo4ERB73
         i6jWna5hMQnHZmnYghl6DTxblmgQVGI2piQ/BnGqI1ab7KUurV4Zdj5Jlp9Zzc8UQLmp
         JxIkHGuwNwYEcjAw/woEcAR/Vjv2pnpf4aT9UmJ7YTQaKnvMqBT9T9mrOA84Fiep36Nj
         vLB3uoLaI/0Dfs3gVjbzqzHTDlkMf2WYh5oI4owhxqEx17CL7Avrlas5rsJ/vq48eMcX
         11oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7AXTiJ+PI1paWxcCtGYrxQmtleuHLj1fKPHB01K/gow=;
        b=bKCZAJ/hv5q5vjPtq5fQsGAQTIbY9OPCvYuJP1s86BDLf8pjTROxb+iVyoPSDcpWQa
         vCfjBXLtAQCalFnvVWxJH+OEHfSj5oArkWgxH94tdfDdOjp8ipVzXM/nVV9K+jIPYz/B
         4civez+xFCB8iGAgwIJAWbr9e4O1JzYSe2dMgryzkI5dOwe3fKffeM6FUm6m7VH1/wC7
         JAm0JO6CMrTO0wYtblM4PqLGqi2CgeN5luWg/r57KsYgUUt8X8SN2WP9Wd6EMRCio7QY
         PoNM/eNShM+pcRiPLcB0PK7wobzjEc+uK5EEc0BUQHT48uAYd1QfIgwB7EFqkTOR3aBH
         UUYQ==
X-Gm-Message-State: AJcUukcawgzN/WPmVvvv/W7mYPTBDGJ7Kxo1yF5rKcThGYjRbbhJ1jZa
        oQnxkMXEwtTgXGByIKvP7zs=
X-Google-Smtp-Source: ALg8bN4ZWVNntFV2nHZxnnsD6lak5rqvBPmOH5nsFDW6ulgGroR5cH9U1/u8ET5Q1T5zaCSV2SubpA==
X-Received: by 2002:aca:eb0f:: with SMTP id j15mr9007980oih.110.1548171950476;
        Tue, 22 Jan 2019 07:45:50 -0800 (PST)
Received: from [192.168.1.112] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id y2sm6675064oto.49.2019.01.22.07.45.49
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Jan 2019 07:45:50 -0800 (PST)
Subject: Re: [PATCH] b43legacy: no need to check return value of
 debugfs_create functions
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        b43-dev@lists.infradead.org
References: <20190122152151.16139-31-gregkh@linuxfoundation.org>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <451b54fb-0ef0-ce6b-71e4-39ba781b5a94@lwfinger.net>
Date:   Tue, 22 Jan 2019 09:45:49 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190122152151.16139-31-gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 1/22/19 9:21 AM, Greg Kroah-Hartman wrote:
> When calling debugfs functions, there is no need to ever check the
> return value.  The function can work or not, but the code logic should
> never do something different based on this.
> 
> Cc: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: linux-wireless@vger.kernel.org
> Cc: b43-dev@lists.infradead.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks,

Larry

