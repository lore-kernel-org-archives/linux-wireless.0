Return-Path: <SRS0=0XaW=Q3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D76DC43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 14:05:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2066C2147A
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 14:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550671545;
	bh=suw/whWI9R0j1ALdC7aGC+oRXPRXScxWcUIY++sWP20=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=0/PM7Hg1JY2qm0sHcOsNci0HKCjA/QiV4JN89L8T2iKSjCz5UIuu1J2tPeHeEqhfg
	 uw2yjS9G+eX/7jbgkTlyS0oVGhH5ATj6UQyHOXoNvNpI7XzJFfLrHt95VzH3UFmxMs
	 p1eN8szDCe8F1vPot1yfg28OQH3dXBPoZWIQjY7k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726516AbfBTOFo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Feb 2019 09:05:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:48076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726013AbfBTOFn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Feb 2019 09:05:43 -0500
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2023C2146E;
        Wed, 20 Feb 2019 14:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550671543;
        bh=suw/whWI9R0j1ALdC7aGC+oRXPRXScxWcUIY++sWP20=;
        h=From:To:Cc:Subject:Date:From;
        b=2ONXHO9d6RDVY1W6/aIn/CMIzKRKDKxN1xPGevvxU2VfcgGxkWbVgBrxxLxm0PdEM
         rlXZMg9B3rQpMo73jQS1ZTPOl2H3uxZ1NkVH8UfD5uoILtgljDPKM5GgV8iIR8aJa5
         LzB54wX1qLoRJ6H9Hd1uZRzHOOqiBRZi6YIyHSjk=
From:   lorenzo@kernel.org
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com,
        lorenzo.bianconi@redhat.com
Subject: [RFC 0/3] simplify usb layer buffer allocation
Date:   Wed, 20 Feb 2019 15:05:32 +0100
Message-Id: <cover.1550671183.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

Simplify usb rx buffer allocation.
Simplify mt76u_tx_build_sg routine

Lorenzo Bianconi (3):
  mt76: usb: introduce mt76u_fill_bulk_urb routine
  mt76: usb: simplify rx buffer allocation
  mt76: usb: simplify mt76u_tx_build_sg routine

 drivers/net/wireless/mediatek/mt76/mt76.h |   2 -
 drivers/net/wireless/mediatek/mt76/usb.c  | 134 +++++++++-------------
 2 files changed, 55 insertions(+), 81 deletions(-)

-- 
2.20.1

