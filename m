Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:37794 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753739Ab0FPHqN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jun 2010 03:46:13 -0400
From: Sebastian Smolorz <Sebastian.Smolorz@gmx.de>
To: Kalle Valo <kvalo@adurom.com>
Subject: Re: [RFC] Changes in mac80211 to make at76c50x-usb working again
Date: Wed, 16 Jun 2010 09:46:54 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Marcel Holtmann <marcel@holtmann.org>
References: <201006151416.36686.Sebastian.Smolorz@gmx.de> <1276609006.3648.233.camel@jlt3.sipsolutions.net> <AANLkTinHK_MbKZd9HUDoiWuWs5AmDOQiza0poofzYeDn@mail.gmail.com>
In-Reply-To: <AANLkTinHK_MbKZd9HUDoiWuWs5AmDOQiza0poofzYeDn@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201006160946.54197.Sebastian.Smolorz@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo wrote:
> On 15 June 2010 16:36, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Tue, 2010-06-15 at 09:26 -0400, John W. Linville wrote:
> >> On Tue, Jun 15, 2010 at 02:16:36PM +0200, Sebastian Smolorz wrote:
> >> > the at76c50x-usb driver fails to authenticate with an AP.
> >
> > We need more information on how it fails.
> 
> I debugged this a long time ago. The problem is that firmware's
> CMD_JOIN only works if bssid is correct one. I remember trying
> ff:ff:ff:ff:ff:ff, but that didn't work for some reason. The join
> command needs to be sent before association, otherwise transmission
> won't work at all. And if I use a random bssid the firmware will
> filter the replies. But I tested this a long time ago, I might
> remember something wrong.
> 
> I was thinking a hack which would get bssid from association frames
> and then send CMD_JOIN, before the association frame.

Could you elaborate a little bit on this?

How do we proceed to make the driver working again? Do you want to work on 
this issue?

-- 
Sebastian
