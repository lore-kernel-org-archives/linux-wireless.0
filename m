Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26F05C55ABD
	for <linux-wireless@archiver.kernel.org>; Fri, 13 Nov 2020 21:32:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D89C02224F
	for <linux-wireless@archiver.kernel.org>; Fri, 13 Nov 2020 21:32:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="zLBSch94";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="5+vILlEW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbgKMVcD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 13 Nov 2020 16:32:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbgKMVbx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Nov 2020 16:31:53 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13DD4C0613D1
        for <linux-wireless@vger.kernel.org>; Fri, 13 Nov 2020 13:23:12 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1605302591;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=l7Ux3+dzzmysyo4d9CcDf0GWpIIghvt+p7nFSYmjG+U=;
        b=zLBSch94QkNMLP61QQn2RPcK9/n+kemmPKrxDfvBPppgrEukom1ZqfVSc2vU3MOAmehvda
        VoykvCkFg/8jtivIN4TRcYw/OFTR2so4Ei6zDtPqWdOmMILXs0y59AT0VHFD5l0bz2ZJ+i
        o77YOqVIUcp3DIjKoLl1UqyZue8xlkeWyI5YsgQz64Rxpvg1J5ULj67fFod/kgsWYrIFgj
        729bE8VbfIDeLatUXsdTS/L4271mPPirJ3Jrx3c1jLqyZvi9OTqmiofCIP/DlSoVo7P0WC
        awdDqbZLV3YIoX0fWzR5qKNp/0OjhlmaxIqDfUwGFb/8u/1r6QsTqvOBRpOnew==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1605302591;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=l7Ux3+dzzmysyo4d9CcDf0GWpIIghvt+p7nFSYmjG+U=;
        b=5+vILlEW686/M8PBGM+VMwG83DuHB9ZBEumppd8Yy3t4RnNI2iBY6LtAWhVo38jwGmgDdG
        +wscUK79GpWFdMDg==
To:     linux-wireless@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        Dan Williams <dcbw@redhat.com>,
        Jes Sorensen <jes.sorensen@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 00/10] orinoco: Remove in_interrupt() usage.
Date:   Fri, 13 Nov 2020 22:22:42 +0100
Message-Id: <20201113212252.2243570-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

this series removes the in_interrupt() usage in the orinoco driver which
is the last one in drivers/net.

The series preserves the current status based on the context I saw
during the review.

The proper way dealing with this would be to use a mutex_t as another
lock and split the current usage of orinoco_lock() and push some of the
callers into a worker where an immediate answer is not needed. This
would allow to always block on the completion and so avoid the polling.

The problem with the current approach / polling in BH context is that
USB HCDs which marked with HCD_BH (EHCI/XHCI) will complete the URB in
tasklet/BH context. The URB's callback (that part that completes
completion which is being polled for) will obviously not be invoked if
the driver polls with the orinoco_private::lock acquired which disables
BH. The only way it may work is if the USB HCD does not set HCD_BH or
the HCD IRQ fires on a different CPU.

A lot of the "BH" usage comes from the orinoco_lock(). The other callers
are fully preemtible. I didn't look how many of the callers, that
disable BH via orinoco_lock(), are already in atomic context due to
another lock, timer or so. I'm afraid I make it worse by missing
something subtle. This might still work on a OHCI/UHCI controller.

Sebastian
