Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:48175 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888AbZDCEfH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Apr 2009 00:35:07 -0400
Subject: Re: How does rfkill work?
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1238684527.4141.63.camel@johannes.local>
References: <49D44635.80306@lwfinger.net>
	 <1238666206.4141.12.camel@johannes.local>  <49D4CF50.2060100@lwfinger.net>
	 <1238684527.4141.63.camel@johannes.local>
Content-Type: text/plain
Date: Fri, 03 Apr 2009 06:35:03 +0200
Message-Id: <1238733303.19390.0.camel@violet> (sfid-20090403_063522_185614_128625F9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> > > Can you check the contents of
> > > 	/sys/class/leds/b43legacy-...::radio/trigger
> > > please?
> > 
> > The first thing I noticed is that "radio" gets truncated to "rad", thus the file
> > is /sys/class/leds/b43legacy-phy0\:\:rad/trigger,
> 
> Cute. Must be that the limit is 20 bytes (19+NUL) in the buffer it uses
> in led core code.

then this needs fixing in the LED core. We don't have a length limit in
the driver core anymore. Is this an older kernel?

Regards

Marcel


