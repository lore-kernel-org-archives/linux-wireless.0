Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45143 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754473AbaGUKCV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2014 06:02:21 -0400
Message-ID: <1405936933.32255.8.camel@jlt4.sipsolutions.net> (sfid-20140721_120224_288950_DD3872A4)
Subject: Re: [PATCH] regulatory: add NULL to alpha2
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: Arik Nemtsov <arik@wizery.com>, linux-wireless@vger.kernel.org,
	Eliad Peller <eliad@wizery.com>
Date: Mon, 21 Jul 2014 12:02:13 +0200
In-Reply-To: <20140630222303.GO1390@garbanzo.do-not-panic.com> (sfid-20140701_002311_478050_7925FB16)
References: <1402471415-22723-1-git-send-email-arik@wizery.com>
	 <1403516586.4418.13.camel@jlt4.sipsolutions.net>
	 <20140630222303.GO1390@garbanzo.do-not-panic.com>
	 (sfid-20140701_002311_478050_7925FB16)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-06-30 at 15:23 -0700, Luis R. Rodriguez wrote:
> On Mon, Jun 23, 2014 at 11:43:06AM +0200, Johannes Berg wrote:
> > On Wed, 2014-06-11 at 10:23 +0300, Arik Nemtsov wrote:
> > > From: Eliad Peller <eliad@wizery.com>
> > > 
> > > alpha2 is defined as 2-chars array, but is used in multiple
> > > places as string (e.g. with nla_put_string calls), which
> > > might leak kernel data.
> > > 
> > > Solve it by simply adding an extra char for the NULL
> > > terminator, making such operations safe.
> > 
> > I'm beginning to think that it would make more sense to just not use
> > nla_put_string()?
> 
> If the reason for adding the check was because of a new use case
> then yes, but other than that are there other reasons you were
> considering?

This was never intended to be a string, only 2 characters ... so why use
it with string functions?

johannes

