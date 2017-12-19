Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52894 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751875AbdLSM14 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Dec 2017 07:27:56 -0500
Date: Tue, 19 Dec 2017 13:27:07 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Enrico Mioso <mrkiko.rs@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Arnd Bergmann <arnd@arndb.de>, John Crispin <john@phrozen.org>,
        nbd@nbd.name
Subject: Re: ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping
 frame due to full tx queue...?
Message-ID: <20171219122707.GA2672@redhat.com> (sfid-20171219_132759_854518_BB129F9F)
References: <alpine.LNX.2.21.99.1712112132480.7817@localhost.localdomain>
 <20171213152017.GA3554@redhat.com>
 <alpine.LNX.2.21.99.1712161924030.11214@localhost.localdomain>
 <20171218152142.GA15414@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171218152142.GA15414@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 18, 2017 at 04:21:42PM +0100, Stanislaw Gruszka wrote:
> Hi
> 
> On Sat, Dec 16, 2017 at 07:33:47PM +0100, Enrico Mioso wrote:
> > I tested the Archer MR200 device removing the patch as you suggested:
> > package/kernel/mac80211/patches/600-23-rt2x00-rt2800mmio-add-a-workaround-for-spurious-TX_F.patch
> > ... the error still appears, but the driver is still working as of now.
> > Here - reporting my dmesg
> > [  819.060392] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
> > [  819.069900] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2

Please test two patches I posted today:
https://marc.info/?l=linux-wireless&m=151368325114059&w=2
https://marc.info/?l=linux-wireless&m=151368325914062&w=2

If they do not work, please try the queue->threshold change.

Thanks
Stanislaw


> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c b/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
> index a2c1ca5c76d1..9e65b8f285e9 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
> @@ -1224,7 +1224,7 @@ static void rt2x00queue_init(struct rt2x00_dev *rt2x00dev,
>  
>  	rt2x00dev->ops->queue_init(queue);
>  
> -	queue->threshold = DIV_ROUND_UP(queue->limit, 10);
> +	queue->threshold = DIV_ROUND_UP(queue->limit, 8);
>  }
>  
>  int rt2x00queue_allocate(struct rt2x00_dev *rt2x00dev)
