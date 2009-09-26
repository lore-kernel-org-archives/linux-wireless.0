Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:58110 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751520AbZIZSex (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Sep 2009 14:34:53 -0400
Date: Sat, 26 Sep 2009 21:34:46 +0300
From: Jouni Malinen <j@w1.fi>
To: Igor Perminov <igor.perminov@inbox.ru>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] mac80211: Fix [re]association power saving issue on
	AP side
Message-ID: <20090926183446.GA10898@jm.kir.nu>
References: <1253564744.4477.18.camel@sunlight>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1253564744.4477.18.camel@sunlight>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 22, 2009 at 12:25:44AM +0400, Igor Perminov wrote:

> At the step 4 the AP "remembers" the STA and considers it is still in
> the PS state, so the AP buffers frames, which it has to send to the STA.
> But the STA isn't actually in the PS state and so it neither checks
> TIM bits nor reports to the AP that it isn't power saving.
> Because of that authentication/[re]association fails.
> 
> To fix authentication/[re]association stage of this issue, Auth, Assoc
> Resp and Reassoc Resp frames are transmitted disregarding of STA's power
> saving state.

That looks fine to me and should be applied.

> N.B. This patch doesn't fix further data frame exchange after
> authentication/[re]association. A patch in hostapd is required to fix
> that.

Git snapshot of hostapd is now removing the STA entry (if one exists)
when processing reassociation. The combination of these two changes
allows the reassociation back to the same AP to be completed even if the
STA was in PS mode.

-- 
Jouni Malinen                                            PGP id EFC895FA
