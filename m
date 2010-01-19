Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:37122 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754572Ab0ASRLV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jan 2010 12:11:21 -0500
Date: Tue, 19 Jan 2010 09:11:16 -0800
From: Jouni Malinen <j@w1.fi>
To: Eric Volker <evolker@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: eapol_version=1 required for OS X clients?
Message-ID: <20100119171116.GA16616@jm.kir.nu>
References: <1263876237.2619.1.camel@fwdell4550>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1263876237.2619.1.camel@fwdell4550>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 18, 2010 at 10:43:56PM -0600, Eric Volker wrote:

> Is EAP version 1 secure?

It is not EAP version; it is EAPOL version.. In practice, there is no
difference in how hostapd behaves as far as version 1 and 2 are
concerned apart from the value in the header.

> In light of this issue, why is version 2 default? Is there any way to
> negotiate the version level? Which version do off-the-shelf consumer
> routers use?

hostapd is implemented based on 802.1X-2004 and version 2 and as such,
version number 2 is the correct value to use. I would expect
off-the-shelf consumer products use a mix of both version 1 and 2. I
haven't checked this lately, but version 2 started showing up years ago
in many devices.

IEEE 802.1X-2004 (and already the earlier -2001 version) described
version negotiation mechanism for EAPOL. There are some implementations
that did not do this correctly and had problems when -2004 was
introduced (over fixe years ago!).

> Based on the comments in hostapd.conf, EAP only seems to be used for
> 802.1X authentication. I'm using WPA/WPA2 (wpa=3) Personal
> authentication, so why does the EAP version matter?

Because it is not "EAP version", but "EAPOL version" and
WPA/WPA2-Personal uses EAPOL frames.

> Why is an OS as recent as Snow Leopard (10.6) using a protocol version
> that the hostapd.conf comments imply is outdated?

It would be fine to use protocol version 1, but the real question here
is why does it not implement IEEE 802.1X version negotiation correctly..
Anyway, I do not think I've seen this with OS X tests myself (both 10.4
and 10.6), but do not remember details.. In other words, this could be
an issue in a component (just the driver?) and not the generic
supplicant in the OS.

-- 
Jouni Malinen                                            PGP id EFC895FA
