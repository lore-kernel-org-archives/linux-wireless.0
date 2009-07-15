Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f192.google.com ([209.85.221.192]:51008 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755517AbZGOP43 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jul 2009 11:56:29 -0400
MIME-Version: 1.0
In-Reply-To: <43e72e890907150851m69cd2de6lfb71596fbfac30e6@mail.gmail.com>
References: <43e72e890907141511h70a0a987g57cb26e23e5824a9@mail.gmail.com>
	<20090714235332.GA1552@ucw.cz> <43e72e890907150851m69cd2de6lfb71596fbfac30e6@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 15 Jul 2009 08:56:08 -0700
Message-ID: <43e72e890907150856x50735aafv8e3209f16ded7e37@mail.gmail.com>
Subject: Re: Generic events for wake up from S1-S4
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Stephen Chen <Stephen.Chen@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 15, 2009 at 8:51 AM, Luis R. Rodriguez<mcgrof@gmail.com> wrote:
> On Tue, Jul 14, 2009 at 4:53 PM, Pavel Machek<pavel@ucw.cz> wrote:

>> I thought that wifi stack is in software -> you need
>> main cpu to run for wifi to work?
>
> Yes, but we are not processing 802.11 frames for data processing and
> sending them up to any higher layer, we're just doing raw hardware
> pattern matching and event triggering. This of course also means
> devices which do not a CPU or a CPU but no special WoW firmware that
> you won't be able to use WPA for group key stuff for example for which
> I do believe we do need the box's CPU. Which reminds me, maybe we
> should not allow WoW for that case for now.

I should clarify a little more here. It is true you need the main CPU
for wifi to "work", but you don't need it to have the wireless
device's radio turned on, or other logical components of the hardware
sending a PCI PME, for example. All you need for that is some juice.
"Work" in the usual sense would mean to process your raw 802.11
frames, and send them up the stack. That's the part we leave off to
the CPU/driver.

  Luis
