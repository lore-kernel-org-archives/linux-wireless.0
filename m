Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:20947 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758612AbYALMww convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jan 2008 07:52:52 -0500
MIME-Version: 1.0
Subject: RE: [RFC PATCH 07/10] mac80211: A-MPDU Tx change tx_status to      support Block Ack data
Date: Sat, 12 Jan 2008 14:37:22 +0200
Message-ID: <1879838866982C46A9CB3D56BA49ADEB0450EA38@hasmsx411.ger.corp.intel.com> (sfid-20080112_125300_637471_E1628CF7)
In-Reply-To: <49299.::ffff:91.5.126.126.1200138845.squirrel@secure.sipsolutions.net>
References: <11999857423156-git-send-email-ron.rindjunsky@intel.com>    <11999857502772-git-send-email-ron.rindjunsky@intel.com>    <1200070609.3861.208.camel@johannes.berg>    <1ba2fa240801120343v2e60acc8kc56469106cf56df1@mail.gmail.com> <49299.::ffff:91.5.126.126.1200138845.squirrel@secure.sipsolutions.net>
From: "Rindjunsky, Ron" <ron.rindjunsky@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>,
	"Tomas Winkler" <tomasw@gmail.com>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	<flamingice@sourmilk.net>, "Zhu, Yi" <yi.zhu@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



>>> Broadcom hardware is able to give intermediate status notifications,
>>> would there be any use in those?
>>
>> Can you explain?

> Actually, I don't really know what the microcode there provides. I
guess
> it tells you something like "I sent this frame, no TX errors occurred"
or
> so...

> Johannes

>From what you wrote, I would also guess that these notifications
indicate that the Tx itself was OK, as we have the same mechanism. Yet,
Block Ack handling is a must if we want good rate scaling during A-MPDU,
so the driver will have to communicate this data to the rate scaling
module with no connection to HW conformations.

Ron
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

