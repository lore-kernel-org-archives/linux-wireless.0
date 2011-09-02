Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55542 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362Ab1IBME3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Sep 2011 08:04:29 -0400
Subject: RE: [RFC] nl80211: Added NL80211 commands for Bluetooth-WiFi coex
From: Johannes Berg <johannes@sipsolutions.net>
To: "Sumangala, Suraj" <surajs@qca.qualcomm.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"Balasubramanian, senthilkumar" <senthilb@qca.qualcomm.com>,
	"Mehta, Vipin" <vipimeht@qca.qualcomm.com>,
	"Valo, Kalle" <kvalo@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>
In-Reply-To: <480687D4EEFE7447A2E09AADFF6673621AF82B5C@nasanexd02a.na.qualcomm.com>
References: <1314771915-8848-1-git-send-email-surajs@qca.qualcomm.com>
	 (sfid-20110831_082525_612687_34CC3735),<1314772217.4161.10.camel@jlt3.sipsolutions.net>
	 <480687D4EEFE7447A2E09AADFF6673621AF7CDCF@nasanexd02a.na.qualcomm.com>
	 ,<1314772832.4161.16.camel@jlt3.sipsolutions.net>
	 <480687D4EEFE7447A2E09AADFF6673621AF7CE0B@nasanexd02a.na.qualcomm.com>
	 <1314801657.3373.260.camel@aeonflux>
	 <480687D4EEFE7447A2E09AADFF6673621AF7DF82@nasanexd02a.na.qualcomm.com>
	 <1314831118.3373.266.camel@aeonflux>
	 <480687D4EEFE7447A2E09AADFF6673621AF827CC@nasanexd02a.na.qualcomm.com>
	 <1314877381.3373.284.camel@aeonflux>
	 <480687D4EEFE7447A2E09AADFF6673621AF82B5C@nasanexd02a.na.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Sep 2011 14:04:22 +0200
Message-ID: <1314965062.3927.7.camel@jlt3.sipsolutions.net> (sfid-20110902_140434_526382_EC5DBE87)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-09-02 at 07:54 +0000, Sumangala, Suraj wrote:

> If we can provide "hci_dev" as the handle to the Bluetooth core, does
> it make sense to follow the below steps to send channel
> classification?
> 1. Implement an NL80211 command to provide the Bluetooth BDADDR.
> 2. Send it down to the WiFi driver via a cfg80211 API.
> 3. Let it call "hci_get_route" to get a hci_hdev handle.
> 4. Export an API to set channel classification in Bluetooth HCI core.
> 5. Let the WiFi driver form the channel classification and call the
> Bluetooth core "write channel classification" API to set the channels.

I don't see any reason to have a specific wifi device talk to a specific
BT device. The channel exclusion makes more sense if all wifi devices
and all BT devices are taken into account. As such, only simple API is
needed to let cfg80211 tell bluez about the channels, and then bluez can
multiplex it out to all its BT devices.

johannes

