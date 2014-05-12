Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:60629 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751616AbaELSnm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 May 2014 14:43:42 -0400
Message-ID: <53711646.1030909@openwrt.org> (sfid-20140512_204345_700326_53CB7022)
Date: Mon, 12 May 2014 20:43:18 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: David Herrmann <dh.herrmann@gmail.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	ath9k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Subject: Re: [ath9k-devel] [PATCH] ath9k: fix NULL-deref in hw_per_calibration()
 for ar9002
References: <1399447378-31503-1-git-send-email-dh.herrmann@gmail.com> <20140507195435.GF20432@tuxdriver.com> <536A9479.8010201@openwrt.org> <20140512174910.GM17022@tuxdriver.com>
In-Reply-To: <20140512174910.GM17022@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2014-05-12 19:49, John W. Linville wrote:
> On Wed, May 07, 2014 at 10:15:53PM +0200, Felix Fietkau wrote:
>> On 2014-05-07 21:54, John W. Linville wrote:
>> > On Wed, May 07, 2014 at 09:22:58AM +0200, David Herrmann wrote:
>> >> ah->caldata may be NULL if no channel is selected. Check for that before
>> >> accessing it.
>> >> 
>> >> Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
>> >> ---
>> >> Hi
>> >> 
>> >> This is _definitely_ only a workaround, given that no-one guarantees ah->caldata
>> >> is freed while we run in hw_per_calibration(). However, this patch fixes serious
>> >> kernel panics with wifi-P2P on my machine.
>> >> 
>> >> I'm not sure why ah->caldata can be NULL, but it definitely is. I think the
>> >> correct fix would be to synchronously stop any running hw-calibration before
>> >> setting ah->caldata to NULL. I don't know whether/where that is done, so I wrote
>> >> this small workaround.
>> >> 
>> >> Thanks
>> >> David
>> > 
>> > Is there any hope for getting a more complete fix from the ath9k guys
>> > in short order?
>> This looks easy to fix. I'll send a patch soon.
> 
> Ping?
I looked into it again, the scenario where I assumed that this problem
could occur didn't turn out to be true. I have no idea how this crash
can occur.

- Felix
