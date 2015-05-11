Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:32868 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300AbbEKMIo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2015 08:08:44 -0400
Message-ID: <1431346122.1964.26.camel@sipsolutions.net> (sfid-20150511_140847_216921_47FD4256)
Subject: Re: [PATCH] mac80211: WEP, move tailroom size check
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 11 May 2015 14:08:42 +0200
In-Reply-To: <1431336675-15944-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20150511_113150_234690_DED025A4)
References: <1431336675-15944-1-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20150511_113150_234690_DED025A4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-05-11 at 11:31 +0200, Janusz Dziedzic wrote:
> Remove checking tailroom when adding IV, while
> this goes to headroom. Move this check to the function
> that will generate/put ICV for WEP.
> 
> In other case I hit such warning and datapath don't work,
> when testing:
> - IBSS + WEP
> - ath9k with hw crypt enabled
> - IPv6 data (ping6)

Is this new, perhaps due to fast-xmit, because we previously added
tailroom for WEP always? I've certainly never seen this before.

(just asking so I know where it needs to be applied)

johannes

