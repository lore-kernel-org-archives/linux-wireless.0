Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out002.kontent.com ([81.88.40.216]:43001 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab2AAM1B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Jan 2012 07:27:01 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Marek Vasut <marek.vasut@gmail.com>
Subject: Re: loading firmware while usermodehelper disabled.
Date: Sun, 1 Jan 2012 13:28:41 +0100
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	"John W. Linville" <linville@tuxdriver.com>,
	Matthew Garrett <mjg@redhat.com>,
	"Greg Kroah-Hartman" <gregkh@suse.de>,
	USB list <linux-usb@vger.kernel.org>,
	Linux Wireless List <linux-wireless@vger.kernel.org>
References: <20111230235421.GA6054@redhat.com> <201201011048.18953.oliver@neukum.org> <201201011054.47233.marek.vasut@gmail.com>
In-Reply-To: <201201011054.47233.marek.vasut@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201201011328.41311.oliver@neukum.org> (sfid-20120101_132731_027612_A602148C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Sonntag, 1. Januar 2012, 10:54:47 schrieb Marek Vasut:
> > Am Samstag, 31. Dezember 2011, 19:39:18 schrieb Marek Vasut:
> > > maybe we should implement such thing into the firmware loader itself?
> > > Allow it -- for example via some node in /dev -- to force loading
> > > firmware into some buffer in kernel just before suspend so it'll
> > > certainly be readily available at resume time?
> > 
> > This is difficult. We don't know at suspend time which firmware we will
> > need at resume time.
> 
> That's not actually true ... you can ask the drivers if they need to load 
> firmware after resume ... that can be implemented and udev can handle it. The 
> driver should know if the hardware it's controlling is stupid or not.

Device IDs can morph due to a power loss. After resumption another driver
would bind.

	Regards
		Oliver
