Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36207 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755870Ab0EQVuS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 May 2010 17:50:18 -0400
Received: by wyb39 with SMTP id 39so866411wyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 17 May 2010 14:50:16 -0700 (PDT)
Message-ID: <4BF1B9EA.8060009@gmail.com>
Date: Mon, 17 May 2010 22:49:30 +0100
From: Dave <kilroyd@googlemail.com>
MIME-Version: 1.0
To: Walter Goldens <goldenstranger@yahoo.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] fix several minor description typos
References: <974011.51480.qm@web56808.mail.re3.yahoo.com>
In-Reply-To: <974011.51480.qm@web56808.mail.re3.yahoo.com>
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

You may want to prefix the patch title with 'wireless:', and include in
the commitlog a description what type of errors you are correcting. In
this case I'd guess 'avoid word repetition'.

Most of the changes seem obviously correct. However a couple:

On 17/05/10 20:33, Walter Goldens wrote:
> --- a/drivers/net/wireless/orinoco/main.h
> +++ b/drivers/net/wireless/orinoco/main.h
> @@ -12,7 +12,7 @@
>  /* Compile time configuration and compatibility stuff               */
>  /********************************************************************/
>  
> -/* We do this this way to avoid ifdefs in the actual code */
> +/* We do that this way to avoid ifdefs in the actual code */
>  #ifdef WIRELESS_SPY
>  #define SPY_NUMBER(priv)    (priv->spy_data.spy_number)
>  #else

The latter construction doesn't make sense (to me). The former does,
even if it is a little clumsy. If the comment is still useful, I suggest
rewording it as something like:

/* Define SPY_NUMBER like this to avoid ifdefs in the actual code */

> --- a/include/linux/ieee80211.h
> +++ b/include/linux/ieee80211.h
> @@ -302,7 +302,7 @@ static inline int ieee80211_is_data_qos(
>  static inline int ieee80211_is_data_present(__le16 fc)
>  {
>      /*
> -     * mask with 0x40 and test that that bit is clear to only return true
> +     * mask with 0x40 and test that this bit is clear to only return true
>       * for the data-containing substypes.
>       */
>      return (fc & cpu_to_le16(IEEE80211_FCTL_FTYPE | 0x40)) ==

You may also want to correct the spelling of 'subtypes' here. I also
think that this could be reworded better. After consulting
IEE802.11-2007, section 7.1.3.1.2, I'd suggest:

/* Only return true for the data-containing subtypes.
 * Bit 0x40 indicates the frame subtype does not contain a Frame Body
 * field (i.e. there is no data). This bit should not be set.
 */

But I'd confirm with one of the core wireless developers before making
that change. It may also be worth changing the code to use
IEEE80211_STYPE_NULLFUNC instead of 0x40.


Regards,

Dave.
