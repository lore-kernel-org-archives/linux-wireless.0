Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:57999 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755009Ab1H2UOb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 16:14:31 -0400
Received: by qwk3 with SMTP id 3so3573713qwk.19
        for <linux-wireless@vger.kernel.org>; Mon, 29 Aug 2011 13:14:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1314624143.8959.1.camel@jlt3.sipsolutions.net>
References: <1314297201-19007-1-git-send-email-lrodriguez@qca.qualcomm.com> <1314624143.8959.1.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <lrodriguez@qca.qualcomm.com>
Date: Mon, 29 Aug 2011 13:14:11 -0700
Message-ID: <CAB=NE6U1WZ5=_RsuTKKj4K4-42Yamot_NJGjj43ikGUY6dSkEw@mail.gmail.com> (sfid-20110829_221435_669829_3631F69A)
Subject: Re: [RFC] mac80211: add IBSS merge support
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Ivan Seskar <seskar@winlab.rutgers.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 29, 2011 at 6:22 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2011-08-25 at 11:33 -0700, Luis R. Rodriguez wrote:
>> From: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
>>
>> When you try to create an IBSS network with a lot of nodes
>> you typically end up with split networks due to the fact that
>> some nodes for one reason or another end up not listening to
>> beacons from the node others do with a higher TSF. What ends
>> up happening is you split the IBSS network and these do not
>> converge. To address this you can force the BSSID as well as
>> the SSID but if you just want to specify the SSID you can
>> use the ibss_merge knob to force an IBSS merge by focing the
>> BSSID to be based on the passed SSID.
>>
>> Cc: Jouni Malinen <jouni@qca.qualcomm.com>
>> Cc: Ivan Seskar <seskar@winlab.rutgers.edu>
>> Cc: Johannes Berg <johannes@sipsolutions.net>
>> Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
>> ---
>>
>> Ivan, I think this is what you were looking for but an alternative to this
>> problem is to specify the BSSID every time you want to create your own large
>> IBSS network, this would mean that its a requirement and also means we
>> acknowledge a limitation by IEEE's adhoc definition. Is there any reason
>> forcing a BSSID on the experimenter is not an equally good solution?
>
> Even setting "fixed-bssid" is acknowledging that already, but I really
> see no reason for this to live in the kernel.

Agreed, I was just hoping Ivan can test that does indeed fix that
issue and we can throw this out as one of those "bogus" features
MadWifi had for researchers.

  Luis
