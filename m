Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:51874 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946556Ab2LFTfe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 14:35:34 -0500
Received: by mail-wi0-f180.google.com with SMTP id hj13so820841wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 06 Dec 2012 11:35:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1354815611-7220-1-git-send-email-nbd@openwrt.org>
References: <1354815611-7220-1-git-send-email-nbd@openwrt.org>
Date: Thu, 6 Dec 2012 11:35:33 -0800
Message-ID: <CAJ-Vmonvo9tq4ZF8WosnXNQq=ArqoDuKtz5y8UnFoWfYAikMxQ@mail.gmail.com> (sfid-20121206_203538_116399_9C37BFBB)
Subject: Re: [PATCH] Revert "ath9k_hw: Update AR9003 high_power tx gain table"
From: Adrian Chadd <adrian@freebsd.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@qca.qualcomm.com, rmanohar@qca.qualcomm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6 December 2012 09:40, Felix Fietkau <nbd@openwrt.org> wrote:
> This reverts commit f74b9d365ddd33a375802b064f96a5d0e99af7c0.
>
> Turns out reverting commit a240dc7b3c7463bd60cf0a9b2a90f52f78aae0fd
> "ath9k_hw: Updated AR9003 tx gain table for 5GHz" was not enough to
> bring the tx power back to normal levels on devices like the
> Buffalo WZR-HP-G450H, this one needs to be reverted as well.
>
> This revert improves tx power by ~10 db on that device

Did anyone figure out why this was happening?

Maybe we should look at the HAL commits around the same time to see if
someone changed the programming - eg, assuming TPC is always on, or
the 2 stream / 3 stream reduction PHY register, or such.



Adrian
