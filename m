Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:38803 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756755AbXHBSyK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2007 14:54:10 -0400
Subject: RE: [ipw3945-devel] chaning mode only when interface down?
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Winkler, Tomas" <tomas.winkler@intel.com>,
	dragoran <drago01@gmail.com>, linux-wireless@vger.kernel.org,
	network manager <networkmanager-list@gnome.org>,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1186058047.24230.38.camel@johannes.berg>
References: <C07C4589BE74A34981C3C3525EE1F801024CF2CB@hasmsx412.ger.corp.intel.com>
	 <1186058047.24230.38.camel@johannes.berg>
Content-Type: text/plain
Date: Thu, 02 Aug 2007 14:51:15 -0400
Message-Id: <1186080675.9527.10.camel@xo-13-A4-25.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2007-08-02 at 14:34 +0200, Johannes Berg wrote:
> On Thu, 2007-08-02 at 15:17 +0300, Winkler, Tomas wrote:
> 
> > There is a definitely a known issue in the driver that we still need to
> > resolve, but I agree with Johannes that there is a problem in design of
> > the configuration as well. 
> 
> Nono, you cannot solve it in the driver. The whole design of mac80211
> mandates that assumption and I think it is a valid one to make. If
> userspace breaks because of that it's their fault.

Well, to be honest none of the drivers before mac80211 required you to
down the device to change modes.  But they were mostly fullmac, or
half-mac like ipw2x00.  Since mac80211 has only just become useful in
the past couple of months for most people, it's not really fair to
expect versions of NM that were out before mac80211 landed to play nice
with what mac80211 expects, which is different from what other drivers
implement.

Not to say NM shouldn't be fixed for this.  The other problem is that
there's really not a good way to determine whether the driver is
actually _ready_ after down it and bringing it back up.  You basically
have to spin & block until the interface gets IFF_UP set on it again,
and even then that's not entirely reliable.

Dan


