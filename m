Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51616 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176AbZI1UPv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2009 16:15:51 -0400
Date: Mon, 28 Sep 2009 16:14:19 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] iwlagn: fix panic in iwl{5000,4965}_rx_reply_tx
Message-ID: <20090928201419.GE4737@tuxdriver.com>
References: <1253695894-4553-1-git-send-email-sgruszka@redhat.com> <1253828287.26521.999.camel@rc-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1253828287.26521.999.camel@rc-desk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 24, 2009 at 02:38:07PM -0700, reinette chatre wrote:
> Hi Stanislaw,
> 
> On Wed, 2009-09-23 at 01:51 -0700, Stanislaw Gruszka wrote:
> > In some cases firmware can give us bad value of index in transmit
> > buffers array. This patch add sanity check for such values and return
> > from processing function instantly when it happens.
> > 
> > https://bugzilla.redhat.com/show_bug.cgi?id=521931
> > 
> > Patch was tested by reporter on iwl5000. I think check can be also
> > helpful for 4965.
> > 
> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> > ---
> 
> I looked at the bugzilla entry and I think that there may be another fix
> required here. After the driver submitted the five frames it received a
> surprisingly large number of tx responses from firmware, with one of
> these causing the problem. The bad value from the firmware may be a
> result of something else done incorrectly by driver here since the
> firmware has been trying for more than 40 times at this point to inform
> driver about tx results.
> 
> I commented in that bugzilla and we can continue to debug this issue
> there. Until then I'd like to hold off on this patch.

Hmmm...well, I already sent it to Dave/Linus -- it's in 2.6.32-rc1...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
