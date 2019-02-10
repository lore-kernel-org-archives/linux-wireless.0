Return-Path: <SRS0=fcMp=QR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ED26C282C2
	for <linux-wireless@archiver.kernel.org>; Sun, 10 Feb 2019 19:52:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67A152145D
	for <linux-wireless@archiver.kernel.org>; Sun, 10 Feb 2019 19:52:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726093AbfBJTw3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 10 Feb 2019 14:52:29 -0500
Received: from shell.v3.sk ([90.176.6.54]:42509 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725958AbfBJTw3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 10 Feb 2019 14:52:29 -0500
Received: from localhost (localhost [127.0.0.1])
        by zimbra.v3.sk (Postfix) with ESMTP id CB47FCE834;
        Sun, 10 Feb 2019 20:52:26 +0100 (CET)
Received: from shell.v3.sk ([127.0.0.1])
        by localhost (zimbra.v3.sk [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id 4JwHXKgPb4j4; Sun, 10 Feb 2019 20:52:21 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by zimbra.v3.sk (Postfix) with ESMTP id B412ACE835;
        Sun, 10 Feb 2019 20:52:20 +0100 (CET)
X-Virus-Scanned: amavisd-new at zimbra.v3.sk
Received: from shell.v3.sk ([127.0.0.1])
        by localhost (zimbra.v3.sk [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 1tWXBy-UYJ7s; Sun, 10 Feb 2019 20:52:20 +0100 (CET)
Received: from nedofet.lan (ip-89-102-31-34.net.upcbroadband.cz [89.102.31.34])
        by zimbra.v3.sk (Postfix) with ESMTPSA id EADB0CE774;
        Sun, 10 Feb 2019 20:52:19 +0100 (CET)
From:   Lubomir Rintel <lkundrak@v3.sk>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] libertas_tf: fix setting the hardware address
Date:   Sun, 10 Feb 2019 20:52:14 +0100
Message-Id: <20190210195217.18817-1-lkundrak@v3.sk>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

this short patchset addresses a problem with libertas_tf driver, where
the driver registers the interface without having the MAC address set,
only setting it when the interface is brought up. That is generally too
late, and it confuses NetworkManager.

Some restructuring is needed first, done in first two patches.

Tested on an OLPC XO laptop.

Cheers,
Lubo


