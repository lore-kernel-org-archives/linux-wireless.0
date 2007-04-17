Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sj-iport-6.cisco.com ([171.71.176.117]:20608 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031267AbXDQWAK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Apr 2007 18:00:10 -0400
To: jt@hpl.hp.com
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	netdev@vger.kernel.org
Subject: Re: [PATCH 2.6] WE-22 : prevent information leak on 64 bit
References: <20070323003116.GC2712@bougret.hpl.hp.com>
	<1175508410.23438.75.camel@johannes.berg>
	<20070417170820.GB22372@bougret.hpl.hp.com>
	<20070417183442.GE8633@tuxdriver.com>
	<20070417211859.GB22897@bougret.hpl.hp.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 17 Apr 2007 14:59:52 -0700
In-Reply-To: <20070417211859.GB22897@bougret.hpl.hp.com> (Jean Tourrilhes's message of "Tue, 17 Apr 2007 14:19:00 -0700")
Message-ID: <adaejmi1x2f.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 > > This API was controversial and mostly unwelcome from the start.
 > > It was ridiculed as "ioctls over netlink" at the last kernel summit.
 > 
 > 	Which is complete FUD. In that case, the whole RtNetlink can
 > be classified as "ioctls over netlink".

The problem is that WE over netlink is basically using netlink to
transfer the same binary blobs as the WE ioctls, rather than using
properly structured netlink messages.

 > > One of the objections to having merged the API was that _if_ it were
 > > to gain users then we would have to carry that maintenance burden
 > > ad infinitum.
 > 
 > 	More FUD. It does not add any new commands. The proof is in
 > the pudding, no change was needed in any driver to support it,
 > therefore it could not have added any burden on any compatibility
 > layer.

The point is that if WE over netlink is used by applications, then the
kernel must maintain that ABI (of WE over netlink) forever.

 - R.
