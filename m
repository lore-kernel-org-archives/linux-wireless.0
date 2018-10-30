Return-Path: <SRS0=qkCK=NK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23FBEC2BC61
	for <linux-wireless@archiver.kernel.org>; Tue, 30 Oct 2018 14:53:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C432D2080A
	for <linux-wireless@archiver.kernel.org>; Tue, 30 Oct 2018 14:53:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=stalkr.net header.i=@stalkr.net header.b="Nt0Br66I"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C432D2080A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=stalkr.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbeJ3XrP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 30 Oct 2018 19:47:15 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:46645 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbeJ3XrP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Oct 2018 19:47:15 -0400
Received: by mail-ed1-f66.google.com with SMTP id v18-v6so10725146edq.13
        for <linux-wireless@vger.kernel.org>; Tue, 30 Oct 2018 07:53:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=stalkr.net; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=jYKOFWqNhmGfWNSf54p2Y9wC7QSDLfLfvF9UXpQ8Y8w=;
        b=Nt0Br66IhFQ6ArCvZiX+rAAm3IVcLDldE/iMG9MrQWZYibgowlpnpZv6hMFK9wd0EO
         EqEOLZuI1cd75d4q0sC5+5qpQmgWqV+O6tauD6psZnyv9vt7kGvaPAjzaYfLkFAsKi3l
         pHGKgLV78MG6jZQq1BpBGvMWBdZw0xIqXvE9RGYgH/7mrvQ+N6RzdXKfi9NsIzmOlFOJ
         SlVH8/Xkii8nT7XpY46eO5y10EnjRIZVXkkyGJpbCXNRhNs2igrmXjiBKFtrLoBogNyp
         uQh+cHFxPNFbuAL8n2SkYOXlMcHBA+znQFHNNMbe493Ub7/iqObkRL6S4cMINMhkHUYI
         JgCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=jYKOFWqNhmGfWNSf54p2Y9wC7QSDLfLfvF9UXpQ8Y8w=;
        b=e2HtFA11eMpyPIeoOFT4nT7Q3ZI4v/cKCfHEdZI19mgJnQ7OrDlrJsVpcwKOanKHUD
         88jaPtF89LUymVyySa2NJdi66eTiKf1mHkrVIvdPBCOM3c5ZVewo/+dXNRsj3+9hzFai
         DoHTe23PWetV8DNf0HXZYEhtRX0z8LhSxmZOCrVq+dbJbC3Rskrhm0DskeStZfL6v95d
         NooCKW9AAf++36ohAb6beLF1F0suc+c35HHAe6iFq3NI4vv3JaJclsugqcbRq0cSeKHx
         5xl2GDhdVH1nnIesTwMh7AL4lK60X4RWvgRuv7c+29Z/dFgxb7jnPgOQPncaaHxB9edp
         LJNw==
X-Gm-Message-State: AGRZ1gJ51Rl2kVe7G86Qcj4R/2hRoVxnaTvlZHTeV1VUAihUAEw2ovjH
        +NGEEVLKVLFzAP9g2Gbt+D/AQ+fE7mM=
X-Google-Smtp-Source: AJdET5f+X4vTsNIiOJOHOaWX2iOn7GfPCqI+ZQAW7r+d/aEaDuY9gwrxMFHywB9Ey8IXMKofL1FMWQ==
X-Received: by 2002:a05:6402:184b:: with SMTP id v11mr125318edy.147.1540911205978;
        Tue, 30 Oct 2018 07:53:25 -0700 (PDT)
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com. [209.85.221.54])
        by smtp.googlemail.com with ESMTPSA id h6-v6sm1122425ejj.54.2018.10.30.07.53.24
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Oct 2018 07:53:25 -0700 (PDT)
Received: by mail-wr1-f54.google.com with SMTP id x12-v6so12927747wrw.8
        for <linux-wireless@vger.kernel.org>; Tue, 30 Oct 2018 07:53:24 -0700 (PDT)
X-Received: by 2002:adf:eb02:: with SMTP id s2-v6mr19922377wrn.201.1540911204430;
 Tue, 30 Oct 2018 07:53:24 -0700 (PDT)
MIME-Version: 1.0
From:   StalkR <stalkr@stalkr.net>
Date:   Tue, 30 Oct 2018 14:53:12 +0000
X-Gmail-Original-Message-ID: <CAK_XK8Q2Rd2jrsQwcRUEwTxdBwsOgbNySTWXmAznWexxSAuf0w@mail.gmail.com>
Message-ID: <CAK_XK8Q2Rd2jrsQwcRUEwTxdBwsOgbNySTWXmAznWexxSAuf0w@mail.gmail.com>
Subject: rtl8xxxu: success with usb TL-WN725N
To:     Jes.Sorensen@gmail.com
Cc:     linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello,

I have a TP-Link TL-WN725N 802.11n USB WiFi dongle, lsusb identifies
it as ID 0bda:8176 Realtek Semiconductor Corp. RTL8188CUS 802.11n WLAN
Adapter.
It didn't work well with rtl8192cu (power management issue causing
deauth after inactivity), https://github.com/pvaret/rtl8192cu-fixes
made it work but it's deprecated.
I tried rtl8xxxu, initially it didn't work (nothing happened) until I
found out CONFIG_RTL8XXXU_UNTESTED wasn't enabled on my kernel, so I
enabled it and recompiled.
Per the note at
https://elixir.bootlin.com/linux/latest/source/drivers/net/wireless/realtek/rtl8xxxu/Kconfig
I am reporting that it works well so far.
I'm currently using it on armel (SheevaPlug) with Debian stretch
kernel 4.9.0-8-marvell (4.9.110-3+deb9u6) and config modified to
enable CONFIG_RTL8XXXU_UNTESTED. I haven't tested with a more recent
version or vanilla but I can if you're interested.

Thanks for the work on this new driver!
