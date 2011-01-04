Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:59515 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047Ab1ADWaA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jan 2011 17:30:00 -0500
Received: from kpbe13.cbf.corp.google.com (kpbe13.cbf.corp.google.com [172.25.105.77])
	by smtp-out.google.com with ESMTP id p04MTxGU007681
	for <linux-wireless@vger.kernel.org>; Tue, 4 Jan 2011 14:29:59 -0800
Received: from iyb26 (iyb26.prod.google.com [10.241.49.90])
	by kpbe13.cbf.corp.google.com with ESMTP id p04MTs4i005740
	for <linux-wireless@vger.kernel.org>; Tue, 4 Jan 2011 14:29:58 -0800
Received: by iyb26 with SMTP id 26so14779910iyb.27
        for <linux-wireless@vger.kernel.org>; Tue, 04 Jan 2011 14:29:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTinvrdj4jbzH3COVZ9gW8W0h0em7uD6DBWBEXUp=@mail.gmail.com>
References: <1292482775.3542.8.camel@jlt3.sipsolutions.net>
	<AANLkTi=pZAnyp5ztSqCo-MEF=_arECfAYg43JJ_j1Gb4@mail.gmail.com>
	<1292499024.3612.3.camel@jlt3.sipsolutions.net>
	<AANLkTimxoA+3GaZZWODKJ9MVJTJzRhnj5oh_jWGJhzWc@mail.gmail.com>
	<1292501047.3612.9.camel@jlt3.sipsolutions.net>
	<AANLkTiktMJvk55fz-Ww_nUtHcTS1mNVSR-hhkfbux+j_@mail.gmail.com>
	<1292502934.3612.15.camel@jlt3.sipsolutions.net>
	<AANLkTimZdxQNk2hr-ekGPAWJB5YTZBqxdppOAjdbrb1i@mail.gmail.com>
	<1292504020.3612.17.camel@jlt3.sipsolutions.net>
	<AANLkTinWkYK2Zu1LsKw9YQ4dAXJ2b_quEvZLc59-c_5q@mail.gmail.com>
	<20101216174410.GB5677@tux>
	<AANLkTinvrdj4jbzH3COVZ9gW8W0h0em7uD6DBWBEXUp=@mail.gmail.com>
Date: Tue, 4 Jan 2011 14:29:53 -0800
Message-ID: <AANLkTikDP_uF_jGh5bNyMv17VoZB=9u-SrdWRUQ15gRb@mail.gmail.com>
Subject: Re: [PATCH] mac80211: Push idle state to driver before stop
From: Paul Stewart <pstew@google.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 4, 2011 at 10:19 AM, Paul Stewart <pstew@google.com> wrote:
> On Thu, Dec 16, 2010 at 9:44 AM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
>> Try this:
>
> Happy new year.  I've tried this patch, and the system continues to
> suspend and resume successfully (i.e, the fix from the earlier patches
> continues to alleviate the original problem), however the system
> continues to be "deaf" to beacons at resume time if the system
> suspends and resumes while associated.  You don't need a ChromeOS
> system to reproduce this issue.  Just associate to the network and
> suspend/resume.  On resume the system believes it should be
> associated, but then the beacon loss timer kicks in and we
> disassociate, since we are never successful in receiving a response.

Whoops.  I didn't apply that change correctly.  Actually, I think this
change works.  I think I may have spotted a couple of unrelated
anomalies I'll trace down and address separately.

--
Paul
