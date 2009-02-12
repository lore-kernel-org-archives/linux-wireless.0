Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:28147 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbZBLR74 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Feb 2009 12:59:56 -0500
Received: by nf-out-0910.google.com with SMTP id d21so77916nfb.21
        for <linux-wireless@vger.kernel.org>; Thu, 12 Feb 2009 09:59:54 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "Christoph .J Thompson" <cjsthompson@gmail.com>
Subject: Re: Sitecom WL-608 USB WiFi
Date: Thu, 12 Feb 2009 18:59:51 +0100
Cc: linux-wireless@vger.kernel.org
References: <20090211211707.d5e71ddb.cjsthompson@gmail.com> <a32f33a40902120040odc535cp3ecdeef3bc9565ab@mail.gmail.com> <20090212153348.e69a7508.cjsthompson@gmail.com>
In-Reply-To: <20090212153348.e69a7508.cjsthompson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200902121859.51935.IvDoorn@gmail.com> (sfid-20090212_185959_797236_72420FF7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 12 February 2009, Christoph .J Thompson wrote:
> On Thu, 12 Feb 2009 09:40:22 +0100
> Ivo Van Doorn <ivdoorn@gmail.com> wrote:
> > As far as I know the rt2870 driver provided by Ralink contains support
> > for Master mode, and it should even cooperate with hostapd. Not sure
> > if anybody has tested that yet. But you could give it a try.
> 
> I've looked at the RaLink 1.4.0.0 driver for the rt2870usb available on RaLink's
> website and there is only station mode support. Maybe I'm missing something and
> there is a fork or older driver with AP support?

Hmm, the driver does contain comments and some code for master mode,
so perhaps the implementation isn't complete or indeed restricted to an
internal or private version of the driver.

> > Otherwise
> > you can check rt2x00.git to see if the rt2800usb driver can send out
> > beacons correctly. So far I have only tested managed mode and that
> > worked reasonable (if you ignore the lack of 11n AP scan results, and
> > some startup kickups). Note that you should use the module parameter
> > nohwcrypt for rt2800usb to disable HW crypto.
> 
> I think I'll have to resort to that. Sorry if the question is stupid, but
> what version of the kernel is in rt2x00.git? Can I backport the changes
> to 2.6.28.4 by making a diff between rt2x00.git's drivers/net/wireless
> and 2.6.28.4's drivers/net/wireless directory?

rt2x00.git = wireless-testing + rt2800usb
So that makes it 2.6.29-rcx.

It won't be possible to copy the drivers only, you need to copy mac80211
as well, and even then you might run into problems for other API changes.

You might want to grab the compat-wireless testing package, copy the drivers/net/wireless/rt2x00
sourcecode into the compat-wireless folder (just override the existing rt2x00 code). After that it
might be needed to update some Makefiles and config options, but that shouldn't be too hard.

Ivo


