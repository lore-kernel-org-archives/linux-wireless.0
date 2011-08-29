Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54940 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556Ab1H2NW3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 09:22:29 -0400
Subject: Re: [RFC] mac80211: add IBSS merge support
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Ivan Seskar <seskar@winlab.rutgers.edu>
In-Reply-To: <1314297201-19007-1-git-send-email-lrodriguez@qca.qualcomm.com> (sfid-20110825_203358_141791_DD74CE54)
References: <1314297201-19007-1-git-send-email-lrodriguez@qca.qualcomm.com>
	 (sfid-20110825_203358_141791_DD74CE54)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Aug 2011 15:22:23 +0200
Message-ID: <1314624143.8959.1.camel@jlt3.sipsolutions.net> (sfid-20110829_152235_853948_F2520A0C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-08-25 at 11:33 -0700, Luis R. Rodriguez wrote:
> From: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
> 
> When you try to create an IBSS network with a lot of nodes
> you typically end up with split networks due to the fact that
> some nodes for one reason or another end up not listening to
> beacons from the node others do with a higher TSF. What ends
> up happening is you split the IBSS network and these do not
> converge. To address this you can force the BSSID as well as
> the SSID but if you just want to specify the SSID you can
> use the ibss_merge knob to force an IBSS merge by focing the
> BSSID to be based on the passed SSID.
> 
> Cc: Jouni Malinen <jouni@qca.qualcomm.com>
> Cc: Ivan Seskar <seskar@winlab.rutgers.edu>
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
> ---
> 
> Ivan, I think this is what you were looking for but an alternative to this
> problem is to specify the BSSID every time you want to create your own large
> IBSS network, this would mean that its a requirement and also means we
> acknowledge a limitation by IEEE's adhoc definition. Is there any reason
> forcing a BSSID on the experimenter is not an equally good solution?

Even setting "fixed-bssid" is acknowledging that already, but I really
see no reason for this to live in the kernel.

johannes

