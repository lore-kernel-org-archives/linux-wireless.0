Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx76.mail.ru ([94.100.176.91]:54950 "EHLO mx76.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752385AbZIPKFu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2009 06:05:50 -0400
Date: Wed, 16 Sep 2009 14:12:45 +0300
From: Nikolai ZHUBR <zhubr@mail.ru>
Message-ID: <186931799.20090916141245@mail.ru>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless@vger.kernel.org,
	Gaurav Jauhar <gaurav.jauhar@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: Re[6]: cfg80211 and rfkill_backport question.
In-reply-To: <43e72e890909151817u375cd847r7cdf78b53f26fe2f@mail.gmail.com>
References: <174470396.20090916030952@mail.ru>
 <43e72e890909151614l9820e2y7031e09de11653@mail.gmail.com>
 <792649359.20090916034611@mail.ru>
 <43e72e890909151649x66321b6emdc2977473e22872a@mail.gmail.com>
 <90263558.20090916050213@mail.ru>
 <43e72e890909151817u375cd847r7cdf78b53f26fe2f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Luis,

I've solved (kind of) symbol issues by simply commenting out
the CONFIG_RFKILL_BACKPORT=m (because I don't actually need
the rfkill thing yet). Finally mac80211 loads fine.

Now I'm getting an error when loading the RT61 driver:

PCI: Unable to reserve mem region #1:8000@40000000 for device 0000:00:02.0
rt2x00pci -> rt2x00pci_probe: Error - PCI request regions failed.
rt61pci: probe of 0000:00:02.0 failed with error -16
Any hints?


Wednesday, September 16, 2009, 4:17:40 AM, Luis R. Rodriguez wrote:
> On Tue, Sep 15, 2009 at 7:02 PM, Nikolai ZHUBR <zhubr@mail.ru> wrote:
>> Wednesday, September 16, 2009, 2:49:04 AM, Luis R. Rodriguez wrote:
>>> Check if the symbols you had issues with were indeed exported via
>>> EXPORT_SYMBOL() on the compat code (compat/*.c) or if whether they
>>> were defined via a header as an inline (compat/*.h).
>> As far as I can see, the symbols in question are not defined as inline:

> They don't have to be exported and inlined, its one or the other. So
> just ensure you your symbols you have conflicts with as
> EXPORT_SYMBOL() or defined in a header file as inline. You will
> obviously also need the header declaration if defined as an
> EXPORT_SYMBOL.

>   Luis


