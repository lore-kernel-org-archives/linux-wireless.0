Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:44564 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751271AbaEVOjK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 10:39:10 -0400
Message-ID: <1400769536.4174.24.camel@jlt4.sipsolutions.net> (sfid-20140522_163914_184130_3779CBDB)
Subject: Re: [PATCH 1/3] mac80211: move csa counters from sdata to
 beacon/presp
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 22 May 2014 16:38:56 +0200
In-Reply-To: <1400769454.4174.22.camel@jlt4.sipsolutions.net> (sfid-20140522_163747_967070_FC75DEAE)
References: <1400765294-14732-1-git-send-email-michal.kazior@tieto.com>
	 <1400765294-14732-2-git-send-email-michal.kazior@tieto.com>
	 <1400766195.4174.13.camel@jlt4.sipsolutions.net>
	 <CA+BoTQmw6taxwxHtK99BQXgGugu6aDrGUOCz+-MvUo52JoWrpw@mail.gmail.com>
	 (sfid-20140522_155348_321691_FA0123D1) <1400769454.4174.22.camel@jlt4.sipsolutions.net>
	 (sfid-20140522_163747_967070_FC75DEAE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-05-22 at 16:37 +0200, Johannes Berg wrote:

> You could use "struct cfg80211_csa_settings" here I suppose, but I think
> a new struct is perfectly reasonable.

Actually I don't think that's a terribly good idea - there are a lot of
temporary pointers so you can't copy the struct, and it has a lot of
unnecessary baggage too.

johannes

