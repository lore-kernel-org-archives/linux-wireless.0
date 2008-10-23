Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.188]:45453 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124AbYJWWHi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2008 18:07:38 -0400
Received: by rn-out-0910.google.com with SMTP id k40so392313rnd.17
        for <linux-wireless@vger.kernel.org>; Thu, 23 Oct 2008 15:07:37 -0700 (PDT)
Message-ID: <445f43ac0810231507l790332b9h2c05e95aa0212392@mail.gmail.com> (sfid-20081024_000742_626566_B9F0B044)
Date: Thu, 23 Oct 2008 15:07:36 -0700
From: "Javier Cardona" <javier@cozybit.com>
To: "Andrey Yurovsky" <andrey@cozybit.com>
Subject: Re: [RFC] mac80211 rx filter in mesh mode, rt2x00 mesh point operation
Cc: linux-wireless@vger.kernel.org, ivdoorn@gmail.com
In-Reply-To: <4900f16b.0b0c360a.2bc3.ffffa11a@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <4900f16b.0b0c360a.2bc3.ffffa11a@mx.google.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andrey,

On Thu, Oct 23, 2008 at 2:49 PM, Andrey Yurovsky <andrey@cozybit.com> w=
rote:
> I've come across a problem with the RX filter setting while testing m=
esh point
> operation in the rt2x00 driver (my hardware is rt73usb).  We transmit=
 and
> receive mesh beacons but mesh peer link action frames are dropped.  A=
 patch
> for enabling mesh point mode is included here, this works except that=
:
>
> The RX filter, as set by mac80211 in mesh mode is 0x02, that is FIF_A=
LLMULTI is
> set.  This is sufficient for other drivers but not for rt2x00.  I not=
iced that
> running tcpdump on the MP interface sets the filter to 0x43, this add=
s
> FIF_OTHER_BSS and FIF_PROMISC_IN_BSS, and rt2x00 is then able to make=
 peer
> links and mesh point mode works correctly.
>
> Actually for rt2x00, setting either FIF_OTHER_BSS or FIF_PROMISC_IN_B=
SS is the
> key here because they are both treated as FIF_PROMISC_IN_BSS, which c=
auses the
> driver to enable TXRX_CSR0_DROP_TO_DS.

Mesh frames have 4 addresses and no BSSID, so BSSID filtering should
be disabled (i.e. FIF_OTHER_BSS should be set).
The ALL_MULTI flag is also needed for mesh mode because an
intermediate node has to forward multicast traffic for addresses that
it may not be listening to.

But promiscuous mode is not necessary:  mesh points don't need to
receive unicast frames not addressed=B9 to them.  Furthermore, enabling
promiscuous mode normally disables acknowledgments, which are needed
for proper mesh operation.

So my recommendation would be to configure the RX filter in mesh mode
to be ( FIF_ALLMULTI | FIF_OTHER_BSS )

Cheers,

Javier

[1] By addressed I mean that the node's address is in the first
address field, RA, not necessarily in the DA.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
