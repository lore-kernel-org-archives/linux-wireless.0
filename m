Return-Path: <SRS0=0pM2=P6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EAE6C282C3
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 19:37:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A102A2085A
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 19:37:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wp.pl header.i=@wp.pl header.b="n9L9iWMK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725991AbfAVThN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Jan 2019 14:37:13 -0500
Received: from mx3.wp.pl ([212.77.101.9]:58907 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725925AbfAVThM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Jan 2019 14:37:12 -0500
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Jan 2019 14:37:11 EST
Received: (wp-smtpd smtp.wp.pl 31984 invoked from network); 22 Jan 2019 20:30:31 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1548185431; bh=onorsRyAFeBAIA9gD05poPTsCUq7I2rXIEu0lu7y5Yw=;
          h=From:To:Cc:Subject;
          b=n9L9iWMKZULRWilGiMr9Ou5Q8w445TG5JHGp548DQstaLCChxf38BjnRs0eoKHeo3
           +l276tpA1I7xwAwxkOSq3LZ0sLkmmPHfp+wMQDuuVHexCMeSBTsguXqdWsDqeRit9t
           VQ4MIpQA/7N4Xt21ZjPZVhkanPXCPFeqSF4d/ezs=
Received: from 014.152-60-66-biz-static.surewest.net (HELO cakuba.netronome.com) (kubakici@wp.pl@[66.60.152.14])
          (envelope-sender <kubakici@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <sgruszka@redhat.com>; 22 Jan 2019 20:30:31 +0100
Date:   Tue, 22 Jan 2019 11:30:26 -0800
From:   Jakub Kicinski <kubakici@wp.pl>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     linux-wireless@vger.kernel.org, Michael <ZeroBeat@gmx.de>
Subject: Re: [PATCH] mt7601u: bump supported EEPROM version
Message-ID: <20190122113026.48e9fa81@cakuba.netronome.com>
In-Reply-To: <1548161274-3335-1-git-send-email-sgruszka@redhat.com>
References: <1548161274-3335-1-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-MailID: 019f033adf3cfdf21b9ee78e4a3a392b
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [cVNV]                               
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 22 Jan 2019 13:47:54 +0100, Stanislaw Gruszka wrote:
> As reported by Michael eeprom 0d is supported and work with the driver.
> 
> Dump of /sys/kernel/debug/ieee80211/phy1/mt7601u/eeprom_param
> with 0d EEPORM looks like this:
> 
> RSSI offset: 0 0
> Reference temp: f9
> LNA gain: 8
> Reg channels: 1-14
> Per rate power:
> 	 raw:05 bw20:05 bw40:05
> 	 raw:05 bw20:05 bw40:05
> 	 raw:03 bw20:03 bw40:03
> 	 raw:03 bw20:03 bw40:03
> 	 raw:04 bw20:04 bw40:04
> 	 raw:00 bw20:00 bw40:00
> 	 raw:00 bw20:00 bw40:00
> 	 raw:00 bw20:00 bw40:00
> 	 raw:02 bw20:02 bw40:02
> 	 raw:00 bw20:00 bw40:00
> Per channel power:
> 	 tx_power  ch1:09 ch2:09
> 	 tx_power  ch3:0a ch4:0a
> 	 tx_power  ch5:0a ch6:0a
> 	 tx_power  ch7:0b ch8:0b
> 	 tx_power  ch9:0b ch10:0b
> 	 tx_power  ch11:0b ch12:0b
> 	 tx_power  ch13:0b ch14:0b
> 
> Reported-and-tested-by: Michael <ZeroBeat@gmx.de>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Acked-by: Jakub Kicinski <kubakici@wp.pl>
