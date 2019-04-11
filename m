Return-Path: <SRS0=IMqP=SN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CC36C10F13
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Apr 2019 11:52:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A3D12133D
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Apr 2019 11:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554983567;
	bh=V46oDlvXSy648a4BQm4ywm3LtWaXvz3v/7iU3zuFdtU=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=ViVIAFp0/x5KGk4X7K9POKMGE/yMoCZr10WtdsWWLx8NuLNMtWIQF078Pstsb4Ihd
	 mczwR3pT47HU5ef4yYYJHxTa1MLpZfp9pNxPeOp5FMomGSQDUyiBsTHUJbtljLjsI8
	 g01j+dgPZjMnNjqnNGBYYjf1C7wK3LaeI8ZTFarU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbfDKLwq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Apr 2019 07:52:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:32936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726215AbfDKLwq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Apr 2019 07:52:46 -0400
Received: from localhost.localdomain (unknown [151.66.24.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99CA52184B;
        Thu, 11 Apr 2019 11:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554983565;
        bh=V46oDlvXSy648a4BQm4ywm3LtWaXvz3v/7iU3zuFdtU=;
        h=From:To:Cc:Subject:Date:From;
        b=jYlo9k5BrBY6/sdntZd1hSxnRp/PsC8VrbQvTOp83pvHdXbJSLC++Nx1kREivV3jg
         U43pYSOPxdS7EXTZvq4SXMri4qfSmHbjQMNJJNlB0PIYwDFjtUE4SDP5H1v/TK/Y/H
         +2DWJmxQPgGwIpY8AIDyF6gxmt9viW/aUl/ajBxE=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org
Subject: [RFC 0/5] use standard signature for mt7603 mcu api
Date:   Thu, 11 Apr 2019 13:52:32 +0200
Message-Id: <cover.1554982661.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Introduce mt76_mcu_ops data structure in mt7603 mcu code in order to
unify mcu code between mt7603 and mt7615 drivers

Lorenzo Bianconi (5):
  mt7603: remove query from mt7603_mcu_msg_send signature
  mt7603: use standard signature for mt7603_mcu_msg_send
  mt7603: initialize mt76_mcu_ops data structure
  mt76: introduce mt76_mcu_restart macro
  mt7603: init mcu_restart function pointer

 drivers/net/wireless/mediatek/mt76/mt76.h     |   3 +
 .../net/wireless/mediatek/mt76/mt7603/init.c  |   2 +-
 .../net/wireless/mediatek/mt76/mt7603/mcu.c   | 102 +++++++++---------
 .../wireless/mediatek/mt76/mt7603/mt7603.h    |   2 +-
 .../net/wireless/mediatek/mt76/mt76x02_mmio.c |   2 +-
 5 files changed, 55 insertions(+), 56 deletions(-)

-- 
2.20.1

