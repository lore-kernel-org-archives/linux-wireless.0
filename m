Return-Path: <SRS0=xkZe=QU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23F5FC282C2
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 10:09:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EBF3C207E0
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 10:09:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732703AbfBMKJS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Feb 2019 05:09:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51246 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727580AbfBMKJR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Feb 2019 05:09:17 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B65F181F07;
        Wed, 13 Feb 2019 10:09:17 +0000 (UTC)
Received: from localhost (unknown [10.40.205.129])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1545160856;
        Wed, 13 Feb 2019 10:09:16 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>
Subject: [PATCH v5 0/5] rt2800: register programing tweaks and clean ups 
Date:   Wed, 13 Feb 2019 11:09:11 +0100
Message-Id: <1550052556-7158-1-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Wed, 13 Feb 2019 10:09:17 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This is repost of 
https://lore.kernel.org/linux-wireless/1539334591-9965-1-git-send-email-sgruszka@redhat.com/

with controversial patches removed. I will work on them letter.
 
Stanislaw Gruszka (3):
  rt2800: enable TX_PIN_CFG_LNA_PE_ bits per band
  rt2800: enable TX_PIN_CFG_RFRX_EN only for MT7620
  rt2800: comment and simplify AGC init for RT6352

Tomislav Požega (2):
  rt2x00: remove unneeded check
  rt2x00: remove confusing AGC register

 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 141 +++++++++++++------------
 1 file changed, 72 insertions(+), 69 deletions(-)

-- 
2.7.5

