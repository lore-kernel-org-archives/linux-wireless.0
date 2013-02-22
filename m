Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:51291 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757299Ab3BVQVQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2013 11:21:16 -0500
Message-ID: <51279AFA.3000608@openwrt.org> (sfid-20130222_172120_315765_3D3A5C9D)
Date: Fri, 22 Feb 2013 17:21:14 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
CC: linux-wireless@vger.kernel.org,
	Thomas Pedersen <thomas@cozybit.com>,
	johannes@sipsolutions.net, antonio@open-mesh.com,
	marek@open-mesh.com,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Subject: Re: [RFC] design discussion: Collecting information for (non-peer)
 stations
References: <20130215171938.GA4140@pandem0nium>
In-Reply-To: <20130215171938.GA4140@pandem0nium>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Since this is a rare special case, I think it really does not belong
into the mac80211 data path. How about creating a monitor mode device
and claiming it from within the kernel in your own module via rx_handler
(the same mechanism that the bridge code uses to hook into the data path
of a normal net_device). You can extract relevant information from the
radiotap headers.
That way you can keep your code completely separate from mac80211 and
don't have to dump the maintenance overhead of this on other people.

- Felix
