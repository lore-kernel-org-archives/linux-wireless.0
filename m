Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:41926 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab2IKWAx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Sep 2012 18:00:53 -0400
Received: by ggdk6 with SMTP id k6so230318ggd.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 Sep 2012 15:00:53 -0700 (PDT)
Message-ID: <504FB53C.6050106@gmail.com> (sfid-20120912_000103_088154_E376C867)
Date: Tue, 11 Sep 2012 18:03:40 -0400
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: linux-wireless@vger.kernel.org, scchen@qca.qualcomm.com,
	linville@tuxdriver.com, johannes@sipsolutions.net,
	marco@tampabay.rr.com, janusz.dziedzic@gmail.com
Subject: Re: [PATCH] carl9170: fix spurious transmissions in sniffer mode
References: <201209112318.35334.chunkeey@googlemail.com>
In-Reply-To: <201209112318.35334.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/11/2012 05:18 PM, Christian Lamparter wrote:
> Several people have complained about an unusual
> and undocumented feature of the AR9170 hardware:
> 
> In siffer mode, the hardware generates spurious
> ACK frames for every received frame... even
> broadcasts.
> 
> The reason for this malfunction is unknown:
> <http://marc.info/?l=linux-wireless&m=134517238506033>
> But there's a workaround: Instead of the special
> sniffer mode, the hardware will be put into
> station mode and all rx filters are disabled.
I am by no means an expert here but wouldn't it be better to disable
ACK? Or is this not really an option?

Did you test to see if this actually does receive the same number of
packets as "special sniffer mode"? If so, that really should be in the
commit message imho. (I know you tested it, but since you didn't say it
the commit message reads like you didn't).

Thanks,
Zero
> 
> Reported-by: Johannes Berg <johannes@sipsolutions.net>
> Reported-by: Marco Fonseca <marco@tampabay.rr.com>
> Reported-by: Janusz Dziedzic <janusz.dziedzic@gmail.com>
> Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
> ---
>  drivers/net/wireless/ath/carl9170/mac.c |   21 ++++++++++++++++++---
>  1 file changed, 18 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/carl9170/mac.c b/drivers/net/wireless/ath/carl9170/mac.c
> index e3b1b6e..24d75ab 100644
> --- a/drivers/net/wireless/ath/carl9170/mac.c
> +++ b/drivers/net/wireless/ath/carl9170/mac.c
> @@ -343,7 +343,24 @@ int carl9170_set_operating_mode(struct ar9170 *ar)
>  			break;
>  		}
>  	} else {
> -		mac_addr = NULL;
> +		/*
> +		 * Enable monitor mode
> +		 *
> +		 * rx_ctrl |= AR9170_MAC_RX_CTRL_ACK_IN_SNIFFER;
> +		 * sniffer |= AR9170_MAC_SNIFFER_ENABLE_PROMISC;
> +		 *
> +		 * When the hardware is in SNIFFER_PROMISC mode,
> +		 * it generates spurious ACKs for every incoming
> +		 * frame. This confuses every peer in the
> +		 * vicinity and the network throughput will suffer
> +		 * badly.
> +		 *
> +		 * Hence, the hardware will be put into station
> +		 * mode and just the rx filters are disabled.
> +		 */
> +		cam_mode |= AR9170_MAC_CAM_STA;
> +		rx_ctrl |= AR9170_MAC_RX_CTRL_PASS_TO_HOST;
> +		mac_addr = common->macaddr;
>  		bssid = NULL;
>  	}
>  	rcu_read_unlock();
> @@ -355,8 +372,6 @@ int carl9170_set_operating_mode(struct ar9170 *ar)
>  		enc_mode |= AR9170_MAC_ENCRYPTION_RX_SOFTWARE;
>  
>  	if (ar->sniffer_enabled) {
> -		rx_ctrl |= AR9170_MAC_RX_CTRL_ACK_IN_SNIFFER;
> -		sniffer |= AR9170_MAC_SNIFFER_ENABLE_PROMISC;
>  		enc_mode |= AR9170_MAC_ENCRYPTION_RX_SOFTWARE;
>  	}
>  
> 

