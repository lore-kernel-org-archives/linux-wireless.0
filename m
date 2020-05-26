Return-Path: <SRS0=qCs9=7I=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6890C433DF
	for <linux-wireless@archiver.kernel.org>; Tue, 26 May 2020 15:59:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E6AC2075F
	for <linux-wireless@archiver.kernel.org>; Tue, 26 May 2020 15:59:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K4q3iVGS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730006AbgEZP7O (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 May 2020 11:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729102AbgEZP7N (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 May 2020 11:59:13 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABB31C03E96D
        for <linux-wireless@vger.kernel.org>; Tue, 26 May 2020 08:59:13 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id h7so16716994otr.3
        for <linux-wireless@vger.kernel.org>; Tue, 26 May 2020 08:59:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=V1TmlmheR4aTtDsemV7Ak+vlVfZBah2p3OZJKn0vSHU=;
        b=K4q3iVGSrjDEnL4HGX4fpkxamfPoopnRdaniSraKUz3xmC+PXh4jAgnt4EhTTARCOC
         R4aDbSOrM5X/J9NNjW9TM9mT51zO98YoX3T+vFQXf5Cn/mgL1lZn2d2bAiWLkZxPFg7i
         Fj+FCSt6HntN7Z0Irp33uyA9TVyRy3rKEL7J1ckYTZDlCVztW+sptQ4HqO7zn1kUPDAW
         BbClGMDe2qbwMCb7LdAiw2L8tmlc6YXY7aSjUowT7ndfebFJoR/uUkAIWHTjDIFjmydF
         AnuQ1SkRM2SBYvt9056eXqomxVsGzTx9kD6Y+OGiMcxaESHQdCmdp1P3rEqfxxlEpnBW
         t0+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=V1TmlmheR4aTtDsemV7Ak+vlVfZBah2p3OZJKn0vSHU=;
        b=icO5zkU6TmlcMfuIZW0BVsBcJu8tRWCdpd3O/3WmD1UGRDeDmEV7uDtU2KyLTA2JZG
         zZz7S09uNMcfz6RMfUUm3z0PlUzm+YH4Br0bxoiXDneBHXw4qD1Epo8heDKWiH939JKH
         iLYAZLPC+Ww9qKUQE9Y1dQFgFfNrRuY3KzYlfgM+fBTiEdpmEKbj0cOnF4+noKmDFJoI
         27Qil9dQ9O5fMe7FCDPDAbIRxPamy6H3JdMURfw0TJV1pmj3czt2il3u+RM5z5IenHqj
         SNTvdSaR+wdlY5QfuUwK522kV6OLMOeOAD3MKEP84Cn4mIuorRNJOZErHAESm+usH+QN
         giSQ==
X-Gm-Message-State: AOAM533UCGi++3/zSUrPqj70ZuGUWsrreCerWQ12KYA3WXYgGhm5d0Gh
        D40PumCye9WKtEdGp0exchU=
X-Google-Smtp-Source: ABdhPJw54bZA9BUK8NUBD/Xi7Gh6la0dAglpxmRibXo2lawcvQD+rQmrIQaswHCsh3QamSxJAu+JjQ==
X-Received: by 2002:a05:6830:1248:: with SMTP id s8mr1486825otp.30.1590508753158;
        Tue, 26 May 2020 08:59:13 -0700 (PDT)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id k18sm36185otn.51.2020.05.26.08.59.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 08:59:12 -0700 (PDT)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Rui Salvaterra <rsalvaterra@gmail.com>
Subject: [PATCH 0/2] Fix WPA3 problems with b43 and b43_legacy
Date:   Tue, 26 May 2020 10:59:07 -0500
Message-Id: <20200526155909.5807-1-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Neither of these two drivers handle MFP in their hardware encryption,
thus they need to use the software version built into mac80211.
Unfortunately, neither of them sent MFP_CAPABLE as part of their
capabilities.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

Larry Finger (2):
  b43: Fix connection problem with WPA3
  b43_legacy: Fix connection problem with WPA3

 drivers/net/wireless/broadcom/b43/main.c       | 2 +-
 drivers/net/wireless/broadcom/b43legacy/main.c | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

-- 
2.26.2

