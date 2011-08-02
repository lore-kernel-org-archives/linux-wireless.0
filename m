Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38515 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab1HBKMz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2011 06:12:55 -0400
Received: by fxh19 with SMTP id 19so5471526fxh.19
        for <linux-wireless@vger.kernel.org>; Tue, 02 Aug 2011 03:12:53 -0700 (PDT)
From: Vasily Khoruzhick <anarsoul@gmail.com>
To: libertas-dev@lists.infradead.org
Subject: Re: [PATCH 1/2] libertas: disable functionality when interface is down
Date: Tue, 2 Aug 2011 13:12:22 +0300
Cc: Daniel Drake <dsd@laptop.org>, linville@tuxdriver.com,
	dcbw@redhat.com, linux-wireless@vger.kernel.org
References: <20110801154313.8C9389D401F@zog.reactivated.net> <201108021202.03890.anarsoul@gmail.com>
In-Reply-To: <201108021202.03890.anarsoul@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201108021312.23153.anarsoul@gmail.com> (sfid-20110802_121258_413099_351D7380)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 02 August 2011 12:02:03 Vasily Khoruzhick wrote:
> On Monday 01 August 2011 18:43:13 Daniel Drake wrote:
> > Modify the driver so that it does not function when the interface is
> > down, in preparation for runtime power management.
> > 
> > No commands can be run while the interface is down, so the ndo_dev_stop
> > routine now directly does all necessary work (including asking the device
> > to disconnect from the network and disabling multicast functionality)
> > directly.
> > 
> > power_save and power_restore hooks are added meaning that card drivers
> > can take steps to turn the device off when the interface is down.
> > 
> > The MAC address can now only be changed when all interfaces are down;
> > the new address will be programmed when an interface gets brought up.
> > This matches mac80211 behaviour.
> > 
> > Also, some small cleanups/simplifications were made in the surrounding
> > device handling logic.
> 
> Ok, one more question: what about suspend? Maybe it worth to add flag to
> disable card before going suspend and re-enable it during resume?

Implemented it. The only remaining question is messing with power_{on,off} 
functions in if_sdio, but I'm OK with it. Will send my patches in few minutes.

Regards
Vasily
