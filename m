Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:36757 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753976Ab0C3LtY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Mar 2010 07:49:24 -0400
From: <ext-saravanan.dhanabal@nokia.com>
To: <johannes@sipsolutions.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Date: Tue, 30 Mar 2010 13:48:03 +0200
Subject: RE: [PATCH] mac80211: Reschedule dynamic power save timer after
 wakeup
Message-ID: <04BB8F4F2843A24294353CA037CA5B5857D5ABFF60@NOK-EUMSG-01.mgdnok.nokia.com>
References: <1268753462-18094-1-git-send-email-ext-saravanan.dhanabal@nokia.com>
	 <1268775761.8918.0.camel@jlt3.sipsolutions.net>
	 <04BB8F4F2843A24294353CA037CA5B58568D26B52F@NOK-EUMSG-01.mgdnok.nokia.com>
	 <1268841668.5989.3.camel@jlt3.sipsolutions.net>
	 ,<20100329175506.GE4984@tuxdriver.com>
	 <04BB8F4F2843A24294353CA037CA5B58568D26B541@NOK-EUMSG-01.mgdnok.nokia.com>,<1269927192.3927.4.camel@jlt3.sipsolutions.net>
In-Reply-To: <1269927192.3927.4.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I agree that this is totally a driver issue. When sending the patch
we did not notice that. We tried some workaround inside driver, but 
still causes around 10-15ms variation, probably due to ELP wakeup delay.

I guess this patch could be ignored at the moment. Thanks.

saravanan d.
________________________________________
From: ext Johannes Berg [johannes@sipsolutions.net]
Sent: Tuesday, March 30, 2010 8:33 AM
To: Dhanabal Saravanan (EXT-Sasken/Tampere)
Cc: linville@tuxdriver.com; linux-wireless@vger.kernel.org
Subject: RE: [PATCH] mac80211: Reschedule dynamic power save timer after wakeup

On Mon, 2010-03-29 at 23:15 +0200, ext-saravanan.dhanabal@nokia.com
wrote:
> Sorry for the delay, we were checking this in driver also.
>
> The issue was due to a delay in workqueue scheduling,  caused by
> msleep() inside driver. Because of this,
> last transmission happens long after the dynamic power save timer is
> scheduled. So, the difference
> between last transmission time and the time it goes to sleep is less
> than the defined PSM timeout period.
>
> I think that this patch might be considered as a workaround for such
> delays caused by driver as long as it not creating
> any other issues.

At the very least that needs to be very clearly documented in the patch,
but I'm not convinced we should be adding it. Why does the driver need
the delay, and could it maybe do it after TX? And if the driver sleeps
during the TX path how can it possibly get good performance??

johannes

