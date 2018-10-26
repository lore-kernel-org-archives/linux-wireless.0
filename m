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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 001BEC6786E
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Oct 2018 11:22:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E4132064A
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Oct 2018 11:22:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TJl1kY1x"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8E4132064A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727428AbeJZT73 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Oct 2018 15:59:29 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:45870 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727313AbeJZT72 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Oct 2018 15:59:28 -0400
Received: by mail-lf1-f68.google.com with SMTP id c24-v6so619218lfi.12
        for <linux-wireless@vger.kernel.org>; Fri, 26 Oct 2018 04:22:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WFXMQhrzlhNhjA2qSVeN3rBaOFul3j6zBAS8zlLOf7o=;
        b=TJl1kY1xtriO71/KmCrfYujL6X/eiIsmg9gevA5dNshE87Mwwstn8v8PX4MlqunfID
         ku4uMdyvbp33y7iJi7iCq1bAFV7Ogql3/h6gXGIFpdVfH7m2MHq62AQI832dMj2oia5r
         w/eyR2eNwYRXLa9GlPFlEJp6TK9RdgnVAbw9ZLdUxPLgRut4NJ7nzEjLes1qlipmmDJT
         adEL03DNHqAA/4+KIhSV2EkwHFACJlnYAZif6zcood/KrUBY6U+QZvUVqo/DAGPMDwXb
         J0nHemriXBPoA57jLMFckcQVPFFN9ntYLKwPeKC3y23Jo0hP2IKsPEF+leE7BPLRpGzm
         bqJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WFXMQhrzlhNhjA2qSVeN3rBaOFul3j6zBAS8zlLOf7o=;
        b=oQzNkPFF6DlPDVbVnSo5gEK125scZN1pgSVJeAvN0JhBZv3BY6/NuTXQ6W12fsVijp
         sW2WsbnNQzPUIQeBtTf7cugj5W4jK6cNDgOhf1aheLKTCTg70o0UE+vm963Yb5TyX1pZ
         YkzwAtsCNmD3x/+8falVYvcj58p6OvN9k/FB2LpfHkfqTsZGyXKn6eSC7hFRVKkM0x0b
         Y8y4vfwGpcXTVD5bAtYyML0FsGnRYc4aXZXKWieSk0r2IXfpwxWX1NOmoffKmFLx7+3n
         J6wPlARoeqL/akd61P66Lx/1Q0aTXe6yWowtWYyB9CBE64cevVS1754Uvkq2qm0q+WXw
         ybOw==
X-Gm-Message-State: AGRZ1gLa4EJzwpmxHHWE7gqubYxjuqjphvTVNDEkIe6JKsFwQ9uSttGl
        gyQIpW+S8vYUMMMrD7+T1Zk=
X-Google-Smtp-Source: AJdET5eXDiucr++TY5Zi45Dh/o7lnlsg/AtnX21xfeTlcPpwm4RfgyVRxLQMr8/l6tpDqLHYfdhTvA==
X-Received: by 2002:ac2:4299:: with SMTP id m25-v6mr1912158lfh.115.1540552964218;
        Fri, 26 Oct 2018 04:22:44 -0700 (PDT)
Received: from linux-veee.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id b123-v6sm1718207lfe.54.2018.10.26.04.22.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 26 Oct 2018 04:22:42 -0700 (PDT)
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
Subject: [PATCH] brcmutil: print invalid chanspec when WARN-ing
Date:   Fri, 26 Oct 2018 13:22:32 +0200
Message-Id: <20181026112232.22699-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.13.7
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

On one of my devices I got WARNINGs when brcmfmac tried to decode
chanspec. I couldn't tell if it was some unsupported format or just a
malformed value passed by a firmware.

Print chanspec value so it's possible to debug a possible problem.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
There is no rush with this one, it can wait for post 4.20 merge window.
---
 drivers/net/wireless/broadcom/brcm80211/brcmutil/d11.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmutil/d11.c b/drivers/net/wireless/broadcom/brcm80211/brcmutil/d11.c
index eb5db94f5745..8ac34821f1c1 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmutil/d11.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmutil/d11.c
@@ -128,7 +128,7 @@ static void brcmu_d11n_decchspec(struct brcmu_chan *ch)
 		}
 		break;
 	default:
-		WARN_ON_ONCE(1);
+		WARN_ONCE(1, "Invalid chanspec 0x%04x\n", ch->chspec);
 		break;
 	}
 
@@ -140,7 +140,7 @@ static void brcmu_d11n_decchspec(struct brcmu_chan *ch)
 		ch->band = BRCMU_CHAN_BAND_2G;
 		break;
 	default:
-		WARN_ON_ONCE(1);
+		WARN_ONCE(1, "Invalid chanspec 0x%04x\n", ch->chspec);
 		break;
 	}
 }
@@ -167,7 +167,7 @@ static void brcmu_d11ac_decchspec(struct brcmu_chan *ch)
 			ch->sb = BRCMU_CHAN_SB_U;
 			ch->control_ch_num += CH_10MHZ_APART;
 		} else {
-			WARN_ON_ONCE(1);
+			WARN_ONCE(1, "Invalid chanspec 0x%04x\n", ch->chspec);
 		}
 		break;
 	case BRCMU_CHSPEC_D11AC_BW_80:
@@ -188,7 +188,7 @@ static void brcmu_d11ac_decchspec(struct brcmu_chan *ch)
 			ch->control_ch_num += CH_30MHZ_APART;
 			break;
 		default:
-			WARN_ON_ONCE(1);
+			WARN_ONCE(1, "Invalid chanspec 0x%04x\n", ch->chspec);
 			break;
 		}
 		break;
@@ -222,13 +222,13 @@ static void brcmu_d11ac_decchspec(struct brcmu_chan *ch)
 			ch->control_ch_num += CH_70MHZ_APART;
 			break;
 		default:
-			WARN_ON_ONCE(1);
+			WARN_ONCE(1, "Invalid chanspec 0x%04x\n", ch->chspec);
 			break;
 		}
 		break;
 	case BRCMU_CHSPEC_D11AC_BW_8080:
 	default:
-		WARN_ON_ONCE(1);
+		WARN_ONCE(1, "Invalid chanspec 0x%04x\n", ch->chspec);
 		break;
 	}
 
@@ -240,7 +240,7 @@ static void brcmu_d11ac_decchspec(struct brcmu_chan *ch)
 		ch->band = BRCMU_CHAN_BAND_2G;
 		break;
 	default:
-		WARN_ON_ONCE(1);
+		WARN_ONCE(1, "Invalid chanspec 0x%04x\n", ch->chspec);
 		break;
 	}
 }
-- 
2.13.7

