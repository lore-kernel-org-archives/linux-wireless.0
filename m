Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DBD0C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 12:44:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52E41218FF
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 12:44:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="fWJle52D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392568AbfBNMoM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 07:44:12 -0500
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:48224 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389280AbfBNMoL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 07:44:11 -0500
Received: from mail-irv-17.broadcom.com (mail-irv-17.lvn.broadcom.net [10.75.224.233])
        by rnd-relay.smtp.broadcom.com (Postfix) with ESMTP id C06C694A34;
        Thu, 14 Feb 2019 04:44:09 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.10.3 rnd-relay.smtp.broadcom.com C06C694A34
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1550148249;
        bh=McyfVtwCk9tAhTATvsy2elMx6Enq7O088IW/oOig4VA=;
        h=From:To:Cc:Subject:Date:From;
        b=fWJle52Dnl/nCrC2cOCdJ8C4b4dEsurzxyBkz8C7QK1d5a3gk8xVOTG0IJ1N0AN3Z
         G3lUVa+juyzvMLES5LYrJFa9rqDP3+2RYObRxAlTLUhVA85ITMIvNomu+4hX5RWCKr
         XhVxCVKAGYDWeJxAGZr3lzHhVFwuNo/JjqWCSo6E=
Received: from bld-bun-01.bun.broadcom.com (bld-bun-01.bun.broadcom.com [10.176.128.83])
        by mail-irv-17.broadcom.com (Postfix) with ESMTP id 3DFDF81EBF;
        Thu, 14 Feb 2019 04:44:10 -0800 (PST)
Received: by bld-bun-01.bun.broadcom.com (Postfix, from userid 25152)
        id DDC84B02AF4; Thu, 14 Feb 2019 13:44:08 +0100 (CET)
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 0/6] brcmfmac: smallish series
Date:   Thu, 14 Feb 2019 13:43:46 +0100
Message-Id: <1550148232-4309-1-git-send-email-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Few fixes that got under my TODO rug. The patches apply on top of the
error logging patch that Rafał submitted earlier.

The series applies to the master branch of the wireless-drivers-next
repository.

Arend van Spriel (6):
  brcmfmac: assure SSID length from firmware is limited
  brcmfmac: add subtype check for event handling in data path
  brcmfmac: create debugfs files for bus-specific layer
  brcmfmac: disable MBSS feature for bcm4330 device
  brcmfmac: check and dump trap info during sdio probe
  brcmfmac: use chipname in brcmf_fw_alloc_request() for error path as
    well

 .../net/wireless/broadcom/brcm80211/brcmfmac/bus.h | 10 +++
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |  2 +
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |  6 +-
 .../wireless/broadcom/brcm80211/brcmfmac/feature.c | 10 ++-
 .../broadcom/brcm80211/brcmfmac/firmware.c         |  6 +-
 .../wireless/broadcom/brcm80211/brcmfmac/fweh.h    | 16 +++--
 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  |  2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    | 71 ++++++++++++++--------
 8 files changed, 87 insertions(+), 36 deletions(-)

--
1.9.1

