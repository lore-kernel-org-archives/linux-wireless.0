Return-Path: <SRS0=yVm+=OT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD5A1C04EB8
	for <linux-wireless@archiver.kernel.org>; Mon, 10 Dec 2018 20:56:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8BA32082F
	for <linux-wireless@archiver.kernel.org>; Mon, 10 Dec 2018 20:56:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A8BA32082F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arndb.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729781AbeLJU4L (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 10 Dec 2018 15:56:11 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:36593 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728820AbeLJU4L (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Dec 2018 15:56:11 -0500
Received: from wuerfel.lan ([109.192.41.194]) by mrelayeu.kundenserver.de
 (mreue106 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MI4gb-1giIxv4611-00FFce; Mon, 10 Dec 2018 21:55:57 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Lyude Paul <lyude@redhat.com>, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] brcmfmac: fix false-positive -Wmaybe-unintialized warning
Date:   Mon, 10 Dec 2018 21:55:37 +0100
Message-Id: <20181210205555.3000038-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:c8n9oVnht6yZZdMzFzt2ov1KCDmfjSTO3yfd/Y3Hf0zedJgmk8S
 8ObgdgUO9jIrpTjvsloM4TwvKT55C02zMsVHvH9ayHgEFIMd1fE6y4ITk0MViFJ1397y5V7
 FZeLvPPAAuZGPTQiIMH6rX1U1PnMd6ys/q7ogqow5e/vqtrXzja+gjhjjjCS8N9g9bK7UOh
 d/anCt5O4kNK29fPw6CZg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:hoUXMykC07g=:s/27cROxD2vRSf6qo/o9zb
 YaWdDBnJ9LZ4DJM4B2fHYXgSidQFp00iGfjxoFeb+ZiddIhx0whGR4ZwJBnBZhrNHMd0fWBP2
 VKs+ugL6hWsrWcmCinbU2v5WsONOF0dydaIWyG1/P0BoXcOCeeVsQMRs5jMaO1rI5faOzvhgP
 TgTmuykYgnN3XXmlhbTr4KFcvEg5BKhltI9NjJ2P4FjmRLT6QT2Lae3sC3TgyJ4MBZqUoB3ya
 q0+z7YLFpwEV/N5+KugTm6BR5OcSaiAcxVRndGmYd4L9YpF3qnMlLSfE1DqgMza4v93x6CxaE
 eP8puk/kr5Rz8P3YAjqnzTKFoKAWQHGMORNjGxKNO7tmgpQSuUQbmzCm5PujItOHygRIMxL2S
 cBwx8d59jstig3d9mfiXMB9q0l16u1T+Ih/QUZ5EE06uic+uJrkENDWF6CDBS/ukQOA2XShIQ
 94y/DCFaXPdvP0Ty0aPStHjwNwdatJnGGABQaolN281rxT///Y1GPiB1HQecvp4T4ubJ7STRD
 V1KsawqMkv0pRiCVWhTlr0l7NV09H945rhLYk/F3jh/pU+z3PdkdxSp/2GdgMaHc1VAOXeYiy
 rxc+3/B4gaSkdgZrw8HXePsOuXe6iciCKJnSpt3KELNojlzKhKV2JqbSZVHT40acTyqWu8uZP
 s1N5FoFWf3oWNbMh6xPIcEKlmMMlijreJENoLZ3pBjhXFHFyAjGIWZzh/uZI6UxTTiFsB/Tfy
 2xrIV9rsmurXv7GcjLUyATlINGU+j04ecpUOVQ==
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

When CONFIG_NO_AUTO_INLINE is set, we get a false-postive warning
for the brcmf_fw_request_nvram_done() function, after gcc figures
out that brcmf_fw_nvram_from_efi() might not set the 'data_len'
variable, but fails to notice that it always returns NULL:

drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c: In function 'brcmf_fw_request_nvram_done':
drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c:560:11: error: 'data_len' may be used uninitialized in this function [-Werror=maybe-uninitialized]

Mark it 'inline' to force gcc to understand this.

Fixes: ce2e6db554fa ("brcmfmac: Add support for getting nvram contents from EFI variables")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
index dad3c1c79038..14b948917a1a 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
@@ -512,7 +512,7 @@ static u8 *brcmf_fw_nvram_from_efi(size_t *data_len_ret)
 	return NULL;
 }
 #else
-static u8 *brcmf_fw_nvram_from_efi(size_t *data_len) { return NULL; }
+static inline u8 *brcmf_fw_nvram_from_efi(size_t *data_len) { return NULL; }
 #endif
 
 static void brcmf_fw_free_request(struct brcmf_fw_request *req)
-- 
2.20.0

