Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:58685 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754619AbaEHSSH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 May 2014 14:18:07 -0400
Cc: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>,
	"Senthil Balasubramanian" <senthilb@qti.qualcomm.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	<ath9k-devel@lists.ath9k.org>,
	Oleksij Rempel <linux@rempel-privat.de>
Date: Thu, 8 May 2014 23:48:32 +0530
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: David Herrmann <dh.herrmann@gmail.com>
Subject: Re: [PATCH] ath9k: fix NULL-deref in hw_per_calibration() for ar9002
Message-ID: <20140508181830.GA9859@qca.qualcomm.com> (sfid-20140508_201812_295557_1677CB10)
References: <1399447378-31503-1-git-send-email-dh.herrmann@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1399447378-31503-1-git-send-email-dh.herrmann@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 07, 2014 at 09:22:58AM +0200, David Herrmann wrote:
> ah->caldata may be NULL if no channel is selected. Check for that before
> accessing it.
> 
> Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
> ---
> Hi
> 
> This is _definitely_ only a workaround, given that no-one guarantees ah->caldata
> is freed while we run in hw_per_calibration(). However, this patch fixes serious
> kernel panics with wifi-P2P on my machine.
> 
> I'm not sure why ah->caldata can be NULL, but it definitely is. I think the
> correct fix would be to synchronously stop any running hw-calibration before
> setting ah->caldata to NULL. I don't know whether/where that is done, so I wrote
> this small workaround.
>
David,

Whenever the DUT is moving to off-channel, ah->caldata is set to NULL in
hw_reset. As you mentioned, before doing hw_reset, the on-going calibration is stopped
synchronously. I using ar9280 for p2p (GO & CLI) validation. Somehow i do not observe
the panics. Is there a easiest way to reproduce the problem. Are you
using wireless-testing tree? Thanks for reporting the problem. Will try
to fix asap.

-Rajkumar
