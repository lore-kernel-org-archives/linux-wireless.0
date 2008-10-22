Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:39524 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963AbYJVW6K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 18:58:10 -0400
Subject: Re: New iwlwifi 3945 uCode available
From: Marcel Holtmann <holtmann@linux.intel.com>
To: reinette chatre <reinette.chatre@linux.intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Tomas Winkler <tomasw@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1224707446.10863.155.camel@rc-desk>
References: <1224613633.10863.43.camel@rc-desk>
	 <1224624324.28639.9.camel@johannes.berg>
	 <1ba2fa240810211433q2e7a13b2p45cb8d38a74393c9@mail.gmail.com>
	 <1224624899.28639.17.camel@johannes.berg>
	 <20081021213814.GM17268@tuxdriver.com>
	 <1ba2fa240810211453y40739183v84999364c89886ee@mail.gmail.com>
	 <1224627187.9386.103.camel@californication>
	 <1224628088.10863.100.camel@rc-desk>
	 <1224660449.28639.22.camel@johannes.berg>
	 <1224662185.9386.131.camel@californication>
	 <1224707446.10863.155.camel@rc-desk>
Content-Type: text/plain
Date: Thu, 23 Oct 2008 00:59:07 +0200
Message-Id: <1224716347.9386.151.camel@californication> (sfid-20081023_005814_938297_6E8A7A8C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Reinette,

> > > I really don't know why we let you get away with this and bitch
> > > endlessly when b43 does such a change, to the point where we finally
> > > cave in and support both versions. Why should a community-supported
> > > driver be held to higher standards?
> > 
> > If in any way possible, we should support both versions of the firmware.
> 
> I would like to hear some suggestions on how we can do this as I am not
> familiar with the other drivers. The driver is closely tied to the
> firmware ... and I am actually tempted to draw an analogy between the
> interface between the driver and mac80211 here. From what I understand,
> for the driver to support many versions of the firmware it dynamically
> needs to detect which features are supported at runtime and act
> accordingly. This is a hard problem. What am I missing?

in some cases it might be possible with a set of quirks or special
functions that can be switched at runtime. Check the whole bunch of USB
drivers that have special handling depending on what hardware it finds.
We could do the same. In some cases this effort might be too much, but
if possible we should at least try.

It all depends on how much the ucode API changes and sometimes we really
wanna cleanup the driver and remove the old code, but in that case we
have to tell the users via modules_install that this kernel will break
or we have to keep the old driver around. Breaking it from one kernel
version to the next one without the user noticing only after reboot is
just not good enough.

Regards

Marcel


