Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:59031 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384Ab3K3NOs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Nov 2013 08:14:48 -0500
Message-ID: <1385817282.5056.0.camel@jlt4.sipsolutions.net> (sfid-20131130_141508_214071_F08B5CB5)
Subject: Re: wireless network interfaces and network namespaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Kevin Wilson <wkevils@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Sat, 30 Nov 2013 14:14:42 +0100
In-Reply-To: <CAGXs5wXPB2WvuxfXzuyDaGS5_cA+GG5vHkHO+PnnVncvOwJTDg@mail.gmail.com> (sfid-20131130_131217_199581_DE585625)
References: <CAGXs5wXPB2WvuxfXzuyDaGS5_cA+GG5vHkHO+PnnVncvOwJTDg@mail.gmail.com>
	 (sfid-20131130_131217_199581_DE585625)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2013-11-30 at 14:12 +0200, Kevin Wilson wrote:
> Hello,
> I am trying to move a wireless interface to a network namespace I
> created and I get an error:
> 
> ip link set wlan0 netns ns1
> RTNETLINK answers: Invalid argument
> 
> I do it with latest iproute2 git sources,  on 3.8 kernel.
> 
> I want to verify this: all wireless interfaces do no support
> network namespace. Is this true ? what in fact is the reason for this ?

At least mac80211-based wireless interfaces *do* support namespaces, but
you have to change the entire wireless NIC's namespace using iw --
having different virtual interfaces of the same NIC in different
namespaces is not supported.

johannes

