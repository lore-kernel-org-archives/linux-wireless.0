Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F73AC43441
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 08:56:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 21FAB2087D
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 08:56:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 21FAB2087D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728080AbeJLQ15 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 12:27:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35052 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727705AbeJLQ15 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 12:27:57 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A9C6A3097042;
        Fri, 12 Oct 2018 08:56:32 +0000 (UTC)
Received: from localhost (unknown [10.40.205.119])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 09B86912B1;
        Fri, 12 Oct 2018 08:56:31 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     Daniel Golle <daniel@makrotopia.org>,
        Mathias Kresin <dev@kresin.me>, Felix Fietkau <nbd@nbd.name>,
        =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>
Subject: [PATCH v4 0/8] rt2800: register programing tweaks and clean ups
Date:   Fri, 12 Oct 2018 10:56:23 +0200
Message-Id: <1539334591-9965-1-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Fri, 12 Oct 2018 08:56:32 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

v3 -> v4:
- do not program addition registers for MT7620
- fix RT6362 typo

v2 -> v3:
- fix wrongly applied hunk during rebase
- add SoB

Stanislaw Gruszka (5):
  rt2800: fix registers init for MT7620
  rt2800: enable TX_PIN_CFG_LNA_PE_ bits per band
  rt2800: enable TX_PIN_CFG_RFRX_EN only for MT7620
  rt2800: remove unneeded RT6352 check
  rt2800: comment and simplify AGC init for RT6352

Tomislav Požega (3):
  rt2x00: remove unneeded check
  rt2x00: remove confusing AGC register
  rt2x00: update TX_SW_CFG2 value

 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 150 +++++++++++++------------
 1 file changed, 78 insertions(+), 72 deletions(-)

-- 
2.7.5

