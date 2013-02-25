Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:41061 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923Ab3BYFII (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2013 00:08:08 -0500
Received: by mail-wi0-f182.google.com with SMTP id hi18so2710607wib.3
        for <linux-wireless@vger.kernel.org>; Sun, 24 Feb 2013 21:08:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1361726886.8129.9.camel@jlt4.sipsolutions.net>
References: <A47087626F2942499CF47E79803E771E0431B792@SJEXCHMB13.corp.ad.broadcom.com>
	<1361564916.3420.11.camel@jlt4.sipsolutions.net>
	<CAJ-VmokSn-jo9oFm4Udhf=T+HXM2N4g=Ckc-=NQEOKL=j=w5NA@mail.gmail.com>
	<A47087626F2942499CF47E79803E771E0431BD3C@SJEXCHMB13.corp.ad.broadcom.com>
	<1361726886.8129.9.camel@jlt4.sipsolutions.net>
Date: Sun, 24 Feb 2013 21:08:07 -0800
Message-ID: <CAJ-Vmo=z+zbCfjMPXT4edyrB9Ukz0-ChE_Q1sqU_=6m_btx_Hg@mail.gmail.com> (sfid-20130225_060814_162283_B5F04602)
Subject: Re: [PATCH 1/2] [RFC] cfg80211: configuration of Bluetooth
 coexistence mode
From: Adrian Chadd <adrian@freebsd.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Arend Van Spriel <arend@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Piotr Haber <phaber@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 24 February 2013 09:28, Johannes Berg <johannes@sipsolutions.net> wrote:

>> In the driver we could inspect each sk_buff and boost priority of any
>> BOOTP packets so that it will end up in the AC_VO fifo and have
>> hardware coexistence handle it further. I consider that more a
>> pragmatic fix, which is not always the worst thing to go for.
>
> Well, I don't really think that's the best idea. Sniffing the protocol
> is clumsy at best.

Sure, but it's the kind of thing that commercial devices do in order
to work around real world issues.

So it'd be nice to have a programmatic way to detect things (eg bootp
packets going out) and signal the driver via some side channel to do
things like btcoex weight changing.

But it'd also be nice to do it based on QoS too.

>> However, I would prefer a solution is which user-space, ie. dhcp
>> client can control the priority and/or BT coexistence.
>
> It's not just BT coex btw, with multi-channel support it might also be
> interesting to not switch channels while DHCP is going on, for example.

Right.



Adrian
