Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35631 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761509Ab3DCNox (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 09:44:53 -0400
Message-ID: <1364996685.8351.46.camel@jlt4.sipsolutions.net> (sfid-20130403_154456_761775_D015B305)
Subject: Re: mac80211_hwsim driver attribute
From: Johannes Berg <johannes@sipsolutions.net>
To: Martin Pitt <martin.pitt@ubuntu.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, dcbw@redhat.com
Date: Wed, 03 Apr 2013 15:44:45 +0200
In-Reply-To: <20130403133802.GK2960@piware.de>
References: <20130403133802.GK2960@piware.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Martin,

>  /sys/class/net/wlan0/device/driver -> ../../../../bus/pci/drivers/iwlwifi
> 
> But /sys/class/net/wlan1/device/ only has the default "uevent" and
> subsystem link.

I suspect this is because there's no real "device", and therefore no
real driver.

We do play with device_create() in hwsim, which was likely intended to
address something like this, but I have no idea how this should really
work.

johannes

