Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:42663 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445AbaAQMZI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jan 2014 07:25:08 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath10k: fix the MAC address of peer statistic
References: <1389345564-21042-1-git-send-email-yeohchunyeow@gmail.com>
Date: Fri, 17 Jan 2014 14:24:56 +0200
In-Reply-To: <1389345564-21042-1-git-send-email-yeohchunyeow@gmail.com>
	(Chun-Yeow Yeoh's message of "Fri, 10 Jan 2014 17:19:24 +0800")
Message-ID: <87txd2re1z.fsf@kamboji.qca.qualcomm.com> (sfid-20140117_132515_644901_1220F614)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chun-Yeow Yeoh <yeohchunyeow@gmail.com> writes:

> Fix the MAC address of wmi_peer_stats so that it is
> printed correctly. This is tested and verified using
> firmware version 999.999.0.636.
>
> Based on the verification, maximum only 3 peer statistics including 
> self STA able to be printed out.
>
> Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
> ---
> v2: offset the stats to ignore the first peer (Chun-Yeow)

I think something is wrong still. I tested this with 999.999.0.636 on
x86 32 bit laptop in AP mode, connected STA 00:24:d7:9b:0b:7c to it and
still MAC address is wrong:

              PHY errors drops          0
   MPDU errors (FCS, MIC, ENC)          0

             ath10k PEER stats
             =================

              Peer MAC address 9b:d7:24:00:00:00
                     Peer RSSI 36
                  Peer TX rate 0

Without your patch it's also wrong:

             ath10k PEER stats
             =================

              Peer MAC address 00:00:00:00:02:00
                     Peer RSSI 3
                  Peer TX rate 0

              Peer MAC address 00:00:00:00:00:24
                     Peer RSSI 31755
                  Peer TX rate 0

Any ideas what's happening here?

> --- a/drivers/net/wireless/ath/ath10k/debug.c
> +++ b/drivers/net/wireless/ath/ath10k/debug.c
> @@ -242,6 +242,10 @@ void ath10k_debug_read_target_stats(struct ath10k *ar,
>  		}
>  	}
>  
> +	/* The first peer is self MAC address, ignore this */
> +	num_peer_stats--;
> +	tmp += sizeof(struct wmi_peer_stats);

Should we show "self peer" separately? Does it provide any useful
information?

-- 
Kalle Valo
