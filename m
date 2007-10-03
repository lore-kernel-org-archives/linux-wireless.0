Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:36358 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755614AbXJCCuw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Oct 2007 22:50:52 -0400
Date: Tue, 2 Oct 2007 19:50:19 -0700
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Kernelspace --> Userspace MLME move and related items
Message-ID: <20071003025019.GF933@jm.kir.nu> (sfid-20071003_035058_550541_D2535931)
References: <43e72e890709281725n6a8ffe0bq487f32796a7e1cf2@mail.gmail.com> <1191066581.22960.55.camel@johannes.berg> <20070929161740.GB6130@tuxdriver.com> <1191141815.22960.134.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1191141815.22960.134.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Sep 30, 2007 at 10:43:35AM +0200, Johannes Berg wrote:

> > >  * 802.11r (fast roaming)
> 
> Already has a (partial?) implementation in wpa_supplicant.

The current implementation is more or less complete for all the required
functionality. I just updated it for the latest draft (D8.0) that was
released last week. This includes code for adding new IEs to
authentication and association frames and also sending/receiving of
action frames.

> > >  * 802.11w (encrypted management)
> 
> All the key handling is in wpa_supplicant so we will not be able to
> support it in the kernel w/o wpa_supplicant and I don't see a good way
> to do it in the kernel either (not too familiar with the spec though),
> and wpa_supplicant already has a (partial?) implementation.

wpa_supplicant has implementation for negotiating the keys and
configuring them to the driver. It does not implement
encryption/decryption of the management frames, though, and I do not
have plans on doing that in user space either. 802.11w actually uses the
same PTK than data frames for unicast management frames, so the kernel
side (or firmware/hardware) CCMP should be used for this. As far as
broadcast/multicast management frames are concerned, they will need a
new encryption (or well, actually it is not encryption, just integrity
protection) algorithm in the kernel. The key (IGTK) comes from user
space in the same way as GTK for data frames.

In general, 802.11w has quite minimal requirements for the MLME parts
and the key negotiation (part of 4-way handshake) is completely separate
functionality from the encryption/decryption/integrity protection of
management frames.

-- 
Jouni Malinen                                            PGP id EFC895FA
