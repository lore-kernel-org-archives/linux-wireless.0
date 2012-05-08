Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:34067 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753087Ab2EHSeH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 May 2012 14:34:07 -0400
From: "Venkataraman, Meenakshi" <meenakshi.venkataraman@intel.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
CC: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH 3.4] iwlwifi: fix a potential race in receive buffer
 allocation
Date: Tue, 8 May 2012 18:34:05 +0000
Message-ID: <4595B4D22AB93C4FABBA84AAD5AA37FD156BE6@ORSMSX103.amr.corp.intel.com> (sfid-20120508_203412_549171_0399A4AD)
References: <1336079364-16222-1-git-send-email-wey-yi.w.guy@intel.com>
	<20120508140555.GA4412@redhat.com>
 <CANUX_P3V6-sGO5+nmRA7b5wq-tDujs5gZtkrJQj_w29wD1tunQ@mail.gmail.com>
In-Reply-To: <CANUX_P3V6-sGO5+nmRA7b5wq-tDujs5gZtkrJQj_w29wD1tunQ@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi guys,

>> This patch make no sense. Nothing stops compiler or CPU to write
>> ->page into memory before ->page_dma .
>>
>
>I thought that too,but  the call to dma_map... is a call to functon.
>Shouldn't force the compiler the make things in order. Or maybe the
>assignment to rxb->page_dma can be reordered... I am not really sure.

[MV] In that case I'll explicitly add barriers here and elsewhere...there is a race condition here and it needs to be resolved.

Thanks,
Meenakshi
