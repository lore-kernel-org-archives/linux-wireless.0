Return-Path: <SRS0=y7Wd=6T=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 266A8C47254
	for <linux-wireless@archiver.kernel.org>; Tue,  5 May 2020 14:15:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D2D52085B
	for <linux-wireless@archiver.kernel.org>; Tue,  5 May 2020 14:15:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729736AbgEEOPI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 5 May 2020 10:15:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729704AbgEEOO5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 May 2020 10:14:57 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5E49C061A0F
        for <linux-wireless@vger.kernel.org>; Tue,  5 May 2020 07:14:57 -0700 (PDT)
Received: from bigeasy by Galois.linutronix.de with local (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1jVyLX-0001Ge-AY; Tue, 05 May 2020 16:14:55 +0200
Date:   Tue, 5 May 2020 16:14:55 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     yhchuang@realtek.com
Cc:     kvalo@codeaurora.org, pkshih@realtek.com,
        linux-wireless@vger.kernel.org, briannorris@chromium.org,
        kevin_yang@realtek.com
Subject: Re: [PATCH 28/40] rtw88: 8723d: Add shutdown callback to disable BT
 USB suspend
Message-ID: <20200505141455.k2mk7tmuiujfv2sh@linutronix.de>
References: <20200417074653.15591-1-yhchuang@realtek.com>
 <20200417074653.15591-29-yhchuang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200417074653.15591-29-yhchuang@realtek.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2020-04-17 15:46:41 [+0800], yhchuang@realtek.com wrote:
> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> Without this patch, wifi card can't initialize properly due to BT in USB
> suspend state. So, we disable BT USB suspend (wakeup) in shutdown callback
> that is the moment before rebooting. To save BT USB power, we can't do this
> in 'remove' callback.

So you can't initialize the USB part because it is in suspend and the
only way to avoid it to disable it on the PCI side. That means you don't
see it enumerated on the USB bus at all?

> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>

Sebastian
