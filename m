Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:35430 "EHLO
	mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbcFNOQX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jun 2016 10:16:23 -0400
Received: by mail-qk0-f193.google.com with SMTP id b136so6029105qkg.2
        for <linux-wireless@vger.kernel.org>; Tue, 14 Jun 2016 07:16:23 -0700 (PDT)
Date: Tue, 14 Jun 2016 10:16:06 -0400
From: Bob Copeland <me@bobcopeland.com>
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"michal.kazior@tieto.com" <michal.kazior@tieto.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: fix potential null dereference bugs
Message-ID: <20160614141606.GA713@localhost> (sfid-20160614_161627_133331_624EF1AD)
References: <1465563164-783-1-git-send-email-me@bobcopeland.com>
 <CA+BoTQkg+uea_YzUgrVBPhA8uRxNpd29Kd1y1tvt0a-JyOSLQw@mail.gmail.com>
 <1465808939.2434.1.camel@sipsolutions.net>
 <20160613130507.GA11074@localhost>
 <1465823880.10050.3.camel@sipsolutions.net>
 <87shwf3mlh.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87shwf3mlh.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 14, 2016 at 01:51:24PM +0000, Kalle Valo wrote:
> > It's not clear that's the same situation, since tun->sk is very likely
> > to have been an actual pointer, not an embedded thing like drv_priv.

Just to follow up on that thread, I did research it a bit yesterday and
came to the conclusion that it is UB even when the target is in the same
struct.  However, in a not very scientific survey, I didn't see either clang
or gcc remove the test in a simplified test case (with -O3 and without
-fno-delete-null-pointer-checks).  If drv_priv were an actual pointer, gcc
did remove it but clang did not.  So, there's that.

> > However, with all this, I think I'd simply not take any chances - the
> > patch isn't exactly invasive and in some cases (for example the first
> > hunk of the patch) will even improve the code to the point where the
> > compiler could warn about uninitialized usage of the pointer when the
> > code gets modified to use it in case of !txq->sta.
> >
> > I'd take it, but I guess it's Kalle's decision :)
> 
> Yeah, I'm leaning towards Johannes. These are not really invasive.

Thanks, and sorry about the checkpatch -- I did run checkpatch on it but
for some reason my version only complained about some of them.

-- 
Bob Copeland %% http://bobcopeland.com/
