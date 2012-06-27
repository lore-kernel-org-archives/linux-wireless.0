Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41772 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514Ab2F0L1W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 07:27:22 -0400
Received: by bkcji2 with SMTP id ji2so821358bkc.19
        for <linux-wireless@vger.kernel.org>; Wed, 27 Jun 2012 04:27:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1340795869.11012.12.camel@jlt3.sipsolutions.net>
References: <1340640308.27437.16.camel@jlt3.sipsolutions.net>
 <CAB3XZEe7t3MYVv6Bja9X315CuhWa=aaEyB82pGp_9hMp8grbMg@mail.gmail.com>
 <1340707305.14634.9.camel@jlt3.sipsolutions.net> <CAB3XZEfEB2TaeN4EYGyBmcuh823EfmdLhSWE55u5OwPE+Ff7oQ@mail.gmail.com>
 <CA+XVXffLy5mSqXTtEh7STC_xtSKOJTdtVF9jGPj5UEQ88wD+LQ@mail.gmail.com> <1340795869.11012.12.camel@jlt3.sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 27 Jun 2012 14:27:06 +0300
Message-ID: <CA+XVXfcNpj_UqCOXUG7sr2MQH8qZNHYr7MfBz5J3vwC3f+KU6Q@mail.gmail.com> (sfid-20120627_132726_504307_DD6DBE48)
Subject: Re: mac80211 auth/assoc in multi-channel scenarios
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Eliad Peller <eliad@wizery.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 27, 2012 at 2:17 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2012-06-26 at 14:35 +0300, Arik Nemtsov wrote:
>
>> Can you give a bit more info on the Tx-sync approach, for the uninitiated?
>> I'm also thinking that maybe we could somehow treat the sleeping-GO as
>> a special case (maybe with some special code and a HW flag). Right now
>> I'm not sure the wl12xx FW even supports it.
>
> I basically had a simpler version in mind, something like this:
> http://p.sipsolutions.net/cd928e926a941ac7.txt

If the low level driver has to prepare for each such Tx, that's fine.
But does this somehow rely on the timing of the Tx? Relying on op_tx
to come right after this seems racy.
