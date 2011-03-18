Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:45972 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757182Ab1CRRM3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2011 13:12:29 -0400
Date: Fri, 18 Mar 2011 18:12:23 +0100
From: Johannes Stezenbach <js@sig21.net>
To: Juan Carlos Garza <juancarlosgarza@gmail.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Subject: Re: [rt2x00-users] rt2800usb stops working with big file transfers
 in AP and IBSS
Message-ID: <20110318171222.GB12889@sig21.net>
References: <AANLkTik9wfkskAHEpmsm4_gPM0FFBf=q8OVXM99NBRjO@mail.gmail.com>
 <201103171316.02636.helmut.schaa@googlemail.com>
 <AANLkTi=Gm-apOyop22UgFMgoQE_+maEQgrMDdH-kTxZq@mail.gmail.com>
 <201103172107.25316.helmut.schaa@googlemail.com>
 <AANLkTi=u3dw1D1-+-Cy9aEPc2H1MAF+cUi=ucvMTNrNc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AANLkTi=u3dw1D1-+-Cy9aEPc2H1MAF+cUi=ucvMTNrNc@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Juan Carlos,

On Fri, Mar 18, 2011 at 04:23:15PM +0100, Juan Carlos Garza wrote:
> I applied the patches (manually), and tested the stick.
> 
> The transfer of big loads now is successful. The
> "rt2800_txdone_entry_check:" warnings are still there, but they are
> less frequent (just like in the example i gave you with the laptop
> where it succeeded with the unpatched driver), some 5 warnings every
> 1, 2 or 3 seconds.

Thanks for testing!  The occational "tx status missed" is unavoidable
due to hardware limitations.  My patches reduce the number of them,
but more importantly they fix a few issues with TX (status) timeout handling.
(IIRC false positives in TX timeout check, and fluash would wait for
TX queue empty which would never happen without the timer to reap
the status queue.)

I tested a lot with these patches and they work stable for me, however I
must admit I'm not sure why they help in your case (i.e. why does
bulk transfer stall without these patches?).


Johannes
