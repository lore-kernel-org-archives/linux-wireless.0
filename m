Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f52.google.com ([209.85.160.52]:34435 "EHLO
        mail-pl0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730326AbeHNBZB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Aug 2018 21:25:01 -0400
Received: by mail-pl0-f52.google.com with SMTP id f6-v6so7492174plo.1
        for <linux-wireless@vger.kernel.org>; Mon, 13 Aug 2018 15:40:45 -0700 (PDT)
Date: Mon, 13 Aug 2018 15:40:41 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Tomasz Kalbarczyk <tkalbar@utexas.edu>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Promiscuous (not monitor) Mode support for ath10k
Message-ID: <20180813224041.GA165278@ban.mtv.corp.google.com> (sfid-20180814_004104_229692_F89BDEA1)
References: <CAH9jq_Ow7Gt-m1QZoS3-JOEdU1CkC33S2mCfYz4bHNOMDX+q9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAH9jq_Ow7Gt-m1QZoS3-JOEdU1CkC33S2mCfYz4bHNOMDX+q9A@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 06, 2018 at 06:08:46PM -0400, Tomasz Kalbarczyk wrote:
> Hello,

Hi!

> I have a QCA6174 and I'm running tcpdump on the wireless interface to
> listen for packets. I can receive packets addressed directly to the
> device, but not any other packets on the network.
> 
> Does anyone know the status of promiscuous mode support on ath10k?
> Note that this is different from monitor mode / supported on a larger
> subset of hardware. Dmesg merely indicates that the device has
> "entered promiscuous mode" when tcpdump is initiated.
> 
> Here is a link to similar discussion regarding the ath9k a few years
> back: https://marc.info/?l=linux-wireless&m=135936563626791&w=2

This might be relevant:

commit df1404650ccbfeb76a84f301f22316be0d00a864
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Wed Apr 22 14:40:58 2015 +0200

    mac80211: remove support for IFF_PROMISC

    This support is essentially useless as typically networks are encrypted,
    frames will be filtered by hardware, and rate scaling will be done with
    the intended recipient in mind. For real monitoring of the network, the
    monitor mode support should be used instead.

    Removing it removes a lot of corner cases.

Regards,
Brian
