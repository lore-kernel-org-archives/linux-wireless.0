Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53080 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab2FFIvn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 04:51:43 -0400
Message-ID: <1338972702.4513.24.camel@jlt3.sipsolutions.net> (sfid-20120606_105147_433796_F12872D4)
Subject: Re: [RFC 01/14] cfg80211: respect intf combinations for 1 interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 06 Jun 2012 10:51:42 +0200
In-Reply-To: <1338203942-5667-2-git-send-email-michal.kazior@tieto.com>
References: <1338203942-5667-1-git-send-email-michal.kazior@tieto.com>
	 <1338203942-5667-2-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-05-28 at 13:18 +0200, Michal Kazior wrote:
> Don't ignore interface combinations when only one
> interface is up. Otherwise we may call a driver to
> create (or change) interface type to something it
> didn't report in interface combinations it
> reported.

We still check wiphy.interface_modes before we even go into this
function, no? Arguably we should move the check into the function, but
I'm not sure what you're fixing here.

johannes

