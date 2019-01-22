Return-Path: <SRS0=0pM2=P6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA241C282C3
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 19:37:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B6932085A
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 19:37:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wp.pl header.i=@wp.pl header.b="dutvllHo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725991AbfAVThX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Jan 2019 14:37:23 -0500
Received: from mx3.wp.pl ([212.77.101.10]:60738 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725936AbfAVThX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Jan 2019 14:37:23 -0500
Received: (wp-smtpd smtp.wp.pl 15312 invoked from network); 22 Jan 2019 20:30:40 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1548185441; bh=ntYaFPpt27/qwNRcNnR5edm8IWZaVgmrja7VM6vk5aY=;
          h=From:To:Cc:Subject;
          b=dutvllHo+aM23UjRGsUubHf1RjvFJZNLfJj1Zvm7+M4h/jKilTMYAAXZZXDMkev9C
           WBK/b0Dpn72cDuoqlPq+oNoRPXU0CGQD7r+muKysI8ZzfTjBlowXdAka8TYo0WD9L/
           1IfpIVsFgElxUZW1Qhi5sD+MJTBRCRhKqGsRJgsw=
Received: from 014.152-60-66-biz-static.surewest.net (HELO cakuba.netronome.com) (kubakici@wp.pl@[66.60.152.14])
          (envelope-sender <kubakici@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <lorenzo.bianconi@redhat.com>; 22 Jan 2019 20:30:40 +0100
Date:   Tue, 22 Jan 2019 11:30:36 -0800
From:   Jakub Kicinski <kubakici@wp.pl>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mt7601u: do not use WARN_ON in the datapath
Message-ID: <20190122113036.78b0f063@cakuba.netronome.com>
In-Reply-To: <ea874df744d188833cf8c38261b509ef246f3d5d.1548171270.git.lorenzo.bianconi@redhat.com>
References: <cover.1548171270.git.lorenzo.bianconi@redhat.com>
        <ea874df744d188833cf8c38261b509ef246f3d5d.1548171270.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-MailID: a2ea5d9fde02481697a45b3e7b039d1d
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 000000A [oVM0]                               
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 22 Jan 2019 16:39:34 +0100, Lorenzo Bianconi wrote:
> Substitute WARN_ON with WARN_ON_ONCE in mt7601u_rx_next_seg_len
> routine
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

Acked-by: Jakub Kicinski <kubakici@wp.pl>
