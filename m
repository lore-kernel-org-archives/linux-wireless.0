Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:44345 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752506Ab2HVU2s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Aug 2012 16:28:48 -0400
Message-ID: <503540FC.9030408@openwrt.org> (sfid-20120822_222852_268986_DCB69FD8)
Date: Wed, 22 Aug 2012 22:28:44 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: Sergey Ryazanov <ryazanov.s.a@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Per sta interfaces in WDS (4-address) mode
References: <CAHNKnsRVh_BXqW0CLfxO5WZCJ8UH7O=cHN-zh7AuM_pQj0xUqg@mail.gmail.com> <20120820111321.71c6f07e@mj>
In-Reply-To: <20120820111321.71c6f07e@mj>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-08-20 5:13 PM, Pavel Roskin wrote:
> On Sun, 19 Aug 2012 21:51:27 +0400
> Sergey Ryazanov <ryazanov.s.a@gmail.com> wrote:
> 
>> Hello dear all,
>> 
>> please tell me, why in the WDS mode, the stack creates a new interface
>> for each WDS station, and this interface hostapd adds to the parent AP
>> interface bridge? Why we couldn't simply pass this frames via AP
>> interface?
> 
> You may want to use a completely different IP address and netmask on the
> WDS interface.  Using the AP interface would take away that option.
> 
> hostapd is not a part of the kernel.  It should be possible not to add
> WDS interfaces to the bridge.
It's not just that. If the WDS station communication were done over the
AP interface, mac80211 would have to keep a table of which MAC address
is reachable behind which WDS station, which is something that the
bridge layer is supposed to do.
I've seen such a design mistake in various drivers, and I've seen the
weird quirks that this usually produces in more complex network
topologies ;)

- Felix

