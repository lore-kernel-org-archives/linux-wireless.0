Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:33508 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753642AbYFXLKV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2008 07:10:21 -0400
Subject: Re: [PATCH 3/4] mac80211: add last beacon time in scan list
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Tomas Winkler <tomas.winkler@intel.com>, linville@tuxdriver.com,
	yi.zhu@intel.com, linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
In-Reply-To: <1214304433.8967.277.camel@johannes.berg>
References: <1214303881-31525-1-git-send-email-tomas.winkler@intel.com>
	 <1214303881-31525-2-git-send-email-tomas.winkler@intel.com>
	 <1214303881-31525-3-git-send-email-tomas.winkler@intel.com>
	 <1214303881-31525-4-git-send-email-tomas.winkler@intel.com>
	 <1214304433.8967.277.camel@johannes.berg>
Content-Type: text/plain
Date: Tue, 24 Jun 2008 07:09:13 -0400
Message-Id: <1214305753.12270.5.camel@localhost.localdomain> (sfid-20080624_131024_773414_4544F188)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-06-24 at 12:47 +0200, Johannes Berg wrote:
> On Tue, 2008-06-24 at 13:38 +0300, Tomas Winkler wrote:
> > From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> > 
> > This patch adds the interval between the scan results and the last time a
> > beacon was received in the result of the scan.
> 
> Why do we need this?

Sometimes it's nice to see when the beacon was last seen, since the
driver holds onto BSSs for a while, you don't know how long they've been
in the scan list.  If you only cared about the newest BSSs you could use
this to ignore certain APs from the scan list.

Would be nice to push this attribute back with nl80211 as well.

Dan

> 
> > +			memset(&iwe, 0, sizeof(iwe));
> > +			iwe.cmd = IWEVCUSTOM;
> > +			sprintf(buf, " Last beacon: %dms ago",
> > +				jiffies_to_msecs(jiffies - bss->last_update));
> 
> Is there no time_between() or something that accounts for wraparound?
> 
> johannes

