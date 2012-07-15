Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:42928 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807Ab2GOFkz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Jul 2012 01:40:55 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Message-ID: <20482.22437.126251.847921@gargle.gargle.HOWL> (sfid-20120715_074137_165443_5C23C808)
Date: Sun, 15 Jul 2012 11:09:49 +0530
To: =?iso-8859-1?Q?Nicol=E1s_Ech=E1niz?= <nicoechaniz@codigosur.org>
CC: Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	Guido Iribarren <guidoiribarren@buenosaireslibre.org>,
	<ath9k-devel@lists.ath9k.org>, <linux-wireless@vger.kernel.org>,
	<ordex@autistici.org>
Subject: Re: [ath9k-devel] ath9k_htc 1mbps in IBSS mode
In-Reply-To: <4FFF2B15.5070502@codigosur.org>
References: <4FD56DCA.1080200@codigosur.org>
	<CAJ-VmomzoXV8YBdiS_2nkzVagBupX3Be-Dmboxotwy9s3h3r7w@mail.gmail.com>
	<CAHD-aqKWdUBGyadCnVoSbkf4BysoSuvBBHrupXx-JbowqqNZPQ@mail.gmail.com>
	<CAHD-aqJrKfL8OL97wcnaaTYFZrx2cBXvdY5vKeK67u_-VjGOKg@mail.gmail.com>
	<20474.20627.928963.262924@gargle.gargle.HOWL>
	<4FFF2B15.5070502@codigosur.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nicolás Echániz wrote:
> Sujith, does this mean that the problem is outside the scope of the
> ath9k_htc driver itself or could it be fixed?
> 
> we are doing some heavy use of hardware based on this driver for many
> projects; any further debugging work you might need, we are more than
> willing to help.

This is a regression introduced by this commit:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commit;h=6d810f10325522cfcf498dc6d64b9f96e1f5153f

Fixing this requires either introducing a new mac80211 callback or
revert to the older behavior which issued a station notification only
after the supported rates have been setup.

Sujith
