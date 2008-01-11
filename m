Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:44764 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760053AbYAKQtK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jan 2008 11:49:10 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <larry.finger@lwfinger.net>
Subject: Re: [PATCH RFT] b43: Add support for new firmware
Date: Fri, 11 Jan 2008 17:47:18 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <200801102046.56979.mb@bu3sch.de> <47879BE4.7040108@lwfinger.net>
In-Reply-To: <47879BE4.7040108@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200801111747.18797.mb@bu3sch.de> (sfid-20080111_164913_110951_2B4FAA4B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 11 January 2008 17:40:04 Larry Finger wrote:
> Michael Buesch wrote:
> > This patch adds support for new firmware.
> > Please test this on old and new firmware.
> 
> I have tested this patch with old firmware. It seems to work; however my testing is not complete as
> my computer has started hanging with the "Caps Lock" light flashing. The crash is not caused by this
> patch as it happened with 2.6.24-rc5, which has run for many days. I do have a suggestion for
> changing the patch (see below).
> 
> > +static inline
> > +size_t b43_txhdr_size(struct b43_wldev *dev)
> > +{
> > +	if (b43_is_old_txhdr_format(dev))
> > +		return 100 + sizeof(struct b43_plcp_hdr6);
> > +	return 104 + sizeof(struct b43_plcp_hdr6);
> > +}
> 
> Why not eliminate most of the magic numbers in this part with
> 
> size_t b43_txhdr_size(struct b43_wldev *dev)
> {
> 	if (b43_is_old_txhdr_format(dev))
> 		return sizeof(struct b43_txhdr) - 4;
> 	return sizeof(struct b43_txhdr);
> }

Because this is IMO as magic as the above.
The struct b43_txhdr is _not_ meant to be used as an object anymore,
as it now contains this union magic stuff. So we must only use it
as a pointer type. The sizeof, however, uses it as an object.
I'm perfectly fine with the hardcoded constants. And they really
are constants, as they are defined by the hard(firm)ware.
I think this all leads to the same issue as "Should we use
#defines for the PCI IDs in PCI ID tables?".
However, this code will go away in summer anyway. So it doesn't
really matter. It really is just a hack.

-- 
Greetings Michael.
