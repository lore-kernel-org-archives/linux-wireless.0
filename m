Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:48692 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751956AbZCPIu5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2009 04:50:57 -0400
Date: Mon, 16 Mar 2009 10:50:36 +0200
From: Jouni Malinen <j@w1.fi>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC PATCH v2 4/4] mac80211: add beacon filtering support
Message-ID: <20090316085036.GA29705@jm.kir.nu> (sfid-20090316_095102_202208_B6A187A4)
References: <20090314171234.11126.21125.stgit@tikku> <20090314171452.11126.11618.stgit@tikku> <43e72e890903141318n25fa5f4bi7903eee2ef216040@mail.gmail.com> <87r60z1c8x.fsf@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87r60z1c8x.fsf@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Mar 15, 2009 at 09:22:38AM +0200, Kalle Valo wrote:

> In my opinion also 2.4 GHz band needs checksum support. At least ERP
> protection changes come to my mind, but maybe there are also others.

Johannes mentioned Quiet IE as one such example. WMM can also change its
parameters dynamically. Both of these need to be detected from Beacon
frames. In addition, Channel Switch Announcement can be used to move the
BSS to another channel, even on 2.4 GHz band.

> Other option is that the hardware which does not support checksumming
> would just pass beacons periodically to the stack, for example every 5
> seconds. Even though beacon filter is enabled in mac80211 it does not
> prevent hardware from sending beacons. This is not the most optimal
> solution, but there's not much choices if the hardware doesn't support
> checksumming.

While it would be possible to do that, it does not really solve many of
the use cases where Beacon contents can change and the STA is required
to take some action. For example, Channel Switch Announcement IEs would
likely be missed if a Beacon frames is passed through that infrequently.
I would assume the driver could enable this even if the hardware does
not use checksumming to detect Beacon changes, but this may severely
limit functionality in number of cases, so I'm not sure I would
recommend this to be done in general.

-- 
Jouni Malinen                                            PGP id EFC895FA
