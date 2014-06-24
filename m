Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:50873 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382AbaFXAuf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jun 2014 20:50:35 -0400
Received: by mail-pb0-f50.google.com with SMTP id rp16so6511864pbb.37
        for <linux-wireless@vger.kernel.org>; Mon, 23 Jun 2014 17:50:35 -0700 (PDT)
Date: Mon, 23 Jun 2014 17:50:30 -0700
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: Victor <silentworks@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: No channels available (no IR) in 5Ghz band for intel 7260-ac
Message-ID: <20140624005030.GI1390@garbanzo.do-not-panic.com> (sfid-20140624_025041_663530_150DAFC1)
References: <CAAnNoB_8MSR3S+VmFJUKKU4bO5zfeu1N_4-vQULqBf1_UbAqkg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAAnNoB_8MSR3S+VmFJUKKU4bO5zfeu1N_4-vQULqBf1_UbAqkg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 23, 2014 at 10:55:48PM +0200, Victor wrote:
> Hello, first of all i'm not sure if this is the proper place to ask
> since it seems mostly dev-related, but i have been looking everywhere
> trying to find a solution without luck, so i'm not sure if i
> encountered some kind of bug.
> 
> Context: Setup of wireless AP using an intel 7260-ac on 5Ghz+ band, linux 3.15.1
> 
> Problem found: the system shows all channels for Ghz band as (no IR),
> so they can't be used

NO-IR means you can't initiate radiation, it doesn't mean they are
disabled. The NO-IR flag then means you cannot use modes of operation
that require you to initiate radiation first, there are two ways that
can happen:

  * beconing -- AP, IBSS, Mesh, P2P master mode
  * active scanning

You are still able to do passive scanning. The NO-IR flag can be
lifted from channels if the driver does like the idea of trusting
beacon hints:

http://wireless.kernel.org/en/developers/Regulatory/processing_rules#Beacon_hints

If the driver does not like those then you won't get the NO-IR flag
lifted when a beacon is found. There device follows the desire by
the silicon manufacturer and whoever deploys the device and integrates
it into your system so anything beyond this should be checked with
Intel folks.

  Luis
