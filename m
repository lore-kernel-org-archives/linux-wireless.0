Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46896 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968Ab1BFThX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Feb 2011 14:37:23 -0500
Received: by wyb28 with SMTP id 28so3921289wyb.19
        for <linux-wireless@vger.kernel.org>; Sun, 06 Feb 2011 11:37:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTikYS1EUdTc9mo2kvoR-S1Cv+WcKqkGaFDA8fR+0@mail.gmail.com>
References: <20110131214515.GC6368@thinkpad-t410>
	<AANLkTikYS1EUdTc9mo2kvoR-S1Cv+WcKqkGaFDA8fR+0@mail.gmail.com>
Date: Sun, 6 Feb 2011 20:37:21 +0100
Message-ID: <AANLkTi=mRO99U5t3Z_gscuwix0X+brFhWtC=9nkytE+M@mail.gmail.com>
Subject: Re: Missing skb_pad() return value checks in rt2x00 driver
From: Wolfgang Kufner <wolfgang.kufner@gmail.com>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: Seth Forshee <seth.forshee@canonical.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ivo,

On Sun, Feb 6, 2011 at 5:17 PM, Ivo Van Doorn <ivdoorn@gmail.com> wrote:
> Between here and where you added the padding are a couple of function
> calls which use the skb->len field. So this patch would change the value what
> they expect. Have you checked the possible impact?

I don't think skb_pad() touches skb->len. It writes zeros into the tailroom:
/**
*      skb_pad                 -       zero pad the tail of an skb
*      @skb: buffer to pad
*      @pad: space to pad
*
*      Ensure that a buffer is followed by a padding area that is zero
*      filled. Used by network drivers which may DMA or transfer data
*      beyond the buffer end onto the wire.
*
*      May return error in out of memory cases. The skb is freed on error.
*/

Thanks,
Wolfgang
