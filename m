Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:59813 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753899AbXDDOiu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Apr 2007 10:38:50 -0400
Subject: Re: Orinoco, mac80211 and wpa2
From: Dan Williams <dcbw@redhat.com>
To: Jan Dittmer <jdi@l4x.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4613A4A9.1060902@l4x.org>
References: <4613A4A9.1060902@l4x.org>
Content-Type: text/plain
Date: Wed, 04 Apr 2007 10:42:17 -0400
Message-Id: <1175697737.2656.3.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2007-04-04 at 15:14 +0200, Jan Dittmer wrote:
> Hello,
> 
> I've a 802.11b Orinoco based integrated WLAN card in my
> Sony Laptop (SRX51P). I'm using it with the in kernel 'orinoco-cs'
> driver. The driver does not support connecting to wpa2
> enabled networks. If I understand it correctly, the mac80211
> can emulate wpa2 in software? Would porting the orinoco
> driver to the new framework make it to possible to use wpa2
> with it? Or is wpa2 hardware dependent?

WPA requires a combination of updated firmware and hardware support.  If
you card doesn't have the right hardware (though most are likely capable
of WPA-TKIP at least), it won't be able to do WPA.  If you do not have
firmware that is capable of WPA, you will not be able to do WPA.

Only a few manufacturers released updated firmware to support WPA-TKIP
and even fewer to support WPA-CCMP on cards that did not originally
support it.

In your case, some cards supported by the orinoco drivers _do_ have WPA
capability with a firmware upgrade and by using the 'hostap' drivers.
I'd try blacklisting the orinoco and see if the 'hostap' driver supports
your card.

Dan


