Return-Path: <SRS0=7+pU=3S=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BC84C2D0DB
	for <linux-wireless@archiver.kernel.org>; Wed, 29 Jan 2020 18:40:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 335482071E
	for <linux-wireless@archiver.kernel.org>; Wed, 29 Jan 2020 18:40:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H74ENqB1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727512AbgA2SkF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 29 Jan 2020 13:40:05 -0500
Received: from mail-qt1-f177.google.com ([209.85.160.177]:33331 "EHLO
        mail-qt1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726332AbgA2SkF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Jan 2020 13:40:05 -0500
Received: by mail-qt1-f177.google.com with SMTP id d5so319014qto.0
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jan 2020 10:40:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:date:mime-version
         :content-transfer-encoding;
        bh=edDbto1ayWJTc7kkFco+GN3h20aSoy5f31PU1XYRnl8=;
        b=H74ENqB1d0MpbPoFJrusHJYZfaAypd+fE6rB6R4o38hbL5OSErOD+DLEjiG5HaLhHW
         ftHbZMmxPMSbpVEJ8JgrYOjHDP1/Wxq5I4Eemslw8D6FGoSNXDHv9VAHI0kR19Pw2FaF
         AgBq2QBhwhnUcypvfY49uIkv/vGhQNIbHThXKhfMZNafk0hJ1JbLa5qroTsVj6pD8GTZ
         kvwOr6WSfH4GTxRELPu7xsu7S9SaDqAC9CB3T6clOOY2BBKxnThGIYCSu/cN1EqSeeCX
         unE5f7eEVnvOdpvKH9WYonjt93AMo7scAFWvi5y2MQqKnOGkRMNR7cqMNlJwHd5B+qNu
         43MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:mime-version
         :content-transfer-encoding;
        bh=edDbto1ayWJTc7kkFco+GN3h20aSoy5f31PU1XYRnl8=;
        b=CcGvWxCuVZSjfHM5up9ZQOLO5QfjKe7fLZlfujohUMsqEaXCaRtr6v7JJ2la4rRbvg
         +CyygFJ/Ixqw1NszXOoJdT/smv3ZGlIWOP4CwCpRxoQ15hvwR5WRqTnBs9D2LycJWEv5
         W/Nc8JZhIQ13xtLCpCkAnYmquWE6OBV/LiesePrzPMuBaQqLX8e2bcYD3/78BHQ81ROz
         28mmD6tWXHQaz/UGc2E2yh9IYJwzrrDSIzhMJ5Q5c2E28qMcBXfmuACNNe7LlpfFbm7G
         Leun7AqpWOiuzzOKXtMxdb7mJ2HAUKFa8ws9i/vxfEjSexjJcS62y0z8sPvtgCKuYpmh
         l8Vg==
X-Gm-Message-State: APjAAAXFCVrhwrsyMBpEgFj7V5undRDkqiKFsUxkc2KTDUqAhvutX5S5
        N3vmEQ8AtVjnc1qh6i9++00NUBJE
X-Google-Smtp-Source: APXvYqxzurb/DkcwamAbS4cisE08RBAT6nsSE3F9kGcbuai3KusQcJ5CjyLyKOuo+Mcu5e2fKVvz9Q==
X-Received: by 2002:ac8:6f04:: with SMTP id g4mr596577qtv.314.1580323203534;
        Wed, 29 Jan 2020 10:40:03 -0800 (PST)
Received: from [192.168.0.10] (dhcp-108-168-58-21.cable.user.start.ca. [108.168.58.21])
        by smtp.gmail.com with ESMTPSA id z1sm1433199qtq.69.2020.01.29.10.40.02
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 Jan 2020 10:40:02 -0800 (PST)
Message-ID: <1580323191.26012.48.camel@gmail.com>
Subject: Strange performance issue when using two devices at once
From:   Marlon Smith <marlon.smith10@gmail.com>
To:     linux-wireless@vger.kernel.org
Date:   Wed, 29 Jan 2020 13:39:51 -0500
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.18.5.2-0ubuntu3.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi everyone,

I have two RT5370 devices connected to the same access point. Both
devices are very slow, but the instant I disconnect one device, the
other speeds up by a factor of 10.

The really strange part is that one device will perform slowly even if
the other device is basically idle! I've confirmed this with a packet
sniffer.

I've been trying to do some debugging, and I've found that when both
devices are connected to the access point, they report a large number
of duplicate frames. I added some debug output
in ieee80211_rx_h_check_dup() to confirm that this only happens while
both devices are connected. The packet sniffer also shows a large
number of retries while this is occurring.

Using backports 5.3-rc4 for this, but also tested on 4.14-rc2.

I did post about this previously on this mailing list (RT5370
performance issues), but I thought I'd post again with this new
information and more descriptive title. I'm a little bit stuck on this
for a while now, so any ideas are much appreciated.

Thanks!

Marlon
