Return-Path: <SRS0=fyxI=7X=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D8BCC433DF
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Jun 2020 21:37:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FEC22074B
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Jun 2020 21:37:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbgFJVh3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Jun 2020 17:37:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726134AbgFJVh3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Jun 2020 17:37:29 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A851AC03E96B
        for <linux-wireless@vger.kernel.org>; Wed, 10 Jun 2020 14:37:28 -0700 (PDT)
Received: from bigeasy by Galois.linutronix.de with local (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1jj8PQ-00049j-EX; Wed, 10 Jun 2020 23:37:20 +0200
Date:   Wed, 10 Jun 2020 23:37:20 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     yhchuang@realtek.com
Cc:     kvalo@codeaurora.org, kernel@iuliancostan.com,
        linux-wireless@vger.kernel.org, i@outv.im, trevor@shartrec.com
Subject: Re: [PATCH v1] rtw88: pci: disable aspm for platform inter-op with
 module parameter
Message-ID: <20200610213720.3sopcuimas375xl2@linutronix.de>
References: <20200605074703.32726-1-yhchuang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200605074703.32726-1-yhchuang@realtek.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2020-06-05 15:47:03 [+0800], yhchuang@realtek.com wrote:
> From: Yan-Hsuan Chuang <yhchuang@realtek.com>
> 
> Some platforms cannot read the DBI register successfully for the
> ASPM settings. After the read failed, the bus could be unstable,
> and the device just became unavailable [1]. For those platforms,
> the ASPM should be disabled. But as the ASPM can help the driver
> to save the power consumption in power save mode, the ASPM is still
> needed. So, add a module parameter for them to disable it, then
> the device can still work, while others can benefit from the less
> power consumption that brings by ASPM enabled.

Can you set disable_aspm if rtw_dbi_read8() fails? Or make a test if it
is save to use?

If someone notices the warning they still have to search for the warning
in order to make the link towards loading the module with the
disable_aspm=1 paramter.
Is it known what causes the failure?

> [1] https://bugzilla.kernel.org/show_bug.cgi?id=206411
> [2] Note that my lenovo T430 is the same.

Sebastian
