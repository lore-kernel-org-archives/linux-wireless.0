Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BB65C433FE
	for <linux-wireless@archiver.kernel.org>; Sun, 20 Nov 2022 19:28:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbiKTT22 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 20 Nov 2022 14:28:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiKTT21 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 20 Nov 2022 14:28:27 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C2762018B
        for <linux-wireless@vger.kernel.org>; Sun, 20 Nov 2022 11:28:26 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id h132so10690701oif.2
        for <linux-wireless@vger.kernel.org>; Sun, 20 Nov 2022 11:28:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:sender:from:to:cc:subject
         :date:message-id:reply-to;
        bh=JFNf0xkafzndvLDoLiOxkKJorG86toYqjYyxxTRVAog=;
        b=bcsIF24kCcD9g52JZnbuwA6UXlSCPbD6xYg71H7GjW/6kk3YrA36XvyRVbeQzuNZlI
         /Yukf91v09FB1VySVEMC/mLAEnSMSHFNY+/ZVxHtZsUAAydZRhIk53VTq2fTCgKFC2MN
         ehWP3sxbnfdj6LDypeDZ6+ax0mm5AjrF4wbjWut7MHNgns1NaoY8kTVW3tfcqTuC1ToU
         SrZIv7PiChOVpH65DNv5Qgh1sQ4eqOEUv1NzXVpUBmncSDIDmDld4UBwfKvUaedR6twj
         HDQjbwNgNr/UAMzaQgqekVh7+0J/MUbn29I0FBw7rTSC4NWLV7Hvs77zzDlLeyxL3r+R
         xC6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:sender:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JFNf0xkafzndvLDoLiOxkKJorG86toYqjYyxxTRVAog=;
        b=QXOuxrZQOPolDVhbl57pI6o7xkBOyNbV3qws/3WSzZwOKur6avJ/leOocJ+fknQWzW
         bsp4MGWZg6jzNtx93twG9167m8+B7Ay4aNnkvQxbFVORDFZCeBeiF707Ae0qo3FSO5X1
         8mOESLTlY+5fYPVwpv5FqLGTUkU02f7MGgKqz49dbVjus20oDTauSBmffEwznN2gKHC/
         U5dPSXvQMEi+zc+9i0T1KVR9BUFENbnTNkTltpOzS+3VqFI9doaxRBpbkERcsVYYqT+q
         c6OEgdmP7RniURoJ05wmxdMGNXIkEWLtrDXOtfa9yRMDKCkdtaH90nvey1OKut3tndEu
         m6GQ==
X-Gm-Message-State: ANoB5pkBo4K2jcdv1mceFFbp5IHjoRq8OUbfGgMpgvUoX8LFHi8W6Xvr
        vYOQ/76eE/jj/DQfB9Abv74=
X-Google-Smtp-Source: AA0mqf5lN4SCSiKvjxG9coFiJCOPoYrFpwXRUtuGgQ9F2lZ46GMGx4oiJNlD1atEOWPuZ/ToIt9xCg==
X-Received: by 2002:a05:6808:8c9:b0:351:1a63:a74c with SMTP id k9-20020a05680808c900b003511a63a74cmr7367448oij.288.1668972505710;
        Sun, 20 Nov 2022 11:28:25 -0800 (PST)
Received: from [192.168.1.119] ([216.130.59.33])
        by smtp.gmail.com with ESMTPSA id a23-20020aca1a17000000b00359a9663053sm3535840oia.4.2022.11.20.11.28.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Nov 2022 11:28:25 -0800 (PST)
Sender: Larry Finger <larry.finger@gmail.com>
Message-ID: <3fdb4dd8-b3c9-6f3c-37e6-a9d5712d6c73@lwfinger.net>
Date:   Sun, 20 Nov 2022 13:28:24 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Content-Language: en-US
To:     Kalle Valo <kvalo@codeaurora.org>, Pkshih <pkshih@realtek.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Subject: Missing commit
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Kalle,

I was answering a query regarding the driver for RTW8852BE, and happened to 
check the configuration for 6.1-rc and discovered that the appropriate Kconfig 
and Makefile are missing the following:

commit b5db4ef38e21dd9b6b95ae96cea5032b00e04f24
Author: Ping-Ke Shih <pkshih@realtek.com>
Date:   Fri Oct 14 14:02:37 2022 +0800

     wifi: rtw89: 8852b: add 8852be to Makefile and Kconfig

I expected that this one would have been sent upstream to mainline by now. Is my 
expectation wrong, or is the commit missing?

Larry
