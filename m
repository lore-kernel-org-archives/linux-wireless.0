Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60348 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755736Ab1K2R7q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Nov 2011 12:59:46 -0500
Subject: Re: [RFC] prism54: fix compilation warning on wrqu.data.pointer
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1322588518-15623-1-git-send-email-mcgrof@qca.qualcomm.com> (sfid-20111129_184235_135720_7307E3A5)
References: <1322588518-15623-1-git-send-email-mcgrof@qca.qualcomm.com>
	 (sfid-20111129_184235_135720_7307E3A5)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Nov 2011 18:59:33 +0100
Message-ID: <1322589573.4110.28.camel@jlt3.sipsolutions.net> (sfid-20111129_185949_450620_5E7A34A5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-11-29 at 12:41 -0500, Luis R. Rodriguez wrote:
> This fixes this compilation warning:
> 
>   CHECK   drivers/net/wireless/prism54/isl_ioctl.c
> drivers/net/wireless/prism54/isl_ioctl.c:2052:27: warning: incorrect type in assignment (different address spaces)
> drivers/net/wireless/prism54/isl_ioctl.c:2052:27:    expected void [noderef] <asn:1>*pointer
> drivers/net/wireless/prism54/isl_ioctl.c:2052:27:    got char *[assigned] memptr
> drivers/net/wireless/prism54/isl_ioctl.c:2071:27: warning: incorrect type in assignment (different address spaces)
> drivers/net/wireless/prism54/isl_ioctl.c:2071:27:    expected void [noderef] <asn:1>*pointer
> drivers/net/wireless/prism54/isl_ioctl.c:2071:27:    got char *[assigned] memptr
> 
> The wrqu.data.pointer shouldn't be assigned by the driver, addiotionally
> custom wext driver events would simply be dropped anyway.
> 
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
> ---
> 
> Johannes, it was unclear to me whether or not wireless_send_event()
> no longer supports custom driver events if so then not only was this
> bogus but also all the private driver event crap could likely be
> removed from prism54 as well.

Looking at cfg80211_michael_mic_failure() in net/wireless/mlme.c, this
should work.

johannes

