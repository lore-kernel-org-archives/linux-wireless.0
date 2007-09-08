Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.180]:1785 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbXIHElE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Sep 2007 00:41:04 -0400
Received: by wa-out-1112.google.com with SMTP id v27so769492wah
        for <linux-wireless@vger.kernel.org>; Fri, 07 Sep 2007 21:41:04 -0700 (PDT)
Message-ID: <6b8cef970709072140o23cfd152nee56313db53739ae@mail.gmail.com>
Date: Sat, 8 Sep 2007 00:40:58 -0400
From: "Rob Hussey" <robjhussey@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: Kernel panic with rt2500pci built-in
Cc: linux-wireless@vger.kernel.org, "Ivo van Doorn" <ivdoorn@gmail.com>
In-Reply-To: <6b8cef970709072129r5d7658b8v46e5b327638b8f06@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <6b8cef970709052006q43d5602ewde0cea45500deede@mail.gmail.com>
	 <6b8cef970709052025w4885b075yc9cf79c9f7f6dd52@mail.gmail.com>
	 <1189125944.28781.125.camel@johannes.berg>
	 <6b8cef970709071231s5693b835vaf8493254c8292da@mail.gmail.com>
	 <1189193840.28781.197.camel@johannes.berg>
	 <6b8cef970709071438o6870cecej355119fee4396dcb@mail.gmail.com>
	 <1189202441.28781.208.camel@johannes.berg>
	 <6b8cef970709072129r5d7658b8v46e5b327638b8f06@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/8/07, Rob Hussey <robjhussey@gmail.com> wrote:
> Not sure if it's any help, but I've attached dmesg output with rt2x00
> built as modules. DEBUG_KOBJECT is still enabled, so maybe there's
> some sorta clue in there. BTW, if I do:
> grep -c "parent: <NULL>" dmesg.txt
> I get: 32
> Is that normal?
>

You don't have to answer that. Going through the dmesg it seems a lot
of devices rightfully have null for parent. The relevant line seems to
be:
[   28.348658] kobject phy0: registering. parent: ieee80211, set: devices

Strange that it correctly registers as a module but not built-in.
