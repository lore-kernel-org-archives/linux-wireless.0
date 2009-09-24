Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:64000 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209AbZIXAif (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Sep 2009 20:38:35 -0400
Received: by iwn8 with SMTP id 8so649266iwn.33
        for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2009 17:38:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890909231628g340f1467ka5c02515b051285b@mail.gmail.com>
References: <43e72e890909221541u67fa291fq353327d1d55841f2@mail.gmail.com>
	<20090923225853.GA14625@jm.kir.nu> <43e72e890909231628g340f1467ka5c02515b051285b@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 23 Sep 2009 17:38:19 -0700
Message-ID: <43e72e890909231738j2bde509cg6e8de797dd0965d0@mail.gmail.com>
Subject: Re: Flush TX - wireless summit topic
To: Jouni Malinen <j@w1.fi>
Cc: Bob Copeland <me@bobcopeland.com>,
	"Jouni.Malinen" <Jouni.Malinen@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 23, 2009 at 4:28 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:

> I'm inclined for mac80211 to force an rxflush here so that we force
> all drivers to do the right thing and we'd document this as such,
> instead of having to rely on each driver doing the right thing
> (caching the channel for the RX'f frame). The downside to this is
> obviously this can create a delay on channel change, however long it
> takes to process the pending frames already sitting for us on the
> DMA'd memory.

After reviewing this in great detail with Jouni it seems the advised
path is to implement an RX flush prior to channel change in each
driver. There is some obvious delta created upon channel change if you
force to process all pending DMA'd frames but it remains unproven that
this delta in time will actually create an issue.

  Luis
