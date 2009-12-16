Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:37995 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934791AbZLPI1y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2009 03:27:54 -0500
From: Holger Schurig <holgerschurig@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wireless: wext: allocate space for NULL-termination for  32byte SSIDs
Date: Wed, 16 Dec 2009 09:26:13 +0100
Cc: Albert Cahalan <acahalan@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	m.hirsch@raumfeld.com, libertas-dev@lists.infradead.org,
	dcbw@redhat.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@kernel.org, daniel@caiaq.de,
	David Miller <davem@davemloft.net>
References: <1260650850-16163-1-git-send-email-daniel@caiaq.de> <1260873307.3692.10.camel@johannes.local> <787b0d920912152254r4bd3e1e2l14fbe7c1fdf42e60@mail.gmail.com>
In-Reply-To: <787b0d920912152254r4bd3e1e2l14fbe7c1fdf42e60@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200912160926.14062.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> First of all, isn't TEST\0\0\0 simply the wrong length anyway?
> (that is, a length other than 32 is nonsense AFAIK)

No, the SSID IE in a beacon encodes also a length. So the beacons 
from SSID of TEST, TEST\0 and TEST\0\0\0 are different.

This is because in the beacon, the SSID is *NOT* an u8[32], but 
an IE, which is struct { u8 type, u8 length, u8 data[] };

-- 
http://www.holgerschurig.de
