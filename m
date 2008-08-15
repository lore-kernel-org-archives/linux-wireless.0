Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:62065 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757024AbYHOR6u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Aug 2008 13:58:50 -0400
Received: by nf-out-0910.google.com with SMTP id d3so711653nfc.21
        for <linux-wireless@vger.kernel.org>; Fri, 15 Aug 2008 10:58:49 -0700 (PDT)
To: Mikko =?iso-8859-15?q?Virkkil=E4?= <mikko.virkkila@bluegiga.com>
Subject: Re: mac80211 interprets missing TX_ACK flag as tx fail
Date: Fri, 15 Aug 2008 19:58:46 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net,
	Stephen Blackheath <tramp.enshrine.stephen@blacksapphire.com>
References: <1218813764.22679.11.camel@virkkmi-linux> <200808151844.13657.IvDoorn@gmail.com> <1218822632.22679.73.camel@virkkmi-linux>
In-Reply-To: <1218822632.22679.73.camel@virkkmi-linux>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Message-Id: <200808151958.46302.IvDoorn@gmail.com> (sfid-20080815_195855_157460_3E5F1F1A)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 15 August 2008, Mikko Virkkil=E4 wrote:
> I'm moving the conversation over from rt2400-devel to linux-wireless.
> The last message (as of this writing) from the earlier conversation a=
t
> rt2400-devel can be found at http://tinyurl.com/6p9n7g with some more
> details.
>=20
> So to summarize the situation:=20
>=20
> - the rt73usb driver (in rt2x00) doesn't set IEEE80211_TX_STAT_ACK
>   because "frames which are uploaded to the hardware are not guarente=
ed
>   to be acked".

rt2500usb suffers from the same issue.

> - The mac80211 layer will set the IEEE80211_RADIOTAP_F_TX_FAIL if the=
=20
>   IEEE80211_TX_STAT_ACK flag is missing.=20
> - hostapd will interpret the IEEE80211_RADIOTAP_F_TX_FAIL as a failur=
e
>   to send
>=20
> This all results in hostapd reporting "MGMT (TX callback) fail" and
> making rt73usb not work in AP mode.=20
>=20
> I'm hoping that some decision can be reached on how to fix this so th=
at
> AP mode will work with the rt73.=20
>=20
> Just off the top of my head, one way of fixing this would be to make
> IEEE80211_TX_CTL_NO_ACK also work the other way around: Now it is use=
d
> to tell the lower level not to wait for an ACK. Perhaps it could also=
 be
> used by the lower level to tell higher levels that no ACK is ever goi=
ng
> to come e.g. because the hardware is incapable of supplying TX ACKs. =
The
> mac80211 layer would be changed to check for IEEE80211_TX_CTL_NO_ACK.=
 If
> the flag was set it would skip setting IEEE80211_RADIOTAP_F_TX_FAIL e=
ven
> when the IEEE80211_TX_STAT_ACK is missing.

Actually this isn't the complete picture, what you might need is a new =
flag
IEEE80211_TX_CTL_UNKNOWN which then informs mac80211 that the
frame has an unknown status, and that is something that could be passed=
 on to
userspace through radiotap later.

This is better then setting a global "supports ACK reporting" flag, bec=
ause in case
of rt61 one every x frames also has an unknown status because the txdon=
e interrupt
isn't happening for that frame. So that means you definately need a per=
-frame flag
to tell if the frame was acked, not-acked or if the status was unknown.

Ivo
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
