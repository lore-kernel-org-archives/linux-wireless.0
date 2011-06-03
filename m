Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37546 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823Ab1FCVgG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2011 17:36:06 -0400
Received: by iwn34 with SMTP id 34so1711112iwn.19
        for <linux-wireless@vger.kernel.org>; Fri, 03 Jun 2011 14:36:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1307133509.3800.10.camel@jlt3.sipsolutions.net>
References: <1307051170-17374-1-git-send-email-lauro.venancio@openbossa.org>
 <1307051170-17374-3-git-send-email-lauro.venancio@openbossa.org>
 <1307108661.3800.6.camel@jlt3.sipsolutions.net> <BANLkTikS+cssYccjg_SfOhR15N=M9erw6Q@mail.gmail.com>
 <1307133509.3800.10.camel@jlt3.sipsolutions.net>
From: Aloisio Almeida <aloisio.almeida@openbossa.org>
Date: Fri, 3 Jun 2011 18:35:45 -0300
Message-ID: <BANLkTim_d839pWW4DPeH+6o03wN8HbgBxQ@mail.gmail.com> (sfid-20110603_233609_953251_5761CA50)
Subject: Re: [PATCH 2/6] NFC: add nfc generic netlink interface
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, marcio.macedo@openbossa.org,
	sameo@linux.intel.com, Waldemar.Rymarkiewicz@tieto.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 3, 2011 at 5:38 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2011-06-03 at 17:18 -0300, Lauro Ramos Venancio wrote:
>> We don't need a generation counter here because we have the events
>> NFC_EVENT_DEVICE_ADDED and NFC_EVENT_DEVICE_REMOVED. So, it is
>> possible to keep the device list consistency listening for these
>> events.
>
> That may be true, but it complicates coding in userspace. Much easier to
> check a generation counter (in both cases) to see if data is consistent
> than to listen to multiple events concurrently with receiving a dump.

The userspace must listen to these events anyway. In addition, the
application needs to get the list of devices only once (on its
initialization).

In the target list case, the userspace application would have to
orderly call start_poll before receive the dump in order to create the
"invalid list" situation.

I understand the benefits of the generation counters, but IMO they are
'too much' in these cases.

Aloisio
