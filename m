Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:18851 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237Ab0C2VQk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 17:16:40 -0400
From: <ext-saravanan.dhanabal@nokia.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Date: Mon, 29 Mar 2010 23:15:55 +0200
Subject: RE: [PATCH] mac80211: Reschedule dynamic power save timer after
	wakeup
Message-ID: <04BB8F4F2843A24294353CA037CA5B58568D26B541@NOK-EUMSG-01.mgdnok.nokia.com>
References: <1268753462-18094-1-git-send-email-ext-saravanan.dhanabal@nokia.com>
 <1268775761.8918.0.camel@jlt3.sipsolutions.net>
 <04BB8F4F2843A24294353CA037CA5B58568D26B52F@NOK-EUMSG-01.mgdnok.nokia.com>
 <1268841668.5989.3.camel@jlt3.sipsolutions.net>,<20100329175506.GE4984@tuxdriver.com>
In-Reply-To: <20100329175506.GE4984@tuxdriver.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry for the delay, we were checking this in driver also. 

The issue was due to a delay in workqueue scheduling,  caused by msleep() inside driver. Because of this, 
last transmission happens long after the dynamic power save timer is scheduled. So, the difference 
between last transmission time and the time it goes to sleep is less than the defined PSM timeout period.

I think that this patch might be considered as a workaround for such delays caused by driver as long as it not creating
any other issues.

saravanan.

________________________________________
From: ext John W. Linville [linville@tuxdriver.com]
Sent: Monday, March 29, 2010 8:55 PM
To: Johannes Berg
Cc: Dhanabal Saravanan (EXT-Sasken/Tampere); linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Reschedule dynamic power save timer after        wakeup

On Wed, Mar 17, 2010 at 09:01:08AM -0700, Johannes Berg wrote:
> On Wed, 2010-03-17 at 12:09 +0100, ext-saravanan.dhanabal@nokia.com
> wrote:
> > In worst case it takes up to that much,  though the average is less but still significant.
>
> > On Tue, 2010-03-16 at 11:31 -0400, Saravanan Dhanabal wrote:
> > > After last transmission, the device goes to sleep earlier
> > > than the configured dynamic power save timeout. If timeout
> > > is set to 400ms, device enters into sleep mode at around
> > > 330ms since from last TX.
>
> I still don't think I understand this patch. Why would you be interested
> in the exact timing rather than the time since the transmission? I
> mean ... why does it go to sleep _earlier_?

Any further comments on this one?

John
--
John W. Linville                Someday the world will need a hero, and you
linville@tuxdriver.com                  might be all we have.  Be ready.
