Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:48471 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935065Ab3DII0q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Apr 2013 04:26:46 -0400
Received: by mail-la0-f44.google.com with SMTP id fr10so3104468lab.31
        for <linux-wireless@vger.kernel.org>; Tue, 09 Apr 2013 01:26:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1365490278.8465.1.camel@jlt4.sipsolutions.net>
References: <1365486778-2336-1-git-send-email-mcgrof@do-not-panic.com>
 <1365486778-2336-3-git-send-email-mcgrof@do-not-panic.com> <1365490278.8465.1.camel@jlt4.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 9 Apr 2013 01:26:23 -0700
Message-ID: <CAB=NE6XjS7647FADXs7g9P4GmZPpdZmH1A9tNyY9u1_6QHX9og@mail.gmail.com> (sfid-20130409_102653_207221_B7EF4923)
Subject: Re: [wireless-regdb] [PATCH 2/3] wireless-regdb: enable VHT80 when
 world roaming
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>, kandala@qca.qualcomm.com,
	linux-wireless <linux-wireless@vger.kernel.org>,
	qca_vkondrat <qca_vkondrat@qca.qualcomm.com>,
	Michael Green <green@qca.qualcomm.com>,
	yunsenw@qca.qualcomm.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 8, 2013 at 11:51 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2013-04-08 at 22:52 -0700, Luis R. Rodriguez wrote:
>> From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
>>
>> For VHT, the wider bandwidths (up to 160 MHz) need
>> to be allowed. Since world roaming only covers the
>> case of connecting to an AP, it can be opened up
>> there, we will rely on the AP to know the local
>> regulations.
>>
>> Based on a patch by Johannes Berg for upstream Linux.
>
>> --- a/db.txt
>> +++ b/db.txt
>> @@ -6,10 +6,10 @@ country 00:
>>       # Channel 14. Only JP enables this and for 802.11b only
>>       (2474 - 2494 @ 20), (3, 20), PASSIVE-SCAN, NO-IBSS, NO-OFDM
>>       # Channel 36 - 48
>> -     (5170 - 5250 @ 40), (3, 20), PASSIVE-SCAN, NO-IBSS
>> +     (5170 - 5250 @ 80), (3, 20), PASSIVE-SCAN, NO-IBSS
>>       # NB: 5260 MHz - 5700 MHz requies DFS
>>       # Channel 149 - 165
>> -     (5735 - 5835 @ 40), (3, 20), PASSIVE-SCAN, NO-IBSS
>> +     (5735 - 5835 @ 80), (3, 20), PASSIVE-SCAN, NO-IBSS
>
> I also have a separate upstream patch that I haven't sent here yet to
> enable 160 MHz by enabling the radar channels (passively), see below;
> any thoughts on that?

Enabling it passively seems fine to me. Michael if we take care of DFS
/ passive scan, etc, are we still OK to use VHT160 if we find an AP
that uses it on the DFS channels (assuming client follows channel
change announcements, etc)?

  Luis
