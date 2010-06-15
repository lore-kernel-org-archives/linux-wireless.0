Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:58776 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368Ab0FOOdl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jun 2010 10:33:41 -0400
Received: by wwb18 with SMTP id 18so4833322wwb.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 Jun 2010 07:33:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1276609006.3648.233.camel@jlt3.sipsolutions.net>
References: <201006151416.36686.Sebastian.Smolorz@gmx.de>
	<20100615132619.GB12885@tuxdriver.com>
	<1276609006.3648.233.camel@jlt3.sipsolutions.net>
Date: Tue, 15 Jun 2010 17:26:14 +0300
Message-ID: <AANLkTinHK_MbKZd9HUDoiWuWs5AmDOQiza0poofzYeDn@mail.gmail.com>
Subject: Re: [RFC] Changes in mac80211 to make at76c50x-usb working again
From: Kalle Valo <kvalo@adurom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Sebastian Smolorz <Sebastian.Smolorz@gmx.de>,
	linux-wireless@vger.kernel.org,
	Marcel Holtmann <marcel@holtmann.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15 June 2010 16:36, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2010-06-15 at 09:26 -0400, John W. Linville wrote:
>> On Tue, Jun 15, 2010 at 02:16:36PM +0200, Sebastian Smolorz wrote:
>> > the at76c50x-usb driver fails to authenticate with an AP.
>
> We need more information on how it fails.

I debugged this a long time ago. The problem is that firmware's
CMD_JOIN only works if bssid is correct one. I remember trying
ff:ff:ff:ff:ff:ff, but that didn't work for some reason. The join
command needs to be sent before association, otherwise transmission
won't work at all. And if I use a random bssid the firmware will
filter the replies. But I tested this a long time ago, I might
remember something wrong.

I was thinking a hack which would get bssid from association frames
and then send CMD_JOIN, before the association frame. IMHO no need to
change mac80211 because of this old hardware.

Kalle
