Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:50034 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647Ab1AZVvp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jan 2011 16:51:45 -0500
Received: by qwa26 with SMTP id 26so1425710qwa.19
        for <linux-wireless@vger.kernel.org>; Wed, 26 Jan 2011 13:51:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1296030720.3635.14.camel@jlt3.sipsolutions.net>
References: <1295816579-28925-1-git-send-email-arik@wizery.com>
 <1295816579-28925-3-git-send-email-arik@wizery.com> <1295868924.3639.2.camel@jlt3.sipsolutions.net>
 <AANLkTinJo7EV7zr=Z6oN3M2X3=gcv1W8G7cpbHPPNs=0@mail.gmail.com>
 <1295950325.3650.5.camel@jlt3.sipsolutions.net> <AANLkTin49svPAzuhH-ENdzoa4FnTRyOeizKrTLNYLOeu@mail.gmail.com>
 <1296030720.3635.14.camel@jlt3.sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 26 Jan 2011 23:51:29 +0200
Message-ID: <AANLkTimTASMMUhofp=1o=Z6-dY7v8T8uoNLbqYK4TStv@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] nl80211: Pass probe response data to drivers
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 26, 2011 at 10:32, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2011-01-26 at 08:00 +0200, Arik Nemtsov wrote:
>
>> >> > Why use a separate command for this, and not do it like the SSID? I also
>> >>
>> >> Its only relevant to AP-mode (at least for now) so bss_conf didn't
>> >> seem appropriate.
>> >> Also since its a dynamically allocated buffer it should be protected by RCU.
>> >
>> > But all that is unrelated to the nl80211 API, no? Also the SSID already
>> > uses bss_conf too, and it's AP mode too...
>>
>> Do you have a preferred alternative?
>
> What's wrong with putting it in the same place as the SSID?

Just put it as a pointer inside ieee80211_bss_conf? (It will still
have to be RCU managed and all).
About nl80211 API - I tried making it as similar as possible to the
way the beacon works, but I guess I can pass it with bss_parameters as
well.

Arik
