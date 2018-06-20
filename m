Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:37322 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932960AbeFTIpR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Jun 2018 04:45:17 -0400
Message-ID: <1529481305.3130.3.camel@sipsolutions.net> (sfid-20180620_104525_089072_64E1EAB8)
Subject: Re: [PATCH] mac80211: Fix oops in ieee80211_tx_control_port
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Denis Kenzior <denkenz@gmail.com>,
        linux-wireless@vger.kernel.org
Date: Wed, 20 Jun 2018 09:55:05 +0200
In-Reply-To: <5B2A0843.9080902@broadcom.com> (sfid-20180620_095446_031821_FD96522E)
References: <20180619153950.28903-1-denkenz@gmail.com>
         <5B2A0772.4060200@broadcom.com> <1529481182.3130.2.camel@sipsolutions.net>
         <5B2A0843.9080902@broadcom.com> (sfid-20180620_095446_031821_FD96522E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-06-20 at 09:54 +0200, Arend van Spriel wrote:
> On 6/20/2018 9:53 AM, Johannes Berg wrote:
> > On Wed, 2018-06-20 at 09:51 +0200, Arend van Spriel wrote:
> > > On 6/19/2018 5:39 PM, Denis Kenzior wrote:
> > > > On pre-emption enabled kernels the following oops was being seen due
> > > > to missing local_bh_disable/local_bh_enable calls.  mac80211 assumes
> > > > that pre-emption is disabled in the data path.
> > > 
> > > No sure if "assumes" is the right term here. It seems like it is
> > > required and there is probably a good reason for that. Would be nice to
> > > know what that reason is.
> > 
> > It's using per-CPU data.
> 
> Hence the smp_processor_id() call which Denis mentioned in the bug report?

Yeah, I think that's an implementation detail thereof.

johannes
