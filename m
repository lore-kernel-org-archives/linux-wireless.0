Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:35346 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752116AbXFLIHS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2007 04:07:18 -0400
Subject: Re: [Take 2] mac80211 IEEE802.11e/WMM code cleanup
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1181584907.29767.30.camel@johannes.berg>
References: <20070611085950.GA5540@mail.intel.com>
	 <1181584907.29767.30.camel@johannes.berg>
Content-Type: text/plain
Date: Tue, 12 Jun 2007 16:06:09 +0800
Message-Id: <1181635570.4758.22.camel@debian.sh.intel.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2007-06-11 at 20:01 +0200, Johannes Berg wrote:
> Hi Yi,
> 
> In sta_process_dls_req, you currently always accept DLS. I'm not sure
> how well power save mode works in mac80211 (probably not at all, someone
> versed in 802.11 should probably look at it some time soon), but once
> DLS is set up power saving must be disabled by the DLS peer. This,
> however, possibly leads to battery lifetime diminishing, so always
> accepting the direct link might not be desirable. Any thoughts?

You are right. I once had the debugfs file on the DLS request response
side to to indicate accept or deny all DLS requests. But after a second
thought, maybe a MAC list is better? But this is just for testing not a
real API.

> Should we have user-space controlled list of DLS possible DLS peers? Or
> call out to userspace via nl80211 to make a decision? The list would be
> easy by simply adding a sta_info for a possible DLS peer, callout also
> shouldn't be too hard by sending a message to some QoS nl80211 multicast
> group and possibly not responding to the DLS request at all when our
> userspace doesn't accept it (that way it'll just time out on the other
> side).

Right. For the real API, I'd prefer the kernel to send an event to
userspace (daemon) via netlink (nl80211) and let user space to make the
decision. This way mac80211 doesn't need to manage the user prefered DLS
list itself. Another benefit is the DLS connection could be established
interactively. For example when a user is VIing in Xwindows, a pop up
window from NetworkManager asks "MAC address XX:XX:.. wants to setup a
DLS connection with you, do you accept?"

Thanks,
-yi
