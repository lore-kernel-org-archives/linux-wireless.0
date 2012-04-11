Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:53954 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902Ab2DKHKm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 03:10:42 -0400
Date: Wed, 11 Apr 2012 10:11:21 +0300
From: Andrei Emeltchenko <Andrei.Emeltchenko.news@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [RFCv1] mac80211: Adds Software / Virtual AMP 80211
Message-ID: <20120411071119.GC17779@aemeltch-MOBL1> (sfid-20120411_091117_086888_DF65B524)
References: <1334059909-20513-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
 <1334059909-20513-2-git-send-email-Andrei.Emeltchenko.news@gmail.com>
 <4F846257.1060807@sipsolutions.net>
 <1334092668.16897.54.camel@aeonflux>
 <4F84A422.3030900@sipsolutions.net>
 <4F84A52A.7050905@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4F84A52A.7050905@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Tue, Apr 10, 2012 at 02:24:58PM -0700, Johannes Berg wrote:
> On 4/10/2012 2:20 PM, Johannes Berg wrote:
> >>>I don't get this patch at all. Why am I reviewing some very very basic
> >>>skeleton code when we should be discussing userspace APIs (we have
> >>>already discussed them with a few people years ago), how the AMP is
> >>>going to be managed, how the security handshake is going to work, etc.
> >>
> >>adding AMP (meaning Bluetooth Alternate MAC/PHY in case anybody cares)
> >>for SoftMac WiFi cards should be done solely in kernel space between
> >>Bluetooth core and mac80211. All the FullMac cards will expose the HCI
> >>AMP directly via the Bluetooth core. See Marvell solution for example.
> >>
> >>If we require a userspace interaction, I think we are doing something
> >>wrong here. And as far as I can tell, the only tricky part is the WPA2
> >>PSK 4-way handshake. We would need a kernel implementation for that.
> >
> >You already know I disagree, I don't want this code re-implemented in
> >kernel space when adding a few tightly controlled APIs is all it needs
> >to use an existing implementation of the relevant mechanisms.
> 
> There are also additional complexities like wpa_supplicant having to
> know whether to set up/tear down a BT AMP interface for P2P
> concurrency etc.,

I am new to the wireless code but can new virtual interface separate those
interfaces? They can have different MAC addresses and you can run
wpa_supplicant for each virtual interface separately.

Best regards 
Andrei Emeltchenko 

