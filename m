Return-Path: <SRS0=rthY=NG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C93E4C6786E
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Oct 2018 10:50:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7514220856
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Oct 2018 10:50:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UkcyCARE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7514220856
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbeJZT1c (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Oct 2018 15:27:32 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:45508 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726493AbeJZT1c (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Oct 2018 15:27:32 -0400
Received: by mail-lf1-f65.google.com with SMTP id c24-v6so553056lfi.12
        for <linux-wireless@vger.kernel.org>; Fri, 26 Oct 2018 03:50:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/GjCSHamKbLjb9IMQiHvjhXSCoApCnDXPL5a+jzN1vY=;
        b=UkcyCARESVXBCkNrduS2lp8mezUvOVSNek2vTntjbSQl5T/qhkS6DGsNIST4ZKGJF8
         Rzb2m3smFqEp6Z3zyjHIQvsXfJbScVBIzmnwrFd4MlgO0NERcZwnqcE0tKDdo4XhPaKY
         IBK6ytUI1+j+9iDcRwtS/+pQGh2INTMrJx3WZZf8kmUmnd0nPxnkz6OJn1z1o3ZAWbmb
         H99iuRKo47EIKwZTQdS/Q1KoESzEgs62jXZmWmRyYDjDtweJGnIRAp9yKhT2QfU3iZ2P
         nOybPr5n78TUT9Uo9gJhc+HdDY0Iod1+VulRAonzTqvNtbKjDcel8l7fOTIWhY8Ax27V
         mdLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/GjCSHamKbLjb9IMQiHvjhXSCoApCnDXPL5a+jzN1vY=;
        b=rpG51mwB/WM/YP6wlSFh4JSfcFI/fuDTDNWtJ+wdXP1dlUGhS7gNy98RMsUb+vg3s3
         LIDzvj+GxeBKSGUOyQwTqpviMmFQ0ISbeH0PsehN+NFH29coCUcu7IMp+Adxx9H92ecq
         JM9zkdY6zDCz9dMzgfi/8y+I1JqjZoTz30BbrguN60Q53Ojl4+Ns4YlmKYDLhM5yXbaa
         s6RoxBZJCYHTfnQfHV3fVecxogH/gM8E/PlHVshIpmwzgabyz+OJ7vyvRXeVQcApJcr1
         P9A7TuQgwDfj3sGl+MSeFlkybj8L1WxLJ438bTmDTbPV63ir5NqJbHgKPOQIDQMNbwnG
         zlHw==
X-Gm-Message-State: AGRZ1gIvhIeHdVFedtUDEygTZI5xuD7gpNo6+xS/WTDicegh4EErNDuZ
        zncqNAPcs+YzFPv5/STO5EQ=
X-Google-Smtp-Source: AJdET5cNrVFVqH+DQyUr7VsFyV/p62s1IVTl0rqeEuYLcHyPCanWsYOygTFD8X+rm6SGZ4iPyJOKQg==
X-Received: by 2002:a19:6719:: with SMTP id b25mr1812721lfc.38.1540551054541;
        Fri, 26 Oct 2018 03:50:54 -0700 (PDT)
Received: from linux-veee.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id t4-v6sm1551331ljj.13.2018.10.26.03.50.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 26 Oct 2018 03:50:52 -0700 (PDT)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH 4.20 FIX] brcmutil: really fix decoding channel info for 160 MHz bandwidth
Date:   Fri, 26 Oct 2018 12:50:39 +0200
Message-Id: <20181026105039.11445-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.13.7
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

Previous commit /adding/ support for 160 MHz chanspecs was incomplete.
It didn't set bandwidth info and didn't extract control channel info. As
the result it was also using uninitialized "sb" var.

This change has been tested for two chanspecs found to be reported by
some devices/firmwares:
1) 60/160 (0xee32)
   Before: chnum:50 control_ch_num:36
    After: chnum:50 control_ch_num:60
2) 120/160 (0xed72)
   Before: chnum:114 control_ch_num:100
    After: chnum:114 control_ch_num:120

Fixes: 330994e8e8ec ("brcmfmac: fix for proper support of 160MHz bandwidth")
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 drivers/net/wireless/broadcom/brcm80211/brcmutil/d11.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmutil/d11.c b/drivers/net/wireless/broadcom/brcm80211/brcmutil/d11.c
index e7584b842dce..eb5db94f5745 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmutil/d11.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmutil/d11.c
@@ -193,6 +193,9 @@ static void brcmu_d11ac_decchspec(struct brcmu_chan *ch)
 		}
 		break;
 	case BRCMU_CHSPEC_D11AC_BW_160:
+		ch->bw = BRCMU_CHAN_BW_160;
+		ch->sb = brcmu_maskget16(ch->chspec, BRCMU_CHSPEC_D11AC_SB_MASK,
+					 BRCMU_CHSPEC_D11AC_SB_SHIFT);
 		switch (ch->sb) {
 		case BRCMU_CHAN_SB_LLL:
 			ch->control_ch_num -= CH_70MHZ_APART;
-- 
2.13.7

