Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:33397 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab3JGHdN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Oct 2013 03:33:13 -0400
Message-ID: <525263B7.5090609@linutronix.de> (sfid-20131007_093318_040636_0EAF6704)
Date: Mon, 07 Oct 2013 09:33:11 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
MIME-Version: 1.0
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
CC: Thomas Meyer <thomas@m3y3r.de>,
	"linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
	"Berg, Johannes" <johannes.berg@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [Ilw] Re: Kernel panic in 3.10.10-rt7 (iwlwifi)
References: <2CD18B42-2489-4DF7-98D6-4D002329DC63@m3y3r.de> <20131004101216.GA17043@linutronix.de> <0BA3FCBA62E2DC44AF3030971E174FB301DBC098@HASMSX103.ger.corp.intel.com>
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB301DBC098@HASMSX103.ger.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/06/2013 08:00 AM, Grumbach, Emmanuel wrote:
> 
> We have a patch internally that goes into that direction, but one thing though.

Sounds great.

> If you still have a spinlock in the primary handler, wouldn't that sleep in a non-sleepable context? Forgive my -rt ignorance, but I understood that in -rt, all the spinlock go to sleep which basically mean that we can't take any spinlock in the primary irq handler so I am a bit confused here.

After my change there is no primary handler anymore, just the threaded
where you can take the (sleeping) spinlock.
Everything what you wrote is correct:
- you can't take a spinlock in the primary handler
- all spinlocks may sleep

Sebastian
