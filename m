Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53867 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030268Ab2CTGTo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Mar 2012 02:19:44 -0400
Subject: Re: About the .start function in ieee80211_ops.
From: Johannes Berg <johannes@sipsolutions.net>
To: Matt Chen <machen@suse.com>
Cc: users@rt2x00.serialmonkey.com,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <CALx5=V_czM-3sqhutbYx27wHnLtQL_PvcSjKHd4RGtopkKqf3A@mail.gmail.com> (sfid-20120320_070247_013413_2AAE94EF)
References: <CALx5=V_czM-3sqhutbYx27wHnLtQL_PvcSjKHd4RGtopkKqf3A@mail.gmail.com>
	 (sfid-20120320_070247_013413_2AAE94EF)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Mar 2012 07:19:37 +0100
Message-ID: <1332224377.3329.1.camel@jlt3.sipsolutions.net> (sfid-20120320_072003_804732_38A8C248)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-03-20 at 14:02 +0800, Matt Chen wrote:
> Hi all,
> I have a issue recently for rt2800pci, the way to duplicate this is
> 1. Press function key to set rfkill hard blocked, it would cause
> driver to power off.
> 2. reboot
> 3. find when load the driver (rt2800pci), it would stop in "Registered
> led device: rt2800pci-phy0::quality".
> 
> Here you would find the rfkill_poll function is not started to work,
> also the rt2x00mac_start() registered in rt2800pci_mac80211_ops
> structure is not yet be executed.
> My question is when or what condition the rt2x00mac_start()  would be
> running, because if it is not yet executed, then it would not be able
> to load the firmware in rt2x00lib_start().

That's a bug in the driver then -- it should probably start the rfkill
stuff without mac80211's start() command. start() is only called when
the first interface comes up, but that will never happen if it's in
rfkill block.

johannes

