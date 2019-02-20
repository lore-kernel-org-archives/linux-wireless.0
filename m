Return-Path: <SRS0=0XaW=Q3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C629C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 10:59:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D804B20685
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 10:59:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727656AbfBTK7A (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Feb 2019 05:59:00 -0500
Received: from shell.v3.sk ([90.176.6.54]:59828 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726573AbfBTK67 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Feb 2019 05:58:59 -0500
Received: from localhost (localhost [127.0.0.1])
        by zimbra.v3.sk (Postfix) with ESMTP id CBB37101A5C;
        Wed, 20 Feb 2019 11:58:56 +0100 (CET)
Received: from shell.v3.sk ([127.0.0.1])
        by localhost (zimbra.v3.sk [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id fniW9j40cDwn; Wed, 20 Feb 2019 11:58:50 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by zimbra.v3.sk (Postfix) with ESMTP id 5396F101A60;
        Wed, 20 Feb 2019 11:58:50 +0100 (CET)
X-Virus-Scanned: amavisd-new at zimbra.v3.sk
Received: from shell.v3.sk ([127.0.0.1])
        by localhost (zimbra.v3.sk [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id c6ctJtzczHKn; Wed, 20 Feb 2019 11:58:48 +0100 (CET)
Received: from belphegor.brq.redhat.com (nat-pool-brq-t.redhat.com [213.175.37.10])
        by zimbra.v3.sk (Postfix) with ESMTPSA id 6EBBF101A5B;
        Wed, 20 Feb 2019 11:58:48 +0100 (CET)
From:   Lubomir Rintel <lkundrak@v3.sk>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Steve deRosier <derosier@cal-sierra.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] libertas_tf: fix setting the hardware address]
Date:   Wed, 20 Feb 2019 11:58:37 +0100
Message-Id: <20190220105840.793525-1-lkundrak@v3.sk>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

this is a second version of a patchset addresses a problem with libertas_=
tf
driver, where the driver registers the interface without having the MAC
address set, only setting it when the interface is brought up.

It fixes an embarassing build issue and folds in fixes for things
pointed up in a review into the patch 2/3.

Cheers,
Lubo


