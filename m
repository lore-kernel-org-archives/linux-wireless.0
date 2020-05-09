Return-Path: <SRS0=l8p9=6X=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE493C47255
	for <linux-wireless@archiver.kernel.org>; Sat,  9 May 2020 04:36:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B43724957
	for <linux-wireless@archiver.kernel.org>; Sat,  9 May 2020 04:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588998994;
	bh=T/45YfBm6OW0ecw2oj1/DwU94Ny5kbwW8UeQin60ZnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=0gW/f6kBBf2SXS6DONBWm4M0dK0PVEQFjcL/Bire0614evECAV8zoRdVah7fQlXIV
	 L93fxAW6teh36xqQqM/zPmJswDkgLUIUNmyq7kBVnesr7xdb0ppNNDg43IM/TeOOKi
	 HLskXGXymxDKAC7vTabDGU4Jvd8e2ea4G8+CdV9Y=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728880AbgEIEg2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 9 May 2020 00:36:28 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:53153 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728852AbgEIEgV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 May 2020 00:36:21 -0400
Received: by mail-pj1-f66.google.com with SMTP id a5so5222430pjh.2;
        Fri, 08 May 2020 21:36:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7qq8CjFpGo8CsnGjybDf2MvNxEFQWkR0c2M9w7bQbfM=;
        b=XwKUKBbP35FmqQ3Ugi0gHKS86zf+FQUKbBIwofqqjb6PBPikVJcfGpeYB06mEbXnib
         DQkD+dXiY024LW9+cJ6wfxlmDMY/QbUN+QC2JuPKlxd1e1J9zErHf8MEkaQP5yv+p2Rc
         qdCfaTH6I0VHMrfZhS5dL69wKYWsKJQaQSe20Tp4es88uWJJMvGBtLmcVFo76g7cYJrg
         PTJ2ddtC/lacLBX1AiGd0y3T0/OiWhedEv0E2J6R2W63lysY3tRZhxI/B+BaEFEoVAa+
         tOWNLCKu0CFKS1pgv8AQpD+NU9PRjhKHfF08hkBz4x1MWRa567Q7fcnzo0gspyg4uVZp
         90Pg==
X-Gm-Message-State: AGi0PuYUWgPOfirt2JIN3SWLNNozbJcUkuSUO2T2R8F0jqao91r+HxTb
        8Kw4Yho6E/Te/6G895b7yaE=
X-Google-Smtp-Source: APiQypLjmRNDTEznZjzA3S9166t5JFNaclA+EPQ0OH8e1pQEJSa/LM2UXqofDkr98aCEqoNdflNEOg==
X-Received: by 2002:a17:90a:d0c3:: with SMTP id y3mr9417112pjw.25.1588998980730;
        Fri, 08 May 2020 21:36:20 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id z28sm3318243pfr.3.2020.05.08.21.36.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 21:36:15 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 6A8F942341; Sat,  9 May 2020 04:36:01 +0000 (UTC)
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     jeyu@kernel.org
Cc:     akpm@linux-foundation.org, arnd@arndb.de, rostedt@goodmis.org,
        mingo@redhat.com, aquini@redhat.com, cai@lca.pw, dyoung@redhat.com,
        bhe@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        gpiccoli@canonical.com, pmladek@suse.com, tiwai@suse.de,
        schlad@suse.de, andriy.shevchenko@linux.intel.com,
        keescook@chromium.org, daniel.vetter@ffwll.ch, will@kernel.org,
        mchehab+samsung@kernel.org, kvalo@codeaurora.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Subject: [PATCH 14/15] brcm80211: use new module_firmware_crashed()
Date:   Sat,  9 May 2020 04:35:51 +0000
Message-Id: <20200509043552.8745-15-mcgrof@kernel.org>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20200509043552.8745-1-mcgrof@kernel.org>
References: <20200509043552.8745-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This makes use of the new module_firmware_crashed() to help
annotate when firmware for device drivers crash. When firmware
crashes devices can sometimes become unresponsive, and recovery
sometimes requires a driver unload / reload and in the worst cases
a reboot.

Using a taint flag allows us to annotate when this happens clearly.

Cc: linux-wireless@vger.kernel.org
Cc: brcm80211-dev-list.pdl@broadcom.com
Cc: brcm80211-dev-list@cypress.com
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Franky Lin <franky.lin@broadcom.com>
Cc: Hante Meuleman <hante.meuleman@broadcom.com>
Cc: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
Cc: Wright Feng <wright.feng@cypress.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "Rafał Miłecki" <rafal@milecki.pl>
Cc: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index c88655acc78c..d623f83568b3 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -1393,6 +1393,7 @@ void brcmf_fw_crashed(struct device *dev)
 	struct brcmf_pub *drvr = bus_if->drvr;
 
 	bphy_err(drvr, "Firmware has halted or crashed\n");
+	module_firmware_crashed();
 
 	brcmf_dev_coredump(dev);
 
-- 
2.25.1

