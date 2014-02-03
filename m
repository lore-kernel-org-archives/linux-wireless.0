Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62602 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451AbaBCKhF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 05:37:05 -0500
Date: Mon, 3 Feb 2014 11:39:05 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: ath9k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org
Subject: Re: [RFC/RFT] ath9k_htc: avoid scheduling while atomic on
 sta_rc_update
Message-ID: <20140203103905.GB1725@redhat.com> (sfid-20140203_113710_167136_0C8DE693)
References: <20140131133707.GA7648@redhat.com>
 <52EBEA45.5090606@rempel-privat.de>
 <20140131193850.GC7648@redhat.com>
 <52EE0997.1060402@rempel-privat.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52EE0997.1060402@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 02, 2014 at 10:02:15AM +0100, Oleksij Rempel wrote:
> Am 31.01.2014 20:38, schrieb Stanislaw Gruszka:
> > On Fri, Jan 31, 2014 at 07:24:05PM +0100, Oleksij Rempel wrote:
> >> I have different HW. How can trigger sta_rc_update?
> > 
> > Below patch should trigger it when any management frame is received
> > from know sta and print information about it. 
> 
> It seems to work,
> a least it didn't crashed. I was able to trigger it only in IBSS mode.

Looks ieee80211_rx_h_mgmt with know STA is not used for Managed mode as
frequent as I thought.

Thanks for testing! I'll post the patch shortly.
Stanislaw

