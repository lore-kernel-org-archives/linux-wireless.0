Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:46545 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab1AZGBG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jan 2011 01:01:06 -0500
Received: by gwj20 with SMTP id 20so9931gwj.19
        for <linux-wireless@vger.kernel.org>; Tue, 25 Jan 2011 22:01:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1295950325.3650.5.camel@jlt3.sipsolutions.net>
References: <1295816579-28925-1-git-send-email-arik@wizery.com>
 <1295816579-28925-3-git-send-email-arik@wizery.com> <1295868924.3639.2.camel@jlt3.sipsolutions.net>
 <AANLkTinJo7EV7zr=Z6oN3M2X3=gcv1W8G7cpbHPPNs=0@mail.gmail.com> <1295950325.3650.5.camel@jlt3.sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 26 Jan 2011 08:00:50 +0200
Message-ID: <AANLkTin49svPAzuhH-ENdzoa4FnTRyOeizKrTLNYLOeu@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] nl80211: Pass probe response data to drivers
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 25, 2011 at 12:12, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2011-01-24 at 22:47 +0200, Arik Nemtsov wrote:
>> On Mon, Jan 24, 2011 at 13:35, Johannes Berg <johannes@sipsolutions.net> wrote:
>> > On Sun, 2011-01-23 at 23:02 +0200, Arik Nemtsov wrote:
>> >> Allow usermode to pass probe-response data. This data can be used as a
>> >> template probe-response offloading.
>> >
>> > Why use a separate command for this, and not do it like the SSID? I also
>>
>> Its only relevant to AP-mode (at least for now) so bss_conf didn't
>> seem appropriate.
>> Also since its a dynamically allocated buffer it should be protected by RCU.
>
> But all that is unrelated to the nl80211 API, no? Also the SSID already
> uses bss_conf too, and it's AP mode too...

Do you have a preferred alternative?

>
>> About compatibility - good point there. Currently the probe response
>> template is set according to the beacon for compatibility. As for SSID
>> - with the current wl12xx we'll set an empty SSID when a
>> non-supporting hostapd is encountered. I'll fix that (in a v3). Other
>> than that, we should be able to operate with either one configured.
>
> Does that mean if you set an empty SSID it won't reply but pass them up?
> Then you could implement the behaviour I just asked for ...

Well no. The FW never passes up beacons. You've helped uncover a bug
where a non-supporting hostapd doesn't set the SSID and consequently
we'll have an empty SSID configured to FW.
In this case we should fallback to use the SSID extracted from the beacon.

Arik
