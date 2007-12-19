Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:59443 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920AbXLSQ3z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2007 11:29:55 -0500
MIME-Version: 1.0
Subject: RE: [PATCH 5/8] mac80211: A-MPDU Rx handling aggregation reordering
Date: Wed, 19 Dec 2007 18:29:37 +0200
Message-ID: <C07C4589BE74A34981C3C3525EE1F8010308C398@hasmsx412.ger.corp.intel.com> (sfid-20071219_163000_905159_C2A2EC80)
In-Reply-To: <1198079220.4747.10.camel@johannes.berg>
References: <11979070692599-git-send-email-ron.rindjunsky@intel.com> <11979070782762-git-send-email-ron.rindjunsky@intel.com> <1197915515.4885.86.camel@johannes.berg> <c85cb4470712180544m682a93b1v9a7a34d2148a770b@mail.gmail.com> (sfid-20071218_134457_890406_A2932F58) <1197986248.4885.149.camel@johannes.berg> <1879838866982C46A9CB3D56BA49ADEB0431391B@hasmsx411.ger.corp.intel.com> <1198079220.4747.10.camel@johannes.berg>
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>,
	"Rindjunsky, Ron" <ron.rindjunsky@intel.com>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	<flamingice@sourmilk.net>, "Zhu, Yi" <yi.zhu@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



>-----Original Message-----
>From: Johannes Berg [mailto:johannes@sipsolutions.net]
>Sent: Wednesday, December 19, 2007 5:47 PM
>To: Rindjunsky, Ron
>Cc: linville@tuxdriver.com; linux-wireless@vger.kernel.org;
>flamingice@sourmilk.net; Winkler, Tomas; Zhu, Yi
>Subject: RE: [PATCH 5/8] mac80211: A-MPDU Rx handling aggregation
>reordering
>
>
>> > I'm just not sure why you'd want to. As far as I can the frames
>> already
>> > passed __ieee80211_rx(), no? Maybe only as part of the aggregation?
>>
>> No, not passed it yet, they are still queued for reordering, but as
>> aggregation is being tear down I am expected to drop the frames
>> that are still not in order.
>
>But haven't they passed through __ieee80211_rx() as the aggregate
frame?

AMsDU aggregation is different from AMpDU aggregation. For AMPDU the
disaggregating is happening let say in PHY level. First one is many
packets in packed into one. Second one is packets in a row without ACK
between them. (You answer with Block Ack to them). They appear as
regular frames to mac80211 but they are not in order. Only ordered
sequence might be passed to the network stack. So we might drop the
frames are result of non order.
So what Ron was concerning about is whether we it's not waste of time to
pass packets through rx handler before we know the sequence is
completed.

Tomas
>johannes
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

