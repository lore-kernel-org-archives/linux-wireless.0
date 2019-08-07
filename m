Return-Path: <SRS0=5ylD=WD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7609C433FF
	for <linux-wireless@archiver.kernel.org>; Wed,  7 Aug 2019 09:33:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7ECF522305
	for <linux-wireless@archiver.kernel.org>; Wed,  7 Aug 2019 09:33:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="RGbAct+5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727642AbfHGJdT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 7 Aug 2019 05:33:19 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39920 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727541AbfHGJdT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Aug 2019 05:33:19 -0400
Received: by mail-wm1-f68.google.com with SMTP id u25so68918383wmc.4
        for <linux-wireless@vger.kernel.org>; Wed, 07 Aug 2019 02:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hHohxkD8Dy1RgfP9kbDhhtmE/Erxuj8OKDjrb7QnOBY=;
        b=RGbAct+5o7cBANnjhLkPp2NM5e+wrulhTW52fYAJ7MTJqy/ftp7cXNK4NeYHy8bKpk
         QC8a00gMBLrBIC5LV2K1v7jbFYI9T0sG2vAdZnyTGS4eZ6cvVbfMv/ZtnVTP9hHd1QWe
         xhNkHljRCIZkKCMzFzIsBcV28J1SGj+ax58+M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hHohxkD8Dy1RgfP9kbDhhtmE/Erxuj8OKDjrb7QnOBY=;
        b=cigXSJt+zKJfLUq4Muo7CIVGrg6o8v08JaZO3Zb252sA2KnHd/w8Aj/dHkxZkPGaxZ
         mnwnUc22QiuvuDmqcSBU8VrTZwfSpOga3AR0+grg7v8ZqSRyNNCXG401NlZkmvo6OtG+
         /qOiKl02G+K4naD0tdrcS9XJ7xkXewBcQY441U3BY+WlVTziqqIX3jTu3pIPcX46IxY9
         MtWbZhGJIAMEhAZWWFZaG1VqUx4fQkPLXZiatQeHUdQyw6aUjtUE6YtMDEQE11RF+TCv
         VStfV7Ty5v1G8/DYQyvVN4MPvx1Ncbh/yCUhqgTXIsv20EbLOiyaq73WzMbJrUraliGR
         xaZA==
X-Gm-Message-State: APjAAAVKy3EJXRGdxliR9hK855HcmIRnAeLTn0LZve9JEFUoYuOS+vtl
        GfzCLi2SxuwSYzQt5jtR4OD/f5WGtmrEvw==
X-Google-Smtp-Source: APXvYqzxprxntYiREvKygfjmSSiht2uspOaPBU4UCxAqyeZf6f60IKOrhGkrZlbz/ujjfbc+DDU8Lw==
X-Received: by 2002:a1c:ef0c:: with SMTP id n12mr9146389wmh.132.1565170397303;
        Wed, 07 Aug 2019 02:33:17 -0700 (PDT)
Received: from [10.176.68.244] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id e6sm91082159wrw.23.2019.08.07.02.33.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Aug 2019 02:33:16 -0700 (PDT)
Subject: Re: [PATCH v2 2/2] rtw88: RTL8822C: add WoW firmware v7.3
To:     yhchuang@realtek.com, jwboyer@kernel.org
Cc:     linux-firmware@kernel.org, linux-wireless@vger.kernel.org,
        Larry.Finger@lwfinger.net, briannorris@chromium.org
References: <1565167700-22501-1-git-send-email-yhchuang@realtek.com>
 <1565167700-22501-2-git-send-email-yhchuang@realtek.com>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <3307e4b7-c92d-e1d2-b896-26e45fb69a9b@broadcom.com>
Date:   Wed, 7 Aug 2019 11:33:15 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1565167700-22501-2-git-send-email-yhchuang@realtek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



On 8/7/2019 10:48 AM, yhchuang@realtek.com wrote:
> From: Yan-Hsuan Chuang <yhchuang@realtek.com>
> 
> Add WoW firmware to support entering Wake on WirelessLAN mode
> 
> Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
> ---
> 
> v1 -> v2
>     * update WHENCE file for new added firmware
> 
>   WHENCE                    |   1 +
>   rtw88/rtw8822c_wow_fw.bin | Bin 0 -> 138720 bytes
>   2 files changed, 1 insertion(+)
>   create mode 100755 rtw88/rtw8822c_wow_fw.bin

Just wondering: Is this a good approach? What firmware should distros 
pick? Is there a trade-off affecting other wifi functionality when using 
WoW firmware?

Regards,
Arend
