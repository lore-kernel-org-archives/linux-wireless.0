Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:46028 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453Ab1H3QXH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 12:23:07 -0400
Received: by qyk34 with SMTP id 34so4646402qyk.19
        for <linux-wireless@vger.kernel.org>; Tue, 30 Aug 2011 09:23:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1314706867.4011.25.camel@jlt3.sipsolutions.net>
References: <1314236064-6339-1-git-send-email-thomas@cozybit.com> <1314706867.4011.25.camel@jlt3.sipsolutions.net>
From: Javier Cardona <javier@cozybit.com>
Date: Tue, 30 Aug 2011 09:22:44 -0700
Message-ID: <CAPjQAd8z5pdPaf1t29LmqUo=qdBVAZ7qo=XkmuqDTTGd3krY8Q@mail.gmail.com> (sfid-20110830_182311_043887_A2E4D58E)
Subject: Re: [PATCH] ath5k: Invoke irqsafe version of ieee80211_tx_status() to
 avoid deadlock
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Thomas Pedersen <thomas@cozybit.com>,
	linux-wireless@vger.kernel.org, jirislaby@gmail.com,
	mickflemm@gmail.com, lrodriguez@atheros.com, me@bobcopeland.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 30, 2011 at 5:21 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2011-08-24 at 18:34 -0700, Thomas Pedersen wrote:
>> From: Javier Cardona <javier@cozybit.com>
>>
>> This driver reports transmission status to the upper layer
>> (ath5k_tx_frame_completed()) while holding the lock on the transmission
>> queue (txq->lock).  Under failure conditions, the mesh stack will
>> attempt to send PERR messages to the previous sender of the failed
>> frame.
>
> I'd feel a lot more comfortable if the mesh stack didn't do that. I
> suppose it could use ieee80211_add_pending_skb() instead?

Suggestion taken.  We'll implement that.

Cheers,

Javier
