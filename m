Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33054 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbcDRQUJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2016 12:20:09 -0400
From: Christian Lamparter <chunkeey@googlemail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Lauri Kasanen <cand@gmx.com>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	sgruszka@redhat.com, emmanuel.grumbach@intel.com,
	linuxwifi@intel.com, johannes.berg@intel.com
Subject: Re: [PATCH v2] carl9170: Clarify kconfig text
Date: Mon, 18 Apr 2016 18:20:06 +0200
Message-ID: <3244016.0TmHG3E4A9@debian64> (sfid-20160418_182032_023033_8AAE0BB9)
In-Reply-To: <87shyiyl8a.fsf@purkki.adurom.net>
References: <20160416113312.8de2266358165182bb4b4a15@gmx.com> <20160416171856.1769c0e16bcc75372407e06f@gmx.com> <87shyiyl8a.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, April 18, 2016 06:45:09 PM Kalle Valo wrote:
> Lauri Kasanen <cand@gmx.com> writes:
> 
> > The previous text was confusing, leading readers to think this
> > driver was a duplicate, and so didn't need to be enabled.
> >
> > After the removal of the older staging driver, this is the only
> > driver in mainline for these devices.
> >
> > Signed-off-by: Lauri Kasanen <cand@gmx.com>
> > ---
> > v2: Remove the mention of the previous driver, suggested by Christian.
> >
> >  drivers/net/wireless/ath/carl9170/Kconfig | 8 +++-----
> >  1 file changed, 3 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/net/wireless/ath/carl9170/Kconfig b/drivers/net/wireless/ath/carl9170/Kconfig
> > index 1a796e5..2e34bae 100644
> > --- a/drivers/net/wireless/ath/carl9170/Kconfig
> > +++ b/drivers/net/wireless/ath/carl9170/Kconfig
> > @@ -5,12 +5,10 @@ config CARL9170
> >  	select FW_LOADER
> >  	select CRC32
> >  	help
> > -	  This is another driver for the Atheros "otus" 802.11n USB devices.
> > +	  This is the mainline driver for the Atheros "otus" 802.11n USB devices.
> >  
> > -	  This driver provides more features than the original,
> > -	  but it needs a special firmware (carl9170-1.fw) to do that.
> > -
> > -	  The firmware can be downloaded from our wiki here:
> > +	  It needs a special firmware (carl9170-1.fw), which can be downloaded
> > +	  from our wiki here:
> >  	  <http://wireless.kernel.org/en/users/Drivers/carl9170>
> 
> Why even mention anything about a "special firmware" as the firmware is
> already available from linux-firmware.git? 
Yes and no. 1.9.6 is in linux-firmware.git. I've tried to add 1.9.9 too
but that failed.
<http://comments.gmane.org/gmane.linux.kernel.wireless.general/114639>

> That's default location for all firmware images and I think most, if not all,
> distros should have it available. So wouldn't it be better not to mention 
> anything about firmware at all?
Sure, but this could be a different patch then. I think Intel devices 
(iwlwifi, iwlegacy and ipw2x00) have a similar text about "download
firmware from this device from our homepage here" too. So if we want,
we can remove them altogether?

Regards,
Christian
