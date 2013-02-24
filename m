Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:55960 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794Ab3BXJMl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Feb 2013 04:12:41 -0500
Received: by mail-la0-f53.google.com with SMTP id fr10so1774570lab.26
        for <linux-wireless@vger.kernel.org>; Sun, 24 Feb 2013 01:12:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <A47087626F2942499CF47E79803E771E0431BD3C@SJEXCHMB13.corp.ad.broadcom.com>
References: <A47087626F2942499CF47E79803E771E0431B792@SJEXCHMB13.corp.ad.broadcom.com>
	<1361564916.3420.11.camel@jlt4.sipsolutions.net>
	<CAJ-VmokSn-jo9oFm4Udhf=T+HXM2N4g=Ckc-=NQEOKL=j=w5NA@mail.gmail.com>
	<A47087626F2942499CF47E79803E771E0431BD3C@SJEXCHMB13.corp.ad.broadcom.com>
Date: Sun, 24 Feb 2013 11:12:39 +0200
Message-ID: <CANUX_P3gu0L+mwaRWna104KdKLhBtOMLMsFEy=aY=Ny4hSHKxw@mail.gmail.com> (sfid-20130224_101259_552423_75369E99)
Subject: Re: [PATCH 1/2] [RFC] cfg80211: configuration of Bluetooth
 coexistence mode
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Arend Van Spriel <arend@broadcom.com>
Cc: Adrian Chadd <adrian@freebsd.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Piotr Haber <phaber@broadcom.com>
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>>
>
> In the driver we could inspect each sk_buff and boost priority of any BOOTP packets so that it will end up in the AC_VO fifo and have hardware coexistence handle it further. I consider that more a pragmatic fix, which is not always the worst thing to go for. However, I would prefer a solution is which user-space, ie. dhcp client can control the priority and/or BT coexistence.
>

I don't think that the "session solution" as proposed in the RFC is
the right one. Because the DHCP could take forever and also because
there might be quite a few non-critical packets right after
connections. There might be a bunch of services that may wake up and
begin to send a whole bunch of things. OTOH, EAPOL and friends *need*
priority, so I guess that the per-packet solution is the right one.
Note that we could think about a flag in the tx_control in which cfg /
mac80211 would let the driver know that this packet is a "high
priority packet" or even better "a connection gating packet". This
list would include managements / EAPOL / DHCP / any other kind of
stuff that look like these. I remember I saw once in the code
something that looked like this but can't find it right now.

FWIW: here is the code that classifies the packets in iwlwifi:

	/* High prio packet (wrt. BT coex) if it is EAPOL, MCAST or MGMT */
	if (info->band == IEEE80211_BAND_2GHZ        &&
	    (skb->protocol == cpu_to_be16(ETH_P_PAE)  ||
	     is_multicast_ether_addr(hdr->addr1)      ||
	     ieee80211_is_back_req(fc)                ||
	     ieee80211_is_mgmt(fc)))
		tx_flags |= TX_CMD_FLG_BT_DIS;
