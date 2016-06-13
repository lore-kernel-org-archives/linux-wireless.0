Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f44.google.com ([209.85.192.44]:34350 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422821AbcFMNFW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2016 09:05:22 -0400
Received: by mail-qg0-f44.google.com with SMTP id p34so67494264qgp.1
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jun 2016 06:05:22 -0700 (PDT)
Date: Mon, 13 Jun 2016 09:05:07 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: fix potential null dereference bugs
Message-ID: <20160613130507.GA11074@localhost> (sfid-20160613_150539_264237_4D03E63D)
References: <1465563164-783-1-git-send-email-me@bobcopeland.com>
 <CA+BoTQkg+uea_YzUgrVBPhA8uRxNpd29Kd1y1tvt0a-JyOSLQw@mail.gmail.com>
 <1465808939.2434.1.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1465808939.2434.1.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 13, 2016 at 11:08:59AM +0200, Johannes Berg wrote:
> On Mon, 2016-06-13 at 07:39 +0200, Michal Kazior wrote:
> > 
> > FWIW all of these are false positives. I think this was already
> > pointed out some time ago. The drv_priv stuff is merely an offset
> > (see how ieee80211_vif and ieee80211_sta are defined) and the
> > according structure is always checked beforehand.

OK, fair enough, sorry for the noise.  I'm daily running sparse / smatch
on wireless-testing; although these had been around for a while they
showed up as new "errors" because of some line number changes, but I'll
squelch them going forward.

> IIRC, doing something like that can (sometimes?) still get you into
> undefined behaviour territory, so the compiler could potentially
> "optimize" away the later NULL check.

So I did just go and check the generated code for each of these cases
and gcc didn't elide the subsequent if-test, at least on x86-64 and my
compiler / build config.  Given http://lwn.net/Articles/342330, it seems
possible, though.

-- 
Bob Copeland %% http://bobcopeland.com/
