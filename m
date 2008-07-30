Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.183]:22639 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbYG3LRc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 07:17:32 -0400
Received: by ik-out-1112.google.com with SMTP id c28so379599ika.5
        for <linux-wireless@vger.kernel.org>; Wed, 30 Jul 2008 04:17:31 -0700 (PDT)
Subject: Re: [PATCH 1/6] mac80211: allow no mac address until firmware load
From: Luis Carlos Cobo <luisca@cozybit.com>
To: Dan Williams <dcbw@redhat.com>
Cc: Tomas Winkler <tomasw@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org
In-Reply-To: <1217262158.28198.44.camel@localhost.localdomain>
References: <48763814.27052c0a.1794.2095@mx.google.com>
	 <200807281544.33509.mb@bu3sch.de> <1217253397.6364.2.camel@localhost>
	 <200807281600.39103.mb@bu3sch.de>
	 <1217257174.28198.27.camel@localhost.localdomain>
	 <1217257628.15381.2.camel@johannes.berg>
	 <1217258040.28198.40.camel@localhost.localdomain>
	 <1ba2fa240807280858o4020fec8k4c287567dff177ca@mail.gmail.com>
	 <1217262158.28198.44.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 30 Jul 2008 13:17:20 +0200
Message-Id: <1217416640.6379.144.camel@localhost> (sfid-20080730_131735_922054_8DB0F8EA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

So I see three options:

1) Use 00:... and be happy. No problem with udev, we use an address that
is actually valid.

2) Use 01:00... and fix udev so it ignores it.

3) Use 44:44..., because it is what orinoco used and fix udev so it
ignores it.

I would go for solution 2, 00:00:00:00:00:00 is a valid address for a
device and multicast addresses are not, and that should be reflected on
udev's policy.

About persistent names, can we get a persistent name after the device
gets its MAC address? Before that, the device is not being used and it
does not matter much.

-- 
Luis Carlos Cobo Rus       GnuPG ID: 44019B60
cozybit Inc.


