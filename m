Return-Path: <SRS0=8fZi=PT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39B19C43387
	for <linux-wireless@archiver.kernel.org>; Fri, 11 Jan 2019 15:18:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0BD6120675
	for <linux-wireless@archiver.kernel.org>; Fri, 11 Jan 2019 15:18:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731728AbfAKPSe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 11 Jan 2019 10:18:34 -0500
Received: from mail-ed1-f52.google.com ([209.85.208.52]:43805 "EHLO
        mail-ed1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730170AbfAKPSd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 Jan 2019 10:18:33 -0500
Received: by mail-ed1-f52.google.com with SMTP id f9so13340469eds.10
        for <linux-wireless@vger.kernel.org>; Fri, 11 Jan 2019 07:18:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=AbcYWFRrSZdGTd6eb6nkRC4/uj87F0h/Q1d7JPdsd4c=;
        b=lcZpbm9iHLHh23m68Fxpws94uJRtdXLaZG4PHJTuYkTciXudB2s5YFONB7yCbkJC6w
         +feXYTMlvgDJQZK8L7yv932PcaCWwin/v7Xgta3jv1jVaT6+64CyWDsWtxdNONCr/OtX
         Dk+UhvlJe1yLg2pQ49GzfJrJQVxSpwYNJuZqT25bHY9FYQ2KlTqkYwij7QNe1Q7ExuPn
         VFUqO8KY2d8kd2XnC+XBhvSBG2mgr+3jYPZ/eptHGSM45vBOYhPAvfmOtNZbeGE5Ztba
         9HtDDrnF5FSvgMImmzhIE49qRyMFihKBJwl85aZCbvRvCS7M2EvLRvF1c2ZS4mlXlZob
         xVdw==
X-Gm-Message-State: AJcUukfaFgDuuTuEkbcEPtelvkZlDFL1tx+YXw2v82+/iUlTAN0PIkWA
        lD2Fafi7BkNP/aki8sTGB+bseQ==
X-Google-Smtp-Source: ALg8bN4FFzjUkc8F60odPYF4GjSDwaMWTjznOOtK+Kbw6xyc31pwBfuJaqjg21K1wFLwQgg/wCO5ag==
X-Received: by 2002:a17:906:12d3:: with SMTP id l19-v6mr12029089ejb.74.1547219912011;
        Fri, 11 Jan 2019 07:18:32 -0800 (PST)
Received: from dhcp-44-202.space.revspace.nl ([2a01:4f8:1c0c:6c86:46e0:a7ad:5246:f04d])
        by smtp.gmail.com with ESMTPSA id c23-v6sm1520449ejb.62.2019.01.11.07.18.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 11 Jan 2019 07:18:31 -0800 (PST)
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        "Franky Lin <franky.lin@broadcom.com>Franky Lin" 
        <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        brcm80211-dev-list.pdl@broadcom.com
From:   Hans de Goede <hdegoede@redhat.com>
Subject: brcmfmac regression in 4.19 ?
Message-ID: <08b120bb-484f-4c08-30ae-bb023f484a56@redhat.com>
Date:   Fri, 11 Jan 2019 16:18:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

We (Fedora) have been getting bugreports that brcmfmac wifi drops out and needs a rmmod + modprobe
to restore functionality starting with kernel 4.19:

https://bugzilla.redhat.com/show_bug.cgi?id=1658178

Disabling powersaving reportedly helps, but leads to an oops (which might be a hint?) :

https://bugzilla.redhat.com/show_bug.cgi?id=1661768

Regards

Hans
