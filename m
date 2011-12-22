Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:44408 "HELO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751176Ab1LVGIr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Dec 2011 01:08:47 -0500
Date: Thu, 22 Dec 2011 11:38:15 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: Re: [PATCH] mac80211: Call driver commands after drv_start in
 mac80211 restart code
Message-ID: <20111222060814.GA2539@hertz.marvell.com> (sfid-20111222_070850_296341_18DDF615)
References: <20111220060505.GA4556@hertz.marvell.com>
 <20111221132810.GB2235@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20111221132810.GB2235@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 21, 2011 at 05:28:11AM -0800, Stanislaw Gruszka wrote:
> On Tue, Dec 20, 2011 at 11:35:16AM +0530, Yogesh Ashok Powar wrote:
> > Ideally, hardware/firmware initialization is complete after the
> > drv_start routine. In mac80211 restart code (ieee80211_reconfig),
> > defer calling the driver commands i.e. setup fragmentation
> > threshold, rts threshold and coverage class till drv_start
> > routine is called.
> 
> I think this could break drivers that could relay on order we
> have at present. Also chenglog does not tell much. What for you
> need that change?
Is there any specific example? Currently, when the AP is initialized
by the hostapd, drv_start is called first and then the mentioned
commands. We should follow the same sequence even during reconfig. The
reason we need these commands to be sent after drv_start is mentioned in
the commit log i.e. our hw/firmware initialization gets completed in
drv_start. Hence we expect these commands only after drv_start.

Thanks
Yogesh
