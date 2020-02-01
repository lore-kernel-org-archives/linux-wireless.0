Return-Path: <SRS0=cHPN=3V=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11635C33CB3
	for <linux-wireless@archiver.kernel.org>; Sat,  1 Feb 2020 15:34:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3C032070C
	for <linux-wireless@archiver.kernel.org>; Sat,  1 Feb 2020 15:34:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="iFkDx5Dg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbgBAPeI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 1 Feb 2020 10:34:08 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:3149 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726670AbgBAPeH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 1 Feb 2020 10:34:07 -0500
X-UUID: 35847b1e36074bceb0eae052a9527976-20200201
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=0csIRJLeMgqFDBc0WpZNMpF4/Ash9iE+C/byhNFJPjE=;
        b=iFkDx5DgjBljW0BIGEZfv2mbWNjlV+Pq4tE7BbbZAmirLtKLtVrdIla9SqBjGhjoQC6AJuRpi3aHf86iJU3+MDwwnsmw1vbaUIEhmpP7N0OSe4tHTzZqzbl1SkYXHY22qAe3wMT8ZVBFe4tIh1A9hlspvkLm8ZLzQ2ldLOqylEA=;
X-UUID: 35847b1e36074bceb0eae052a9527976-20200201
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw01.mediatek.com
        (envelope-from <ryder.lee@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1362623669; Sat, 01 Feb 2020 23:33:57 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs06n1.mediatek.inc (172.21.101.129) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Sat, 1 Feb 2020 23:33:56 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Sat, 1 Feb 2020 23:31:31 +0800
From:   Ryder Lee <ryder.lee@mediatek.com>
To:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
CC:     Shayne Chen <shayne.chen@mediatek.com>,
        Roy Luo <royluo@google.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Josh Boyer <jwboyer@kernel.org>,
        <linux-wireless@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        Ryder Lee <ryder.lee@mediatek.com>
Subject: [PATCH v2 0/7] switch mt7615 MCU command format from v1 to v2
Date:   Sat, 1 Feb 2020 23:33:45 +0800
Message-ID: <cover.1580565624.git.ryder.lee@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

SGksDQoNClRoaXMgdXBkYXRlcyBjb21tYW5kIGZsb3cgdG8gYWRhcHQgbmV3ZXIgZmlybXdhcmUg
dmVyc2lvbi4NCg0KQ2hhbmdlcyBzaW5jZSB2MjoNCi0gY2hlY2sgdGhlIHJldHVybiB2YWx1ZSBm
cm9tIF9fbXQ3Nl9tY3Vfc2VuZF9tc2cuDQotIHJlbmFtZSBkZXYtPmZ3X3ZlciB0byAnMi4wJy4N
Ci0gc2ltcGxpZnkgaXNfdjEgZXhwcmVzc2lvbi4NCi0gcmV2aXNlIGNvbW1pdCBtZXNzYWdlcy4N
Cg0KUnlkZXIgTGVlICg3KToNCiAgbXQ3NjogbXQ3NjE1OiBzaW1wbGlmeSBtY3Vfc2V0X2JtYyBm
bG93DQogIG10NzY6IG10NzYxNTogc2ltcGxpZnkgbWN1X3NldF9zdGEgZmxvdw0KICBtdDc2OiBt
dDc2MTU6IGFkZCBhIGhlbHBlciB0byBlbmNhcHN1bGF0ZSBzdGFfcmVjIG9wZXJhdGlvbg0KICBt
dDc2OiBtdDc2MTU6IGFkZCBzdGFyZWMgb3BlcmF0aW5nIGZsb3cgZm9yIGZpcm13YXJlIHYyDQog
IG10NzY6IG10NzYxNTogdXNlIG5ldyB0YWcgc3RhX3JlY193dGJsDQogIG10NzY6IG10NzYxNTog
c3dpdGNoIG10NzYxNV9tY3Vfc2V0X3R4X2JhIHRvIHYyIGZvcm1hdA0KICBtdDc2OiBtdDc2MTU6
IHN3aXRjaCBtdDc2MTVfbWN1X3NldF9yeF9iYSB0byB2MiBmb3JtYXQNCg0KIC4uLi9uZXQvd2ly
ZWxlc3MvbWVkaWF0ZWsvbXQ3Ni9tdDc2MTUvbWFpbi5jICB8ICAxMiArLQ0KIC4uLi9uZXQvd2ly
ZWxlc3MvbWVkaWF0ZWsvbXQ3Ni9tdDc2MTUvbWN1LmMgICB8IDU3NyArKysrKysrKystLS0tLS0t
LS0NCiAuLi4vbmV0L3dpcmVsZXNzL21lZGlhdGVrL210NzYvbXQ3NjE1L21jdS5oICAgfCAgIDgg
Ky0NCiAuLi4vd2lyZWxlc3MvbWVkaWF0ZWsvbXQ3Ni9tdDc2MTUvbXQ3NjE1LmggICAgfCAgMjAg
Ky0NCiA0IGZpbGVzIGNoYW5nZWQsIDMxMCBpbnNlcnRpb25zKCspLCAzMDcgZGVsZXRpb25zKC0p
DQoNCi0tIA0KMi4xOC4wDQo=

