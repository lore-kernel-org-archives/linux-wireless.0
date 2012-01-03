Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([93.93.128.6]:43581 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab2ACDZR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jan 2012 22:25:17 -0500
Date: Tue, 3 Jan 2012 03:25:05 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Jack Stone <jwjstone@fastmail.fm>,
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
Message-ID: <20120103032505.GA19702@srcf.ucam.org> (sfid-20120103_042603_412043_12096BB3)
References: <20120102215028.GA15701@srcf.ucam.org>
 <Pine.LNX.4.44L0.1201022136190.20386-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <Pine.LNX.4.44L0.1201022136190.20386-100000@netrider.rowland.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 02, 2012 at 09:45:58PM -0500, Alan Stern wrote:

> Wait a second.  Why does isight_firmware bind at this time?  Binding to
> new devices is handled by khubd, which doesn't start running again
> until after the resume is finished (the device appears to be new
> because its descriptors have changed).  At that point there should be
> no trouble reloading the firmware.

Then why are we getting this warning? The firmware is only loaded in the 
probe function.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
