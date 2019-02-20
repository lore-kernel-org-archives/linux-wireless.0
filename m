Return-Path: <SRS0=0XaW=Q3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AFB9C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 22:35:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4907520880
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 22:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550702128;
	bh=pvf7kjcpEshQJm+lrjsPiY0j7Wcjbnz5FnwD8k1dT3o=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=14iXyHpi0EUR0c8jIjZzIM/HVPzbnaGKbEm0HcRr0vMIQ60wPdASLAzH7kPd7HmeQ
	 aQdBa9ANZ1v/8Zn5fF48u3t+yR8pfc+JlL7qEj2kA518vnDryZTwR+UiRW2g9cC9RC
	 EWWk1wZ88EPqBLo0zG3GKKb3RzFna6sXuUbC9BvM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727326AbfBTWf1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Feb 2019 17:35:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:50396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727200AbfBTWf1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Feb 2019 17:35:27 -0500
Received: from lore-desk.lan (unknown [151.66.48.245])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 146D520836;
        Wed, 20 Feb 2019 22:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550702126;
        bh=pvf7kjcpEshQJm+lrjsPiY0j7Wcjbnz5FnwD8k1dT3o=;
        h=From:To:Cc:Subject:Date:From;
        b=Agc1kNbafpsg21p5F0ZsOVA5OTO+ZzYdWB+QhYlGAvq2VGjgqWVBBpg0rCCdL29vl
         4QnveHFwvHz0lKV+WUsEhErLp15AREQLCnGheRD7p8lLUheWV0rWiPWZFi0jRR9sCl
         FKdpaIjpSe3/GLfhkVjwz2GxGl0CUBsHUWUQM4hU=
From:   lorenzo@kernel.org
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com,
        lorenzo.bianconi@redhat.com, Lorenzo Bianconi <lorenzo@kernel.org>
Subject: [PATCH 0/3] simplify usb layer buffer allocation
Date:   Wed, 20 Feb 2019 23:35:15 +0100
Message-Id: <cover.1550701735.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

Simplify usb rx buffer allocation.
Simplify mt76u_tx_build_sg routine.
This series is based on 'mt76usb: allow mt76u_bulk_msg be used for reads'
https://patchwork.kernel.org/patch/10822469/

Lorenzo Bianconi (3):
  mt76: usb: introduce mt76u_fill_bulk_urb routine
  mt76: usb: simplify rx buffer allocation
  mt76: usb: simplify mt76u_tx_build_sg routine

 drivers/net/wireless/mediatek/mt76/mt76.h |   2 -
 drivers/net/wireless/mediatek/mt76/usb.c  | 132 +++++++++-------------
 2 files changed, 53 insertions(+), 81 deletions(-)

-- 
2.20.1

