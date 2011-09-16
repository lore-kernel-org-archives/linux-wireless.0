Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:22982 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495Ab1IPJ1D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Sep 2011 05:27:03 -0400
Date: Fri, 16 Sep 2011 14:57:38 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: <johannes@sipsolutions.net>, <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH v2] mac80211: stop tx before doing hw config and rate
 update
Message-ID: <20110916092737.GA1834@vmraj-lnx.users.atheros.com> (sfid-20110916_112708_501262_3650C76F)
References: <1314951719-9816-1-git-send-email-rmanohar@qca.qualcomm.com>
 <4E730147.1090408@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4E730147.1090408@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 16, 2011 at 09:56:55AM +0200, Felix Fietkau wrote:
> On 2011-09-02 10:21 AM, Rajkumar Manoharan wrote:
> >The assumption is that during the hw config, transmission was
> >already stopped by mac80211. Sometimes the AP can be switching
> >b/w the ht modes due to intolerant or etc where STA is in
> >the middle of transmission. In such scenario, buffer overflow
> >was observed at driver side. And also before updating the rate
> >control, the frames are continued to xmited with older rates.
> >This patch ensures that the frames are always xmitted with
> >updated rates and avoid buffer overflow.
> >
> >Signed-off-by: Rajkumar Manoharan<rmanohar@qca.qualcomm.com>
> John, please revert this one, it's completely messed up. It stops
> queues, and calls drv_flush whenever it receives a beacon with
> 802.11n information, even if 802.11n is already enabled and the mode
> is the correct one.
> Additionally, it even wakes the queues again before the settings
> have been applied, so it's 100% useless.

As we discussed in irc, drv_flush & queue stop shouldn't be called
so frequently. It is a bug. But this patch prevents the transmission
while doing hw config because of 20/40 switch from beacon ie. So
this patch is really needed and also there is not point in covering
bss_info_change state. To avoid the accidential queue wakeup by
flush, this patch defines new reason code. I will send the followup
patch ASAP.

--
Rajkumar
