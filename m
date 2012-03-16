Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58819 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756364Ab2CPNN1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Mar 2012 09:13:27 -0400
Date: Fri, 16 Mar 2012 14:13:23 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC 1/3] mac80211: do not scan and monitor connection in
 parallel
Message-ID: <20120316131322.GA10844@redhat.com> (sfid-20120316_141331_017635_61E7372E)
References: <1331899378-10543-1-git-send-email-sgruszka@redhat.com>
 <1331902378.6753.3.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1331902378.6753.3.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 16, 2012 at 01:52:58PM +0100, Johannes Berg wrote:
> On Fri, 2012-03-16 at 13:02 +0100, Stanislaw Gruszka wrote:
> > Before we send probes in connection monitoring we check if scan is not
> > pending. But we do that check without locking. Fix that and also do not
> > start scan if connection monitoring is in progress.
> 
> Wouldn't it be easier to just abort the check instead of deferring the
> scan?

It would be easier. However we already defer scan on
!list_empty(&local->work_list) case. Also random failures of
scan request can not be well seen from user-space perspective.

Stanislaw
