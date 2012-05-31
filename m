Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:34955 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758385Ab2EaWb5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 May 2012 18:31:57 -0400
Message-ID: <4FC7F14F.3020608@candelatech.com> (sfid-20120601_003300_589238_E59049D7)
Date: Thu, 31 May 2012 15:31:43 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Adrian Chadd <adrian@freebsd.org>
CC: Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
Subject: Re: Anyone doing WiFi throughput tests?
References: <4FC04B5A.1070900@candelatech.com> <20416.19680.571601.549629@gargle.gargle.HOWL> <4FC0F8CE.1030303@candelatech.com> <20417.972.888113.821079@gargle.gargle.HOWL> <20417.1857.115550.807746@gargle.gargle.HOWL> <4FC2437C.9090106@candelatech.com> <CAJ-Vmon13Q5icGU0oeQWaOaHF+jfhEZHyK2Y1xp5BwCgM_74pg@mail.gmail.com> <4FC2F73F.4070701@candelatech.com> <CAJ-VmonMtRUZpidJERT7hRUDJNgyoMdVovXoG5WdStH6zk7yFQ@mail.gmail.com> <20419.9719.160216.124618@gargle.gargle.HOWL> <CAJ-Vmokf+EfpQ9m_8W6q3q-nsKgMMTn0w7=BgnW26AWh5vZB2g@mail.gmail.com> <CAJ-Vmok8oK6G1U2GR074n3QWJUr924WitP4Xn47wG6k95msfDA@mail.gmail.com>
In-Reply-To: <CAJ-Vmok8oK6G1U2GR074n3QWJUr924WitP4Xn47wG6k95msfDA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/31/2012 12:24 PM, Adrian Chadd wrote:
> .. yup, I got it to 250MBit UDP. :-)
>
> It turns out that (at least in FreeBSD-9), the scheduler and sleep
> state behaviour when doing adaptive power save/sleep state (ie,
> adaptive CPU speed changes, going into C2) is enough to negatively
> impact my iperf and ath/net80211 taskqueue scheduling.
>
> When I nail it back up to C1, fixed speed - everything is perfectly fine.
>
> I'll go and do some further digging into this, but it's good to see
> that I can squeeze decently high throughput out of the 2x2 NICs.

I'm getting right at 250Mbps of UDP payload received when
using a 2x2 AR9382 NIC (WPEA-121N) in a Lenovo X220i (with hacked white-listed BIOS).
AP is a 3x3 AR9380 NIC (WPEA_127N) in Atom based network appliance.

Open-air connection, about 3 feet apart.  This is in
the 'download' direction:  Wired to Station.  HT-40 on 5Ghz.

The rates bounce around a bit...down to 240Mbps or so for a bit, then
back to 250Mbps.  Might be some other interference around as this is
a relatively noisy environment...

Upload speed seems to be a constant 243Mbps..at least at this moment.

Kernel is 3.3.7+.


Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

