Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59280 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674Ab3KGSAT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Nov 2013 13:00:19 -0500
Date: Thu, 7 Nov 2013 12:52:02 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Solomon Peachy <pizza@shaftnet.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Greg KH <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org
Subject: Re: future of prism2_usb (aka wlan-ng) in staging tree
Message-ID: <20131107175201.GA2002@tuxdriver.com> (sfid-20131107_190023_344081_8186E7F0)
References: <20131107160522.GA12612@shaftnet.org>
 <527BC04F.2080000@lwfinger.net>
 <20131107163719.GC12612@shaftnet.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20131107163719.GC12612@shaftnet.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 07, 2013 at 11:37:19AM -0500, Solomon Peachy wrote:
> On Thu, Nov 07, 2013 at 10:31:11AM -0600, Larry Finger wrote:
> > This seems like a good point to clarify what it takes for a wireless
> > driver to be added to net/wireless.
> > 
> > Is it necessary that any new softmac driver in net/wireless must use
> > mac80211, or is it sufficient that it implement cfg80211?
> 
> IMO a softmac driver should use mac80211 before being merged; there's no 
> sense in having multiple 802.11 stacks especially with the ever-growing 
> complexity of 802.11.
> 
> But in this particular case, prism2_usb/wlan-ng is perhaps the original 
> fullmac 802.11 device.  :)

We have long said that any softmac driver needs to be based on
mac80211.  We have also been saying for some time that any newly
merged drivers need to fully support cfg80211.  FWIW, I think that
we would actively discourage anyone from implementing any support at
all for wireless extensions -- shouldn't need that anyway with full
cfg80211 support..

I haven't looked at the driver in question in a long time.  Are there
actually any users?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
