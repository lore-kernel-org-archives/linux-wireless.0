Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:58343 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799Ab3GBNuy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jul 2013 09:50:54 -0400
Message-ID: <51D2DAB9.4050002@openwrt.org> (sfid-20130702_155110_745197_D3621590)
Date: Tue, 02 Jul 2013 15:50:49 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Jean-Pierre Tosoni <jp.tosoni@acksys.fr>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC v2] mac80211: Use libnl-configurable values for retry counts
References: <1372351227-25575-1-git-send-email-jp.tosoni@acksys.fr> <51CF3EC9.3000707@openwrt.org> <000001ce7728$18b07de0$4a1179a0$@acksys.fr>
In-Reply-To: <000001ce7728$18b07de0$4a1179a0$@acksys.fr>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-07-02 3:28 PM, Jean-Pierre Tosoni wrote:
> Hi Felix,
> 
>> -----Message d'origine-----
>> De : Felix Fietkau [mailto:nbd@openwrt.org]
>> > ---
>> > What I am seeking with this patch:
>> > I believe the configuration of the retries will help making recovery
>> > much faster when an AP (in infrastructure mode) or a peer (in mesh
>> > mode) suddenly disappears.
>> I'm all for reducing retries, but I think the way you're applying the
>> limit is problematic.
>> If minstrel decides to use many retries for a high rate and you're
>> simply cutting off all retries that exceed the configured limit, you're
>> potentially inviting quite a bit of unnecessary packet loss.
>> I'm planning to remove the use of retry rate slot 4 (fallback to lowest
>> rate) from minstrel, since max_prob_rate should already provide quite
>> decent reliability.
> 
> Well, on one hand, people who want to reduce retries are more concerned with
> low latency and jitter than with reliable delivery of data.
Makes sense.

> On another hand the code should work for any rate control plugin, not just
> minstrel.
But much more important than that is to not cause regressions for other
people via aggressive packet dropping.

> Finally this code is executed for each frame, and I don’t want to bloat it
> more than necessary...
If you put the code in minstrel (and minstrel_ht), it not only allows
making a better tradeoff for retry handling, the code also doesn't have
to be run for every single packet. You can run it during the rate
control stats update.

The reduction of retry attempts definitely needs to be balanced
properly. Retries with max_prob_rate can be more important than retries
with max_tp_rate, but there needs to be a minimum for each of those.

- Felix
