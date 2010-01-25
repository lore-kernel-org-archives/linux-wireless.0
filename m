Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:45667 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751433Ab0AYSci (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2010 13:32:38 -0500
Date: Mon, 25 Jan 2010 10:32:24 -0800
From: Jouni Malinen <j@w1.fi>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, wey-yi.w.guy@intel.com,
	linux-wireless@vger.kernel.org, Kalle Valo <kalle.valo@nokia.com>
Subject: Re: [PATCH v3 1/1] mac80211: tell driver when dtim change detected
Message-ID: <20100125183224.GA19528@jm.kir.nu>
References: <1264109996-15995-1-git-send-email-wey-yi.w.guy@intel.com>
 <1264186981.2593.10.camel@johannes.local>
 <43e72e891001221120i79c6525bo4852cb5a6c7a37@mail.gmail.com>
 <1264189560.2593.14.camel@johannes.local>
 <43e72e891001221544j1b1bd67ao8dfcf4d0dd12dd81@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e891001221544j1b1bd67ao8dfcf4d0dd12dd81@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 22, 2010 at 03:44:41PM -0800, Luis R. Rodriguez wrote:

> OK. Still curious, if in practice would funky APs ever tune DTIM
> dynamically and not kick you off, and if they do is it fair to ignore
> that and blame the AP?

As far as I can tell, the standard requires you to restart the BSS if
you change the DTIM value. I don't think there is explicit requirement
for the AP to send you a deauthentication or disassociation frame,
though, but I would expect the association to be lost if the AP is
compliant with the standard.

Anyway, it is not like all APs really follow the standard requirements
in all cases, so I would not be to surprised to hear about an AP that
changes the DTIM value more dynamically. Anyway, that is just asking for
problems due to the way a specific timestamps are defined to be used for
the beacons that are followed by buffered multicast/broadcast frames.

-- 
Jouni Malinen                                            PGP id EFC895FA
