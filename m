Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:38332 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932737AbaDVREl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Apr 2014 13:04:41 -0400
Received: by mail-lb0-f176.google.com with SMTP id 10so4524725lbg.21
        for <linux-wireless@vger.kernel.org>; Tue, 22 Apr 2014 10:04:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140422184824.74973bb3@xenia.leun.net>
References: <1398137975-14275-1-git-send-email-mcgrof@do-not-panic.com>
 <20140422180003.6438dbb7@xenia.leun.net> <CAB=NE6URp2S9rhVr2cqT+4VOj50m+q0o1rVRehCZvcUtNwTVVw@mail.gmail.com>
 <20140422184824.74973bb3@xenia.leun.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 22 Apr 2014 10:04:19 -0700
Message-ID: <CAB=NE6W64b5VS5pTnxrcRRkRdje6h_hQcGmF9jUiXO55b+nHRw@mail.gmail.com> (sfid-20140422_190447_527068_763B230C)
Subject: Re: [PATCH 0/2] cfg80211: two reg fixes
To: Michael Leun <lkml20140418@newton.leun.net>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Arik Nemtsov <arik@wizery.com>,
	Sander Eikelenboom <linux@eikelenboom.it>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 22, 2014 at 9:48 AM, Michael Leun
<lkml20140418@newton.leun.net> wrote:
> 1611                    if (wiphy->regulatory_flags & REGULATORY_COUNTRY_IE_IGNORE)
> 1612                            return REG_REQ_IGNORE;

Interesting -- same line as your regression test had found, wiphy->
must be NULL. Digging deeper, you can discard that patch now, we can
rule out the reprocessing of the request.

 Luis
