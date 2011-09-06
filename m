Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lucidpixels.com ([72.73.18.11]:58543 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754153Ab1IFSjF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Sep 2011 14:39:05 -0400
Date: Tue, 6 Sep 2011 14:39:03 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Pavel Roskin <proski@gnu.org>
cc: linux-wireless@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
Subject: Re: 3.0.0: carl9170: drivers/net/wireless/ath/carl9170/tx.c:351
 carl9170_tx_status+0x431/0x440 [carl9170]()
In-Reply-To: <20110906110422.326f95c5@mj>
Message-ID: <alpine.DEB.2.02.1109061402170.31228@p34.internal.lan> (sfid-20110906_203939_129129_8E733508)
References: <alpine.DEB.2.02.1109051750010.23828@p34.internal.lan> <20110906110422.326f95c5@mj>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Tue, 6 Sep 2011, Pavel Roskin wrote:

> On Mon, 5 Sep 2011 17:53:06 -0400 (EDT)
> Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>
>> Hello,
>>
>> Saw this on one of my Linux machines with a Linux (community
>> supported USB stick):
>>
>> [88927.073741] ------------[ cut here ]------------
>> [88927.073762] WARNING: at drivers/net/wireless/ath/carl9170/tx.c:351
>
> I'm dropping LKML from cc, no need to write there if there is a specialized
> mailing list.
>
> It looks like the bitmap code in carl9170 needs reviewing.  I spotted
> one error immediately.  bitmap_zero() takes the number of bits, not the
> number of long integers.
>
> Chances are not very high that it would help in your case, but here's
> the patch.  I hope to give carl9170 some good testing before submitting
> that patch formally.
>
> carl9170: fix bitmap initialization
>
> From: Pavel Roskin <proski@gnu.org>
>
> bitmap_zero() takes the number of bits, not the long integers used to
> keep them.
>
> Signed-off-by: Pavel Roskin <proski@gnu.org>
> ---
>
> drivers/net/wireless/ath/carl9170/main.c |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
>
>
> diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
> index af351ec..2f68747 100644
> --- a/drivers/net/wireless/ath/carl9170/main.c
> +++ b/drivers/net/wireless/ath/carl9170/main.c
> @@ -1411,7 +1411,7 @@ static int carl9170_op_ampdu_action(struct ieee80211_hw *hw,
> 		sta_info->stats[tid].req = false;
>
> 		if (tid_info) {
> -			bitmap_zero(tid_info->bitmap, CARL9170_BAW_SIZE);
> +			bitmap_zero(tid_info->bitmap, CARL9170_BAW_BITS);
> 			tid_info->state = CARL9170_TID_STATE_IDLE;
> 		}
> 		rcu_read_unlock();
>
> -- 
> Regards,
> Pavel Roskin
>


Hi,

Patch applied to both hosts, rebooted and both running again, will let you
know if I see anything further errors, thanks.

d630:/usr/src/linux# patch -p1 < ../c
patching file drivers/net/wireless/ath/carl9170/main.c
Hunk #1 succeeded at 1360 (offset -51 lines).

atom:/usr/src/linux# patch -p1 < ../c
patching file drivers/net/wireless/ath/carl9170/main.c
Hunk #1 succeeded at 1360 (offset -51 lines).

Applied against linux-3.0.

Justin.


