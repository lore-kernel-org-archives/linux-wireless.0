Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33182 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756359Ab1CRSHV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2011 14:07:21 -0400
Received: by bwz15 with SMTP id 15so3563914bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 18 Mar 2011 11:07:20 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Stezenbach <js@sig21.net>
Subject: Re: [rt2x00-users] rt2800usb stops working with big file transfers in AP and IBSS
Date: Fri, 18 Mar 2011 19:05:31 +0100
Cc: Juan Carlos Garza <juancarlosgarza@gmail.com>,
	users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
References: <AANLkTik9wfkskAHEpmsm4_gPM0FFBf=q8OVXM99NBRjO@mail.gmail.com> <AANLkTi=u3dw1D1-+-Cy9aEPc2H1MAF+cUi=ucvMTNrNc@mail.gmail.com> <20110318171222.GB12889@sig21.net>
In-Reply-To: <20110318171222.GB12889@sig21.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201103181905.32058.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

Am Freitag, 18. März 2011 schrieb Johannes Stezenbach:
> On Fri, Mar 18, 2011 at 04:23:15PM +0100, Juan Carlos Garza wrote:
> > I applied the patches (manually), and tested the stick.
> > 
> > The transfer of big loads now is successful. The
> > "rt2800_txdone_entry_check:" warnings are still there, but they are
> > less frequent (just like in the example i gave you with the laptop
> > where it succeeded with the unpatched driver), some 5 warnings every
> > 1, 2 or 3 seconds.
> 
> Thanks for testing!  The occational "tx status missed" is unavoidable
> due to hardware limitations.  My patches reduce the number of them,
> but more importantly they fix a few issues with TX (status) timeout handling.
> (IIRC false positives in TX timeout check, and fluash would wait for
> TX queue empty which would never happen without the timer to reap
> the status queue.)
> 
> I tested a lot with these patches and they work stable for me, however I
> must admit I'm not sure why they help in your case (i.e. why does
> bulk transfer stall without these patches?).

Just an assumption: In rt2800pci I had the problem that the tx status register
sometimes suffered from overflows. And I was able to avoid the overflow by
reading the TX_STA_FIFO register fast enough (in hard irq context).

And I guess your patch also changed the timing of TX_STA_FIFO reads is
rt2800usb and thus reduces the number of overflows.

However, this is just a shot in the dark.

Helmut
