Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:53434 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab2EJXz7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 19:55:59 -0400
Date: Thu, 10 May 2012 16:55:56 -0700
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: Hewitt Lee <hewittl@synology.com>
CC: Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	Synology/KueiHuan Chen <khchen@synology.com>,
	andysuper Wang <minhongw@synology.com>
Subject: Re: [PATCH] ath9k : stability issue in a noisy environment
Message-ID: <20120510235556.GB26950@tux> (sfid-20120511_015603_830771_2A65186C)
References: <CABCXq82J7UL2y6Zzt=Rm8XgAdnQeVMp4xOG-fnVU1uFEmooyZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CABCXq82J7UL2y6Zzt=Rm8XgAdnQeVMp4xOG-fnVU1uFEmooyZQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 09, 2012 at 08:12:38PM +0800, Hewitt Lee wrote:
>    Hi All,
>    This patch unlink a skb comes from ath_tx_form_aggr() which is freed at
>    ath_tx_get_buffer() when tx buffers are full.
>    Please kindly review it.

Please see:

http://wireless.kernel.org/en/developers/Documentation/SubmittingPatches

Also please provide a clear description of what you are trying to fix,
what happens without the patch, what happens with the patch. My review
below.

>    Thanks.
>    diff --git a/v3.3.x/drivers/net/wireless/ath/ath9k/xmit.c
>    b/v3.3.x/drivers/net/wireless/ath/ath9k/xmit.c
>    old mode 100644
>    new mode 100755
>    index 3182408..f4e1e62
>    --- a/v3.3.x/drivers/net/wireless/ath/ath9k/xmit.c
>    +++ b/v3.3.x/drivers/net/wireless/ath/ath9k/xmit.c
>    @@ -1858,6 +1858,12 @@ static struct ath_buf *ath_tx_setup_buffer(struct
>    ath_softc *sc,
>       return bf;
>     
>     error:
>    +  if (tid) {
>    +  if (skb == skb_peek(&tid->buf_q)) {
>    +  __skb_unlink(skb, &tid->buf_q);
>    +  }
>    +  }
>    +
>       dev_kfree_skb_any(skb);
>       return NULL;
>     }

Yeah I have no idea why you are doing this here, based on your description
the skb will be free'd at ath_tx_get_buffer() but ath_tx_get_buffer()
does not free anything. Can you please be sure to check first against
the latest development tree for 802.11 first?

  Luis
