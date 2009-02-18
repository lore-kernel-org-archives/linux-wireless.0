Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:54303 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752062AbZBRHcP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Feb 2009 02:32:15 -0500
Date: Wed, 18 Feb 2009 09:31:04 +0200
From: Jouni Malinen <j@w1.fi>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Dan Williams <dcbw@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: Missing link quality with wireless-testing
Message-ID: <20090218073104.GA23366@jm.kir.nu> (sfid-20090218_083219_546555_0337B005)
References: <1234896777.4678.7.camel@californication> <1234899806.29785.35.camel@johannes.local> <1234902294.4678.12.camel@californication> <1234904111.29785.44.camel@johannes.local> <1234904978.4678.31.camel@californication> <1234913132.11832.10.camel@70-5-246-164.pools.spcsdns.net> <1234933059.21412.28.camel@californication>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1234933059.21412.28.camel@californication>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 18, 2009 at 05:57:39AM +0100, Marcel Holtmann wrote:
> > Would setting qual->updated |= IW_QUAL_QUAL_INVALID; work for you?  If
> > some app doesn't handle that, it's totally, completely broken.
> 
> does wpa_supplicant handle this value correctly? I actually never
> checked that.

No, it doesn't use qual->updated at all. Then again, neither does it
rely on qual->qual either. The signal level (qual->level) is used first
and only if that is not available, qual->qual will be used in sorting
the results.

> However I think it is bad practice to abandon a value that has been
> previously set by mac80211 and remove it without any further warning. If
> a driver never set the value before it is a different story than
> mac80211 deciding to not set it any more from one kernel version to
> another one.

It would be interesting to know which applications depend only on
qual->qual values being there and cannot use qual->level. Anyway, I
would agree that it would be reasonable to fill in something in the
qual->qual field for now. It should be enough to do this in the wext
compat code (i.e., not changing anything in mac80211 and only touching
#ifdef CONFIG_WIRELESS_EXT blocks in net/wireless/scan.c). This would
provide somewhat useful value for applications that depend on a value
that was not really guaranteed to be there in the first place. I think I
would include the IW_QUAL_QUAL_INVALID flag anyway and just target the
broken apps with this workaround.

-- 
Jouni Malinen                                            PGP id EFC895FA
