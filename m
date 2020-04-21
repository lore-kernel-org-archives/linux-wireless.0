Return-Path: <SRS0=wZZW=6F=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA2D8C54FCC
	for <linux-wireless@archiver.kernel.org>; Tue, 21 Apr 2020 15:20:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3F39206A5
	for <linux-wireless@archiver.kernel.org>; Tue, 21 Apr 2020 15:20:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbgDUPU0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 21 Apr 2020 11:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726732AbgDUPUZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Apr 2020 11:20:25 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A749C061A10;
        Tue, 21 Apr 2020 08:20:25 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jQuhC-00DWGd-L2; Tue, 21 Apr 2020 17:20:22 +0200
Message-ID: <a8b99311d732d2627d57beb3970fab9cdcd0e4d2.camel@sipsolutions.net>
Subject: how to use skb_postpush_rcsum()?
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Date:   Tue, 21 Apr 2020 17:20:18 +0200
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

This is probably a stupid question but I'm hitting my head against the
wall ...

I have an skb. I have this:


        if (skb->ip_summed == CHECKSUM_COMPLETE) {
                printk(KERN_DEBUG "csum before\n");
                printk(KERN_DEBUG "  hw = 0x%.4x\n", skb->csum);
                printk(KERN_DEBUG "  sw = 0x%.4x\n", csum_fold(skb_checksum(skb, 0, skb->len, 0)));
        }

	ehdr = skb_push(skb, ETH_HLEN);
	memcpy(ehdr, &tmp, ETH_HLEN);
	skb_postpush_rcsum(skb, &tmp, ETH_HLEN);

        if (skb->ip_summed == CHECKSUM_COMPLETE) {
                printk(KERN_DEBUG "csum after\n");
                printk(KERN_DEBUG "  hw = 0x%.4x\n", csum_fold(skb->csum));
                printk(KERN_DEBUG "  sw = 0x%.4x\n", csum_fold(skb_checksum(skb, 0, skb->len, 0)));
        }

Why does this print, for example:

csum before
  hw = 0xce81
  sw = 0xce81
csum after
  hw = 0x5f36
  sw = 0xfc39


I'm clearly doing something wrong, but most of the examples seem to do
things this way, so what I'm I doing wrong?

johannes

