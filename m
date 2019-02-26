Return-Path: <SRS0=BviI=RB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5642DC10F0B
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 13:11:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 27A8421841
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 13:11:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cWrFseDW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727465AbfBZNLw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Feb 2019 08:11:52 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:45281 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726908AbfBZNLv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Feb 2019 08:11:51 -0500
Received: by mail-lj1-f195.google.com with SMTP id d24so10430339ljc.12
        for <linux-wireless@vger.kernel.org>; Tue, 26 Feb 2019 05:11:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hVm3wogQM2Z2xpUildeCjXSxgthvr2hgr9u40pT4C5U=;
        b=cWrFseDWldp5QGft68HbIvo+vJPFfep40pKCIK7HE1WXpetWbfJgcPWsSV9LxEJgRg
         XtsGhYpJwyn27VH8c0oGPGULV6lIxYEXG2O5OZFM24VvlcT90HNh+Cucc2Onm2YlWGvy
         lLkwjx9BSov0UkakaQbkHwrCxd0Fs7MCbb/650YA19FnWqvf2Jzl60gDPK7Cdf0QlUfc
         50XDU7fHpqcnp/xYTtBwFtKbltWDx6mWCebyL3OHjP7y40RWFtIY/Xl3uIGri69WMWPc
         FitCjXYnN9+wh/uFkN8zE41ZYbhs0LzgdePJPZg7FjqtR6zgLqfrrBiWnDGJSpsAjAOS
         34Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hVm3wogQM2Z2xpUildeCjXSxgthvr2hgr9u40pT4C5U=;
        b=DRwP9iQLPUMolmGe5TBhMJZlxpHQK5/ERdXs+qqBTRrf+PFa+r8JuZKcfRXctbeEdq
         kDnbO2uzPd854+CeI9xpCtP45ej9C7Kh8IbKapeNwWIqkStQ30ZmROICjmkrEgZGpKzu
         8iaSQR0FoFncC7lLq1y3nl8/V1DkT56kZ5WAoq/dy9NJu3fe6Ll9LCTsIMNHlYdV3GHI
         NFF5z+XSlqDx+2uQpekQlHuYhOAstWBka+iyXF7VSrxi0HjaEE4VOZ5BQjJ8FkM0Q9HS
         iaVy5zS/H1I13owxnbshyVplsG6wmal6Gt6a3H6z7Tecwyb7kFP1roR0ewEDaqrJP6YN
         zSdA==
X-Gm-Message-State: AHQUAuZFVSUSpACG9o2FGW0/bz6lzha91TzRYt9fQKQmXWT1N2G/M8VK
        D3P+eCoh1gJshIO4K5JAoW8=
X-Google-Smtp-Source: AHgI3IbYZfySk/6lG3Hl/G3EGyqWJruoabWOCISA+4hVqu/TwUxQ7+rz8AzZivU5htBHvdlwn66STg==
X-Received: by 2002:a2e:92ce:: with SMTP id k14-v6mr13501699ljh.154.1551186708900;
        Tue, 26 Feb 2019 05:11:48 -0800 (PST)
Received: from elitebook.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id f16-v6sm2952518lji.88.2019.02.26.05.11.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Feb 2019 05:11:48 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH 0/4] brcmfmac: recover PCIe devices from firmware crashes
Date:   Tue, 26 Feb 2019 14:11:15 +0100
Message-Id: <20190226131119.7907-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

So far PCIe firmware halts / crashes were resulting in massive timeouts
and running out of resources (e.g. slots). There wasn't even a clear
message indicating the problem source.

This patches improves it by:
1) Printing an error
2) Reloading a firmware

After that user can setup interface(s) & use a wireless card again. It
should be much more convenient than reloading a module manually thanks
to:
1) Automation
2) Not affecting other (working) wireless cards

Rafał Miłecki (4):
  brcmfmac: support multiple brcmf_fw_alloc_request() calls
  brcmfmac: get RAM info right before downloading PCIe firmware
  brcmfmac: add function designated for handling firmware failures
  brcmfmac: reset PCIe bus on firmware crash

 .../broadcom/brcm80211/brcmfmac/bus.h         | 12 ++++++
 .../broadcom/brcm80211/brcmfmac/chip.c        |  6 ++-
 .../broadcom/brcm80211/brcmfmac/chip.h        |  1 +
 .../broadcom/brcm80211/brcmfmac/core.c        | 22 ++++++++++
 .../broadcom/brcm80211/brcmfmac/core.h        |  2 +
 .../broadcom/brcm80211/brcmfmac/firmware.c    |  1 +
 .../broadcom/brcm80211/brcmfmac/pcie.c        | 43 ++++++++++++++++++-
 .../broadcom/brcm80211/brcmfmac/sdio.c        |  4 +-
 8 files changed, 86 insertions(+), 5 deletions(-)

-- 
2.20.1

