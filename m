Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:12055 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751931AbZIXViG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2009 17:38:06 -0400
Subject: Re: [PATCH] iwlagn: fix panic in iwl{5000,4965}_rx_reply_tx
From: reinette chatre <reinette.chatre@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1253695894-4553-1-git-send-email-sgruszka@redhat.com>
References: <1253695894-4553-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain
Date: Thu, 24 Sep 2009 14:38:07 -0700
Message-Id: <1253828287.26521.999.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

On Wed, 2009-09-23 at 01:51 -0700, Stanislaw Gruszka wrote:
> In some cases firmware can give us bad value of index in transmit
> buffers array. This patch add sanity check for such values and return
> from processing function instantly when it happens.
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=521931
> 
> Patch was tested by reporter on iwl5000. I think check can be also
> helpful for 4965.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---

I looked at the bugzilla entry and I think that there may be another fix
required here. After the driver submitted the five frames it received a
surprisingly large number of tx responses from firmware, with one of
these causing the problem. The bad value from the firmware may be a
result of something else done incorrectly by driver here since the
firmware has been trying for more than 40 times at this point to inform
driver about tx results.

I commented in that bugzilla and we can continue to debug this issue
there. Until then I'd like to hold off on this patch.

Reinette


