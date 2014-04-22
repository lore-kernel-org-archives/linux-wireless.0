Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:53130 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933319AbaDVQo1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Apr 2014 12:44:27 -0400
Received: by mail-la0-f42.google.com with SMTP id el20so1180708lab.29
        for <linux-wireless@vger.kernel.org>; Tue, 22 Apr 2014 09:44:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <112458057.20140422173756@eikelenboom.it>
References: <1398137975-14275-1-git-send-email-mcgrof@do-not-panic.com>
 <1398137975-14275-3-git-send-email-mcgrof@do-not-panic.com>
 <1398179899.4211.21.camel@jlt4.sipsolutions.net> <112458057.20140422173756@eikelenboom.it>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 22 Apr 2014 09:44:06 -0700
Message-ID: <CAB=NE6V6hvsJuzSBqp_nQ1GoMp0xuG-BxBkNZcFZUZLbNgcr3w@mail.gmail.com> (sfid-20140422_184445_047713_907ACEA4)
Subject: Re: [PATCH 2/2] cfg80211: fix processing world regdomain when non modular
To: Sander Eikelenboom <linux@eikelenboom.it>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Leun <lkml20140418@newton.leun.net>,
	Arik Nemtsov <arik@wizery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 22, 2014 at 8:37 AM, Sander Eikelenboom
<linux@eikelenboom.it> wrote:
>
> Tuesday, April 22, 2014, 5:18:19 PM, you wrote:
>
>> Applied, I hope it won't blow up again :)
>
>> johannes
>
> At least there is some time left this time around ;-)
> Will retest tomorrow to at least verify that it indeed also fixes something !

FWIW you had already tested the second patch which had solved your
issue, the first patch is an enhancement fix that addresses two
regressions introduced by enabling reprocessing of the last request
which as Arik found was caused by treating free'ing a new request (or
reprocessing after my patch) being processed as a last request. One
aspect of the full series I had originally sent out is still not
merged and that is the last patch which added opportunistic triggers
to check the regulatory queue after bootup. That was rejected based on
an architectural design to compartmentalize regulatory and while I
could argue with it, over time I think Johannes is right and will send
out a follow up patch with a timer for it eventually. The other
triggers for hitting the queue can be manual (userspace iw reg set) or
beacon hints on 5 GHz channels (most folks will have this) my goal was
to automate something to kick it after boot up.

  Luis
