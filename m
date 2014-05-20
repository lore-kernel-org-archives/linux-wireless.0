Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:37890 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbaETGp7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2014 02:45:59 -0400
Received: by mail-lb0-f173.google.com with SMTP id 10so23848lbg.4
        for <linux-wireless@vger.kernel.org>; Mon, 19 May 2014 23:45:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CB3B3D4774441E42AA3EA0E1BA8230A0333EC082@HASMSX106.ger.corp.intel.com>
References: <1398234178-24685-1-git-send-email-ilan.peer@intel.com>
 <1398437216.4152.7.camel@jlt4.sipsolutions.net> <CB3B3D4774441E42AA3EA0E1BA8230A0333EC082@HASMSX106.ger.corp.intel.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Mon, 19 May 2014 23:45:37 -0700
Message-ID: <CAB=NE6VMhMLbQOjQtaE=dBzfVMuLAfS2bH8VBVw77Njkk=zLqg@mail.gmail.com> (sfid-20140520_084603_593928_6F2AB3BD)
Subject: Re: [PATCH] cfg80211: Fix GO Concurrent relaxation on UNII-3
To: "Peer, Ilan" <ilan.peer@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Apr 27, 2014 at 2:33 AM, Peer, Ilan <ilan.peer@intel.com> wrote:
>> On Wed, 2014-04-23 at 09:22 +0300, Ilan Peer wrote:
>> > At some locations, channels 149-165 are considered a single bundle,
>> > while at some other locations, e.g., Indonesia, channels
>> > 149-161 are considered a single bundle, while channel 165 belongs to a
>> > different bundle. This means that:
>> >
>> > 1. A station interface connection to an AP on channel 165 allows
>> >    the instantiation of a P2P GO on channels 149-165.
>> > 2. A station interface connection to an AP on channels 149-161
>> >    does NOT allow the instantiation of a P2P GO on channel 165.
>> >
>> > Fix this.
>>
>> I'll apply this, but I'm not a big fan of it. Please work with Luis to get some
>> information into the regulatory database.
>>
>
> Sure. Luis, how would like me to address this?

Generally we move things that are not universal as flags, or value
attributes, the difficulty here lies in that we'd get different sets
of groups that allow flexibility to lift restrictions. A flag would
still work in the case of UNII 3 and would enable this permissive rule
to be usable on other bands as well. It would also then make the
restriction to Indonesia specific to that region. As far as I can tell
P2P does mandate country IE to be set so this would make relying on
the country IE to be available on clients associating, the flag could
also be cleared upon disconnect as we clear all permissive flags as we
do not after a disconnect /  suspend / resume / reboot.

Let me know what you think.

  Luis
