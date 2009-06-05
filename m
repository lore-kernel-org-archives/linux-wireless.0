Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:43479 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752571AbZFEHnD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jun 2009 03:43:03 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 05 Jun 2009 00:43:05 -0700
Subject: Re: [ath9k-devel] [PATCH 14/15] mac80211: move management / no-ack
 frame rate decision to mac80211
From: Jouni Malinen <jouni.malinen@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Zhu Yi <yi.zhu@intel.com>,
	Chittajit Mitra <Chittajit.Mitra@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	Derek Smithies <derek@indranet.co.nz>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <1244183288.22576.93.camel@johannes.local>
References: <1244180502-4323-1-git-send-email-lrodriguez@atheros.com>
	 <1244180502-4323-15-git-send-email-lrodriguez@atheros.com>
	 <1244183288.22576.93.camel@johannes.local>
Content-Type: text/plain
Date: Fri, 5 Jun 2009 10:42:58 +0300
Message-ID: <1244187778.3952.2.camel@jm-desktop>
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-06-04 at 23:28 -0700, Johannes Berg wrote:
> On Fri, 2009-06-05 at 01:41 -0400, Luis R. Rodriguez wrote:
> > All rate control algorithms agree to send management and no-ack
> > frames at the lowest rate. They also agree to do this when sta
> > and the private rate control data is NULL. We move this to mac80211
> > and simplify the rate control algorithm code.
> 
> We previously thought this would constrain our rate control algorithms
> more than we would like for future experimentation with higher multicast
> rates. Has that changed?

I hope not. I don't like the idea of forcing the lowest rate in
mac80211; we should allow rate control algorithms to be improved to do
more intelligent selection of rate at least for multicast/broadcast
frames. That might also be of use for some (likely post-association)
unicast management frames since their use is going to increase in the
future.

- Jouni


