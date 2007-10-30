Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2708 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752387AbXJ3R21 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Oct 2007 13:28:27 -0400
Date: Tue, 30 Oct 2007 13:28:11 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: RTS wrong hdrlen computation?
Message-ID: <20071030172811.GA7478@tuxdriver.com> (sfid-20071030_172832_129137_E22AF67F)
References: <43e72e890710300956w55740788mc70c63c4bace6d28@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e890710300956w55740788mc70c63c4bace6d28@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 30, 2007 at 12:56:39PM -0400, Luis R. Rodriguez wrote:
> Perhaps an oversight, gotta go so can't keep looking, perhaps others will know
> 
> diff --git a/net/mac80211/util.c b/net/mac80211/util.c
> index 27203f1..7f7da9c 100644
> --- a/net/mac80211/util.c
> +++ b/net/mac80211/util.c
> @@ -188,8 +188,11 @@ int ieee80211_get_hdrlen(u16 fc)
>                  *   subtype mask:   0b0000000011110000 (0x00F0)
>                  *   ACK subtype:    0b0000000011010000 (0x00D0)
>                  *   CTS subtype:    0b0000000011000000 (0x00C0)
> +                *   RTS subtype:    0b0000000010110000 (0x00B0) **
>                  *   bits that matter:         ^^^      (0x00E0)
>                  *   value of those: 0b0000000011000000 (0x00C0)
> +                *
> +                *   Note: this doesn't work for RTS...
>                  */
>                 if ((fc & 0xE0) == 0xC0)
>                         hdrlen = 10;

It looks like the default case (i.e. "hdrlen = 16") is fine for RTS.
What am I missing...?

John
-- 
John W. Linville
linville@tuxdriver.com
