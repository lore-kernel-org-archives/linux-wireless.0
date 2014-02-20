Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:59610 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbaBTHIR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Feb 2014 02:08:17 -0500
Message-ID: <1392880090.5073.2.camel@jlt4.sipsolutions.net> (sfid-20140220_080819_877750_C0707216)
Subject: Re: [PATCH v4] cfg80211: regulatory introduce maximum bandwidth
 calculation
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 20 Feb 2014 08:08:10 +0100
In-Reply-To: <CALhHN=qnWsY3cEewxAOR+KafW8L-VFFG9djk5shS_BSdepKqnw@mail.gmail.com> (sfid-20140220_070758_613044_2C66DDE2)
References: <1391071940-4296-1-git-send-email-janusz.dziedzic@tieto.com>
	 <CAB=NE6XQs17pWVWchN8FJrv9HZwzkOF94iCPY=nx1BsJ5_bLcg@mail.gmail.com>
	 <CALhHN=qnWsY3cEewxAOR+KafW8L-VFFG9djk5shS_BSdepKqnw@mail.gmail.com>
	 (sfid-20140220_070758_613044_2C66DDE2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-02-20 at 07:07 +0100, Janusz Dziedzic wrote:

> > What happens if an old kernel gets a new wireless-regdb with AUTO on
> > all of its 5 GHz regdomain for the country it using ? I see no mention
> > of this anywhere in the documentation and at least from the code
> > review I just did it seemed like we'd use 0. I hope I'm wrong as
> > otherwise that'd introduce a severe regression when this is introduced
> > to wireless-regdb.

> Old-kernel + new wireless-regdb + new crda.
> In case of AUTO we will not set NL80211_ATTR_FREQ_RANGE_MAX_BW we will
> get -EINVAL

That seems like a problem.

johannes

