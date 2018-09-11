Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:48138 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727645AbeILCDS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Sep 2018 22:03:18 -0400
Message-ID: <1536699720.3224.152.camel@sipsolutions.net> (sfid-20180911_230314_083418_24732640)
Subject: Re: 4.19-rc[23] iwlwifi: BUG in swiotlb
From: Johannes Berg <johannes@sipsolutions.net>
To: Randy Dunlap <rdunlap@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linuxwifi@intel.com
Date: Tue, 11 Sep 2018 23:02:00 +0200
In-Reply-To: <8bea4cfc-4b16-7c7c-3e9a-5b6684b47345@infradead.org>
References: <0c5e53e5-2afa-8d38-0b48-272c670c4bc5@infradead.org>
         <1536651177.3224.106.camel@sipsolutions.net>
         <8bea4cfc-4b16-7c7c-3e9a-5b6684b47345@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-09-11 at 13:57 -0700, Randy Dunlap wrote:

> I can't be sure.  I've been having problems booting this laptop for a few
> weeks now but haven't tracked it down yet.

Ok.

> The wireless NIC is Condor Peak:
> 
> 04:00.0 Network controller: Intel Corporation Centrino Wireless-N 1000 [Condor Peak]

Wow, that's old. I should have one somewhere, but we haven't worked on
this NIC in many years. We've touched the driver, of course, but the
configuration for this wouldn't have changed.

> sigh.  I can reproduce it without the patch:
> 
> > https://p.sipsolutions.net/aa0dccd7a60fe176.txt
> 
> but with that patch, it just hangs after about 25 seconds of booting
> (slow hard drive, not SSD).
> 
> I'll try some other ways.

Hmm. That makes me think you have some corruption going on, rather than
something really being set to 0, because otherwise you should've seen
the warning at least?

johannes
