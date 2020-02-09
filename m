Return-Path: <SRS0=ZRRt=35=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94F68C35250
	for <linux-wireless@archiver.kernel.org>; Sun,  9 Feb 2020 16:59:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 770C520726
	for <linux-wireless@archiver.kernel.org>; Sun,  9 Feb 2020 16:59:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727836AbgBIQ7P (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 9 Feb 2020 11:59:15 -0500
Received: from smail.rz.tu-ilmenau.de ([141.24.186.67]:49160 "EHLO
        smail.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727725AbgBIQ7P (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 9 Feb 2020 11:59:15 -0500
Received: from isengard.fritz.box (unknown [84.174.247.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smail.rz.tu-ilmenau.de (Postfix) with ESMTPSA id 96D5E580065;
        Sun,  9 Feb 2020 17:59:12 +0100 (CET)
From:   Markus Theil <markus.theil@tu-ilmenau.de>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Markus Theil <markus.theil@tu-ilmenau.de>
Subject: [PATCH 0/8] iw: parse measurement pilot and fix scan bugs
Date:   Sun,  9 Feb 2020 17:58:54 +0100
Message-Id: <20200209165902.44110-1-markus.theil@tu-ilmenau.de>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Besides adding a parser for the measurement pilot element, this
series fixes several bugs found while fuzzing the scan code of iw.

Markus Theil (8):
  iw: scan: parse measurement pilot element
  iw: scan: fix buffer over-read in print_ies()
  iw: scan: fix buffer over-read in operation class parsing
  iw: scan: fix buffer over-read in parsing roaming consortium
  iw: scan: fix buffer over-read in print_wifi_wps
  iw: scan: fix buffer over-read in print_p2p
  iw: scan: fix undefined behaviour in rm capa print
  iw: scan: fix undefined behaviour in print_vht_capa()

 scan.c | 71 +++++++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 58 insertions(+), 13 deletions(-)

--
2.25.0

