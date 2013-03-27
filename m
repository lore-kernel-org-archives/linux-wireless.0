Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sycorax.lbl.gov ([128.3.11.121]:40353 "EHLO sycorax.lbl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753752Ab3C0TJH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Mar 2013 15:09:07 -0400
From: Alex Romosan <romosan@sycorax.lbl.gov>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, ilw@linux.intel.com
Subject: Re: iwlwifi unable to reconnect after suspend since v3.9-rc1
References: <87li993mug.fsf@sycorax.lbl.gov>
	<1364390086.8388.7.camel@jlt4.sipsolutions.net>
	<87r4j021ac.fsf@sycorax.lbl.gov>
	<1364406085.8388.11.camel@jlt4.sipsolutions.net>
	<87ip4cg1qg.fsf@sycorax.lbl.gov>
	<1364410962.8388.19.camel@jlt4.sipsolutions.net>
Date: Wed, 27 Mar 2013 12:08:59 -0700
In-Reply-To: <1364410962.8388.19.camel@jlt4.sipsolutions.net> (message from
	Johannes Berg on Wed, 27 Mar 2013 20:02:42 +0100)
Message-ID: <87txnwacdw.fsf@sycorax.lbl.gov> (sfid-20130327_200913_967166_37293384)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Wed, 2013-03-27 at 11:02 -0700, Alex Romosan wrote:
>
>> > Humm, yes, that makes more sense. That commit fixed a bug in another
>> > commit though, I'm surprised you ended up there?! Curious ... I'll
>> > check over the commit and see if I can find anything wrong with it.
>> 
>> i just reverted that commit on top of 3.9-rc4 and now i can reconnect
>> when resuming from suspend. so whatever bug that commit fixed, it also
>> introduced a new one.
>
> Hmm, actually ... I suspect this didn't introduce a bug but rather
> unmasked one in iwlwifi/mac80211 interaction.
>
> Are you sure this only happens after suspend/resume? It seems like it
> would always happen? At least if there was a beacon in the scan results
> already, which should probably always be the case...

no, it always happens, but i only noticed it after suspend/resume. when
i suspend i do an ifdown (because i haven't figured out a way to
convince my new access point not to drop idle connections) and then i do
an ifup to reconnect on resume. when i'm testing it now, i just take the
network down and then try to bring it back up.

> Can you enable iwlwifi debugging and set the iwlwifi module parameter
> debug=0x40000000 ? I have a feeling you'll see something like
> "PASSIVE_NO_RX" in there.

i'll do it and let you know. i have iwlwifi compiled in the kernel, how
do i specify it at boot time?

--alex--

-- 
| I believe the moment is at hand when, by a paranoiac and active |
|  advance of the mind, it will be possible (simultaneously with  |
|  automatism and other passive states) to systematize confusion  |
|  and thus to help to discredit completely the world of reality. |
