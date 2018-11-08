Return-Path: <SRS0=/7yp=NT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EC07ECDE4B
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 14:47:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 614822081D
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 14:47:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 614822081D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727677AbeKIAXb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 8 Nov 2018 19:23:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53732 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727668AbeKIAXa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Nov 2018 19:23:30 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0B478307DAAA;
        Thu,  8 Nov 2018 14:47:41 +0000 (UTC)
Received: from localhost (unknown [10.43.2.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7BBB710D827D;
        Thu,  8 Nov 2018 14:47:12 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: [RFC/RFT 0/4] restore some old mt76x0u behaviour
Date:   Thu,  8 Nov 2018 15:47:06 +0100
Message-Id: <1541688430-31855-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Thu, 08 Nov 2018 14:47:41 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

I can still observe random performance drops on my setup.
Those drops are very rare after applying those:

mt76x02: assure we update gain after scan
mt76x02: run calibration after scanning
mt76x0: do not overwrite other MT_BBP(AGC, 8) fields

but sill happened in Felix tree up to:

79864387b0a0 mt76x0: pci: add DFS support

I did not notice them on linux-4.20 with 3 above fixes
and following patches:

1737618972d6 mt76x0: phy: unify calibration between mt76x0u and mt76x0e
c9540a53b257 mt76x2u: introduce mac workqueue support
9ed42cfca329 mt76x0: use mt76x02_mac_work as stats handler
f6f36ffc6da8 mt76x0: use shared debugfs implementation
1ef5b4893baa mt76: move mt76x02_debugfs in mt76x02-lib module
210ec41d92a0 mt76: move mt76x02_mac_work routine in mt76x02-lib module
9e72f73dc692 mt76x0: pci: add get_survey support
70ef7506c741 mt76x0: phy: improve code readability in initvals_phy.h
30ec3a3558c8 mt76x0: phy: simplify rf configuration routines
37385b8f96bc mt76x0: phy: use proper name convention
7936959c4544 mt76x2u: align channel gain logic to mt76x2 one
0129c6cf5577 mt76x2: align mt76x2 and mt76x2u firmware

Since is hard to reproduce the problem, I was not able to
identify offended commit. However looking at the history there are
planty of commits like:

mt76: move XXX in mt76x02-lib module

which does not only move the code, but change the behavior of
the mt76x0u driver in various ways.

Following patches restore some of old mt76x0u behaviour and
should do correct thing and do not cause any harm on different
setup (AP mode , mt76x2u, mt76x0e), but I did not test them 
in those setups.

Stanislaw Gruszka (4):
  mt76x02: configure basic rates and fallback on STA mode
  mt76x02: reserve wcid 0 for global
  mt76x02: do not set protection on set_rts_threshold callback
  mt76x02: set protection according to ht capabilities

 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c  | 74 ++++++++++++++++++-----
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.h  |  4 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c | 24 +++++++-
 3 files changed, 84 insertions(+), 18 deletions(-)

-- 
1.9.3

