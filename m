Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ed1-f65.google.com ([209.85.208.65]:46024 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726647AbeIKSfF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Sep 2018 14:35:05 -0400
Received: by mail-ed1-f65.google.com with SMTP id p52-v6so19232373eda.12
        for <linux-wireless@vger.kernel.org>; Tue, 11 Sep 2018 06:35:43 -0700 (PDT)
Received: from manjaro ([37.237.210.254])
        by smtp.gmail.com with ESMTPSA id d23-v6sm4358545eds.47.2018.09.11.06.35.41
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 11 Sep 2018 06:35:42 -0700 (PDT)
Date: Tue, 11 Sep 2018 16:35:34 +0300
From: Ali MJ An-Nasrawy <alimjalnasrawy@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: brcmsmac: AP mode: network stalls frequently for power-saving
 stations
Message-ID: <20180911163534.21312d08@manjaro> (sfid-20180911_153547_050518_868C85D7)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

I have been investigating a network problem that I have when connecting
my phones to my laptop as an access point. The problem manifests as
highly variable ping latencies (1ms to several seconds from AP to
clients specifically) and frequent network stalls at random occasions
rendering it unusable for certain applications.

After investigation, I have found that it was due to incomplete
implementation of AP mode for brcmsmac regarding power management:
1. TIM is not updated for beacons as needed and, thus, power-saving
stations have no way to know about buffered traffic for them until they
wake up for different reason.
2. Transmission of broadcast packets doesn't obey DTIM period: they are
transmitted at any time.

I was able to fix point 1 with probably inefficient and buggy patch
that I shall submit and have no idea regarding point 2.

Hope to see professional fixes,
Thank you.
