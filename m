Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([93.93.128.6]:60228 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468Ab2ACAOJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jan 2012 19:14:09 -0500
Date: Tue, 3 Jan 2012 00:13:56 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Jack Stone <jwjstone@fastmail.fm>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Oliver Neukum <oliver@neukum.org>,
	Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	"John W. Linville" <linville@tuxdriver.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	USB list <linux-usb@vger.kernel.org>,
	Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: loading firmware while usermodehelper disabled.
Message-ID: <20120103001356.GA17183@srcf.ucam.org> (sfid-20120103_011450_244438_4CE25078)
References: <20120102211904.GA15316@srcf.ucam.org>
 <CA+55aFwJuuvqcsgHnZ4-VhUhbVvL6beKogo1adgYyZt_ZM=H7A@mail.gmail.com>
 <20120102215028.GA15701@srcf.ucam.org>
 <CA+55aFz73GuHiOW1NoAuJLea_GKLepiZjrnrgpOKdQizPgnhoA@mail.gmail.com>
 <20120102221235.GA16012@srcf.ucam.org>
 <CA+55aFyHvmvast_kuNddU3iotReR1mOpKM4HGAw80ma8kn+2-g@mail.gmail.com>
 <20120102222920.GA16160@srcf.ucam.org>
 <CA+55aFyUK6X7ip2UXV9iT07=qezXfbw82wn6UKAN8JFQtYNs5Q@mail.gmail.com>
 <20120102230037.GA16458@srcf.ucam.org>
 <4F023E6B.2020307@fastmail.fm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4F023E6B.2020307@fastmail.fm>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 02, 2012 at 11:31:55PM +0000, Jack Stone wrote:

> Rather than merging the drivers we could make the uvcvideo (or any other
> generic driver) driver expose a "subdriver" interface that allows
> another module to bind to the specific ID and add extra handling to
> certain events. We could then use that interface to provide a firmware
> driver for each device that needs it. The firmware driver could bind to
> the bootstrap device and to the uvcvideo subdriver interface and it
> would then have all the lifetime info we need. [Credit to Linus for
> suggesting this idea]

No, the uvcvideo driver would need to call out to load the firmware 
loader driver, otherwise you'll never know to load the firmware loader 
driver.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
