Return-Path: <SRS0=IBNP=X5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89E8EC4360C
	for <linux-wireless@archiver.kernel.org>; Fri,  4 Oct 2019 13:24:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 679C021D81
	for <linux-wireless@archiver.kernel.org>; Fri,  4 Oct 2019 13:24:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388333AbfJDNX7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 4 Oct 2019 09:23:59 -0400
Received: from mout.kundenserver.de ([212.227.126.134]:53409 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387952AbfJDNX7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 4 Oct 2019 09:23:59 -0400
Received: from buildfff.adridolf.com ([188.192.135.195]) by
 mrelayeu.kundenserver.de (mreue012 [212.227.15.167]) with ESMTPSA (Nemesis)
 id 1N0Ip5-1hsX7b2DmJ-00xL5x; Fri, 04 Oct 2019 15:23:56 +0200
From:   Adrian Schmutzler <freifunk@adrianschmutzler.de>
To:     linux-wireless@vger.kernel.org
Cc:     Pawel Dembicki <paweldembicki@gmail.com>,
        Felix Fietkau <nbd@nbd.name>
Subject: [PATCH] mt76x0: eeprom: add support for MAC address from OF
Date:   Fri,  4 Oct 2019 15:23:49 +0200
Message-Id: <20191004132349.4924-1-freifunk@adrianschmutzler.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:yW/JQ6pu16OzzS6/VyGukoWRZuL/1OuANGO07xzBePOxSMbndaj
 xZBYAc5kQPoy1JH62iPX9IB315RNPuxCcKCgIWhOXXZGPZ8gmGwQoBc838QHUW74293g/Od
 JuqB4KlzOtlDyqr+G7CIR71KqXIH4W3ZNyTDHIoFBDwkimSdE5OUPDSScGRq6qtWhemGpN2
 sqzEffO3aEFShbwnT5gMQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:v6uqdu53s/4=:itXk7U/3//5suAeyTMd85e
 sUc1nSRCn0NDu3FCHdhw+mXcGIZ3ZAqWwMlBVEdf2cHEx7AXdewy9NmAm1gSLutunxz4N2/bw
 tPMD/qvgym/g1PDmF5XXsWZV4EdeFdkTYwZp/8A7/19Uc61FuEhRGXcVWvxLTt0/o2WOl6xj/
 WyAxbcCMPIDtKyyvokTalZO13nfMcWQ8/DEonE3VhP7Z50ZOoeNt+j3DqJs3u9aKwOc64eO6n
 t/Z4B3WJ6fu8wyAAMMKfzh7LmbDpmcOXCVGMZMFqIemgqcWCqtISNN7rRZz4QtOg6USgrr5Ul
 OJqsHx8t6urNiffvh7v6uFnFjWMGcS0OUFuxZ6IzyMO9MOQQOdVOCg/KTSzK+avbBls51yDOx
 VSJdcpqxZJGRv5vEvzhjtyP83R5PxbkHTdukIXVXsA5Vjzf32+2ShoN8mXZIHsp8Q3cTwtDu2
 +KmJMqa0BxkqPSt2rs4dEigDtjts8bOqh5ioaR5m7dYe5YxjmCFQuQNesiRazh09/Fqa8lzbE
 TjOgA3ZubcwYNkBkTCB2YH8PeYn1Ouuk+7jZt3XFmzF0NkXm5oYt5gpmV2R3MSAb1xk+JGFt3
 +qHRZ8xE3bXo+tTdTV18H9BnatbZ3/4lnn/lMtyaoAhpmniYPXvQ8IBLnvncdzoQFfz2wluUR
 IMI8q4xsKbJG4MN+Aa3PVT4g3VOgdegjWYgKcQ8XbVpqIBNtI36W+RzRDG8q6qqu9klK2Htt+
 i19sep6GDFdXC7QeYWpXNFyepn941MwdQDHklMWn8B4rTRKEl7hUfkh9vKJUMF57QrZu7u8TW
 KVBLIgyUfAs25BP3NaPgNF3cFqn3HhWYnY519c6Kb6PJ3A1FbcR2c6WpHf4PEAYn7fKh5UJQ2
 9MfPjMH1vFWLi4nXGPj9QRgRO/YikfIEosVzT+fgI=
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Pawel Dembicki <paweldembicki@gmail.com>

mt76x0e driver only supports MAC addresses from
calibration data eeprom. Many routers however do not
have a valid stock address set in this field.

This patch makes it possible to take a MAC address
from OF (e.g. from mtd).

Cc: Felix Fietkau <nbd@nbd.name>

Signed-off-by: Pawel Dembicki <paweldembicki@gmail.com>
[adjusted for kernel submission]
Signed-off-by: Adrian Schmutzler <freifunk@adrianschmutzler.de>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
index 9d4426f6905f..48f61fd49c04 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
@@ -343,6 +343,7 @@ int mt76x0_eeprom_init(struct mt76x02_dev *dev)
 		 version, fae);
 
 	mt76x02_mac_setaddr(dev, dev->mt76.eeprom.data + MT_EE_MAC_ADDR);
+	mt76_eeprom_override(&dev->mt76);
 	mt76x0_set_chip_cap(dev);
 	mt76x0_set_freq_offset(dev);
 	mt76x0_set_temp_offset(dev);
-- 
2.20.1

