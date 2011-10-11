Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34643 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752373Ab1JKNAA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Oct 2011 09:00:00 -0400
Date: Tue, 11 Oct 2011 14:58:11 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 17/34] iwlagn: fix a race in the unmapping of the TFDs
Message-ID: <20111011125810.GC2218@redhat.com> (sfid-20111011_150004_976051_4E964A91)
References: <1318256839-31837-1-git-send-email-wey-yi.w.guy@intel.com>
 <1318256839-31837-18-git-send-email-wey-yi.w.guy@intel.com>
 <20111011122216.GA2218@redhat.com>
 <4825B8A2C4E264489E57869F0DCFB2234457A944D0@hasmsx502.ger.corp.intel.com>
 <20111011123630.GB2218@redhat.com>
 <4825B8A2C4E264489E57869F0DCFB2234457A944F2@hasmsx502.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4825B8A2C4E264489E57869F0DCFB2234457A944F2@hasmsx502.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 11, 2011 at 02:38:52PM +0200, Grumbach, Emmanuel wrote:
> > Why not simply take hcmd_lock?
> 
> Hcmd_lock is related to the host command queue only, it won't work for Tx queues.

So you only fix reces between
iwl_trans_pcie_tx()/iwl_tx_queue_reclaim() and iwl_tx_queue_unmap().
Races between
iwl_enqueue_hcmd()/iwl_cmd_queue_reclaim() and iwl_tx_queue_unmap()
are unresolved.

Stanislaw
