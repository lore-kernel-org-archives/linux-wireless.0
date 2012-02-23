Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm11-vm0.bullet.mail.ird.yahoo.com ([77.238.189.218]:45833 "HELO
	nm11-vm0.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752219Ab2BWC1V convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Feb 2012 21:27:21 -0500
Message-ID: <1329964040.38655.YahooMailClassic@web29503.mail.ird.yahoo.com> (sfid-20120223_032725_307563_9FBA05B1)
Date: Thu, 23 Feb 2012 02:27:20 +0000 (GMT)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: [PATCH] rtl8187: Add Ad-hoc mode
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Attila Fazekas <turul64@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Herton Ronaldo Krzesinski <herton@canonical.com>
In-Reply-To: <CAGRGNgXOjKZQqF_JrAA0hyqcsn8TZWHd9OysqOMrE5_JrmnRjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- On Thu, 23/2/12, Julian Calaby <julian.calaby@gmail.com> wrote:

> If it's anything like how it works on Ubuntu, when you start
> an Ad-Hoc
> network with NetworkManager, it chooses an IP range based on
> some
> internal logic (usually in the 10.0.0.0/8 private network)
> sets it's
> IP to something sensible then starts a DHCP server for
> everyone else
> on the network, so everyone should get a valid IP.

Thanks - that would make sense. (I have no experience setting up an ad-hoc network).

OTOH, just so that we have established the basics - I would shutdown networkmanger/wpa_supplicant and do things manually if I were to test prototype driver patches though. There are many reasons why ad-hoc mode itself might work but one cannot ping, other than the patch not working or the hardware not behaving. The latter is in the tcp/ip layer and quite a lot higher than the wifi mac layer - if one had iptables/netfilter blocking icmp echo, for example. I'd probably just look at the packet stats from iwconfig/ifconfig, and may be firing up wireshark. It is up to Attila to show that it does work, and Larry to show that it does not :-).

Hin-Tak
