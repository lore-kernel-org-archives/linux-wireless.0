Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43630 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbaELSAP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 May 2014 14:00:15 -0400
Date: Mon, 12 May 2014 13:49:10 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: David Herrmann <dh.herrmann@gmail.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	ath9k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Subject: Re: [ath9k-devel] [PATCH] ath9k: fix NULL-deref in
 hw_per_calibration() for ar9002
Message-ID: <20140512174910.GM17022@tuxdriver.com> (sfid-20140512_200019_523309_44F2E6A4)
References: <1399447378-31503-1-git-send-email-dh.herrmann@gmail.com>
 <20140507195435.GF20432@tuxdriver.com>
 <536A9479.8010201@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <536A9479.8010201@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 07, 2014 at 10:15:53PM +0200, Felix Fietkau wrote:
> On 2014-05-07 21:54, John W. Linville wrote:
> > On Wed, May 07, 2014 at 09:22:58AM +0200, David Herrmann wrote:
> >> ah->caldata may be NULL if no channel is selected. Check for that before
> >> accessing it.
> >> 
> >> Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
> >> ---
> >> Hi
> >> 
> >> This is _definitely_ only a workaround, given that no-one guarantees ah->caldata
> >> is freed while we run in hw_per_calibration(). However, this patch fixes serious
> >> kernel panics with wifi-P2P on my machine.
> >> 
> >> I'm not sure why ah->caldata can be NULL, but it definitely is. I think the
> >> correct fix would be to synchronously stop any running hw-calibration before
> >> setting ah->caldata to NULL. I don't know whether/where that is done, so I wrote
> >> this small workaround.
> >> 
> >> Thanks
> >> David
> > 
> > Is there any hope for getting a more complete fix from the ath9k guys
> > in short order?
> This looks easy to fix. I'll send a patch soon.

Ping?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
