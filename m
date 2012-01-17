Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49041 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278Ab2AQNFv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jan 2012 08:05:51 -0500
Subject: Re: why can the distance only be set on a phy not a dev
From: Johannes Berg <johannes@sipsolutions.net>
To: David Goodenough <david.goodenough@btconnect.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <201201171229.33901.david.goodenough@btconnect.com> (sfid-20120117_135652_146253_52D9EF91)
References: <201201171229.33901.david.goodenough@btconnect.com>
	 (sfid-20120117_135652_146253_52D9EF91)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Jan 2012 14:05:50 +0100
Message-ID: <1326805550.3342.17.camel@jlt3.sipsolutions.net> (sfid-20120117_140553_761018_376791D6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-01-17 at 12:29 +0000, David Goodenough wrote:
> Using the iw command, most things can either be directed to a dev or
> a phy, but a distance can only be set on a phy.
> 
> This leads to problems as I do not know which phy is connected to a 
> dev (or at least I do not know how to find out which phy is connected
> to a dev), and so in my Debian /etc/network/interfaces file I have:-
> 
> iface wlan0 inet manual
> 	pre-up iw dev wlan0 interface add mesh0 type mp
> 
> iface mesh0 inet static
>     address 10.101.11.254
>     netmask 255.255.255.0
>     pre-up iw dev mesh0 set channel 153
>     post-up iw phy phy0 set distance 3500
>     up iw dev mesh0 mesh join MeshId
> 
> so in the mesh0 stanza I have a reference to phy0 which is hard
> coded and if it changes subject to error.
> 
> So either I need to be able to set distance to dev mesh0, or have
> some means or working out which phy corresponds to dev mesh0.

I can easily allow you to invoke iw with the netdev rather than the phy,
but the parameter would still be per phy.

johannes

