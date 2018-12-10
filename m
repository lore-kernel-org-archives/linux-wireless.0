Return-Path: <SRS0=yVm+=OT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2DB7C04EB8
	for <linux-wireless@archiver.kernel.org>; Mon, 10 Dec 2018 09:15:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7BCF42081F
	for <linux-wireless@archiver.kernel.org>; Mon, 10 Dec 2018 09:15:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="VLwjB9+C"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7BCF42081F
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726804AbeLJJPL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 10 Dec 2018 04:15:11 -0500
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:53874 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726667AbeLJJPL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Dec 2018 04:15:11 -0500
Received: from mail-irv-17.broadcom.com (mail-irv-17.lvn.broadcom.net [10.75.224.233])
        by rnd-relay.smtp.broadcom.com (Postfix) with ESMTP id B164530C026;
        Mon, 10 Dec 2018 01:15:09 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.10.3 rnd-relay.smtp.broadcom.com B164530C026
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1544433309;
        bh=oCpMpjTwH0p3bvRMdbqhAiCyZd2zxFllzEVJMAGCRJY=;
        h=From:To:Cc:Subject:Date:From;
        b=VLwjB9+CJkryM6xdNbHc8bn/yVihGa0dN0zr9DavlqznPxu02/GnsXK9ZgAuGTl3g
         Q8q2A/lsuAVrgNbkKHSX5SIf2G1r09BW8rnQEaBDsFS3qf2OPa7sfXIuPpPCkq+H3S
         Y7csyLw+kmzJHULXY9D8iVcCP58Jjp75P1B0Y+z0=
Received: from bld-bun-01.bun.broadcom.com (bld-bun-01.bun.broadcom.com [10.176.128.83])
        by mail-irv-17.broadcom.com (Postfix) with ESMTP id 497C281EC4;
        Mon, 10 Dec 2018 01:15:09 -0800 (PST)
Received: by bld-bun-01.bun.broadcom.com (Postfix, from userid 25152)
        id CAD57B02B24; Mon, 10 Dec 2018 10:15:03 +0100 (CET)
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
To:     linux-firmware@kernel.org
Cc:     linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 0/2] brcm: new firmware for BCM4366 chip family
Date:   Mon, 10 Dec 2018 10:14:52 +0100
Message-Id: <1544433294-6997-1-git-send-email-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This series includes the firmwares for the BCM4366 3x3 802.11ac chipset.
The firmware for the bcm4366c0 has been long overdue.

I did submit the firmware files early November in a single patch, but
probably hit the majordomo limit of 100,000 character with it. So here
is the 2nd attempt.

These patches apply to the master branch of the linux-firmware repository.

Regards,
Arend

Arend van Spriel (2):
  brcm: provide new firmware for BCM4366B chipset
  brcm: provide new firmware for BCM4366C chipset

 brcm/brcmfmac4366b-pcie.bin | Bin 989401 -> 1105361 bytes
 brcm/brcmfmac4366c-pcie.bin | Bin 0 -> 1120971 bytes
 2 files changed, 0 insertions(+), 0 deletions(-)
 rewrite brcm/brcmfmac4366b-pcie.bin (70%)
 create mode 100644 brcm/brcmfmac4366c-pcie.bin

-- 
1.9.1

