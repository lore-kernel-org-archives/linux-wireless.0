Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dhost002-35.dex002.intermedia.net ([64.78.21.120]:33152 "EHLO
	dhost002-35.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965661AbXC1TAa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2007 15:00:30 -0400
From: "Jouni Malinen" <jkm@devicescape.com>
Date: Wed, 28 Mar 2007 12:00:17 -0700
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
Subject: Re: WPA/RSN information in cfg80211?
Message-ID: <20070328190017.GI6036@devicescape.com>
References: <1175034846.5151.20.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1175034846.5151.20.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 28, 2007 at 12:34:06AM +0200, Johannes Berg wrote:

> Looking through wpa_supplicant and then through the kernel I notice that
> we currently in the kernel special-case some things in SIOCSIWAUTH, for
> example IW_AUTH_WPA_VERSION is ignored since we rely on the IE that wpa
> supplicant gave us.

Use of WPA/RSN IE vs. individual parameters depends on the driver. For
example, NDIS drivers generate the IEs internally and need to be
configured with the key management (WPA-PSK, WPA-Enterprise, WPA2-PSK,
WPA2-Enterprise, ..) and cipher suites separately. They would not use
WPA/RSN IE at all. Some drivers use the IE so that kernel code does not
need to have all the code for generating it. They may (or may not,
depending on needs) ignore the individual values.

> Apart from how wrong I think this is (we shouldn't be allowing a setting
> we can't do, we need to return some error code and wpa_supplicant should
> sort it out) I also found only one occurrence in prism54 where the
> parameters are actually not ignored. Is that driver fully replaced by
> p54?

Those two options are there for a reason and which one will be used will
depend on the driver. At the moment, wpa_supplicant does not really like
the error code, but if I remember correctly, it will, in practice), try
to continue associating anyway and the only problem is a bit confusing
output in debug log. Returning -EOPNOTSUPP for parameters that are not
used should be fine.

> Is there any point in supporting these at all?

Yes.

> I'm inclined to just require userspace to put both the IE and the
> individual settings into the relevant nl80211 messages, but then we
> might just as well piece the IE together from those settings, no?

As long as the information is available for the driver at the time of
association request, it does not really matter how that information got
there..

-- 
Jouni Malinen                                            PGP id EFC895FA
