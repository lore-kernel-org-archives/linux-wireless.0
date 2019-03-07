Return-Path: <SRS0=M0/e=RK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51A76C43381
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Mar 2019 18:01:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B200920851
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Mar 2019 18:01:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wp.pl header.i=@wp.pl header.b="u88TEgKV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbfCGSBU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Mar 2019 13:01:20 -0500
Received: from mx4.wp.pl ([212.77.101.12]:17603 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726166AbfCGSBT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Mar 2019 13:01:19 -0500
Received: (wp-smtpd smtp.wp.pl 11664 invoked from network); 7 Mar 2019 19:01:15 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1551981676; bh=kA5w1g7mdU4EYT/qZxSiYA+T14VnNozxugsyovn8yT4=;
          h=From:To:Cc:Subject;
          b=u88TEgKVtIeB6lYUhwZU1DwzoUUfeE2utvHtnN+UbAT1qZk5Do/TpkgP2F1OZiL/w
           jlUJyJnFQ5EMpz9t+IbJTTG7Am7tScKq7JQEWZOXMXEjxinFMvxo5e5/BgMAXSPCNR
           Kf9o1dLxRE+gLdsy/pwWhV+ufMwq1JpN7yGwjHFU=
Received: from 014.152-60-66-biz-static.surewest.net (HELO cakuba.hsd1.ca.comcast.net) (kubakici@wp.pl@[66.60.152.14])
          (envelope-sender <kubakici@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <sgruszka@redhat.com>; 7 Mar 2019 19:01:15 +0100
Date:   Thu, 7 Mar 2019 10:01:04 -0800
From:   Jakub Kicinski <kubakici@wp.pl>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     linux-wireless@vger.kernel.org,
        Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH v2] mt7601u: check chip version on probe
Message-ID: <20190307100104.17d4d0b8@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <1551961327-28912-1-git-send-email-sgruszka@redhat.com>
References: <1551961327-28912-1-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-MailID: 1d40169670a4286d17ef0fafb977507c
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [cSPU]                               
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu,  7 Mar 2019 13:22:07 +0100, Stanislaw Gruszka wrote:
> Since some USB device IDs are duplicated between mt7601u and mt76x0u
> devices, check chip version on probe and return error if not match
> 0x7601.
> 
> Don't think this is serious issue, probe most likely will fail at
> some other point for wrong device, but we do not have to configure
> it if we know is not mt7601u device.
> 
> Reported-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Acked-by: Jakub Kicinski <kubakici@wp.pl>

Thanks!
