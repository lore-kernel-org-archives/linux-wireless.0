Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:60837 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932107Ab1IALni (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Sep 2011 07:43:38 -0400
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
Date: Thu, 01 Sep 2011 04:43:00 -0700
In-Reply-To: <480687D4EEFE7447A2E09AADFF6673621AF827CC@nasanexd02a.na.qualcomm.com>
References: <1314771915-8848-1-git-send-email-surajs@qca.qualcomm.com>
	 (sfid-20110831_082525_612687_34CC3735),<1314772217.4161.10.camel@jlt3.sipsolutions.net>
	 <480687D4EEFE7447A2E09AADFF6673621AF7CDCF@nasanexd02a.na.qualcomm.com>
	 ,<1314772832.4161.16.camel@jlt3.sipsolutions.net>
	 <480687D4EEFE7447A2E09AADFF6673621AF7CE0B@nasanexd02a.na.qualcomm.com>
	 <1314801657.3373.260.camel@aeonflux>
	 <480687D4EEFE7447A2E09AADFF6673621AF7DF82@nasanexd02a.na.qualcomm.com>
	 <1314831118.3373.266.camel@aeonflux>
	 <480687D4EEFE7447A2E09AADFF6673621AF827CC@nasanexd02a.na.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <1314877381.3373.284.camel@aeonflux> (sfid-20110901_134350_895130_546D1FF7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Suraj,

> > > > this looks like the total wrong approach to me. This needs to be done
> > between mac80211 and Bluetooth subsystems in the kernel directly. Going
> > through userspace for this is a pretty bad idea.
> > >
> > > > Especially if you wanna listen on D-Bus events from bluetoothd and then run
> > another process to then execute nl80211 commands looks like total overhead at
> > no gain. Not to talk about potential latency > effects that might be
> > counterproductive.
> > >
> > > > What you really want is a way to mark A2DP channels for streaming from
> > userspace as streaming/realtime/priority so the Bluetooth subsystem knows on
> > what to do with it and that way can also tell > > mac80211 correctly about coex
> > settings.
> > >
> > > > We are already settings flushable flags for A2DP streaming channels and there
> > is work ongoing for SO_PRIORITY support with L2CAP sockets.
> > >
> > > More than the A2DP connection, it would be more useful to find out when
> > A2DP start/stop streaming so that we can know when to reallocate resource to
> > Bluetooth. Is it possible to tap this information out of the Bluetooth core?
> > > Also, can you suggest a way to get A2DP streaming status, inquiry status, and
> > SCO and ACL role without a hack in the Bluetooth subsystem?
> > 
> > the inquiry status is tracked by the Linux kernel since ever. Same goes for ACL
> > and SCO status. The kernel keeps track over almost everything on the HCI level
> > and will do proper cleanup afterwards. Doing this in userspace will not work out.
> > And it is also racy.
> > 
> > Especially in the future bluetoothd will be tracking less and less information. The
> > new management interface will hide almost every single state from bluetoothd
> > where the kernel is doing the job anyway and can do a way better job in the first
> > place. This is also leads to power consumption advantages since bluetoothd does
> > not need to be woken up that often anyway. And in addition the kernel has not
> > deal with the extra HCI filter handling.
> > 
> > The only thing that you mentioned here is A2DP streaming. And by the nature of
> > the A2DP protocol, you do establish a second L2CAP channel that is just used for
> > streaming. That channel is also only present if you are streaming right now. If not
> > streaming is going on, it will be disconnected. So it is pretty easy to have
> > bluetoothd tag such a channel with proper SO_PRIORITY (once we have that code
> > merged upstream) and then the Bluetooth subsystem knows when A2DP
> > streaming or any high priority/realtime data is transferred over Bluetooth.
>
> Regarding SCO and Inquiry status, do we have an existing API in Bluetooth core that I can use to get that information?

there is obviously no exported symbols or anything alike. Since we only
export things that are used by drivers or other subsystem. So you would
need to create such an API.

However first we need to establish in which direction this should be
done anyway. Should the Bluetooth subsystem notify mac80211
unconditional or should mac80211 register notifiers of the Bluetooth
subsystem.

We also should not forget direct integration support for changing AFH
channel maps based on the used WiFi channels.

Regards

Marcel


