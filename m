Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53152 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892AbaEGUQE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 16:16:04 -0400
Message-ID: <536A9479.8010201@openwrt.org> (sfid-20140507_221608_568572_0619703A)
Date: Wed, 07 May 2014 22:15:53 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>,
	David Herrmann <dh.herrmann@gmail.com>
CC: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	ath9k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Subject: Re: [ath9k-devel] [PATCH] ath9k: fix NULL-deref in hw_per_calibration()
 for ar9002
References: <1399447378-31503-1-git-send-email-dh.herrmann@gmail.com> <20140507195435.GF20432@tuxdriver.com>
In-Reply-To: <20140507195435.GF20432@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2014-05-07 21:54, John W. Linville wrote:
> On Wed, May 07, 2014 at 09:22:58AM +0200, David Herrmann wrote:
>> ah->caldata may be NULL if no channel is selected. Check for that before
>> accessing it.
>> 
>> Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
>> ---
>> Hi
>> 
>> This is _definitely_ only a workaround, given that no-one guarantees ah->caldata
>> is freed while we run in hw_per_calibration(). However, this patch fixes serious
>> kernel panics with wifi-P2P on my machine.
>> 
>> I'm not sure why ah->caldata can be NULL, but it definitely is. I think the
>> correct fix would be to synchronously stop any running hw-calibration before
>> setting ah->caldata to NULL. I don't know whether/where that is done, so I wrote
>> this small workaround.
>> 
>> Thanks
>> David
> 
> Is there any hope for getting a more complete fix from the ath9k guys
> in short order?
This looks easy to fix. I'll send a patch soon.

- Felix

