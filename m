Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40186 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754794Ab1EZLSQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 May 2011 07:18:16 -0400
Date: Thu, 26 May 2011 13:17:53 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: wwguy <wey-yi.w.guy@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] iwlagn: use cts-to-self protection on 5000 adapters
 series
Message-ID: <20110526111752.GA20099@redhat.com> (sfid-20110526_131819_698473_05698666)
References: <20110525122731.GA2546@redhat.com>
 <1306332806.17516.7.camel@wwguy-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1306332806.17516.7.camel@wwguy-ubuntu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 25, 2011 at 07:13:26AM -0700, wwguy wrote:
> On Wed, 2011-05-25 at 05:33 -0700, Stanislaw Gruszka wrote:
> > after some time, performance downgrade to unpached driver level, like
>                                          unpatched?

> > However patch still make better here, since similar test on unpached
>                                                           unpatched?

I'll fix that.

> > +	/*
> > +	 * force CTS-to-self frames protection if RTS-CTS is not preferred
> > +	 * one aggregation protection method
>              on?

The sentence is not the best English, but replacing "one" to "on" will
not help, I think.

> if I remember correctly, the RTS/CTS was added to fix 6000 performance
> issue 2 years ago. Did you see the similar performance downgrade issue
> on other devices beside 5000?

No, I think only 5000 ware afected (also with random connection hangs).
Patching and using cts-to-self on 6000, give slightly better performance
here with 6300 adapter:

vanilla 6300 5Ghz: 8.13 8.03 8.13 8.03 8.19 avr 8.1020 std 0.070143
patched 6300 5Ghz: 8.60 8.59 8.60 8.41 8.57 avr 8.5540 std 0.081425

vanilla 6300 2GHz: 4.06 4.39 4.60 4.70 4.80 avr 4.5100 std 0.293770
patched 6300 2GHz: 4.94 4.90 4.94 5.05 4.88 avr 4.9420 std 0.065727

I plan to do more testing, but not yet (except 5000 adapters I have
quite good performance).

Stanislaw
