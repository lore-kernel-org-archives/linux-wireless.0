Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:44050 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbaBVVKj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Feb 2014 16:10:39 -0500
Received: by mail-la0-f48.google.com with SMTP id gf5so806540lab.35
        for <linux-wireless@vger.kernel.org>; Sat, 22 Feb 2014 13:10:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CB3B3D4774441E42AA3EA0E1BA8230A033385D1C@HASMSX106.ger.corp.intel.com>
References: <1392896671-4288-1-git-send-email-ilan.peer@intel.com>
 <1392896671-4288-5-git-send-email-ilan.peer@intel.com> <CAB=NE6X4YbNcOonHqPiR7L_ZcQgVz2a=Y3KLA9aogJN0p3fiKw@mail.gmail.com>
 <CB3B3D4774441E42AA3EA0E1BA8230A033385D1C@HASMSX106.ger.corp.intel.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Sat, 22 Feb 2014 13:10:18 -0800
Message-ID: <CAB=NE6UJ2G-S4fgFeXWvwCByin25wBGpkNkTmY-nKHXQG+uK-A@mail.gmail.com> (sfid-20140222_221042_135597_C80968A4)
Subject: Re: [PATCH 4/5] cfg80211: Add an option to hint indoor operation
To: "Peer, Ilan" <ilan.peer@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Feb 22, 2014 at 12:00 PM, Peer, Ilan <ilan.peer@intel.com> wrote:
>> -----Original Message-----
>> From: mcgrof@gmail.com [mailto:mcgrof@gmail.com] On Behalf Of Luis R.
>> Rodriguez
>> Sent: Saturday, February 22, 2014 02:28
>> To: Peer, Ilan
>> Cc: linux-wireless
>> Subject: Re: [PATCH 4/5] cfg80211: Add an option to hint indoor operation
>>
>> On Thu, Feb 20, 2014 at 3:44 AM, Ilan Peer <ilan.peer@intel.com> wrote:
>> > + * Note: currently not protected by any synchronization primitive.
>>
>> You should verify this is protected by RTNL as the other stuff.
>>
>
> It is protect in all cases by RTNL ... I just did not think that it is needed. Do you a problematic scenario that requires RTNL?

It will depend on where the hints are consumed and readers, and also
resets of regulatory, so yes, its needed, just extend the
documentation as with the others to indicate its under RTNL.

  Luis
