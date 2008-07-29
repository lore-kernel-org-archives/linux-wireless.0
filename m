Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:46566 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756227AbYG2MZ5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 08:25:57 -0400
Received: by wa-out-1112.google.com with SMTP id j37so3376801waf.23
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jul 2008 05:25:56 -0700 (PDT)
Message-ID: <1ba2fa240807290525o41832ccei92ff554bef876b37@mail.gmail.com> (sfid-20080729_142601_262240_CB2344A5)
Date: Tue, 29 Jul 2008 15:25:56 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: iwlwifi aggregation info
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1217331408.10489.26.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1217331138.10489.24.camel@johannes.berg>
	 <1217331408.10489.26.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 29, 2008 at 2:36 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>> Say a station enables aggregation on a low-priority TID, manages to fill
>> the hw queue because high-prio frames are eating up all the airtime and
>> then disables aggregation again. Now another station enables aggregation
>> on a high-priority TID, and gets assigned to the same hw queue. Now
>> frames for that station will be stalled, no? Seems like a bug to me.

aggregation queue can still can tx packets in singles so such stall
doesn't happen even in theory.

> Never mind, the queue won't get reassigned. I was just confused by a
> bunch of superfluous code in iwl-tx.c. You cannot ever run into having
> IWL_EMPTYING_HW_QUEUE_ADDBA set because you wait for the queue to drain
> before fully disabling it.

Correct.

Tomas
