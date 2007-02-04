Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:48053
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505AbXBDTHm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Feb 2007 14:07:42 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Jon Smirl" <jonsmirl@gmail.com>
Subject: Re: SoftMAC vs FullMAC
Date: Sun, 4 Feb 2007 20:07:29 +0100
Cc: "Pavel Roskin" <proski@gnu.org>, linux-wireless@vger.kernel.org
References: <9e4733910702040922n63736d27h7ab027dc90ae8989@mail.gmail.com> <20070204123048.4bhesocg4kosgscg@webmail.spamcop.net> <9e4733910702041031i5edd6dfeq7f8c5179fee5e00e@mail.gmail.com>
In-Reply-To: <9e4733910702041031i5edd6dfeq7f8c5179fee5e00e@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <200702042007.29357.mb@bu3sch.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 04 February 2007 19:31, Jon Smirl wrote:
> On 2/4/07, Pavel Roskin <proski@gnu.org> wrote:
> > In fact, Atheros chips are not that intelligent to be treated as FullMAC, but
> > going to d80211 removes many chip specific features.
> 
> What types of features are removed? For example Atheros turbo mode can
> be treated like another PHY layer implementation.
> 
> If it is just off-loading the implementation of standard behavior then
> we may actually be better off ignoring this capability and
> implementing the standard behavior in the host.
> 
> It's not even clear to me that doing encryption is a wireless
> co-processor is a win. It is almost certain that the host can perform
> the same algorithms many times faster that an embedded wireless
> processor.  Moving encryption onto the host reduces the latency of the
> connection.

If creating and uploading the keys to the device is less work than
doing crypto in software, then it is clearly a win.
And that _is_ the case for bcm43xx (at least. I don't know about other
devices' hwcrypto capabilities).
Doing less on the CPU and more in hw is always a win. I'm not sure
how you can say that you're not sure it is. ;)

Additionally, doing crypto in the RX path (tasklet context) is
not really optimal, from a latency point of view.

But you can test it yourself. Enable/disable hwcrypto and watch how
CPU load in "top" reacts.

I did a quick test on my powerbook and software interrupt load
decreases from about 30% to about 10% when switching from swcrypto
to hwcrypto. I'd call that a significant win. And this 20% decrease
is just the RX path. TX is done in process context (I think).

-- 
Greetings Michael.
