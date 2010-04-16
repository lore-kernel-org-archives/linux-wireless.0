Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49551 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757329Ab0DPNpK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 09:45:10 -0400
Date: Fri, 16 Apr 2010 09:41:22 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH] mac80211: Prevent running sta_cleanup timer
	unnecessarily
Message-ID: <20100416134122.GC8554@tuxdriver.com>
References: <1271403308-23416-1-git-send-email-juuso.oikarinen@nokia.com> <1271403308-23416-2-git-send-email-juuso.oikarinen@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1271403308-23416-2-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 16, 2010 at 10:35:08AM +0300, Juuso Oikarinen wrote:
> The sta_cleanup timer is used to periodically expire buffered frames from the
> tx buf. The timer is executing periodically, regardless of the need for it.
> This is wasting resources.
> 
> Fix this simply by not restarting the sta_cleanup timer if the tx buffer was
> empty. Restart the timer when there is some more tx-traffic.
> 
> Cc: Janne Ylälehto <janne.ylalehto@nokia.com>
> Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Seems reasonable to me...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
