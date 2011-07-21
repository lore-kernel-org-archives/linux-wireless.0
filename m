Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39477 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751949Ab1GURQD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2011 13:16:03 -0400
Subject: Re: [PATCH v2 3/3] libertas: reimplement mesh channel selection
From: Dan Williams <dcbw@redhat.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: Daniel Drake <dsd@laptop.org>, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, libertas-dev@lists.infradead.org
Date: Thu, 21 Jul 2011 11:38:43 -0500
In-Reply-To: <87hb6gu8k5.fsf@purkki.adurom.net>
References: <20110720165403.52B629D401C@zog.reactivated.net>
	 <87hb6gu8k5.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <1311266334.3059.11.camel@dcbw.foobar.com> (sfid-20110721_191609_067262_E80D6B4C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-07-20 at 21:10 +0300, Kalle Valo wrote:
> Daniel Drake <dsd@laptop.org> writes:
> 
> > This reimplements code allowing for mesh channel selection according
> > to how NetworkManager expects.
> 
> [...]
> 
> > +static const iw_handler mesh_iw_handler[] =
> > +{
> > +	IW_HANDLER(SIOCGIWNAME, (iw_handler) mesh_get_name),
> > +	IW_HANDLER(SIOCGIWFREQ, (iw_handler) mesh_get_freq),
> > +	IW_HANDLER(SIOCSIWFREQ, (iw_handler) mesh_set_freq),
> > +};
> 
> We are trying to remove wext code, not add it. I'm surprised to see this.

Mesh on OLPC/usb8388 was a pre-802.11s mesh protocol specific to OLPC
implementations.  It's unlikely it would map directly to the standard
mesh layer in mac80211/nl80211, plus it's all fullmac handled by the
firmware.  So unless we want to look into creating one-off commands for
the OLPC mesh bits for nl80211, we probably just want to keep the wext
bits for this until we remove wext completely in the next few years.

Dan

