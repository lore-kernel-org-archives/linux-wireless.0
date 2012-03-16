Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50875 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517Ab2CPNWA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Mar 2012 09:22:00 -0400
Subject: Re: [RFC 1/3] mac80211: do not scan and monitor connection in
 parallel
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20120316131322.GA10844@redhat.com>
References: <1331899378-10543-1-git-send-email-sgruszka@redhat.com>
	 <1331902378.6753.3.camel@jlt3.sipsolutions.net>
	 <20120316131322.GA10844@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Mar 2012 14:21:58 +0100
Message-ID: <1331904118.6753.11.camel@jlt3.sipsolutions.net> (sfid-20120316_142232_936517_F799675F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-03-16 at 14:13 +0100, Stanislaw Gruszka wrote:
> On Fri, Mar 16, 2012 at 01:52:58PM +0100, Johannes Berg wrote:
> > On Fri, 2012-03-16 at 13:02 +0100, Stanislaw Gruszka wrote:
> > > Before we send probes in connection monitoring we check if scan is not
> > > pending. But we do that check without locking. Fix that and also do not
> > > start scan if connection monitoring is in progress.
> > 
> > Wouldn't it be easier to just abort the check instead of deferring the
> > scan?
> 
> It would be easier. However we already defer scan on
> !list_empty(&local->work_list) case. Also random failures of
> scan request can not be well seen from user-space perspective.

Ah, I didn't mean aborting the scan request, but rather the connection
monitor check. But yeah, I guess you're right about already deferring.

johannes

