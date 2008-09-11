Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:58942 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751521AbYIKUdi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2008 16:33:38 -0400
Message-ID: <48C9811A.7070206@w1.fi> (sfid-20080911_223340_638486_63BED5F9)
Date: Thu, 11 Sep 2008 23:35:38 +0300
From: Jouni Malinen <j@w1.fi>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Dan Williams <dcbw@redhat.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>, j@w1.fi
Subject: Re: [PATCH] mac80211: add pre- and post-scan hooks
References: <1214149401.8585.2.camel@localhost.localdomain>	 (sfid-20080622_174624_286344_54D543FD)  <1221033061.12266.10.camel@johannes.berg>	 (sfid-20080910_095115_515502_30A213FC) <1221159194.6986.57.camel@johannes.berg>
In-Reply-To: <1221159194.6986.57.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> The beaconing API in total is a bit strange, we tell the driver when the
> beacon changes and it can then request one, but we never tell it when to
> start/stop beaconing, which means that currently your driver has to
> figure to start out beaconing on the first beacon change, and then
> cannot possibly stop again... We can return NULL from the beacon get
> function but that could be an error condition too...

The original design was for AP mode only and the assumption was that
Beacon transmission is enabled pretty much all the time. Returning NULL
was used if ever needed to stop Beacon transmission for some period of
time.

> I think we just need to add start/stop beacon bits, and then we can use
> them around a scan too, thoughts?

That sounds reasonable.

- Jouni
