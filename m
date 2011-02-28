Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:40909 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667Ab1B1Sja (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Feb 2011 13:39:30 -0500
Received: by vws12 with SMTP id 12so3370113vws.19
        for <linux-wireless@vger.kernel.org>; Mon, 28 Feb 2011 10:39:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110227094344.GA7835@jm.kir.nu>
References: <1298683960-20835-1-git-send-email-thomas@cozybit.com> <20110227094344.GA7835@jm.kir.nu>
From: Javier Cardona <javier@cozybit.com>
Date: Mon, 28 Feb 2011 10:36:13 -0800
Message-ID: <AANLkTimnRsbffJA0vtZxvyB89ntia7buzKnLMTGKSiau@mail.gmail.com>
Subject: Re: [PATCH 0/5] [mac|nl]80211: SAE mesh and userspace authentication
To: Jouni Malinen <j@w1.fi>
Cc: Thomas Pedersen <thomas@cozybit.com>,
	linux-wireless@vger.kernel.org, Dan Harkins <dharkins@lounge.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jouni,

On Sun, Feb 27, 2011 at 1:43 AM, Jouni Malinen <j@w1.fi> wrote:
> On Fri, Feb 25, 2011 at 05:32:35PM -0800, Thomas Pedersen wrote:
>> This patch series introduces support for userspace SAE (Simultaneous
>> Authentication of Equals) daemons through nl80211 and mac80211. This
>> authentication scheme is documented in IEEE 802.11s section 8.2a.1.
>
> While the SAE mechanism is specified in IEEE 802.11s, it is not in any
> way specific to mesh. Some of these patches looked generic, but at least
> the one touching ieee80211_default_mgmt_stypes addressed only the mesh
> point iftype. Do you have plans on making this more generic to allow SAE
> to be used in station mode interface with WPA2-Personal?

Our goal is to implement SAE for mesh mode interfaces in the most
generic way so it can easily be extended for station mode interfaces.
If we have the bandwidth, we might try to implement station mode
support ourselves, but can't guarantee it at this time.  We'll gladly
accept feedback on the best way to implement SAE support in the most
generic way.

> I would assume that AP side can already be handled in hostapd without kernel changes,
> but it would be useful to allow wpa_supplicant to implement SAE for the
> station interface even if there is no use of mesh in the network.

We have prototyped an SAE authentication daemon here:
https://github.com/cozybit/authsae . The current version successfully
authenticates mesh nodes (the kernel requires the patches in this
series).  The next step is to roll that functionality into
wpa_supplicant and hope that the maintainer considers our patches
favorably.  When we do that we'll make sure that we cover the case of
station interfaces, but I don't think we'll be able to implement the
AP side in hostapd.  Do you have plans to support SAE in hostapd?

Cheers,

Javier

-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
