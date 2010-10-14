Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:59684 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335Ab0JNP7b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 11:59:31 -0400
Received: from kpbe12.cbf.corp.google.com (kpbe12.cbf.corp.google.com [172.25.105.76])
	by smtp-out.google.com with ESMTP id o9EFxUtR008434
	for <linux-wireless@vger.kernel.org>; Thu, 14 Oct 2010 08:59:30 -0700
Received: from iwn37 (iwn37.prod.google.com [10.241.68.101])
	by kpbe12.cbf.corp.google.com with ESMTP id o9EFxTXw018266
	for <linux-wireless@vger.kernel.org>; Thu, 14 Oct 2010 08:59:29 -0700
Received: by iwn37 with SMTP id 37so7591956iwn.15
        for <linux-wireless@vger.kernel.org>; Thu, 14 Oct 2010 08:59:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1287067869.4641.440.camel@jlt3.sipsolutions.net>
References: <20101013224851.B8E5D20465@glenhelen.mtv.corp.google.com>
	<1287064265.4641.435.camel@jlt3.sipsolutions.net>
	<AANLkTinq=B13gPd3obqAkBDQv4Ufz5Upp2UPVw9bpED2@mail.gmail.com>
	<1287066750.4641.439.camel@jlt3.sipsolutions.net>
	<1287067869.4641.440.camel@jlt3.sipsolutions.net>
Date: Thu, 14 Oct 2010 08:59:28 -0700
Message-ID: <AANLkTi=pYVQyLuya534tymCbYW7UXd3=9G87knnQ6prW@mail.gmail.com>
Subject: Re: [PATCH 3/6] Add a function for evaluating rate changes for
 possible notification
From: Paul Stewart <pstew@google.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 14, 2010 at 7:51 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2010-10-14 at 16:32 +0200, Johannes Berg wrote:
>
>> I wonder if "rate" is really the best interface for this. Since it's a
>> threshold event, does it matter? Maybe there should instead be events
>> for MCS changes and legacy rate changes so we can avoid all those
>> calculations?
>
> In fact, since you'd only care about changes across a threshold etc, not
> the absolute rate, you might be able to build the system without ever
> doing the expensive rate calculation from MCS.

What if I change the calculate() so that it does a cached table
lookup?  Since MCS numbers aren't linear or monotonic with regard to
bitrate, those numbers can't be compared directly to set thresholds.
I think it'd be a mistake to push it to userspace to interpret MCS and
alert on every MCS change since that would just tradeoff calculation
expense for nl80211 socket traffic, since without an understanding of
the MCS ranking, it'd would not be possible to set thresholds.

--
Paul
