Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.178]:32518 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757832AbXK2ViI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2007 16:38:08 -0500
Received: by py-out-1112.google.com with SMTP id u77so3878725pyb
        for <linux-wireless@vger.kernel.org>; Thu, 29 Nov 2007 13:38:07 -0800 (PST)
Message-ID: <43e72e890711291338j3fb7876fp49b7489764fe2d1a@mail.gmail.com> (sfid-20071129_213812_726126_256423CF)
Date: Thu, 29 Nov 2007 16:38:06 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Francesco Gringoli" <francesco.gringoli@ing.unibs.it>
Subject: Re: ath5k: filter patch
Cc: linux-wireless@vger.kernel.org,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Thomas Graf" <tgraf@suug.ch>, "Jiri Slaby" <jirislaby@gmail.com>,
	"Michael Wu" <flamingice@sourmilk.net>
In-Reply-To: <0D869D0B-A5CF-4AE4-B986-DB168917296B@ing.unibs.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <0D869D0B-A5CF-4AE4-B986-DB168917296B@ing.unibs.it>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Nov 29, 2007 10:53 AM, Francesco Gringoli
<francesco.gringoli@ing.unibs.it> wrote:
> Hello everybody,
>
> I discovered that playing with iface promiscuity to capture traffic
> (including control, promisc and all other stuff) is not working on
> ath5k as rx_filters are never refreshed. To make things going I added
> a single ath5k_hw_set_rx_filters(ah,rfilt) at the end of
> ath5k_configure_filter(). I attach the simple patch. Now tcpdump
> captures everything in monitor mode when iface is set to promisc.

Are you using monitor or promisc? Promiscous is just supposed to sniff
what you would sniff as if you were on Ethernet -- stuff destined to
your BSSID if STA. Monitor is 'catch it all'. Under this definition,
is it still "misbehaving"? For now you can get a real "monitor"
interface by using iw:

http://git.sipsolutions.net/iw.git

However this requires you to have libnl-1.0 pre8. The libnl URL is
down, in fact Thomas's home dir is not even working right now.. hmm,
CC'ing him. You can find pre8 here:

git://git.kernel.org/pub/scm/libs/netlink/libnl.git

  Luis
