Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55947 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754754Ab2E3N7i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 May 2012 09:59:38 -0400
Received: by obbtb18 with SMTP id tb18so8436538obb.19
        for <linux-wireless@vger.kernel.org>; Wed, 30 May 2012 06:57:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1338385800.4511.21.camel@jlt3.sipsolutions.net>
References: <1338383762.4511.16.camel@jlt3.sipsolutions.net>
	<CAB3XZEdmWRn-2O65AnfnF-jya_FNXK8gc21EBBoDisNoZGDeRQ@mail.gmail.com>
	<1338385800.4511.21.camel@jlt3.sipsolutions.net>
Date: Wed, 30 May 2012 16:57:56 +0300
Message-ID: <CAB3XZEdHgjgN=0kUXngzFaEY0Q=pz8k0UaRFXLMEhjPsLdN8NQ@mail.gmail.com> (sfid-20120530_163650_049681_AA44DECF)
Subject: Re: [PATCH 3.5] mac80211: flush off-channel work when interface goes down
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Nirav Shah <nirav.j2.shah@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 30, 2012 at 4:50 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2012-05-30 at 16:44 +0300, Eliad Peller wrote:
>> On Wed, May 30, 2012 at 4:16 PM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > When any interface goes down, it could be the one that
>> > we were doing off-channel with. Thus, we need to flush
>> > the offchannel start/stop work so they can't run when
>> > the interface has already been removed from the driver
>> > or even been destroyed. It's OK to flush them even if
>> > they were for another interface, that just means that
>> > we potentially delay the interface down a little bit.
>> >
>> can't we check hw_roc_dev?
>
> We could, but it didn't seem worthwhile. Think I should do that instead?
>
hmm... i guess it doesn't really matter :)

Eliad.
