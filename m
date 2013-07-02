Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp02.msg.oleane.net ([62.161.4.2]:46580 "EHLO
	smtp02.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879Ab3GBRkX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jul 2013 13:40:23 -0400
From: "Jean-Pierre Tosoni" <jp.tosoni@acksys.fr>
To: "'Felix Fietkau'" <nbd@openwrt.org>
Cc: <linux-wireless@vger.kernel.org>
References: <1372351227-25575-1-git-send-email-jp.tosoni@acksys.fr> <51CF3EC9.3000707@openwrt.org> <000001ce7728$18b07de0$4a1179a0$@acksys.fr> <51D2DAB9.4050002@openwrt.org>
In-Reply-To: <51D2DAB9.4050002@openwrt.org>
Subject: RE: [RFC v2] mac80211: Use libnl-configurable values for retry counts
Date: Tue, 2 Jul 2013 19:40:20 +0200
Message-ID: <000101ce774b$3925e380$ab71aa80$@acksys.fr> (sfid-20130702_194052_723898_5EE8F19A)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Felix,

Sorry to use your time again...

> But much more important than that is to not cause regressions for other
> people via aggressive packet dropping.

Agreed, but see below.

> If you put the code in minstrel (and minstrel_ht), it not only allows
> making a better tradeoff for retry handling, the code also doesn't have
> to be run for every single packet. You can run it during the rate
> control stats update.

OK, I'll have a look at that part now.

> 
> The reduction of retry attempts definitely needs to be balanced
> properly. Retries with max_prob_rate can be more important than retries
> with max_tp_rate, but there needs to be a minimum for each of those.

This leads to a question about regressions and backward compatibility:

Since minstrel can compute as much as 28 retries for a frame,
And since the (standard) default value for "short_frame_max_tx_count" is 7,

... there is no way I can enforce the configured value while keeping
minstrel counts by default !
The standard itself gives a very aggressive limit! Or am I mistaken about
the significance of this configuration parameter ?

Jean-Pierre

