Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50122 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754268Ab0GZSmI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jul 2010 14:42:08 -0400
Received: by pwi5 with SMTP id 5so191874pwi.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Jul 2010 11:42:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1280162044.3492.14.camel@maxim-laptop>
References: <20100528100901.14580.1322.stgit@fate.lan> <1280162044.3492.14.camel@maxim-laptop>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 26 Jul 2010 11:41:47 -0700
Message-ID: <AANLkTikcEpjd_GM8X6YEJ_2Tm4=qnFiz9jz32m1gJg+z@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH] ath5k: disable ASPM
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	"Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	David Quan <David.Quan@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 26, 2010 at 9:34 AM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> Hi,
>
> Just want to summarize and finally put that problem to rest.
>
> Was the patch that removes & sets on CONFIG_PCIEASPM? accepted?
>
> Is it possible to check that all ath5k pcie devices that must not use
> L0s actually have the 'PCI_EXP_DEVCAP_RBER' disabled (this bit causes
> pcie device be marked as legacy, and ASPM is disabled on it)

ASPM should be kept enabled for ath5k but L0s should be disabled, so
that is, only L1 for ASPM should be kept enabled for ath5k for all
ath5k chipsets. Can someone resubmit the simpler patch again on a new
independent thread?

  Luis
