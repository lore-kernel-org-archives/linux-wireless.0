Return-Path: <SRS0=F8Dj=QZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D106C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 02:32:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FA64218DE
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 02:32:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728311AbfBRCcw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 17 Feb 2019 21:32:52 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:26408 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727266AbfBRCcw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 17 Feb 2019 21:32:52 -0500
X-UUID: 5f5a020a42cf46b391cce2649ba17e10-20190218
X-UUID: 5f5a020a42cf46b391cce2649ba17e10-20190218
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw01.mediatek.com
        (envelope-from <ryder.lee@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 916723485; Mon, 18 Feb 2019 10:32:41 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs01n1.mediatek.inc (172.21.101.68) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 18 Feb 2019 10:32:40 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by mtkcas08.mediatek.inc
 (172.21.101.126) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 18 Feb
 2019 10:32:39 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Mon, 18 Feb 2019 10:32:39 +0800
Message-ID: <1550457159.18089.5.camel@mtkswgap22>
Subject: Re: [PATCH 0/2] remove qid dependency from mt76-core code
From:   Ryder Lee <ryder.lee@mediatek.com>
To:     <lorenzo@kernel.org>
CC:     <nbd@nbd.name>, <linux-wireless@vger.kernel.org>,
        <sgruszka@redhat.com>, <roychl666@gmail.com>,
        <linux-mediatek@lists.infradead.org>
Date:   Mon, 18 Feb 2019 10:32:39 +0800
In-Reply-To: <cover.1550336347.git.lorenzo@kernel.org>
References: <cover.1550336347.git.lorenzo@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-MTK:  N
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, 2019-02-16 at 18:47 +0100, lorenzo@kernel.org wrote:
> From: Lorenzo Bianconi <lorenzo@kernel.org>
> 
> Move queue id dependency in driver specific tx queue initialization code
> since new chipsets rely on a different tx queue enumeration scheme.
> Add the possibility to specify qid in mt76_tx routine
> 
> Lorenzo Bianconi (2):
>   mt76: add qid parameter to mt76_tx signature
>   mt76: move txq qid dependency in driver specific code
> 
>  drivers/net/wireless/mediatek/mt76/mac80211.c | 27 +++++++++++-------
>  drivers/net/wireless/mediatek/mt76/mt76.h     | 14 ++++++++--
>  .../net/wireless/mediatek/mt76/mt76x02_txrx.c |  8 +++++-
>  .../net/wireless/mediatek/mt76/mt76x02_util.c |  2 ++
>  drivers/net/wireless/mediatek/mt76/tx.c       | 28 +++++--------------
>  5 files changed, 45 insertions(+), 34 deletions(-)
> 

Thanks. This will help us to develop the new chipsets more easily.

Acked-by: Ryder Lee <ryder.lee@mediatek.com>


