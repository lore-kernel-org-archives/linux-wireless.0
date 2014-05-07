Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46602 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971AbaEGUAZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 16:00:25 -0400
Date: Wed, 7 May 2014 15:54:36 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	ath9k-devel@venema.h4ckr.net,
	Oleksij Rempel <linux@rempel-privat.de>
Subject: Re: [PATCH] ath9k: fix NULL-deref in hw_per_calibration() for ar9002
Message-ID: <20140507195435.GF20432@tuxdriver.com> (sfid-20140507_220031_058352_CB325137)
References: <1399447378-31503-1-git-send-email-dh.herrmann@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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
> Thanks
> David

Is there any hope for getting a more complete fix from the ath9k guys
in short order?

John

> 
>  drivers/net/wireless/ath/ath9k/ar9002_calib.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/ar9002_calib.c b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
> index cdc7400..4667ab9 100644
> --- a/drivers/net/wireless/ath/ath9k/ar9002_calib.c
> +++ b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
> @@ -99,14 +99,16 @@ static bool ar9002_hw_per_calibration(struct ath_hw *ah,
>  				}
>  
>  				currCal->calData->calPostProc(ah, numChains);
> -				caldata->CalValid |= currCal->calData->calType;
> +				if (caldata)
> +					caldata->CalValid |= currCal->calData->calType;
> +
>  				currCal->calState = CAL_DONE;
>  				iscaldone = true;
>  			} else {
>  				ar9002_hw_setup_calibration(ah, currCal);
>  			}
>  		}
> -	} else if (!(caldata->CalValid & currCal->calData->calType)) {
> +	} else if (caldata && !(caldata->CalValid & currCal->calData->calType)) {
>  		ath9k_hw_reset_calibration(ah, currCal);
>  	}
>  
> -- 
> 1.9.2
> 
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
