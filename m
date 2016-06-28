Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:44959 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752683AbcF1K5g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jun 2016 06:57:36 -0400
Message-ID: <1467111448.2493.15.camel@sipsolutions.net> (sfid-20160628_125754_579773_E74FF98F)
Subject: Re: [PATCH] cfg80211/nl80211: add wifi tx power mode switching
 support
From: Johannes Berg <johannes@sipsolutions.net>
To: Wei-Ning Huang <wnhuang@google.com>, Dan Williams <dcbw@redhat.com>
Cc: Linux-Wireless <linux-wireless@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Sameer Nanda <snanda@chromium.org>,
	Todd Broch <tbroch@chromium.org>, davem@davemloft.net,
	netdev@vger.kernel.org
Date: Tue, 28 Jun 2016 12:57:28 +0200
In-Reply-To: <CABicQ-UeU-8PPdK9Je51j_KD-BH8G1HuOjo0yZLcNBQgtJsyTA@mail.gmail.com> (sfid-20160512_113439_036671_8A8ED376)
References: <1462430663-9448-1-git-send-email-wnhuang@chromium.org>
	<1462464478.23962.12.camel@redhat.com>
	<CABicQ-VWrRG+0rEEF0GxUTPixSbkA18Gq4b5hbgph60SoEQ+2Q@mail.gmail.com>
	<CABicQ-XWm=Rxdj3at4+-0OAWn=T7qOTWEaTK=JY7LDOmcN87yw@mail.gmail.com>
	<1462991620.22404.5.camel@redhat.com>
	 <CABicQ-UeU-8PPdK9Je51j_KD-BH8G1HuOjo0yZLcNBQgtJsyTA@mail.gmail.com>
	 (sfid-20160512_113439_036671_8A8ED376)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-05-12 at 17:34 +0800, Wei-Ning Huang wrote:
> 
> Johannes, I feel like being able to set calibration data at runtime
> is something common to all wireless drivers, so instead of using
> vendor commands what do you think if I pass the calibration data name
> instead of using those magic constants? This way, userspace does not
> need to know the details of what band/range power limit the driver
> supports. It allows for flexible driver side implementation and
> easier for userspace to control.
> 

Sorry - I dropped this thread accidentally.

I'm not really sure I understand the situation fully, but right now to
me this seems very strange.

The physical antennas probably don't really change between "clamshell"
and "tablet" mode, do the physical radiation properties change enough
to actually require different *calibration*? To me, that sounds very
strange.

Assuming they don't really change fundamentally, then I understand the
need to set different power levels, per band/channel/whatever
granularity. But that can be achieved in very different ways, and in
fact if you look at Chrome then for our iwl7000 driver there we do have
a command to do something similar (currently a vendor command, but that
can be changed) without ever changing the *calibration*.

So to me, the whole premise of the patch is confusing and/or wrong.

johannes
