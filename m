Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f194.google.com ([209.85.216.194]:34831 "EHLO
	mail-px0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755894Ab0BKUKq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Feb 2010 15:10:46 -0500
MIME-Version: 1.0
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 11 Feb 2010 12:10:24 -0800
Message-ID: <43e72e891002111210l55d6a802pc5a1384e3535c845@mail.gmail.com>
Subject: Coordinating development for Bluetooth 3.0 between 802.11 and BT
	trees
To: "John W. Linville" <linville@tuxdriver.com>,
	Marcel Holtmann <marcel@holtmann.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	linux-bluetooth <linux-bluetooth@vger.kernel.org>,
	Dan Tian <Dan.Tian@atheros.com>,
	Kevin Hayes <kevin@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John, Marcel,

we are reviewing possibilities of working on Bluetooth 3.0. With
Bluetooth 3.0 you essentially will switch to transmitting large data
over your 802.11 device instead of the BT device. One of the first
questions we need to address first is how we would go about
coordinating development between wireless-testing and
bluetooth-testing. First I'll note that I know squat of bluetooth so
bare with me if I'm not being 100% accurate here. From what I gather
on the mac80211 side the biggest piece will be the PAL implementation
which should translate HCI commands to respective 802.11 frames where
needed. It seems this would likely be the first thing tackled. Prior
to working on 802.11 though we realize that at some point we'll need
to synchronize the 802.11 and Bluetooth trees though so work done on
wireless-testing for a PAL is reasonable but then the
bluetooth-testing won't have the respective updates.

Using linux-next is one possibility but using linux-next proves a pain
due to the fact that every single update on breaks updates, so the
only way to update is:

git fetch
git reset --hard origin

Wanted to get your feedback on what you think would be the best
approach to take for focus on development for Bluetooth 3.0 support.
Hoping there is a better solution than using linux-next.

  Luis
