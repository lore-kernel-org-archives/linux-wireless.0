Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0084BC4338F
	for <linux-wireless@archiver.kernel.org>; Fri, 13 Aug 2021 16:44:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC67560EB2
	for <linux-wireless@archiver.kernel.org>; Fri, 13 Aug 2021 16:44:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236528AbhHMQoi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 13 Aug 2021 12:44:38 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:52274 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S237118AbhHMQog (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Aug 2021 12:44:36 -0400
X-UUID: bfeb5d6af51546aba07f781de7bfd407-20210814
X-UUID: bfeb5d6af51546aba07f781de7bfd407-20210814
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw02.mediatek.com
        (envelope-from <sean.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 237412176; Sat, 14 Aug 2021 00:44:05 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs07n1.mediatek.inc (172.21.101.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Sat, 14 Aug 2021 00:44:04 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sat, 14 Aug 2021 00:44:04 +0800
From:   <sean.wang@mediatek.com>
To:     <nbd@nbd.name>
CC:     <lorenzo.bianconi@redhat.com>, <sean.wang@mediatek.com>,
        <Soul.Huang@mediatek.com>, <YN.Chen@mediatek.com>,
        <Leon.Yen@mediatek.com>, <Deren.Wu@mediatek.com>,
        <km.lin@mediatek.com>, <robin.chiu@mediatek.com>,
        <ch.yeh@mediatek.com>, <posh.sun@mediatek.com>,
        <Eric.Liang@mediatek.com>, <Stella.Chang@mediatek.com>,
        <jemele@google.com>, <yenlinlai@google.com>,
        <linux-wireless@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCH] mt76: fix determining multicast frame in sta mode
Date:   Sat, 14 Aug 2021 00:44:03 +0800
Message-ID: <1628873043-30762-1-git-send-email-sean.wang@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <6c6ba2fd-3952-3c44-6c6d-51f77eb66828@nbd.name--annotate>
References: <6c6ba2fd-3952-3c44-6c6d-51f77eb66828@nbd.name--annotate>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sean Wang <sean.wang@mediatek.com>

>>On 2021-08-09 23:13, sean.wang@mediatek.com wrote:
>> From: Sean Wang <sean.wang@mediatek.com>
>>
>> We should use hdr->addr3 as the destination address to determine the
>> frame is multicast frame or not when the device is running in sta mode.
>>
>> We can simply use ieee80211_get_DA for ap mode and sta mode both cases.
>That does not make any sense to me. When a sta sends a packet with DA set to a multicast address, it will be sent as unicast to the AP. Why should it be treated as multicast by the driver?

You're right. I should drop the patch earlier. Sorry for the noise.

Eventually, I have found the cause, it is possible to some unicast frame picking up a wrong legacy rate
to send out because the current driver doesn't program the legacy rate information well.
The fix have been provided with ("mt76: mt7921: fix firmware usage of RA info using legacy rates") in [1].

	Sean

[1]
https://patchwork.kernel.org/project/linux-wireless/patch/4be4378630c93ae32a4db8bc3e0871c7b15150a6.1628661185.git.objelf@gmail.com/

>
>- Felix
>

