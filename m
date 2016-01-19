Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:57151 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756908AbcASVzY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jan 2016 16:55:24 -0500
Subject: Re: Regression in 3.9 caused by "bridge: respect RFC2863 operational
 state"
To: Stephen Hemminger <stephen@networkplumber.org>,
	YanBo <dreamfly281@gmail.com>
References: <CAFuUQkhHsRZMnNYBbVZU0=BcAKMEktzYgPv6oc=CMFd7MFDi6g@mail.gmail.com>
 <20160119134832.3ab2f04b@xeon-e3>
Cc: jouni@qca.qualcomm.com, kvalo@codeaurora.org,
	Krishna Chaitanya <chaitanya.mgit@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Sebastian Gottschall <s.gottschall@dd-wrt.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	netdev <netdev@vger.kernel.org>, hostap@lists.infradead.org
From: Felix Fietkau <nbd@openwrt.org>
Message-ID: <569EB0C5.7090005@openwrt.org> (sfid-20160119_225529_572676_9759FE8F)
Date: Tue, 19 Jan 2016 22:55:17 +0100
MIME-Version: 1.0
In-Reply-To: <20160119134832.3ab2f04b@xeon-e3>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-01-19 22:48, Stephen Hemminger wrote:
> On Thu, 3 Dec 2015 18:29:00 -0800
> YanBo <dreamfly281@gmail.com> wrote:
> 
>> Sorry to pick up this thread again,  it looks this issue still existed  in
>> the newer 4.3 kernel. (The EAP frames can not be received by wireless
>> interface due to the bridge interface,
>> http://marc.info/?l=linux-wireless&m=136743495526905&w=2)
>> 
>> Wonder is anyone know some update for this issue?  Currently the only
>> workaround is make the 4-address  AP and STA associated in security mode
>> firstly and then create the bridge, the renew key configuration also need
>> be disable at the hostapd side to  avoid renew the key at bridge status.
>> 
>> Thanks
>> Yanbo
> 
> How does wireless device indicate that is up?  It may just be that
> the code is missing the logic to propagate operstate correctly.
> This is normally done by netif_stacked_transfer_operstate and linkwatch
> event.
> 
> Also STP can be disabled if you don't need it.
Wireless only the changes the operstate *after* successful
authentication, for which it needs to communicate through the bridge.

- Felix
