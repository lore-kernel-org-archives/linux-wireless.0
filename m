Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45490 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752126AbXC1OpM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2007 10:45:12 -0400
Subject: Re: WPA/RSN information in cfg80211?
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
In-Reply-To: <1175034846.5151.20.camel@johannes.berg>
References: <1175034846.5151.20.camel@johannes.berg>
Content-Type: text/plain
Date: Wed, 28 Mar 2007 10:47:13 -0400
Message-Id: <1175093233.6907.5.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2007-03-28 at 00:34 +0200, Johannes Berg wrote:
> Looking through wpa_supplicant and then through the kernel I notice that
> we currently in the kernel special-case some things in SIOCSIWAUTH, for
> example IW_AUTH_WPA_VERSION is ignored since we rely on the IE that wpa
> supplicant gave us.
> 
> Apart from how wrong I think this is (we shouldn't be allowing a setting
> we can't do, we need to return some error code and wpa_supplicant should
> sort it out) I also found only one occurrence in prism54 where the
> parameters are actually not ignored. Is that driver fully replaced by
> p54?
> 
> Is there any point in supporting these at all? Does the Libertas 8388
> requires the settings as well instead of just the IE to include?

Libertas driver just uses the WPA1/2 selector stuff internally to figure
out what BSS to associate with; I don't think it's actually needed and
it could certainly be scraped from the IE that the user sets.

For the prism54 driver, I was just translating what the
HOSTAP/PRISM2_IOCTL things did.  I never quite understood why there was
a WPA_VERSION selector in IWAUTH, because I thought the IE did that for
us :)

Dan

> I'm inclined to just require userspace to put both the IE and the
> individual settings into the relevant nl80211 messages, but then we
> might just as well piece the IE together from those settings, no?
> 
> johannes

