Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36027 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148Ab1KCHrY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 03:47:24 -0400
Subject: Re: mac80211: UAPSD - EOSP bit seems to be not set when send qos
 null frame
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <CAFED-jkVtVFBJfDc-18a+RogAFoTVudS9_POjZHFZ=AtBu1p0g@mail.gmail.com> (sfid-20111103_083636_963010_396565E0)
References: <CAFED-jkVtVFBJfDc-18a+RogAFoTVudS9_POjZHFZ=AtBu1p0g@mail.gmail.com>
	 (sfid-20111103_083636_963010_396565E0)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Nov 2011 08:47:20 +0100
Message-ID: <1320306440.3950.0.camel@jlt3.sipsolutions.net> (sfid-20111103_084728_040754_3E9CC544)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-11-03 at 08:36 +0100, Janusz Dziedzic wrote:
> Hello,
> 
> I have a question connected with UAPSD implementation.
> Seems, mac80211 always clear EOSP bit in ieee80211_set_qos_hdr() fuction.
> Is that a problem in mac80211 or this should be handled in different place/way?

It should be set:

        if (qos) {
                nullfunc->qos_ctrl = cpu_to_le16(tid);

                if (reason == IEEE80211_FRAME_RELEASE_UAPSD)
                        nullfunc->qos_ctrl |=
                                cpu_to_le16(IEEE80211_QOS_CTL_EOSP);
        }

johannes

