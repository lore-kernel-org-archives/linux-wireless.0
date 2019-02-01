Return-Path: <SRS0=B73O=QI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70ECBC282D8
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 12:28:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C7C12082C
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 12:28:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="HEd3NEsO";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Ud4GYPlO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727438AbfBAM2n (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Feb 2019 07:28:43 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:38764 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbfBAM2n (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Feb 2019 07:28:43 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 483F160590; Fri,  1 Feb 2019 12:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549024122;
        bh=qLb1exFyu4BiUTGkJw2rbHtmE/dXt5Kp6jHnbihCBl4=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=HEd3NEsOboS4NFvZACHCWkfOJOpLotjxvjT5hDzmZ81I7p1gfqeIHT9BBm1FnBe1i
         8HFfqUovhGPDu/5zPU/xXapgCgpYECBr8/jJLie9DmwUyAGccQZKq2tGa0dk3IfEFw
         QVKMQLAN9/CzMXXkp7WP3YhD5UhgLCiEqugmhN80=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 05AA760590;
        Fri,  1 Feb 2019 12:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549024120;
        bh=qLb1exFyu4BiUTGkJw2rbHtmE/dXt5Kp6jHnbihCBl4=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=Ud4GYPlOEbDU3jjZXXHd+eEL8vpHGn4cyhJMHfUDzl3Ti7tzaL+kR41Sdu4McUKNy
         +pogyUtn9WiQgr676gAg81oVzQNC7b/YVeXpdvy7DuLFti0gZzGcd87q7J6L8YP2IB
         zASroD7Ohx22yY92rnVGbNM5fpKHNG9zC198ka7w=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 05AA760590
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mt7601u: bump supported EEPROM version
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1548161274-3335-1-git-send-email-sgruszka@redhat.com>
References: <1548161274-3335-1-git-send-email-sgruszka@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     linux-wireless@vger.kernel.org, Jakub Kicinski <kubakici@wp.pl>,
        Michael <ZeroBeat@gmx.de>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190201122842.483F160590@smtp.codeaurora.org>
Date:   Fri,  1 Feb 2019 12:28:41 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Stanislaw Gruszka <sgruszka@redhat.com> wrote:

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
> Acked-by: Jakub Kicinski <kubakici@wp.pl>

Patch applied to wireless-drivers-next.git, thanks.

3bd1505fed71 mt7601u: bump supported EEPROM version

-- 
https://patchwork.kernel.org/patch/10775455/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

