Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f48.google.com ([209.85.215.48]:53231 "EHLO
	mail-ew0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab1IVHmy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 03:42:54 -0400
Received: by ewy20 with SMTP id 20so857714ewy.7
        for <linux-wireless@vger.kernel.org>; Thu, 22 Sep 2011 00:42:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1316606859.3940.32.camel@jlt3.sipsolutions.net>
References: <1316082334-7664-1-git-send-email-arik@wizery.com>
 <1316082334-7664-6-git-send-email-arik@wizery.com> <1316606859.3940.32.camel@jlt3.sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Thu, 22 Sep 2011 10:42:38 +0300
Message-ID: <CA+XVXffYTAeX2p_c0RWpYMN=OurUJgMtpbeMF4VySnujxP75kQ@mail.gmail.com> (sfid-20110922_094257_798433_48D09F4E)
Subject: Re: [RFC 5/5] mac80211: send data directly to TDLS peers
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Kalyan C Gaddam <chakkal@iit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 21, 2011 at 15:07, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2011-09-15 at 13:25 +0300, Arik Nemtsov wrote:
>> When a station is determined to be a TDLS peer, send the data directly,
>> bypassing the AP.
>>
>> In addition, allow data to be received directly from TDLS peers.
>
> We talked a bit about this but I forgot -- did you want to add the
> buffering here?

Not as part of this patch series but yes. If the TDLS connection is in
setup, don't do anything with the packet, just put it on a queue.
Later when the connection succeeds or fails we can these packets
direct or via the AP, accordingly.

Arik
