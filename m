Return-Path: <SRS0=yCjx=UG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32420C2BCA1
	for <linux-wireless@archiver.kernel.org>; Fri,  7 Jun 2019 17:07:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E894F208C3
	for <linux-wireless@archiver.kernel.org>; Fri,  7 Jun 2019 17:07:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wp.pl header.i=@wp.pl header.b="wOnjKo/s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729983AbfFGRHu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 7 Jun 2019 13:07:50 -0400
Received: from mx3.wp.pl ([212.77.101.10]:45263 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728989AbfFGRHu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Jun 2019 13:07:50 -0400
Received: (wp-smtpd smtp.wp.pl 1711 invoked from network); 7 Jun 2019 19:07:47 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1559927268; bh=7hyXnxTgb+Lex34tVPKUq4v+Bm01NeIG4M56AvblYqU=;
          h=From:To:Cc:Subject;
          b=wOnjKo/s0J5cO6xXF9SxjaqwR5Yw+BBsDPP9mUGKs5NSmw8vi2FE1qmG7qZ4YZmSi
           rpqN5INkzXk+aZ1WHOv0rg6OKVYsOgbtCYZUkZBz9nJBRKF67+iM4oCzAxE9LBxgZv
           ImWqtEV1fpTiryj/S6U+UXyAGsYj7ULsg3V9/WIg=
Received: from unknown (HELO cakuba.netronome.com) (kubakici@wp.pl@[156.39.10.47])
          (envelope-sender <kubakici@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <lorenzo@kernel.org>; 7 Jun 2019 19:07:47 +0200
Date:   Fri, 7 Jun 2019 10:07:43 -0700
From:   Jakub Kicinski <kubakici@wp.pl>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     linux-wireless@vger.kernel.org, lorenzo.bianconi@redhat.com
Subject: Re: [PATCH v2 0/2] mt7601u: do not schedule {rx,tx}_tasklet when
 the device has been disconnected
Message-ID: <20190607100743.3d137d5f@cakuba.netronome.com>
In-Reply-To: <cover.1559906499.git.lorenzo@kernel.org>
References: <cover.1559906499.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-MailID: 05bb39548d98dbc18d43904952ce69a4
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [gePE]                               
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri,  7 Jun 2019 13:48:08 +0200, Lorenzo Bianconi wrote:
> Do not schedule {tx,rx}_tasklet when the usb dongle is disconnected in order to fix
> {TX,RX} urb mismatch warning
> Fix possible memory leak when the device is disconnected while passing traffic.

Acked-by: Jakub Kicinski <kubakici@wp.pl>

Thanks Lorenzo!
