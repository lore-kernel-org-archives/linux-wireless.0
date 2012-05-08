Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:41174 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756695Ab2EHRAa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 May 2012 13:00:30 -0400
MIME-Version: 1.0
In-Reply-To: <20120508140555.GA4412@redhat.com>
References: <1336079364-16222-1-git-send-email-wey-yi.w.guy@intel.com>
	<20120508140555.GA4412@redhat.com>
Date: Tue, 8 May 2012 20:00:29 +0300
Message-ID: <CANUX_P3V6-sGO5+nmRA7b5wq-tDujs5gZtkrJQj_w29wD1tunQ@mail.gmail.com> (sfid-20120508_190036_079514_4E375831)
Subject: Re: [PATCH 3.4] iwlwifi: fix a potential race in receive buffer allocation
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org,
	Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>,
	stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> This patch make no sense. Nothing stops compiler or CPU to write
> ->page into memory before ->page_dma .
>

I thought that too,but  the call to dma_map... is a call to functon.
Shouldn't force the compiler the make things in order. Or maybe the
assignment to rxb->page_dma can be reordered... I am not really sure.
