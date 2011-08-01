Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f171.google.com ([209.85.215.171]:53902 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328Ab1HARjM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Aug 2011 13:39:12 -0400
Received: by eye22 with SMTP id 22so4734418eye.2
        for <linux-wireless@vger.kernel.org>; Mon, 01 Aug 2011 10:39:11 -0700 (PDT)
From: Vasily Khoruzhick <anarsoul@gmail.com>
To: libertas-dev@lists.infradead.org
Subject: Re: [PATCH 1/2] libertas: disable functionality when interface is down
Date: Mon, 1 Aug 2011 20:38:39 +0300
Cc: Daniel Drake <dsd@laptop.org>, linville@tuxdriver.com,
	dcbw@redhat.com, linux-wireless@vger.kernel.org
References: <20110801154313.8C9389D401F@zog.reactivated.net>
In-Reply-To: <20110801154313.8C9389D401F@zog.reactivated.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201108012038.40155.anarsoul@gmail.com> (sfid-20110801_193916_803019_19A49660)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 01 August 2011 18:43:13 Daniel Drake wrote:

Hi, Daniel

> Modify the driver so that it does not function when the interface is
> down, in preparation for runtime power management.
> 
> No commands can be run while the interface is down, so the ndo_dev_stop
> routine now directly does all necessary work (including asking the device
> to disconnect from the network and disabling multicast functionality)
> directly.
> 
> power_save and power_restore hooks are added meaning that card drivers
> can take steps to turn the device off when the interface is down.

You mean completely off? And firmware needs to be reloaded after power up?

> The MAC address can now only be changed when all interfaces are down;
> the new address will be programmed when an interface gets brought up.
> This matches mac80211 behaviour.
> 
> Also, some small cleanups/simplifications were made in the surrounding
> device handling logic.

Regards
Vasily
