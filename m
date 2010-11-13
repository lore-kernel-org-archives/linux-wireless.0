Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:55046 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755538Ab0KMKfF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Nov 2010 05:35:05 -0500
Date: Sat, 13 Nov 2010 12:34:57 +0200
From: Jouni Malinen <j@w1.fi>
To: Josh Lehan <krellan@krellan.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Distinguishing wrong password from other failure to connect?
Message-ID: <20101113103457.GA5166@jm.kir.nu>
References: <4CDCEBE9.8060905@krellan.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4CDCEBE9.8060905@krellan.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 11, 2010 at 11:25:29PM -0800, Josh Lehan wrote:
> Hi.  Curious if there is a way to distinguish between the various
> failure modes when failing to make an association to an AP.

In some cases, yes, in many, not really in any reliable way.

> In particular, I'd love to distinguish between these two states:
> 
> * User entered incorrect password
> 
> * User entered correct password, but the AP rejected them for some other
> reason

That depends on which security mode you are using.. With
WPA/WPA2-Personal, there is no explicit indication that the connection
failed because of incorrect passphrase because the AP will silently drop
the message in which the wrong passphrase was used. In other words, the
protocol does not provide means for the AP to indicate that connection
failed because of incorrect key.

In WPA/WPA2-Enterprise, you may get an explicit error notification of
password failure with some EAP methods, but not all (they may have the
same lets-not-provide-any-more-info-to-attackers design for failure
cases).

> Does the Linux wireless stack support a way for applications to gather
> this information?  Are the "reason=0x00" bytes, sometimes displayed by
> wpa_supplicant in the logs, standardized across all AP's?

Well, the starting problem is that the protocol does not provide such
information (sometimes by design). The best you can do is to assume
things and hope that the most likely reason for an error was the cause
of the problem this time. For example, with WPA/WPA2-Personal, we may
assume that the passphrase was incorrect if we complete association
successfully, receive EAPOL-Key 1/4, send EAPOL-Key 2/4 and get it
acknowledged by the AP, but never see EAPOL-Key 3/4. This does not
guarantee that the reason for incorrect passphrase, but that is one of
the most likely reasons for this.

> This seems to be a common problem, because on many distributions, I see
> NetworkManager constantly popping up the password entry box whenever an
> association fails, when the user already knows the password is correct
> (and in fact has entered it into the box already, as it's pre-filled in
> the box, albeit starred out).

Asking for a passphrase again (and even worse, dropping the previously
stored passphrase based on this) is bad UI design in my opinion for many
of these cases. It should not really done unless we are pretty confident
that the reason was indeed in wrong passphrase. Especially the
forgetting of stored information should really never be done unless we
are very confident on this being caused by wrong passphrase (e.g., never
do that if we have successfully completed even one connection with
WPA/WPA2-Personal).

We have most of the needed information available in user space to allow
applications to do their best in figuring out what could have happened.
One small addition would be to make it easier to get TX status for
EAPOL-Key transmission (i.e., whether AP acknowledged a Data frame sent
by wpa_supplicant) into user space. hostapd can do this with a monitor
interface, and well, so could wpa_supplicant, but the simpler design of
just using normal data frame transmission routines does not provide that
indication back to the application. Still, this would not provide
completely reliable mechanism for determining whether incorrect
passphrase was used, but it would potentially allow limiting some of the
false positives from being reported in cases where 4-way handshake fails
due to AP not receiving frames from the station for some other reason.

-- 
Jouni Malinen                                            PGP id EFC895FA
