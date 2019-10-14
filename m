Return-Path: <SRS0=qTSE=YH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FF46C4CECE
	for <linux-wireless@archiver.kernel.org>; Mon, 14 Oct 2019 21:26:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08FC621835
	for <linux-wireless@archiver.kernel.org>; Mon, 14 Oct 2019 21:26:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="T2iOGku4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388964AbfJNV05 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 14 Oct 2019 17:26:57 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:38883 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388963AbfJNV04 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Oct 2019 17:26:56 -0400
Received: by mail-pl1-f193.google.com with SMTP id w8so8531692plq.5
        for <linux-wireless@vger.kernel.org>; Mon, 14 Oct 2019 14:26:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9eXsKrEfbzo+8zmxoU51wmSMpvCs7xq0OcRfkngpHvQ=;
        b=T2iOGku4Js1ccQ2vLi+cSElqrSyKHlrkLz4fDIL4qLLIEtW4HgnTecrej0TCLpYMY3
         m2be6q9O3LkvCl3QFp7PbROZ/tnCRgyiG3atG9i4eCGYGOBVJJok6p32jBhkxgBhKscZ
         id/DeuHHjYvoh2JxbvfcoBUfnJL8GBhaf/6v8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9eXsKrEfbzo+8zmxoU51wmSMpvCs7xq0OcRfkngpHvQ=;
        b=Ksqa/F+phXRIM71aJFDPkln8ZMEEY2vW8+BXmfv7+tdvROO4+tyMqHm8GaPACMzAgz
         DqeSIm9N+iVLmQPl3Z0upCsXK8WxB3ScpuKksH36EVh6w+eOgogDQ5nJyJr3AKwKwB8M
         lhT2db5Ns9Myak9TklssKY9F3AIE9T8Zv3MVJsNGeQ/9OWhGDMF7kquc8gFPd5IuTeVL
         vXLCqPLccHIoj/3je5d+raqTsVxnEnm5obLhXBPpQIeMKqJLq6DLzlEQkrWGsfDf6OKO
         v657fs5rZlhslCpkLxg1rMENbneaUi0RcOPyjQRHzgROzl2QL9ZZNAF6iKZbChYFtDbO
         i8Yw==
X-Gm-Message-State: APjAAAVJw6huFHPupswK0DvzWEoPXCGD5iaWtiKCeY79hpYI1nbQ3/PR
        PEY2Y2EKj7cuw7cYMNxrpYp3eZxyXNA=
X-Google-Smtp-Source: APXvYqx21ImNVPPVWLkus7kPiCm4EsEy5rntqGm4YDgAcvicyVURqkGSXeqKvQwLheJppqQcEUn8Hw==
X-Received: by 2002:a17:902:8505:: with SMTP id bj5mr30509115plb.296.1571088415003;
        Mon, 14 Oct 2019 14:26:55 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:1:534:b7c0:a63c:460c])
        by smtp.gmail.com with ESMTPSA id m22sm15295913pgd.45.2019.10.14.14.26.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2019 14:26:53 -0700 (PDT)
From:   Brian Norris <briannorris@chromium.org>
To:     <linux-wireless@vger.kernel.org>
Cc:     Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Brian Norris <briannorris@chromium.org>,
        Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH] rtw88: mark rtw_fw_hdr __packed
Date:   Mon, 14 Oct 2019 14:26:48 -0700
Message-Id: <20191014212648.122549-1-briannorris@chromium.org>
X-Mailer: git-send-email 2.23.0.700.g56cf767bdb-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The use of u8 and __le16 in this struct assumes that it's going to be
packed to byte alignment. C doesn't guarantee that, so we should mark
this __packed.

Fixes: cc20a7139836 ("rtw88: use struct rtw_fw_hdr to access firmware header")
Cc: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/net/wireless/realtek/rtw88/fw.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/fw.h b/drivers/net/wireless/realtek/rtw88/fw.h
index 4f7999394235..73d1b9ca8efc 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.h
+++ b/drivers/net/wireless/realtek/rtw88/fw.h
@@ -127,7 +127,7 @@ struct rtw_fw_hdr {
 	__le32 emem_size;
 	__le32 emem_addr;
 	__le32 imem_addr;
-};
+} __packed;
 
 /* C2H */
 #define GET_CCX_REPORT_SEQNUM(c2h_payload)	(c2h_payload[8] & 0xfc)
-- 
2.23.0.700.g56cf767bdb-goog

