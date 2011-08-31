Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:36370 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889Ab1HaOlg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 10:41:36 -0400
Subject: RE: [RFC] nl80211: Added NL80211 commands for Bluetooth-WiFi coex
From: Marcel Holtmann <marcel@holtmann.org>
To: "Sumangala, Suraj" <surajs@qca.qualcomm.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	ath6kl-devel <ath6kl-devel@qualcomm.com>,
	"Balasubramanian, senthilkumar" <senthilb@qca.qualcomm.com>,
	"Mehta, Vipin" <vipimeht@qca.qualcomm.com>,
	"Valo, Kalle" <kvalo@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 31 Aug 2011 07:40:53 -0700
In-Reply-To: <480687D4EEFE7447A2E09AADFF6673621AF7CE0B@nasanexd02a.na.qualcomm.com>
References: <1314771915-8848-1-git-send-email-surajs@qca.qualcomm.com>
	 (sfid-20110831_082525_612687_34CC3735),<1314772217.4161.10.camel@jlt3.sipsolutions.net>
	 <480687D4EEFE7447A2E09AADFF6673621AF7CDCF@nasanexd02a.na.qualcomm.com>
	,<1314772832.4161.16.camel@jlt3.sipsolutions.net>
	 <480687D4EEFE7447A2E09AADFF6673621AF7CE0B@nasanexd02a.na.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <1314801657.3373.260.camel@aeonflux> (sfid-20110831_164144_383009_A33C2021)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Suraj,

> > Why would this need a userspace utility? Are you cloning some sort of
> > windows architecture here?
> 
> Ugh, please trim your quotes and use a useful mailer that will indent things.
> 
> > It will be the userpace bluez dbus events that can provide information
> > regarding the status of variout Bluetooth events.
> > On receiving that information, it can send corresponding NL80211
> > command.
> 
> Doesn't the kernel's bluetooth subsystem already know anyway?
> 
> Not all of the information I believe. Things like A2DP streaming will be best known at the userspace. Also, there is no way to tap these information at the kernel subsystem right now. But, there is a clear defined way to get these information at the userspace. Also, profile based information might not be available at the kernel space. 

this looks like the total wrong approach to me. This needs to be done
between mac80211 and Bluetooth subsystems in the kernel directly. Going
through userspace for this is a pretty bad idea.

Especially if you wanna listen on D-Bus events from bluetoothd and then
run another process to then execute nl80211 commands looks like total
overhead at no gain. Not to talk about potential latency effects that
might be counterproductive.

What you really want is a way to mark A2DP channels for streaming from
userspace as streaming/realtime/priority so the Bluetooth subsystem
knows on what to do with it and that way can also tell mac80211
correctly about coex settings.

We are already settings flushable flags for A2DP streaming channels and
there is work ongoing for SO_PRIORITY support with L2CAP sockets.

Regards

Marcel


