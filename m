Return-Path: <SRS0=sar6=AL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7CBEC433E0
	for <linux-wireless@archiver.kernel.org>; Tue, 30 Jun 2020 21:41:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B86F82065F
	for <linux-wireless@archiver.kernel.org>; Tue, 30 Jun 2020 21:41:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="jyYJZQ9M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728566AbgF3Vls (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 30 Jun 2020 17:41:48 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:32278 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726831AbgF3Vls (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Jun 2020 17:41:48 -0400
X-UUID: 451adc818a6b41f58505f996fb0cc72f-20200701
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=my6niiLx0nSCCSrHDeMum2DvSxJq/ewHLuqNctNA8Dw=;
        b=jyYJZQ9M9uLaWb8ieiKNYR3VipyDLMNsHY6ZZ3DT67ZbfhbWLYZCFjLx/tMeCU/lSSQcj33HWFYZ30MQ0Zf+UDL5sgL9nl4Cbd0wVzJENpgzE7mf/BnWIPpYZfBwp4CSMZzIrX4EvSsVkI/gsMJigXODK4FGQa5IOoGSC7KvnTA=;
X-UUID: 451adc818a6b41f58505f996fb0cc72f-20200701
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw01.mediatek.com
        (envelope-from <sean.wang@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 395041119; Wed, 01 Jul 2020 05:41:41 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs08n2.mediatek.inc (172.21.101.56) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 1 Jul 2020 05:41:39 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 1 Jul 2020 05:41:36 +0800
From:   <sean.wang@mediatek.com>
To:     <lorenzo@kernel.org>
CC:     <nbd@nbd.name>, <Sean.Wang@mediatek.com>,
        <lorenzo.bianconi@redhat.com>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <Ryder.Lee@mediatek.com>,
        <linux-wireless@vger.kernel.org>,
        Sean Wang <sean.wang@mediatek.com>
Subject: Re: [PATCH 1/3] mt76: mt7663u: fix memory leak in set key
Date:   Wed, 1 Jul 2020 05:41:37 +0800
Message-ID: <1593553297-25352-1-git-send-email-sean.wang@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20200630072429.GD2169@localhost.localdomain>
References: <20200630072429.GD2169@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 2C9B81AFE1CDC18AA22159E30B7F248C76E4B6EC919E3865F543F070162C8ACD2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

RnJvbTogU2VhbiBXYW5nIDxzZWFuLndhbmdAbWVkaWF0ZWsuY29tPg0KDQpUaGFua3MsIEknbGwg
aGF2ZSB0aGUgbmV4dCB2ZXJzaW9uIHRvIHJlbW92ZSB0aGUgdW5uZWVkZWQga2ZyZWUuDQoNCj4N
Cj4+ICsNCj4+ICsJcmV0dXJuIGVycjsNCj4+ICB9DQo+Pg0KPj4gIHZvaWQgbXQ3NjYzdV93dGJs
X3dvcmsoc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKQ0K

