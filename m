Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:10925 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932173AbZFOSNC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2009 14:13:02 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 15 Jun 2009 11:13:05 -0700
Date: Mon, 15 Jun 2009 11:13:08 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Marcel Holtmann <marcel@holtmann.org>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"chunkeey@web.de" <chunkeey@web.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"jal2@gmx.de" <jal2@gmx.de>,
	Peter Grabienski <Peter.Grabienski@Atheros.com>,
	Stephen Chen <Stephen.Chen@Atheros.com>,
	Michael Fortin <Michael.Fortin@Atheros.com>,
	Johnny Cheng <Johnny.Cheng@Atheros.com>,
	Yuan-Gu Wei <Yuan-Gu.Wei@Atheros.com>,
	"otus-devel@lists.madwifi-project.org"
	<otus-devel@lists.madwifi-project.org>, <dwmw2@infradead.org>
Subject: Re: [PATCH 0/2] ar9170: 1-stage firmware support / AVM fritz
Message-ID: <20090615181308.GC22922@tesla>
References: <1243546565-19404-1-git-send-email-lrodriguez@atheros.com> <1244992308.15367.3.camel@violet>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1244992308.15367.3.camel@violet>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 14, 2009 at 08:11:48AM -0700, Marcel Holtmann wrote:
> Hi Luis,
> 
> > This series now works for me on my WNDA31000, it took a newer shiny
> > 1-stage firmware to work. I'll push the firmware into linux-firmware
> > next.
> >
> > Should work with the AVM Fritz devices now, haven't tested it but
> > I think it should work.
> 
> I happened to have one of these AVM devices. With ar9170.fw firmware it
> does work fine with the other ones it doesn't.

Excellent, that was the idea behind the patch, to enable these
devices. Thanks for testing.

> The ar9170.fw is still not in linux-firmware.git, any reason for that?

Yes, the patch I sent to David has some funk as objcopy to ihex seems
to have some trailing white space. I sent a new patch to him without
the ihex file though.

> Also since ar9170-1.fw and ar9170-2.fw are not working at all,

They work, they won't work for the AVM device though.

> we better
> not even try and give the user a crypted error message that the device
> is in a bad state. Just printk that the firmware might be too old.

Agreed, but as I sent the patch in we *require* the 1-stage firmware
for the AVM devices, if that is not present we should be bailing out.
Is that not what happens?

  Luis
