Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from canuck.infradead.org ([209.217.80.40]:59469 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756344AbXHBWqm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2007 18:46:42 -0400
Subject: Re: mac80211 IPv6 problems
From: David Woodhouse <dwmw2@infradead.org>
To: Daniel Drake <dsd@gentoo.org>
Cc: Larry Finger <larry.finger@lwfinger.net>,
	Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	Bcm43xx-dev@lists.berlios.de, jbenc@suse.cz,
	flamingice@sourmilk.net
In-Reply-To: <46B25B04.5020804@gentoo.org>
References: <46b1fde0.b+weBDN75J0SPe2a%Larry.Finger@lwfinger.net>
	 <200708021807.20649.mb@bu3sch.de>  <46B20695.2080100@lwfinger.net>
	 <1186088678.2931.10.camel@pmac.infradead.org> <46B25B04.5020804@gentoo.org>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 02 Aug 2007 23:46:18 +0100
Message-Id: <1186094778.6701.6.camel@shinybook.infradead.org>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2007-08-02 at 18:30 -0400, Daniel Drake wrote:
> This may be a stack-level issue. This is one of the issues holding ba=
ck=20
> zd1211rw-mac80211 going into mainline: we have a report that=20
> zd1211rw-softmac works fine with IPv6 but mac80211 only works=20
> occasionally with the same device on the same system.
>=20
> Does anyone have any ideas?

It receives its own neighbour solicitation (multicast) packets when the
AP sends them back out again. These packets...

23:41:56.046939 00:0a:95:f3:99:92 > 33:33:ff:f3:99:92, ethertype IPv6
(0x86dd), length 78: :: > ff02::1:fff3:9992: ICMP6, neighbor
solicitation, who has fe80::20a:95ff:fef3:9992, length 24

You should be able to see this without _any_ IPv6 infrastructure -- and
you'll see the link-local IPv6 address remains 'tentative'.

Once you've fixed that, setting up a local route advertisement d=C3=A6m=
on
(radvd) to give you site-local addresses is fairly trivial too -- and
then you can also check that Ethernet multicast is working properly.

--=20
dwmw2

-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
