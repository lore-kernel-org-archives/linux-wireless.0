Return-Path: <SRS0=0pM2=P6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25252C282C3
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 15:46:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9A3F20844
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 15:46:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uXWj6cPo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729233AbfAVPqY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Jan 2019 10:46:24 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:35546 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728664AbfAVPqY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Jan 2019 10:46:24 -0500
Received: by mail-oi1-f196.google.com with SMTP id v6so17769472oif.2;
        Tue, 22 Jan 2019 07:46:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cLccPGY/Ci26NxYg4k35YsBSS0Px+Hs6AZRkSeDGRCE=;
        b=uXWj6cPodKICiXar8mLcSOlDIzc1bhWAKPghdgh7+UDjsmGt9MBBdXItVKA8rXZPAU
         jF1sDqKlOnBfhpiZOANXBu0+FRHAb1M5L6epiiPUhUua6DPFuBrNVIJAQc9Ch7suG6dU
         o5CRNei8WE1KD2yj7ElUj7VrRyK2oc9an1dfuZEghl9md9brC8rh60KNqtReWBkUl4BU
         WZqKEzXTjsVuD4t/ETllsWqtLRNV2qcTTNXosn341vU0tarej2tkMmR+wKQHdOOLFL/a
         bwImr2WQXJR2ut9j/3kO1VQ2DwPUEhjoENASBBMB15vNVDP6dA5L560rvxtqzaeHBYeH
         8Sqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cLccPGY/Ci26NxYg4k35YsBSS0Px+Hs6AZRkSeDGRCE=;
        b=M9noeKDntm8dAq/b76gRcleySTL2uF2GeuYa4qiMma9PtLolqHPvYzAQjojv0KCy0j
         HwSxsJs5T6QtXpxBTYvkkwmnlC7ZxoZvC/jDjvNYgA90jXVi2RF+Ar4qY3xk7kVDCZMC
         3DK9uIx9NbJb8nf0fBbGfpCirwaxf/b4lhPi13ZG9B4mjeRylZDFlIz8oLgIv0Zficj6
         eMB+2BMH7R18IyA9fGnprva07WOKhm1Ff1GrOBwY+DGwmvuzuOTqC6PADSDelDNQ9yEs
         H6vJOrp0J9GCqOZ4GT9TzBioEg3vVA/c5gNEa7uu19/Rr6agkicFp91QY4oPjGGhP4uK
         lFmQ==
X-Gm-Message-State: AJcUukcaadqY3Ym6/l33rRK39JWPSQXpqjOpVpEZjCbEh7Lct67QWX7W
        ks2GDe8beCrQDmRoE5Pk0Wc=
X-Google-Smtp-Source: ALg8bN6vaU4T5gLcDfWPr41gSXX39CBbzQqyRAgA7zWzVHvHqpxeC+ByV6MlV3NL+KKHqofuNT35vQ==
X-Received: by 2002:aca:cd87:: with SMTP id d129mr8859844oig.120.1548171983524;
        Tue, 22 Jan 2019 07:46:23 -0800 (PST)
Received: from [192.168.1.112] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id q13sm6921570ota.14.2019.01.22.07.46.22
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Jan 2019 07:46:23 -0800 (PST)
Subject: Re: [PATCH] b43: no need to check return value of debugfs_create
 functions
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        Kalle Valo <kvalo@codeaurora.org>
References: <20190122152151.16139-30-gregkh@linuxfoundation.org>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <6dd3973e-4dcc-cdc1-bb55-e17faa213f2d@lwfinger.net>
Date:   Tue, 22 Jan 2019 09:46:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190122152151.16139-30-gregkh@linuxfoundation.org>
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
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: linux-wireless@vger.kernel.org
> Cc: b43-dev@lists.infradead.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks,

Larry

