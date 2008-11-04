Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web23107.mail.ird.yahoo.com ([217.146.189.47]:21603 "HELO
	web23107.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753794AbYKDU1P convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2008 15:27:15 -0500
Date: Tue, 4 Nov 2008 20:27:12 +0000 (GMT)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: [RFC/RFT PATCH v2 2/2] rtl8187: feedback transmitted packets using tx close descriptor for 8187B
To: linux-wireless@vger.kernel.org,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>,
	Andrea Merello <andrea.merello@gmail.com>
In-Reply-To: <1225806649-10050-3-git-send-email-herton@mandriva.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-ID: <244535.27936.qm@web23107.mail.ird.yahoo.com> (sfid-20081104_212725_056619_144F3635)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- On Tue, 4/11/08, Herton Ronaldo Krzesinski <herton@mandriva.com.br> wrote:

> Realtek 8187B has a receive command queue to feedback beacon
> interrupt
> and transmitted packet status. Use it to feedback mac80211
> about status
> of transmitted packets. Unfortunately in the course of
> testing I found
> that the sequence number reported by hardware includes
> entire sequence
> control in a 12 bit only field, so a workaround is done to
> check only
> lowest bits.

> ---
>  v2: fix rate stuck at 1M reported by Larry Finger, Hin-Tak
> and also seen by me.
>      btw, I noted now with a ralink device that rt2500usb
> (rt2x00) has same
>      issue currently.


> -		hdr->retry =
> cpu_to_le32((info->control.rates[0].count - 1) <<
> 8);
> +		hdr->retry =
> cpu_to_le32(info->control.rates[0].count << 8);

> -		hdr->retry =
> cpu_to_le32((info->control.rates[0].count - 1) <<
> 8);
> +		hdr->retry =
> cpu_to_le32(info->control.rates[0].count << 8);

These are the only lines which changed between the two versions of the patch - if removing the two -1's fixes the rate stuck (and these two lines are newly introduced), shouldn't this be a separate commit if it fixes a problem introduced by an earlier commit?

I did *not* (and do not) have a rate-stuck problem, but I am running a slightly mod version of the patch against 2.6.27, which doesn't have "rates[x].count" yet, with the retry_count struct member which seems to have since been removed.


      
