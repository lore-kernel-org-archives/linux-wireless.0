Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:57973 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752967Ab1CaQgR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2011 12:36:17 -0400
From: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 31 Mar 2011 09:36:15 -0700
Subject: RE: [PATCH 1/3] iwlwifi: fix enqueue hcmd race conditions
Message-ID: <E9954878DD1FB34FAE5187FB88C58A3501428BA47D@orsmsx506.amr.corp.intel.com>
References: <1301585788-7331-1-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1301585788-7331-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw,

-----Original Message-----
From: Stanislaw Gruszka [mailto:sgruszka@redhat.com] 
Sent: Thursday, March 31, 2011 8:36 AM
To: Guy, Wey-Yi W
Cc: Intel Linux Wireless; linux-wireless@vger.kernel.org; Stanislaw Gruszka
Subject: [PATCH 1/3] iwlwifi: fix enqueue hcmd race conditions

We mark command as huge by using meta->flags from other (non huge) command,
but flags can be possibly overridden, when non huge command is enqueued,
what can lead to:

WARNING: at lib/dma-debug.c:696 dma_debug_device_change+0x1a3/0x1f0()
DMA-API: device driver has pending DMA allocations while released from device [count=1]

To fix introduce additional CMD_MAPPED to mark command as mapped and
serialize iwl_enqueue_hcmd() with iwl_tx_cmd_complete() using
hcmd_lock. Serialization will also fix possible race conditions,
because q->read_ptr, q->write_ptr are modified/used in parallel.

On the way fix whitespace.

Do you have a bug# against this?

Thanks
Wey


