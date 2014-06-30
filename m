Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:60876 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754889AbaF3WXJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2014 18:23:09 -0400
Received: by mail-pa0-f41.google.com with SMTP id fb1so9413153pad.28
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jun 2014 15:23:09 -0700 (PDT)
Date: Mon, 30 Jun 2014 15:23:03 -0700
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Arik Nemtsov <arik@wizery.com>, linux-wireless@vger.kernel.org,
	Eliad Peller <eliad@wizery.com>
Subject: Re: [PATCH] regulatory: add NULL to alpha2
Message-ID: <20140630222303.GO1390@garbanzo.do-not-panic.com> (sfid-20140701_002329_250280_2CB217C0)
References: <1402471415-22723-1-git-send-email-arik@wizery.com>
 <1403516586.4418.13.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1403516586.4418.13.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 23, 2014 at 11:43:06AM +0200, Johannes Berg wrote:
> On Wed, 2014-06-11 at 10:23 +0300, Arik Nemtsov wrote:
> > From: Eliad Peller <eliad@wizery.com>
> > 
> > alpha2 is defined as 2-chars array, but is used in multiple
> > places as string (e.g. with nla_put_string calls), which
> > might leak kernel data.
> > 
> > Solve it by simply adding an extra char for the NULL
> > terminator, making such operations safe.
> 
> I'm beginning to think that it would make more sense to just not use
> nla_put_string()?

If the reason for adding the check was because of a new use case
then yes, but other than that are there other reasons you were
considering?

 Luis
