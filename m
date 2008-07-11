Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:31395 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728AbYGKR2q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jul 2008 13:28:46 -0400
Received: by wa-out-1112.google.com with SMTP id j37so2356577waf.23
        for <linux-wireless@vger.kernel.org>; Fri, 11 Jul 2008 10:28:46 -0700 (PDT)
Message-ID: <c85cb4470807111028w19f62abel31704deb18c73f6d@mail.gmail.com> (sfid-20080711_192854_547221_3315BC87)
Date: Fri, 11 Jul 2008 19:28:45 +0200
From: "Ron Rindjunsky" <ron.rindjunsky@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: removing STAs while aggregation is in effect?
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1215770111.3483.112.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1215770111.3483.112.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Quick question: I was looking through the new tx queue rework davem did
> and couldn't immediately tell whether or not the right thing happens
> when a STA is removed while aggregation is in effect. Say mac80211 is
> operating as an AP and a STA disassociates in the middle of an
> aggregation session, I can see nothing that guarantees the aggregation
> queue will be drained and returned to the pool etc.
>
> Am I missing something?

funny, but by chance this is a flow i am dealing with right now in STA
mode as part of patch meant to clean a bit the dissassoc flow. as to
AP mode - i did not look at the rework as well and i will have to
check this part, but IMHO this is more to do with the general flow of
assoc/dissassoc. if the MLME decides to remove an STA - by all means
it has to free its resources first - aggregation queues is one if them
of course.

Ron
