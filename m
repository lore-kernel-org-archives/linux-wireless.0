Return-Path: <SRS0=bi0l=ZN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24CFFC432C3
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Nov 2019 21:44:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EEDF4206CC
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Nov 2019 21:44:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gJmT1xtK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbfKUVoW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Nov 2019 16:44:22 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:33152 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbfKUVoW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Nov 2019 16:44:22 -0500
Received: by mail-ot1-f67.google.com with SMTP id u13so4403071ote.0
        for <linux-wireless@vger.kernel.org>; Thu, 21 Nov 2019 13:44:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OCB7MNoXeKl6mVOAvFLS20RYmZWGgaOLFimzCOsMTow=;
        b=gJmT1xtKGcy4CvFNkAWHnr6UId+diW+TEOcHvcYjal0DyhKvdcuSiHDQaQBarE1yPD
         bWkXk4FiB+fsgrGFPsFxEnWX9T5h9VMnuFr8dRodd606F5UCVE3FWWKx7X35stI3rFCa
         KVOcZwdceyiQpm0syXETj/taNDo4J7CQ634KlC8L6cMACTKXKFAVCOwoP/tIOaQvdjpc
         6pj0OW5AxDAyfCLyqdBoZQp+H5GT/+AX19ZfRBGqFJqLstMi40znTfMTVoxvAQZ3rmtf
         Rw6Cpybv6GoSLa4HdHg8r+KcVh6/R9tdCuxfDe74aptlbxF3/GHPYfYPWakLwBR4WRCB
         eZng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=OCB7MNoXeKl6mVOAvFLS20RYmZWGgaOLFimzCOsMTow=;
        b=lBUsR4WErSFHbXB+hRiL4EUWBeT8c61zBQlJCgVbg0KTUt+96E3Ugb2vm4Et2XNviq
         mT2AFdKExwK1SAT07FM/JJjhDq86r1OcQoH5kOZtiHiblgYA8s2DiSvdsN3QaxSHhvQn
         Ammphnew5+u8mvhK85U+sDBOurHjnk7BEYFQrCP1DyE9GO2v52NaH/gEgN4FL1PMF2wF
         tJJ1sQbfO5PeUPgoEiUUuqUzpM2nIR1QK4ddvgLJbzcXIamoNQEHQTAyJ87n2DhUsIqD
         vpvkx22MJgWshpZHP8WqppxLOky5cBW1BiKe4d/D4Spi5kMsm7nFaCvzhrM8593fyuI6
         9fIA==
X-Gm-Message-State: APjAAAXXDLVSqYg6tHxvjKWKmn9JaUqj3UPMVAHNqmHYmMjMSylQ/GMP
        Thu9LUw/GYHTmV/W7H/Dxok=
X-Google-Smtp-Source: APXvYqxuW1rp3D87PvAUUeoxYxiR86ZPfTvEZD3ksJ4NJdkomgRgMRFhkdrYM1IK5pvvVBBFbCMkDA==
X-Received: by 2002:a9d:7305:: with SMTP id e5mr8208843otk.3.1574372661126;
        Thu, 21 Nov 2019 13:44:21 -0800 (PST)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id x82sm1333854oix.29.2019.11.21.13.44.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2019 13:44:20 -0800 (PST)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 0/4] rtlwifi: rtl8192de:  Replace local TX and RX bit manipulation macro
Date:   Thu, 21 Nov 2019 15:44:13 -0600
Message-Id: <20191121214417.29676-1-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

These patches are part of a series intended to replace the bit-manipulation
macros used to set and read the various descriptors with a set of inline
routines.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
Kalle,

There is no particular urgency for these patches as they are part of
a general cleanup.

Larry
---

Larry Finger (4):
  rtlwifi: rtl8192de: Remove unused GET_XXX and SET_XXX macros
  rtlwifi: rtl8192de: Replace local bit manipulation macros
  rtlwifi: rtl8192de: Convert macros that set descriptor
  rtlwifi: rtl8192de: Convert inline routines to little-endian words

 .../wireless/realtek/rtlwifi/rtl8192de/trx.c  | 252 +++---
 .../wireless/realtek/rtlwifi/rtl8192de/trx.h  | 853 +++++++-----------
 2 files changed, 479 insertions(+), 626 deletions(-)

-- 
2.23.0

