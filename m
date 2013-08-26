Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:53099 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022Ab3HZK2M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Aug 2013 06:28:12 -0400
Received: by mail-lb0-f182.google.com with SMTP id r12so1280923lbi.13
        for <linux-wireless@vger.kernel.org>; Mon, 26 Aug 2013 03:28:11 -0700 (PDT)
Date: Mon, 26 Aug 2013 12:27:59 +0200
From: Tobias Waldekranz <tobias@waldekranz.com>
To: linux-wireless@vger.kernel.org
Subject: sd8787 (mwifiex) on big endian system
Message-ID: <20130826102759.GA14350@gmail.com> (sfid-20130826_122815_954971_68E4B954)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As the subject suggests, I am trying to use the SD8787 on a PPC
system. I have found a few endian related issues (submitted a few
hours ago), but it is still not working.

So my first question, has anyone successfully used an mwifiex device
on a big endian system?

Also, I have found that the chip seems to signal interrupts before its
internal registers are in a consistent state. Specifically, the
sdio_ireg and wr_bitmask seems to be out of sync. Inserting a small
delay in mwifiex_interrupt_status (sdio.c), currently 50 us solves the
problem. Is there some bit that should be polled here to make sure that
the registers are in a consistent state?
