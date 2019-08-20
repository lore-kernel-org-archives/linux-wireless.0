Return-Path: <SRS0=DLa0=WQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70710C3A589
	for <linux-wireless@archiver.kernel.org>; Tue, 20 Aug 2019 15:48:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4546422CE3
	for <linux-wireless@archiver.kernel.org>; Tue, 20 Aug 2019 15:48:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Kbf+kMP6";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="gIqIv9Uv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730131AbfHTPsW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 20 Aug 2019 11:48:22 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:38152 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726981AbfHTPsW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Aug 2019 11:48:22 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id A8731611FC; Tue, 20 Aug 2019 15:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1566316100;
        bh=kcLnG6SGOwAqgcRa444jSfftWABKGfz3WrSI6wuaJgw=;
        h=From:To:Cc:Subject:Date:From;
        b=Kbf+kMP61wd6RAxyyZtzE7svfOmLPS9l+MRmXiVtffFHJ+OzgqIz+r93dbL2RMZgZ
         7nSf5A/mCT51MCDwSETueHTI87GSMl9H8snMcNvaXaKQBzS1V5DDjlCj8/+nSVFg1n
         qdyE15UGbXC2XoN0gSvsM6zllTiY//8LPiRwUCB0=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C0A0660A42;
        Tue, 20 Aug 2019 15:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1566316099;
        bh=kcLnG6SGOwAqgcRa444jSfftWABKGfz3WrSI6wuaJgw=;
        h=From:To:Cc:Subject:Date:From;
        b=gIqIv9Uv1qCvEAKJ+KSMlnl1CBrAcYd//uv8LxUW9ouWtqmoMTcJtpGg8kNB/NATL
         DiPBvI2PTVdZePfbnkdkQWQlecglDuREJ1GD033fZaHli4x3/84moyKmgo9UWoTuWT
         dAjy9cAhhJvov/nEhHdOjmheur5eGGKs/6CilaTI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C0A0660A42
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     linux-wireless@vger.kernel.org
Cc:     ath11k@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH 00/49] ath11k: driver for Qualcomm IEEE 802.11ax devices
Date:   Tue, 20 Aug 2019 18:47:26 +0300
Message-Id: <1566316095-27507-1-git-send-email-kvalo@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

ath11k is a new driver for Qualcomm IEEE 802.11ax devices, first
supporting only IPQ8074 SoC using the shared memory AHB bus. ath11k
uses mac80211 and supports AP, Station and Mesh modes.

Even though ath11k has some similar code as with ath10k (especially
the WMI layer) it was concluded to be simpler to have a "clean start"
for ath11k code base and not try to share the code with ath10k. This
makes maintenance easier and avoids major changes in ath10k, which
would have significantly increased the risk of regressions in existing
setups.

Even though the driver is very similar with ath10k but there are major
differences as well. The datapath is completely different. ath11k
supports multiple MACs, called "soc" in the firmware interface. And
there's only one WMI interface to support.

Currently ath11k supports only IEEE 802.11ac mode, but patches for
802.11ax are available and they will be submitted after ath11k is
accepted to upstream.

The firmware images are available from ath11k-firmware repository but
they will be also submitted to linux-firmware:

https://github.com/kvalo/ath11k-firmware

The driver has had multiple authors who are listed in alphabetical
order below.

Signed-off-by: Anilkumar Kolli <akolli@codeaurora.org>
Signed-off-by: Bhagavathi Perumal S <bperumal@codeaurora.org>
Signed-off-by: Ganesh Sesetti <gseset@codeaurora.org>
Signed-off-by: Govindaraj Saminathan <gsamin@codeaurora.org>
Signed-off-by: John Crispin <john@phrozen.org>
Signed-off-by: Julia Lawall <julia.lawall@lip6.fr>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Karthikeyan Periyasamy <periyasa@codeaurora.org>
Signed-off-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Maharaja Kennadyrajan <mkenna@codeaurora.org>
Signed-off-by: Manikanta Pubbisetty <mpubbise@codeaurora.org>
Signed-off-by: Miles Hu <milehu@codeaurora.org>
Signed-off-by: Muna Sinada <msinada@codeaurora.org>
Signed-off-by: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
Signed-off-by: Rajkumar Manoharan <rmanohar@codeaurora.org>
Signed-off-by: Sathishkumar Muruganandam <murugana@codeaurora.org>
Signed-off-by: Shashidhar Lakkavalli <slakkavalli@datto.com>
Signed-off-by: Sriram R <srirrama@codeaurora.org>
Signed-off-by: Sven Eckelmann <seckelmann@datto.com>
Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@codeaurora.org>
Signed-off-by: Venkateswara Naralasetty <vnaralas@codeaurora.org>

--------------[cut]-------------------[cut]-----------------

I have split the driver into multiple patches for easier review, but
the final commit will be one big patch and the commit log being the
text before the cut line above.

This version is based on commit b05c1a55a3a566893e15cfc2dc2cc20d476af0d6
from ath11k-bringup branch on my ath.git tree:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/log/?h=ath11k-bringup

This patch applies to wireless-drivers-next but needs
CONFIG_COMPILE_TEST, CONFIG_REMOTEPROC AND CONFIG_QCOM_QMI_HELPERS to
be able to compile on x86.

Please review and comment.

Kalle


