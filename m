Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:35813 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbbIHBUj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Sep 2015 21:20:39 -0400
Received: by lagj9 with SMTP id j9so60127550lag.2
        for <linux-wireless@vger.kernel.org>; Mon, 07 Sep 2015 18:20:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55EDCD0A.4030503@gmail.com>
References: <55E9A07E.8070005@gmail.com>
	<55EDCD0A.4030503@gmail.com>
Date: Mon, 7 Sep 2015 21:20:37 -0400
Message-ID: <CAEKwDSAjkByMFwN71qe8DE08+zshKgmp+hN13vDG=SuF3yPtvw@mail.gmail.com> (sfid-20150908_032049_233949_273D69F4)
Subject: Re: [question] panic when calling drv_get_tsf
From: Bob Copeland <me@bobcopeland.com>
To: ferran <ranker72@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 7, 2015 at 1:44 PM, ferran <ranker72@gmail.com> wrote:
>
> So firstly, why can't I call drv_get_tsf from there? Is it because TSF
> is exactly then being reset? Secondly, I feel unsafe about

You left out posting the actual panic/warning you got, but one
possibility is beacon_get is called under a lock that the driver also
takes inside drv_get_tsf().  Usually this function just reads a
register so it's unlikely that reading the tsf itself during an update
will give any troubles (other than wrong values).

> Finally, I would be interested on using TSF to measure the time passed
> since a packet is scheduled to transmit in tx.c and its report is
> received at status.c. Do you think that TSF be usable for this?

I am not sure what you want to do, but some things to think about regarding TSF:

- reading the TSF from the driver with drv_get_tsf() will give you
something that may or may not be usable.  For example, depending on
calling context, the process that reads the TSF might get scheduled
out for an unknown amount of time between when you read it and when
you use it.

- in mesh, the TSF changes as the network operates.  The stations try
to adjust their clocks so that their timing offsets are synchronized
(making it possible to know a neighbor's TBTT).

-- 
Bob Copeland %% www.bobcopeland.com
