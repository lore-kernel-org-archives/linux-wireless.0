Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:44662 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756136AbZBKRQ1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Feb 2009 12:16:27 -0500
Subject: Re: [PATCH v2] ipw2x00: age scan results on resume
From: Dan Williams <dcbw@redhat.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>
In-Reply-To: <1234306699.1626.34.camel@rc-desk>
References: <1234303830.15997.27.camel@localhost>
	 <1234306699.1626.34.camel@rc-desk>
Content-Type: text/plain
Date: Wed, 11 Feb 2009 12:14:49 -0500
Message-Id: <1234372489.2648.1.camel@localhost> (sfid-20090211_181630_882673_6B42B531)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-02-10 at 14:58 -0800, reinette chatre wrote:
> On Tue, 2009-02-10 at 14:10 -0800, Dan Williams wrote:
> > Scanned BSS entries are timestamped with jiffies, which doesn't
> > increment across suspend and hibernate.  On resume, every BSS in the
> > scan list looks like it was scanned within the last 10 seconds,
> > irregardless of how long the machine was actually asleep.  Age scan
> > results on resume with the time spent during sleep so userspace has a
> > clue how old they really are.
> > 
> > Signed-off-by: Dan Williams <dcbw@redhat.com>
> > ---
> > This fixes NetworkManager and wpa_supplicant trying to connect to the AP
> > associated with at suspend/hibernate time, which clearly may not exist
> > at the location where the machine is waking up.
> > 
> > v2: always set suspend_at
> 
> Thank you.

Found an issue, plus ieee80211_translate_scan() doesn't handle large
unsigned network->last_seen values (leading to stuff like "Last beacon:
-32131218ms ago"), so I'll post a v3 update.

Dan


