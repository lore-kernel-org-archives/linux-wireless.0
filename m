Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:49079 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab3LRKqt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Dec 2013 05:46:49 -0500
Message-ID: <1387363601.4694.12.camel@jlt4.sipsolutions.net> (sfid-20131218_114652_986688_20ED72ED)
Subject: Re: P2P_DEVICE support in driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Ujjal Roy <royujjal@gmail.com>
Cc: Kernel <linux-wireless@vger.kernel.org>
Date: Wed, 18 Dec 2013 11:46:41 +0100
In-Reply-To: <CAE2MWkn5KT7nM+RgPptbfUDVEz5KThytpNmMUzhQeP30ZSocEg@mail.gmail.com> (sfid-20131218_112927_792469_9DE8FAB4)
References: <CAE2MWkn5KT7nM+RgPptbfUDVEz5KThytpNmMUzhQeP30ZSocEg@mail.gmail.com>
	 (sfid-20131218_112927_792469_9DE8FAB4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-12-18 at 15:59 +0530, Ujjal Roy wrote:
> Hi Johannes,
> 
> I want to add P2P_DEVICE support in a driver. And it's not described
> in the P2P spec. So, please tell me the following points -
> 1> what do the driver do?
> 2> register_netdevice() should not be called from driver for the
> P2P_DEVICE interface. Then what are the procedures (network stacks) to
> add a P2P device from driver's point of view?
> 3> How the supplicant will communicate with this type of interface?

A P2P_DEVICE netdev is (always) created by the supplicant if the driver
advertises support for it, and then p2p-device operations are done there
rather than on the wlan0 netdev.

The driver has to support it (interface combinations) and then deal with
add_interface for it. You can see mac80211 with hwsim and iwlmvm for
example.

johannes

