Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:45029 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752427Ab0CTAPh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Mar 2010 20:15:37 -0400
Date: Fri, 19 Mar 2010 17:15:20 -0700
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Kalle Valo <kalle.valo@iki.fi>,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCHv3 0/2] mac80211: cfg80211: Roam trigger support
Message-ID: <20100320001520.GA26605@jm.kir.nu>
References: <1268830877-5162-1-git-send-email-juuso.oikarinen@nokia.com>
 <20100317132236.GC2990@tuxdriver.com>
 <87aau4dcfm.fsf@purkki.valot.fi>
 <20100319145636.GB9552@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100319145636.GB9552@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 19, 2010 at 10:56:37AM -0400, John W. Linville wrote:
> On Fri, Mar 19, 2010 at 08:59:25AM +0200, Kalle Valo wrote:
> > The idea is that wpa_supplicant will listen to these events, and will
> > enable or disable backround scan (ie. scanning for new APs when
> > associated) based on information received from the events. When the
> > connection to the AP is good enough, it can disable background scan
> > which makes it possible to save power and also get rid of latency
> > introduced by the background scan.
> > 
> > I haven't seen any implementation for wpa_supplicant yet, but we have
> > talked about that few times during the last two years.
> 
> If you can make wpa_supplicant scan less then I am sold! :-)

I would assume it is not really wpa_supplicant that is triggering too
many scans for your liking, but NetworkManager.. The goal here (at least
from my view point) is to actually make wpa_supplicant itself trigger
scans more frequently ;-).

wpa_supplicant already has a notification function just waiting to be
called from somewhere when a beacon is lost of signal strength has
changed.. That somewhere is supposed to be the driver event handler when
it receives one of these new roam trigger events. At that point,
wpa_supplicant can then figure out if it should start scanning more
frequently to find a better BSS. I would hope that this feature will
make NetworkManager eventually stop doing its constant scans (or well,
if it doesn't, I will provide an option in for wpa_supplicant to ignore
D-Bus requests for new scans.. ;-).

-- 
Jouni Malinen                                            PGP id EFC895FA
