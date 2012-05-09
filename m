Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4778 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753452Ab2EIHxf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 May 2012 03:53:35 -0400
Date: Wed, 9 May 2012 09:53:34 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org,
	Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH 3.4] iwlwifi: fix a potential race in receive buffer
 allocation
Message-ID: <20120509075333.GA2363@redhat.com> (sfid-20120509_095342_522566_E0625C49)
References: <1336079364-16222-1-git-send-email-wey-yi.w.guy@intel.com>
 <20120508140555.GA4412@redhat.com>
 <CANUX_P3V6-sGO5+nmRA7b5wq-tDujs5gZtkrJQj_w29wD1tunQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CANUX_P3V6-sGO5+nmRA7b5wq-tDujs5gZtkrJQj_w29wD1tunQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 08, 2012 at 08:00:29PM +0300, Emmanuel Grumbach wrote:
> >
> > This patch make no sense. Nothing stops compiler or CPU to write
> > ->page into memory before ->page_dma .
> >
> 
> I thought that too,but  the call to dma_map... is a call to functon.
> Shouldn't force the compiler the make things in order. Or maybe the
> assignment to rxb->page_dma can be reordered... I am not really sure.

Calling a non lock/unlock function does not make any guarantees about
ordering.

Stanislaw
