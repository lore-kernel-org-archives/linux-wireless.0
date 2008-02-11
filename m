Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:6842 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750965AbYBKFRz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2008 00:17:55 -0500
Subject: Re: [PATCH 00/12] at76_usb mac80211 port
From: Pavel Roskin <proski@gnu.org>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1202706345.20836.26.camel@dv>
References: <20080210145733.17592.61729.stgit@tikku>
	 <1202706345.20836.26.camel@dv>
Content-Type: text/plain
Date: Mon, 11 Feb 2008 00:17:54 -0500
Message-Id: <1202707074.22841.8.camel@dv> (sfid-20080211_051800_413232_0A68DE9F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-02-11 at 00:05 -0500, Pavel Roskin wrote:

> phy5: CMD_JOIN failed: 7<7>wlan3: CTS protection enabled
> (BSSID=00:0b:6b:56:01:bf)
> wlan3: CTS protection disabled (BSSID=00:0b:6b:56:01:bf)
> 
> You forgot end of line in the message (that's patch 05/12).  I'm totally
> at loss why a positive value us printed.

I know why!  Because there is another "CMD_JOIN failed" with the same
missing end of line, which prints the result from a different function
and expects a different result.  7 is CMD_STATUS_TIME_OUT.

Please use different messages for different errors.  In this case,
at76_get_cmd_status_string() should be used for positive ret, so that
you don't print numbers.

-- 
Regards,
Pavel Roskin
