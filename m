Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.169]:3995 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbZCPB2l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Mar 2009 21:28:41 -0400
Received: by wf-out-1314.google.com with SMTP id 28so1615429wfa.4
        for <linux-wireless@vger.kernel.org>; Sun, 15 Mar 2009 18:28:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1237140134.24621.0.camel@johannes.local>
References: <18876.41851.397740.847705@gargle.gargle.HOWL>
	 <1237140134.24621.0.camel@johannes.local>
Date: Sun, 15 Mar 2009 21:28:39 -0400
Message-ID: <b6c5339f0903151828m4e5b3d2dg5ae03bbed5538bd4@mail.gmail.com> (sfid-20090316_022847_734390_49093696)
Subject: Re: [PATCH] mac80211: Tear down aggregation sessions for
	suspend/resume
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Sujith <Sujith.Manoharan@atheros.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Mar 15, 2009 at 2:02 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sun, 2009-03-15 at 12:13 +0530, Sujith wrote:
>> When the driver has been notified with a STA_REMOVE, it tears down
>> the internal ADDBA state. On resume, trying to initiate aggregation would
>> fail because mac80211 has not cleared the operational state for that <TID,STA>.
>> This can be fixed by tearing down the existing sessions on a suspend.
>
> Agreed, but Bob said there were some deadlocks with this?

I think the deadlock went away, not sure what fixed it but I guess
the HT rework.  I tested it a couple of weeks ago on ath5k and Luis
did on ath9k so I say let's go ahead and apply the patch... in the
meantime I'll try again on ath5k just to be sure.

-- 
Bob Copeland %% www.bobcopeland.com
