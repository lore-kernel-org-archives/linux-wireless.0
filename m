Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.190]:54048 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbYJCSSa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Oct 2008 14:18:30 -0400
Received: by fk-out-0910.google.com with SMTP id 18so1176663fkq.5
        for <linux-wireless@vger.kernel.org>; Fri, 03 Oct 2008 11:18:28 -0700 (PDT)
To: Gertjan van Wingerde <gwingerde@kpnplanet.nl>
Subject: Re: Regulatory Framework & rt2x00.
Date: Fri, 3 Oct 2008 20:18:24 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>, mcgrof@gmail.com,
	linux-wireless@vger.kernel.org
References: <48E52D07.8050900@kpnplanet.nl> <1223021104.24551.61.camel@johannes.berg>
In-Reply-To: <1223021104.24551.61.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200810032018.24910.IvDoorn@gmail.com> (sfid-20081003_201834_194893_8E47C243)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> > The problem I'm facing is that many of the Ralink devices have 2 region 
> > settings in their EEPROM, one for 802.11a networks, and one for 
> > 802.11[bgn] networks. So far I have only seen devices where these two 
> > settings contain the same region indication, but I don't know whether 
> > this is the case for all devices.
> > 
> > At this point in time I use the regulatory_hint function at driver 
> > start-up time to communicate the region setting that matches the 
> > configured band, but that would (probably) not hold up when the user 
> > reconfigures the mode.
> 
> I think you basically have two choices depending on whether you have a
> country code in the eeprom or not.
> 
> If you have a country code, I suggest you just use either one.
> 
> As far as I know, though, you don't have country codes. So if there's a
> valid code in the EEPROM you probably should use the regdomain struct
> hint rather than the alpha2 hint and build a regdomain that contains
> both 2.4 and 5 GHz channels based on the two region values you have.

For rt61pci and rt73usb you should do as Johannes suggested by using the
regdomain struct. For rt2500pci and rt2500usb it sounds much easier to
take the country code from the EEPROM since those devices only contain
a single regdom value.

Ivo
