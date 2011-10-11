Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:19860 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754833Ab1JKOoc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Oct 2011 10:44:32 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 11 Oct 2011 16:43:27 +0200
Subject: RE: [PATCH 17/34] iwlagn: fix a race in the unmapping of the TFDs
Message-ID: <4825B8A2C4E264489E57869F0DCFB2234457A94631@hasmsx502.ger.corp.intel.com> (sfid-20111011_164439_775541_C493F103)
References: <1318256839-31837-1-git-send-email-wey-yi.w.guy@intel.com>
 <1318256839-31837-18-git-send-email-wey-yi.w.guy@intel.com>
 <20111011122216.GA2218@redhat.com>
 <4825B8A2C4E264489E57869F0DCFB2234457A944D0@hasmsx502.ger.corp.intel.com>
 <20111011123630.GB2218@redhat.com>
 <4825B8A2C4E264489E57869F0DCFB2234457A944F2@hasmsx502.ger.corp.intel.com>
 <20111011125810.GC2218@redhat.com>
In-Reply-To: <20111011125810.GC2218@redhat.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 
> On Tue, Oct 11, 2011 at 02:38:52PM +0200, Grumbach, Emmanuel wrote:
> > > Why not simply take hcmd_lock?
> >
> > Hcmd_lock is related to the host command queue only, it won't work for Tx
> queues.
> 
> So you only fix reces between
> iwl_trans_pcie_tx()/iwl_tx_queue_reclaim() and iwl_tx_queue_unmap().
> Races between
> iwl_enqueue_hcmd()/iwl_cmd_queue_reclaim() and iwl_tx_queue_unmap()
> are unresolved.
> 

Thanks. Patch is on the way (has been submitted internally).

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

