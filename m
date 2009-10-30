Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:9307 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757351AbZJ3TIR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2009 15:08:17 -0400
Received: by ey-out-2122.google.com with SMTP id d26so87705eyd.19
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2009 12:08:22 -0700 (PDT)
Message-ID: <4AEB39A1.4060702@lwfinger.net>
Date: Fri, 30 Oct 2009 14:08:17 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: Christian Lamparter <chunkeey@googlemail.com>,
	linville@tuxdriver.com, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org, dcbw@redhat.com,
	stern@rowland.harvard.edu, davem@davemloft.net
Subject: Re: [PATCH] libertas if_usb: Fix crash on 64-bit machines
References: <1256924714.4030.44.camel@macbook.infradead.org>	 <4AEB2F13.50102@lwfinger.net>  <200910301944.14740.chunkeey@googlemail.com> <1256928681.4030.112.camel@macbook.infradead.org>
In-Reply-To: <1256928681.4030.112.camel@macbook.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Woodhouse wrote:
> On Fri, 2009-10-30 at 19:44 +0100, Christian Lamparter wrote:
>> that's just a fill-in macro.
>> AFAICT usb_submit_urb does the tricky dma mapping.
> 
> Ah, that makes sense. In that case, all we need to do is make
> map_urb_for_dma() do the right thing.

After I sent my message, I realized that usb_submit_urb() and friends
do no checking and that the test had to be further down the line.

Larry
