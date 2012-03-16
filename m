Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43670 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517Ab2CPN06 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Mar 2012 09:26:58 -0400
Date: Fri, 16 Mar 2012 14:16:45 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC 2/3] mac80211: protect ->scanning by mutex in
 ieee80211_work_work()
Message-ID: <20120316131644.GB10844@redhat.com> (sfid-20120316_142702_123468_60726234)
References: <1331899378-10543-1-git-send-email-sgruszka@redhat.com>
 <1331899378-10543-2-git-send-email-sgruszka@redhat.com>
 <1331902453.6753.4.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1331902453.6753.4.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 16, 2012 at 01:54:13PM +0100, Johannes Berg wrote:
> I don't really see the point in this. It seems that this doesn't really
> help, you'd actually have to protect all the work stuff here with the
> mutex so the scanning can also be excluded or so?

You mean some other work stuff than ieee80211_work_work() ?

We have almost all ieee80211_work_work() code protected by local->mtx
already, I just moved local->scanning check after the mutex_lock.

Stanislaw
