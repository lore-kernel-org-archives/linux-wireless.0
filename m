Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36790 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774Ab3ASWPg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jan 2013 17:15:36 -0500
Message-ID: <1358633754.5472.3.camel@jlt4.sipsolutions.net> (sfid-20130119_231540_065821_2C18C4B7)
Subject: Re: [RFC] iwl4965: report A-MPDU status
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com
Date: Sat, 19 Jan 2013 23:15:54 +0100
In-Reply-To: <201301190030.11771.chunkeey@googlemail.com> (sfid-20130119_004037_956066_34B3CA0C)
References: <201301190030.11771.chunkeey@googlemail.com>
	 (sfid-20130119_004037_956066_34B3CA0C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2013-01-19 at 00:30 +0100, Christian Lamparter wrote:

> 1. This patch [including commit msg] is a copy of:
>    commit 12bf6f45d17038589e0eaa8adeb7ee8169c0e4de
>    Author: Johannes Berg <johannes.berg@intel.com>
>    Date:   Thu Jul 5 13:05:08 2012 +0200
>       iwlwifi: report A-MPDU status

:-)

> 2. RX_RES_PHY_FLAGS_ANTENNA_MSK
>    I had the chance to test this with a real 4965.
>    As far as I can tell, the hardware has just 3
>    antenna connectors. But I have seen frames, which
>    apparently have been received on 4 antennas?!
> 
>    Note: iwlwifi had this problem as well. It was
>    fixed by:
>      commit 362b0563b28506d534a82d9c6cd5fdf58783fda6
>      Author: Johannes Berg <johannes.berg@intel.com>
>      Date:   Fri Aug 24 11:13:17 2012 +0200
>         iwlwifi: fix antenna bitmask
>    I suppose 4965 also uses the 4th bit as the AMPDU
>    indicator. It would be very helpful if someone
>    could confirm this assumption. [Otherwise the
>    whole AMPDU status feature patch has little use].

I can't easily verify this this right now, but I think it's a safe bet
since no iwlegacy/iwlwifi device exists that supports 4 antennas, and
the definition in question has always been the same for all hardware. I
just didn't fix it for 4965 since it was split off to iwlegacy already.

johannes

