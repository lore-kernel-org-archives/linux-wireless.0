Return-Path: <SRS0=6FTc=OM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20393C04EB9
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 18:56:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6FD56208A3
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 18:56:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wp.pl header.i=@wp.pl header.b="JaVHyvn6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6FD56208A3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=wp.pl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726972AbeLCS4G (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 3 Dec 2018 13:56:06 -0500
Received: from mx4.wp.pl ([212.77.101.12]:56751 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726937AbeLCS4G (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Dec 2018 13:56:06 -0500
Received: (wp-smtpd smtp.wp.pl 29077 invoked from network); 3 Dec 2018 19:56:00 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1543863361; bh=mCBMbUijo/Yvb8Fw8wUKY7mw5kUvXIL/Kc1FawogES0=;
          h=From:To:Cc:Subject;
          b=JaVHyvn6Ue/rRHlWJa7JFDztZEQhAJDNwn0u9R0REJ+nD4jaH63gFu1fvpePpdExT
           2Z97CErDWtvoQtkGwqmT7BR+A41fGx/8Dm/6XXs9Ghz8y4dYhWfKn6xzZZiM7oX6j2
           /KsXlv9vK93SCsq5JXDLz+wYNRV4fx3tdmV/u0rs=
Received: from c-73-162-4-14.hsd1.ca.comcast.net (HELO cakuba.netronome.com) (kubakici@wp.pl@[73.162.4.14])
          (envelope-sender <kubakici@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <tiny.windzz@gmail.com>; 3 Dec 2018 19:56:00 +0100
Date:   Mon, 3 Dec 2018 10:55:54 -0800
From:   Jakub Kicinski <kubakici@wp.pl>
To:     Yangtao Li <tiny.windzz@gmail.com>
Cc:     davem@davemloft.net, matthias.bgg@gmail.com, nbd@nbd.name,
        lorenzo.bianconi@redhat.com, joe@perches.com, sgruszka@redhat.com,
        kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH] mt76: convert to DEFINE_SHOW_ATTRIBUTE
Message-ID: <20181203105554.2c40d574@cakuba.netronome.com>
In-Reply-To: <20181203134028.12645-1-tiny.windzz@gmail.com>
References: <20181203134028.12645-1-tiny.windzz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-MailID: 8caf814412f4534c7359652eb3a5eb94
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 000000A [scO0]                               
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon,  3 Dec 2018 08:40:28 -0500, Yangtao Li wrote:
> Use DEFINE_SHOW_ATTRIBUTE macro to simplify the code.
> 
> Signed-off-by: Yangtao Li <tiny.windzz@gmail.com>

Acked-by: Jakub Kicinski <kubakici@wp.pl>
