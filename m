Return-Path: <SRS0=jAIi=VI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26F3AC74A4B
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Jul 2019 09:05:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0A6720872
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Jul 2019 09:05:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="DuWF8zM4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728177AbfGKJFX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Jul 2019 05:05:23 -0400
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:59742 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725963AbfGKJFW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Jul 2019 05:05:22 -0400
Received: from mail-irv-17.broadcom.com (mail-irv-17.lvn.broadcom.net [10.75.224.233])
        by rnd-relay.smtp.broadcom.com (Postfix) with ESMTP id 25D6130C002;
        Thu, 11 Jul 2019 02:05:21 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 rnd-relay.smtp.broadcom.com 25D6130C002
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1562835921;
        bh=g/LMgTPx7L1+ZSVVf/Oczyafq1NFh+aHznOCzuuukKI=;
        h=From:To:Cc:Subject:Date:From;
        b=DuWF8zM4IIHXvDvsbHhl6BybBzpHA+B7YLV1NLiHUVon4OblNrajkhu4waQlhLKQe
         +mD2saXtpvCejWLq+lqYPevJL2HevUkSDS4yt5y0exJ6nmu1ZeVUmg8MWD4rw5gBVz
         eqpsk+EOBNsIkUhHgJ/qThf0syOHIAFyqe2jjR80=
Received: from bld-bun-01.bun.broadcom.com (bld-bun-01.bun.broadcom.com [10.176.128.83])
        by mail-irv-17.broadcom.com (Postfix) with ESMTP id 1FD5760D22;
        Thu, 11 Jul 2019 02:05:21 -0700 (PDT)
Received: by bld-bun-01.bun.broadcom.com (Postfix, from userid 25152)
        id BAAC7B03087; Thu, 11 Jul 2019 11:05:19 +0200 (CEST)
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 0/7] brcmfmac: rework probe/attach sequence
Date:   Thu, 11 Jul 2019 11:05:05 +0200
Message-Id: <1562835912-1404-1-git-send-email-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The brcmfmac driver spews some error message upon unloading and Stefan
Wahren was wondering whether it could be cleaned up. Related to this
was a recent fix for NULL pointer deref. That fix introduced a construct
that added to the itch to rework the probe sequence. So this series
reverts commit 5cdb0ef6144f ("brcmfmac: fix NULL pointer derefence during
USB disconnect").

The changes in this series are:
 * reorder brcmf_detach() code.
 * avoid firmware interaction when bus is down.
 * remove strlcpy() before issueing firmware version iovar.

This series applies to the master branch of the wireless-drivers-next
repository.

Arend van Spriel (7):
  Revert "brcmfmac: fix NULL pointer derefence during USB disconnect"
  brcmfmac: change the order of things in brcmf_detach()
  brcmfmac: avoid firmware command in brcmf_netdev_open() when bus is
    down
  brcmfmac: clear events in brcmf_fweh_detach() will always fail
  brcmfmac: avoid firmware commands when bus is down
  brcmfmac: simply remove flowring if bus is down
  brcmfmac: remove unnecessary strlcpy() upon obtaining "ver" iovar

 .../wireless/broadcom/brcm80211/brcmfmac/bcdc.c    | 11 ++------
 .../wireless/broadcom/brcm80211/brcmfmac/bcdc.h    |  6 ++---
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 23 +++++++++--------
 .../wireless/broadcom/brcm80211/brcmfmac/common.c  |  1 -
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    | 30 +++++++++++-----------
 .../wireless/broadcom/brcm80211/brcmfmac/fweh.c    |  9 -------
 .../broadcom/brcm80211/brcmfmac/fwsignal.c         | 16 +++---------
 .../broadcom/brcm80211/brcmfmac/fwsignal.h         |  3 +--
 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  |  7 +++++
 .../wireless/broadcom/brcm80211/brcmfmac/proto.c   | 10 ++------
 .../wireless/broadcom/brcm80211/brcmfmac/proto.h   |  3 +--
 11 files changed, 47 insertions(+), 72 deletions(-)

--
1.9.1

