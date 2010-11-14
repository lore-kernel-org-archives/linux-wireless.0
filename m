Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server4.hostdango.com ([70.86.37.74]:52224 "EHLO
	server4.hostdango.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224Ab0KNCrZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Nov 2010 21:47:25 -0500
Message-ID: <4CDF4DBB.60909@krellan.com>
Date: Sat, 13 Nov 2010 18:47:23 -0800
From: Josh Lehan <krellan@krellan.com>
MIME-Version: 1.0
To: Jouni Malinen <j@w1.fi>
CC: linux-wireless@vger.kernel.org
Subject: Re: Distinguishing wrong password from other failure to connect?
References: <4CDCEBE9.8060905@krellan.com> <20101113103457.GA5166@jm.kir.nu>
In-Reply-To: <20101113103457.GA5166@jm.kir.nu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/13/2010 02:34 AM, Jouni Malinen wrote:
> That depends on which security mode you are using.. With
> WPA/WPA2-Personal, there is no explicit indication that the connection
> failed because of incorrect passphrase because the AP will silently drop
> the message in which the wrong passphrase was used. In other words, the
> protocol does not provide means for the AP to indicate that connection
> failed because of incorrect key.

That makes sense, to do a silent drop, because of security (you don't
want to give positive feedback to a hacker that the password was
rejected, that would only make it faster for them to loop through a
dictionary of passwords).

It's a shame from a UI point of view, though.  I don't want to accuse my
user of entering the wrong password when in reality it was the network's
fault, and vice versa.

> Well, the starting problem is that the protocol does not provide such
> information (sometimes by design). The best you can do is to assume
> things and hope that the most likely reason for an error was the cause
> of the problem this time. For example, with WPA/WPA2-Personal, we may
> assume that the passphrase was incorrect if we complete association
> successfully, receive EAPOL-Key 1/4, send EAPOL-Key 2/4 and get it
> acknowledged by the AP, but never see EAPOL-Key 3/4. This does not
> guarantee that the reason for incorrect passphrase, but that is one of
> the most likely reasons for this.

Very clever idea.  It would be great to have visibility into the
authentication/EAPOL state machine, instead of just getting final states
like "ASSOCIATED".  Is this information available outside wpa_supplicant
in any standard way, or will I have to patch wpa_supplicant to find a
way to publish this information to my UI?

> Asking for a passphrase again (and even worse, dropping the previously
> stored passphrase based on this) is bad UI design in my opinion for many
> of these cases. It should not really done unless we are pretty confident
> that the reason was indeed in wrong passphrase. Especially the
> forgetting of stored information should really never be done unless we
> are very confident on this being caused by wrong passphrase (e.g., never
> do that if we have successfully completed even one connection with
> WPA/WPA2-Personal).

I'm glad I'm not the only one who is irritated by this design decision
of NetworkManager!  I keep wishing for a checkbox that says "I KNOW my
password is correct, please keep trying with it, and stop bugging me".
Oftentimes I'll walk my laptop out of range, then come back into range,
only to have my laptop fail to automatically connect because it's just
sitting there stuck at the NetworkManager password prompt.

Josh
