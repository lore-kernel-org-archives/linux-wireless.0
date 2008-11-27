Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f11.google.com ([209.85.221.11]:55246 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773AbYK0UCY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Nov 2008 15:02:24 -0500
Received: by qyk4 with SMTP id 4so1378978qyk.13
        for <linux-wireless@vger.kernel.org>; Thu, 27 Nov 2008 12:02:22 -0800 (PST)
Message-ID: <69e28c910811271202s295bbf5bo3dc8c04c50b08a01@mail.gmail.com> (sfid-20081127_210227_870948_B9917443)
Date: Thu, 27 Nov 2008 21:02:22 +0100
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Herton Ronaldo Krzesinski" <herton@mandriva.com.br>
Subject: Re: [RFC] rtl8187: Do not wait for an ACK when IEEE80211_TX_CTL_NO_ACK is set
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Hin-Tak Leung" <hintak.leung@gmail.com>,
	"Larry Finger" <Larry.Finger@lwfinger.net>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200811271543.59126.herton@mandriva.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <69e28c910811261431u26e341d3p51ebadca807f4b61@mail.gmail.com>
	 <200811271543.59126.herton@mandriva.com.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 27, 2008 at 6:43 PM, Herton Ronaldo Krzesinski
<herton@mandriva.com.br> wrote:
>
> nack.
>
> I've seen other drivers set just a flag when hardware has a bit field to
> signalize that there isn't need to ack the tx packet to be sent, but
> don't saw anyone changing retry in tx hw header. Also setting to 0 in
> no_ack case looks wrong, for example see ath5k where it even checks for
> 0 and returns an error if you try to do this.
>
> --
> []'s
> Herton
>

IMO the current implementation is even worse - completely disregard
NO_ACK, and when a packet that should not be ACKed according to IEEE
802.11:2007 is sent (such as a broadcast), retry repeatedly until
timeout.
Also, v26.1010 of the vendor driver does exactly what my patch does.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
