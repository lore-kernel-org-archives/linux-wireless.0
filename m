Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f11.google.com ([209.85.217.11]:55823 "EHLO
	mail-gx0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838AbYKSNCO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2008 08:02:14 -0500
Received: by gxk4 with SMTP id 4so2379682gxk.13
        for <linux-wireless@vger.kernel.org>; Wed, 19 Nov 2008 05:02:13 -0800 (PST)
Message-ID: <1ba2fa240811190502j274595e6lf02b957ae047b4c4@mail.gmail.com> (sfid-20081119_140218_833848_BAD901DB)
Date: Wed, 19 Nov 2008 15:02:12 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH/RFT] iwlagn: fix RX skb alignment
Cc: "John Linville" <linville@tuxdriver.com>,
	"reinette chatre" <reinette.chatre@intel.com>,
	"Marcel Holtmann" <marcel@holtmann.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	"Matt Mackall" <mpm@selenic.com>,
	"Christophe Dumez" <dchris@gmail.com>, "Zhu Yi" <yi.zhu@intel.com>,
	"=?UTF-8?Q?Jan_V=C4=8Del=C3=A1k?=" <vcelak.jan@seznam.cz>,
	"Thomas Witt" <witt_th@gmx.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Andres Freund" <andres@anarazel.de>
In-Reply-To: <1227097994.26243.33.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1226969241.4014.24.camel@johannes.berg>
	 <1227001390.4014.43.camel@johannes.berg>
	 <1ba2fa240811180613g48c94199s67e4334e89282e76@mail.gmail.com>
	 <1227021904.4014.58.camel@johannes.berg>
	 <1ba2fa240811190115i6bad0c89wb1d9c8ee281be2f8@mail.gmail.com>
	 <1227094594.26243.6.camel@johannes.berg>
	 <1ba2fa240811190422o4eebb26ai17ea12825ae8e708@mail.gmail.com>
	 <1227097994.26243.33.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 19, 2008 at 2:33 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2008-11-19 at 14:22 +0200, Tomas Winkler wrote:
>
>> > Yeah, it's weird, and it doesn't even seem to solve it for everyone. So
>> > there must be another thing too.
>>
>> It seems that your wrong command queue problem is no the same root
>> cause  we see on x86 platforms they have just same phenomena, because
>> there is 0xff data on the RX buffer.
>
> Well we've seen at one report that it helps, on x86. And the alignment
> thing is definitely a bug, so fixing it had to help somewhere.

No doubt that it has to be fixed,

But yes,
> it looks like there's a different bug leading to the same symptoms
> elsewhere...

Yes we are tracking it


> Here's a thought: iwl_rx_queue_update_write_ptr doesn't synchronise the
> pointer rxq->bd memory to the device. So if you have a platform that's
> not cache coherent for IO devices (mine is) that might be a problem.

Need to issue wmb() there or something like this?

> johannes
>
