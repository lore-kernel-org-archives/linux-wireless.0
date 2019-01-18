Return-Path: <SRS0=80NG=P2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFFDFC1B0F7
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jan 2019 20:45:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A177B20896
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jan 2019 20:45:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Zy7jpnyw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729506AbfARUpg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 18 Jan 2019 15:45:36 -0500
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:37816 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729488AbfARUpf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Jan 2019 15:45:35 -0500
X-Greylist: delayed 544 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Jan 2019 15:45:35 EST
Received: from mail-irv-17.broadcom.com (mail-irv-17.lvn.broadcom.net [10.75.224.233])
        by rnd-relay.smtp.broadcom.com (Postfix) with ESMTP id BCAE930C070;
        Fri, 18 Jan 2019 12:36:29 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.10.3 rnd-relay.smtp.broadcom.com BCAE930C070
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1547843789;
        bh=pYlJs+kQkX35A/cV5ccw+kYSaD92joevZsKFUdDkVBc=;
        h=From:To:Cc:Subject:Date:From;
        b=Zy7jpnywA2ikmm3yqSVUar+MCTEJCrsY4zD41GzQl2h07gzM1GIhhbmSx39VrHxlB
         voWI8t2FBppTztiIj7dbUR98Qh3wsRU0yjzFTQYD2/uA/y9UPFB4Hm/UFz/VcasQue
         EZG4SD06N8TKRkSJP376CX0toADphsi2zioEq7JE=
Received: from bld-bun-01.bun.broadcom.com (bld-bun-01.bun.broadcom.com [10.176.128.83])
        by mail-irv-17.broadcom.com (Postfix) with ESMTP id F2B3F81EBF;
        Fri, 18 Jan 2019 12:36:29 -0800 (PST)
Received: by bld-bun-01.bun.broadcom.com (Postfix, from userid 25152)
        id 5E349B02A4B; Fri, 18 Jan 2019 21:36:27 +0100 (CET)
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [REGRESSION] hostapd 2.4..2.7 broken with 4.18+
Date:   Fri, 18 Jan 2019 21:36:17 +0100
Message-Id: <1547843777-20189-1-git-send-email-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 1/17/2019 11:03 AM, Russell King - ARM Linux admin wrote:> On Wed, Jan 16, 2019 at 02:21:32PM +0100, Arend Van Spriel wrote:
>> The patch below works for me so can you provide the counters file contents
>> after hitting the issue.
> 
> Okay, with the patch fixed, it seems to have failed last night for some
> reason... I'm not sure exactly when it died, possibly about an hour
> after bringing it up.  Here's the full log.

Sorry for the somewhat late response. I wanted to discuss the log with
firmware engineer. Can you tell how many stations were connected to this
AP before and/or when it died? What does "died" mean? From the log I can
only conclude the firmware is not crashing. So I assume by "died" you
mean no data is successfully exchanged between hostapd and stations. This
is probably due to the failing send_key_to_dongle. Could you try the patch
below to be sure about the key configuration that fails.

Regards,
Arend
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index a62c48d..d43d4c0 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -460,6 +460,8 @@ static void convert_key_from_CPU(struct brcmf_wsec_key *key,
 	int err;
 	struct brcmf_wsec_key_le key_le;
 
+	brcmf_err("idx %d algo %d flags %x\n",
+		  key->index, key->algo, key->flags);
 	convert_key_from_CPU(key, &key_le);
 
 	brcmf_netdev_wait_pend8021x(ifp);
-- 
1.9.1

