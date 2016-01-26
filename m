Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:33371 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757138AbcAZJNB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 04:13:01 -0500
Message-ID: <1453799572.30130.51.camel@collabora.co.uk> (sfid-20160126_101311_309832_3F0423D2)
Subject: Re: [PATCH] brcmfmac: sdio: Increase the default timeouts a bit
From: Sjoerd Simons <sjoerd.simons@collabora.co.uk>
To: Arend van Spriel <arend@broadcom.com>,
	Doug Anderson <dianders@chromium.org>,
	Arend van Spriel <aspriel@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	Paul Stewart <pstew@chromium.org>,
	"open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	brcm80211-dev-list@broadcom.com,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>, netdev@vger.kernel.org,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
Date: Tue, 26 Jan 2016 10:12:52 +0100
In-Reply-To: <56A68064.5020702@broadcom.com>
References: <1453718849-3508-1-git-send-email-sjoerd.simons@collabora.co.uk>
	 <56A64114.3010400@gmail.com>
	 <CAD=FV=X-ejMLnh30TofU7dKP5WwZaXcgLaQwFs__wo9wHsv53Q@mail.gmail.com>
	 <56A68064.5020702@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-01-25 at 21:07 +0100, Arend van Spriel wrote:
> On 25-1-2016 20:23, Doug Anderson wrote:
> > Kinda curious: do we get one or two really slow responses on every
> > bootup, or just some bootups?  Do we ever succeed even with a slow
> > (like 1.8 or 1.9 seconds) response, or is it always either "fast"
> > or
> > "2.1" seconds?
> 
> Now these are interesting questions that I should have spilled out in
> the first place. Thanks.

I would need to get a more data to really conclusively say, but what i
saw in testing thusfar was:

* The issue occurs on _some_ boots
* The issue seems to come up more often on warm reboots
* The likelyhood seemed to change depending on the kernel
  configuration (iotw when the initilisation order/timing changed?)
* Forcing the brcmfmac module to load later in boot seemed to make the 
  likelyhood of the issue showing up lower.
* The samples I have with traces showed either quick responses on 
  success or slow "2.1" seconds responses on failure.

I'll try to make some time to get some statistics over a series of
boots wrt. the response time(s) for control messages so we can get a
better idea how often this happens and its behaviour.


I guess one other thing to note is that both Doug and myself were
seeing this on Rockchip RK3288 based devices. It would ofcourse be
interesting to know if this has been seen on other types of devices..

-- 
Sjoerd Simons
Collabora Ltd.
