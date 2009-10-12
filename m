Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:34418 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753696AbZJLGwv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2009 02:52:51 -0400
Date: Mon, 12 Oct 2009 09:52:10 +0300
From: Jouni Malinen <j@w1.fi>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: "hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: deauthentication and disassociation nl80211 commands
Message-ID: <20091012065210.GA25578@jm.kir.nu>
References: <1254708707.24430.68.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1254708707.24430.68.camel@maxim-laptop>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 05, 2009 at 04:11:47AM +0200, Maxim Levitsky wrote:

> Today kernel explicitly requests the driver to perform both
> disassociation and deauthentication in that order.

I hope that deauthentication alone would be enough since that is
supposed to implicitly first take care of disassociation as far as the
IEEE 802.11 standard is concerned. It should also be noted that "kernel"
here is referring to mac80211; most other drivers/IEEE 802.11 stacks
do not have this type of restriction.

> However, currently wpa_supplicant assumes that once it called
> wpa_drv_disassociate it can again start the complete connect sequence
> from the authentication.

Actually, wpa_supplicant assume that it can authenticate again at any
point, i.e., even without first calling wpa_drv_disassociate.

> In fact I have carefully studied the code and found that calls to
> wpa_supplicant_deauthenticate (which is the only user of
> wpa_drv_deauthenticate) only happen at deinitialization of wireless
> interface and when wpa_supplicant really has to do it, that is if there
> is a failure (mic failure for example).

Yes, wpa_supplicant tries to follow the operations as defined in IEEE
802.11 and does not unnecessarily deauthenticate. In addition, when
reassociating back to the same AP (e.g., to change some parameters),
there will be no deauthentication/disassociation at all.

> My hacky patch that was rejected on the grounds that it is not right to
> introduce the driver dependent behavior might actually be the correct
> solution. It just makes the wpa_supplicant_disassociate do both
> disassociation and deauthentication, as was always assumed by the
> wpa_supplicant core.

There is no such assumption and the patch is not correct.

> Or kernel should became smarter and do the work for wpa_supplicant. 

No, it should not do that either. Rather, it should allow valid IEEE
802.11 operations to be performed (authentication while authenticated is
allowed)..

> If mac80211 is already authenticated to the AP that was requested, it
> should just return success.

No. It should start new authentication in that case.

> If it isn't authenticated to new AP then, new authentication should be
> made.
> (and old one can be kept, but removed after a timeout)

That should be done regardless of the current authentication/association
state.

> When do you plan to switch officially the wpa_supplicant to
> driver_nl80211?

To whom is this "you" referring? wpa_supplicant does support both WEXT
and nl80211. It is up to the user (of wpa_supplicant; e.g., NM) to
decide which driver wrapper it wants to use.


As far as working out this issue is concerned, I committed a following
change to wpa_supplicant:
http://w1.fi/gitweb/gitweb.cgi?p=hostap.git;a=commitdiff;h=6d6f4bb87f33278aed133875d0d561eb55d7ae59

I cannot day that I exactly like this due to the required extra code in
events.c, but the part in driver_nl80211.c shows how this type of
driver-specific cases should be handled in general. Anyway, I hope that
this can be eventually removed from wpa_supplicant.

-- 
Jouni Malinen                                            PGP id EFC895FA
