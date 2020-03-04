Return-Path: <SRS0=7/HX=4V=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D4A0C3F2CD
	for <linux-wireless@archiver.kernel.org>; Wed,  4 Mar 2020 10:21:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75FEE2146E
	for <linux-wireless@archiver.kernel.org>; Wed,  4 Mar 2020 10:21:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728953AbgCDKVy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 4 Mar 2020 05:21:54 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:46571 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728301AbgCDKVy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Mar 2020 05:21:54 -0500
Received: from bigeasy by Galois.linutronix.de with local (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1j9RA0-0000XK-BK; Wed, 04 Mar 2020 11:21:52 +0100
Date:   Wed, 4 Mar 2020 11:21:52 +0100
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     linux-wireless@vger.kernel.org
Subject: Re: Support for RTL8188FU
Message-ID: <20200304102152.a25cczvat2mujxwa@linutronix.de>
References: <20191001160305.qrl4nt2jmdsogaaz@linutronix.de>
 <3af284c7-ee46-dd42-9549-de55feae2528@lwfinger.net>
 <20191001174612.4kj3mt3h5epidyyk@linutronix.de>
 <b958b669-a683-d7cd-6bbf-bfe3e674f62d@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b958b669-a683-d7cd-6bbf-bfe3e674f62d@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2019-10-01 13:52:30 [-0500], Larry Finger wrote:
> The first thing I would do is clone the v5.2.2.4 branch of
> lwfinger/rtl8188eu at GitHub, add the USB ID for your device, and see if
> that works. I expect it will. If so, that would get you quite a ways toward
> the changes needed to get that driver into staging.

Adding the id didn't help. I added "hal/Hal8188FPwrSeq.o" next to
"hal/Hal8188EPwrSeq.o". Some parts were different.
After loading the firmware the driver said that the firmware wasn't
active. So I tweaked the firmware loading part a little. The signature
of the firmware in my driver is 0x88F0 instead of 0x88E0 and the
"normal-nic" firmware has 20306 bytes. By loading the "other" firmware
the firmware and driver says that it is "alive".
I disabled the "IOL" bits (like rtw_IOL_applied() which returns false).
It took long and didn't seem to succeed. My driver lacks most of the
code, rtw_IOL_applied() isn't referenced anyway and the ifdef isn't set.

I would continue to add more pieces in order to get it working unless
you have a different advice.

> Larry

Sebastian
