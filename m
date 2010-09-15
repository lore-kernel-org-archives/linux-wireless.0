Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53894 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294Ab0IOXSi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Sep 2010 19:18:38 -0400
Subject: Re: [PATCH] mac80211: Fix radiotap header it_present field for
 rate in 802.11n data pkts
From: Johannes Berg <johannes@sipsolutions.net>
To: hschultz@pobox.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTinFW+NxDpnKbhWnTZ3qRWqqh0tKXjdHEmWp6XKr@mail.gmail.com>
References: <AANLkTinFW+NxDpnKbhWnTZ3qRWqqh0tKXjdHEmWp6XKr@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Sep 2010 01:18:49 +0200
Message-ID: <1284592729.3707.14.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-09-15 at 16:18 -0400, Harold Schultz wrote:
> In summary patch has these changes:
> 
> 802.11n data packets has the it_present field not set for data rate if
> the packet is 802.11n packets, but space is created in the header for
> it.  This causs the radiotap header fields to not be aligned correctly
> for all data after the rate field. 
> 
> The patched version was in: compat-wireless-2010-07-29, which is used
> by openwrt backfire

Except that this change is bogus, since the Channel field, which
follows, needs 2-byte alignment.

johannes


