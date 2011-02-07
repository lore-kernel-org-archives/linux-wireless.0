Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from adelie.canonical.com ([91.189.90.139]:37523 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137Ab1BGEKN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Feb 2011 23:10:13 -0500
Date: Sun, 6 Feb 2011 22:10:07 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Wolfgang Kufner <wolfgang.kufner@gmail.com>,
	Ivo Van Doorn <ivdoorn@gmail.com>
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: Missing skb_pad() return value checks in rt2x00 driver
Message-ID: <20110207041007.GA14242@thinkpad-t410>
References: <20110131214515.GC6368@thinkpad-t410>
 <AANLkTikYS1EUdTc9mo2kvoR-S1Cv+WcKqkGaFDA8fR+0@mail.gmail.com>
 <AANLkTi=mRO99U5t3Z_gscuwix0X+brFhWtC=9nkytE+M@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AANLkTi=mRO99U5t3Z_gscuwix0X+brFhWtC=9nkytE+M@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 06, 2011 at 08:37:21PM +0100, Wolfgang Kufner wrote:
> Hi Ivo,
> 
> On Sun, Feb 6, 2011 at 5:17 PM, Ivo Van Doorn <ivdoorn@gmail.com> wrote:
> > Between here and where you added the padding are a couple of function
> > calls which use the skb->len field. So this patch would change the value what
> > they expect. Have you checked the possible impact?
> 
> I don't think skb_pad() touches skb->len. It writes zeros into the tailroom:

Agreed, it doesn't look like skb_pad() affects that field.

One point of concern though would be operations that changed the length
so that the amount of padding applied was no longer correct. That isn't
the case here, but it does make more sense logically that the padding
would follow any adjustments to skb->len.

My reason for moving it was that if the padding failed at the original
location some data would have already been written to the hardware,
potentially leaving it in a bad state (at a minimum it looks like
beaconing would be left disabled). Maybe a better option would be to
leave the padding at the original location and add some cleanup for the
failure case. I don't have this hardware and am not familiar with it,
but I'd be happy to rework the patch if someone who knows the hardware
can advise me on what cleanup should be done.
