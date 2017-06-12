Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:58600 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754195AbdFLPgn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Jun 2017 11:36:43 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v3] ath10k: Define structures for CE ctrl/misc register
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1496739941-18132-1-git-send-email-c_sgarna@qti.qualcomm.com>
References: <1496739941-18132-1-git-send-email-c_sgarna@qti.qualcomm.com>
To: Sarada Prasanna Garnayak <c_sgarna@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>,
        Sarada Prasanna Garnayak <c_sgarna@qti.qualcomm.com>,
        <linux-wireless@vger.kernel.org>
Message-ID: <a383aa68b0c744e186e0b7e98b78446b@eusanexr01a.eu.qualcomm.com> (sfid-20170612_182752_641910_891ED035)
Date: Mon, 12 Jun 2017 08:36:17 -0700
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sarada Prasanna Garnayak <c_sgarna@qti.qualcomm.com> wrote:

> Define structures for the copy engine ctrl/misc registers,
> that includes CE CMD halt, watermark source, watermark destination,
> host IE ring, source, destination and dmax ring.
> 
> This adds support to avoid the conditional compilation,
> code optimization and dynamic configuration of the copy engine
> register map for respective hardware bus interface.
> 
> Signed-off-by: Sarada Prasanna Garnayak <c_sgarna@qti.qualcomm.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Like kbuild test robot reported, this failed to build. I fixed it like this in
ahb.c in pending branch:

	ar_pci->bus_ops = &ath10k_ahb_bus_ops;

-- 
https://patchwork.kernel.org/patch/9768317/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
