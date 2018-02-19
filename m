Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:59658 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752006AbeBSJ0u (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Feb 2018 04:26:50 -0500
Message-ID: <1519032404.7832.84.camel@coelho.fi> (sfid-20180219_102653_668256_E1EC3C0F)
From: Luca Coelho <luca@coelho.fi>
To: Kalle Valo <kvalo@codeaurora.org>,
        Steve deRosier <derosier@gmail.com>
Cc: Samuel Sieb <samuel@sieb.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 19 Feb 2018 11:26:44 +0200
In-Reply-To: <87h8qdldfq.fsf@purkki.adurom.net>
References: <HE1PR0501MB23969FCE58F1EE7634D412F0F6F50@HE1PR0501MB2396.eurprd05.prod.outlook.com>
         <1518607856.21268.3.camel@sipsolutions.net>
         <4f048d04-5f25-caa1-51b3-dcb14baf36da@sieb.net>
         <CALLGbRLL-tnptVDuFt5E3QoTZ8Wn4K=2wLp3TCNvDJemkGVyKg@mail.gmail.com>
         <87h8qdldfq.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: Max clients on wifi access point with 7265
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2018-02-19 at 08:07 +0200, Kalle Valo wrote:
> Steve deRosier <derosier@gmail.com> writes:
> 
> > On Wed, Feb 14, 2018 at 2:04 PM, Samuel Sieb <samuel@sieb.net>
> > wrote:
> > > On 02/14/2018 03:30 AM, Johannes Berg wrote:
> > > > 
> > > > On Wed, 2018-02-14 at 10:55 +0000, Mickaël PANNEQUIN wrote:
> > > > 
> > > > > 
> > > > > Do you know the limit of the number of users connected at the
> > > > > same
> > > > > time on the wifi? Works fine with 14 connected devices but
> > > > > not more.
> > > > > 
> > > > > How to increase it?
> > > > 
> > > > 
> > > > You can't.
> > > > 
> > > > > This limit is hardware?
> > > > 
> > > > 
> > > > More or less, yes. The HW/FW can support 16 STAs, but needs two
> > > > for
> > > > other bookkeeping.
> > > 
> > > 
> > > As a general question, is there a standard way to determine this
> > > limit for
> > > any particular hardware?
> > 
> > 
> > Yes, but there's no easy way. Put it in AP mode and connect clients
> > to
> > it until it starts rejecting new clients or dropping the old ones.
> > Usually while watching it with a sniffer. That's how I've always
> > had
> > to do it.
> > 
> > Different chips will have different limits, and there's no reliable
> > way to determine the limit across all chips other than trial and
> > error. It seems a common desire of people to try to use client
> > chips
> > as poor-man APs. While it will work for very limited number of
> > clients, they're not intended as AP chips. If you want something to
> > work as an AP, I recommend you choose an AP chip.
> 
> We do have wiphy::max_ap_assoc_sta, but I see only ath10k, qtnfmac and
> rsi_91x setting it. I wish all drivers would use that.
> 
>  * @max_ap_assoc_sta: maximum number of associated stations supported in AP mode
>  * (including P2P GO) or 0 to indicate no such limit is advertised. The
>  * driver is allowed to advertise a theoretical limit that it can reach in
>  * some cases, but may not always reach.

Cool, I hadn't noticed this before.  I'll add a patch to iwlwifi to add
it.

--
Cheers,
Luca.
