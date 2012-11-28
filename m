Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:40313 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031Ab2K1FyI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 00:54:08 -0500
Message-ID: <1354082008.25524.10.camel@cumari.coelho.fi> (sfid-20121128_065415_932309_886E5A4B)
Subject: Re: [PATCH 14/20] wlcore: restore default channel configuration
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
CC: <linux-wireless@vger.kernel.org>,
	Victor Goldenshtein <victorg@ti.com>
Date: Wed, 28 Nov 2012 07:53:28 +0200
In-Reply-To: <1354080927.25524.6.camel@cumari.coelho.fi>
References: <1353998701-18171-1-git-send-email-arik@wizery.com>
	 <1353998701-18171-15-git-send-email-arik@wizery.com>
	 <1354023406.950.109.camel@cumari.coelho.fi>
	 <CA+XVXfeeo9kPmKyo=qtn_bAnj5gveiKa6PiMq8hV-5P9P4oyhw@mail.gmail.com>
	 <1354080927.25524.6.camel@cumari.coelho.fi>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-11-28 at 07:35 +0200, Luciano Coelho wrote:
> On Tue, 2012-11-27 at 23:32 +0200, Arik Nemtsov wrote:
> > I'm also not sure that having cfg80211 change a structure allocated
> > and owned by the driver is the cleanest solution for the regulatory
> > stuff.
> 
> Yeah, but it has always been like that.  I think the idea is probably
> the same: to avoid duplicate arrays.  But if cfg80211 modifies it, it
> should be able to reset it back to the original as well.  Or the driver
> must alloc a new one each time.
> 
> I wonder what the other drivers do...

I had a quick look and it seems that iwlwifi has the channels struct in
eeprom, so it needs a copy anyway; ath9k seems to make a copy of the
struct before passing it to cfg80211; and ath5k seems to auto-generate
the list using different sources as input.

--
Luca.

