Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:25961 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397Ab0KLRVW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 12:21:22 -0500
Received: from hpaq12.eem.corp.google.com (hpaq12.eem.corp.google.com [172.25.149.12])
	by smtp-out.google.com with ESMTP id oACHLL5k008037
	for <linux-wireless@vger.kernel.org>; Fri, 12 Nov 2010 09:21:21 -0800
Received: from iwn6 (iwn6.prod.google.com [10.241.68.70])
	by hpaq12.eem.corp.google.com with ESMTP id oACHJlfk008018
	for <linux-wireless@vger.kernel.org>; Fri, 12 Nov 2010 09:21:19 -0800
Received: by iwn6 with SMTP id 6so4832525iwn.15
        for <linux-wireless@vger.kernel.org>; Fri, 12 Nov 2010 09:21:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4CDCEBE9.8060905@krellan.com>
References: <4CDCEBE9.8060905@krellan.com>
Date: Fri, 12 Nov 2010 09:21:19 -0800
Message-ID: <AANLkTikHOsYPwU0J-bYFGQamCS4CVUP5T_B1yGLCjmD5@mail.gmail.com>
Subject: Re: Distinguishing wrong password from other failure to connect?
From: Paul Stewart <pstew@google.com>
To: Josh Lehan <krellan@krellan.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 11, 2010 at 11:25 PM, Josh Lehan <krellan@krellan.com> wrote:
> Hi.  Curious if there is a way to distinguish between the various
> failure modes when failing to make an association to an AP.
>
> In particular, I'd love to distinguish between these two states:
>
> * User entered incorrect password
>
> * User entered correct password, but the AP rejected them for some other
> reason (perhaps signal was too weak, or the AP is using MAC address
> filtering, or they couldn't negotiate a common encryption/authentication
> protocol, or whatever).
>
> Does the Linux wireless stack support a way for applications to gather
> this information?  Are the "reason=0x00" bytes, sometimes displayed by
> wpa_supplicant in the logs, standardized across all AP's?

The "reason=xx" codes are standardized by 802.11.  However when
reading such messages, one needs to be careful to note which party
sent that reason code.  There are times when the AP sends this
message, and other times where the station sends it as it departs.

> This seems to be a common problem, because on many distributions, I see
> NetworkManager constantly popping up the password entry box whenever an
> association fails, when the user already knows the password is correct
> (and in fact has entered it into the box already, as it's pre-filled in
> the box, albeit starred out).

It is a problem in general, but for the most part I believe the onus
lies with the supplicant, rather than the kernel to distinguish
between the various error cases.  It is the step between
wpa_supplciant and whatever connection manager which makes it tricky
to properly determine why a connection failed (or was lost) and relay
the correct information back to the user.  For example, in the
ChromeOS connection manager, if we note that wpa_supplicant fell out
of association while in the 4WAY_HANDSHAKE state, we assume that this
is due to a bad WPA passphrase, but in the (admittedly unlikely but
still statistically significant) case where we lose connectivity in
that state due to lower-level failure, we assume the same thing, and
tell the user their password is wrong.  Not a good experience.

Even in the WEP case, you can imagine the supplicant being proactive
in determining if the key is wrong by monitoring packet counts. In
this situation there may need to be some kernel help -- I'm not sure
where counters are kept of packets dropped due to failed WEP
decryption -- but if such a thing existed, wpa_supplicant could
presume the encryption key was incorrect after a period of time.

--
Paul
