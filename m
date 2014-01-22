Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:41894 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408AbaAVTVk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 14:21:40 -0500
Message-ID: <1390418495.4334.49.camel@jlt4.sipsolutions.net> (sfid-20140122_202143_034691_5184CAC6)
Subject: Re: [PATCH] mac80211: send {add,del}ba on AC_VO like other mgmt
 frames, as per spec
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date: Wed, 22 Jan 2014 20:21:35 +0100
In-Reply-To: <20140122191610.GD18365@magnum.frso.rivierawaves.com> (sfid-20140122_201711_730750_BBD5790C)
References: <1390391564-18481-1-git-send-email-karl.beldan@gmail.com>
	 <1390394079.4334.30.camel@jlt4.sipsolutions.net>
	 <20140122130924.GA18365@magnum.frso.rivierawaves.com>
	 <CAGXE3d_V2vST4nkFLUeXgTwbzB_GfPYM3HzBC1QjLuG_=LP2Kw@mail.gmail.com>
	 <20140122152845.GB18365@magnum.frso.rivierawaves.com>
	 <CAGXE3d8_qukp_gb4P0PnJkQJT8MtsypYgzPojE+RqpzEK_R62Q@mail.gmail.com>
	 <20140122164122.GC18365@magnum.frso.rivierawaves.com>
	 <1390416713.4334.46.camel@jlt4.sipsolutions.net>
	 <20140122191610.GD18365@magnum.frso.rivierawaves.com>
	 (sfid-20140122_201711_730750_BBD5790C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-01-22 at 20:16 +0100, Karl Beldan wrote:

> > Given the fact that we only send the frame from
> > ieee80211_stop_tx_ba_cb() I don't see any problem. Even if we were to
> > send the frame directly after calling the ampdu_action, it seems it
> > would be fine, since the callback (now) requires sending the remaining
> > frames unaggregated. (Given that, I'm not even sure why we required the
> > packets to be sent unaggregated, Emmanuel, do you remember?)
> > 
> I'd expect most device to not block ack such frames, and they'd be
> right to do so, sending them unaggregated seems the right thing to do.

Oh, I roughly remember now - we didn't want to separate the cases of us
sending a delBA and us receiving a delBA. If we receive a delBA, we
should stop sending aggregated frames immediately (actually for iwlwifi
the firmware will do that) or as quickly as possible, hence the
requirement

If we decide to tear down the session ourselves then we could continue
sending until later, but it's not worth it.

> So, I guess you are taking what I sent ?

Haven't really made up my mind yet ... I think it's more correct, so I
should, but I also don't really want to break the ralink drivers over
what seems to me to be a fairly small issue.

johannes

