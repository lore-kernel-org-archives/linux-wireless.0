Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:35244 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932787AbcASVsZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jan 2016 16:48:25 -0500
Received: by mail-pa0-f54.google.com with SMTP id ho8so197098891pac.2
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jan 2016 13:48:25 -0800 (PST)
Date: Tue, 19 Jan 2016 13:48:32 -0800
From: Stephen Hemminger <stephen@networkplumber.org>
To: YanBo <dreamfly281@gmail.com>
Cc: Felix Fietkau <nbd@openwrt.org>, jouni@qca.qualcomm.com,
	kvalo@codeaurora.org, Krishna Chaitanya <chaitanya.mgit@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Sebastian Gottschall <s.gottschall@dd-wrt.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	netdev <netdev@vger.kernel.org>, hostap@lists.infradead.org
Subject: Re: Regression in 3.9 caused by "bridge: respect RFC2863
 operational state"
Message-ID: <20160119134832.3ab2f04b@xeon-e3> (sfid-20160119_224830_874613_FE8C6CC0)
In-Reply-To: <CAFuUQkhHsRZMnNYBbVZU0=BcAKMEktzYgPv6oc=CMFd7MFDi6g@mail.gmail.com>
References: <CAFuUQkhHsRZMnNYBbVZU0=BcAKMEktzYgPv6oc=CMFd7MFDi6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 3 Dec 2015 18:29:00 -0800
YanBo <dreamfly281@gmail.com> wrote:

> Sorry to pick up this thread again,  it looks this issue still existed  in
> the newer 4.3 kernel. (The EAP frames can not be received by wireless
> interface due to the bridge interface,
> http://marc.info/?l=linux-wireless&m=136743495526905&w=2)
> 
> Wonder is anyone know some update for this issue?  Currently the only
> workaround is make the 4-address  AP and STA associated in security mode
> firstly and then create the bridge, the renew key configuration also need
> be disable at the hostapd side to  avoid renew the key at bridge status.
> 
> Thanks
> Yanbo

How does wireless device indicate that is up?  It may just be that
the code is missing the logic to propagate operstate correctly.
This is normally done by netif_stacked_transfer_operstate and linkwatch
event.

Also STP can be disabled if you don't need it.
