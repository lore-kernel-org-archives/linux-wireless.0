Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:55006 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727389AbeHWN3Y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Aug 2018 09:29:24 -0400
Date: Thu, 23 Aug 2018 15:30:21 +0530
From: Ajay Singh <ajay.kathat@microchip.com>
To: Claudiu Beznea <Claudiu.Beznea@microchip.com>
CC: <linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <gregkh@linuxfoundation.org>, <ganesh.krishna@microchip.com>,
        <venkateswara.kaja@microchip.com>, <aditya.shankar@microchip.com>,
        <adham.abozaeid@microchip.com>
Subject: Re: [PATCH 10/24] staging: wilc1000: move
 wilc_multicast_mac_addr_list to 'wilc_vif' struct
Message-ID: <20180823153021.3ad58351@ajaysk-VirtualBox> (sfid-20180823_120031_155405_F8B8381E)
In-Reply-To: <92faa952-6722-cc9f-cccf-2275c4158a37@microchip.com>
References: <1534229416-13254-1-git-send-email-ajay.kathat@microchip.com>
        <1534229416-13254-11-git-send-email-ajay.kathat@microchip.com>
        <92faa952-6722-cc9f-cccf-2275c4158a37@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 23 Aug 2018 11:10:48 +0300
Claudiu Beznea <Claudiu.Beznea@microchip.com> wrote:

> On 14.08.2018 09:50, Ajay Singh wrote:
> > Instead of using 'wilc_multicast_mac_addr_list' as global variable
> > move it part of wilc_vif struct. Rename
> > 'wilc_multicast_mac_addr_list' variable to 'mc_mac_addr_list' as
> > its now part of 'wilc_vif' struct.
> > 
> > Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> > ---
> >  drivers/staging/wilc1000/host_interface.c     |  4 +---
> >  drivers/staging/wilc1000/host_interface.h     |  1 -
> >  drivers/staging/wilc1000/linux_wlan.c         | 14 +++++++-------
> >  drivers/staging/wilc1000/wilc_wfi_netdevice.h |  1 +
> >  4 files changed, 9 insertions(+), 11 deletions(-)
> > 
> > diff --git a/drivers/staging/wilc1000/host_interface.c
> > b/drivers/staging/wilc1000/host_interface.c index d930f06..642c314
> > 100644 --- a/drivers/staging/wilc1000/host_interface.c
> > +++ b/drivers/staging/wilc1000/host_interface.c
> > @@ -193,8 +193,6 @@ static struct mutex hif_deinit_lock;
> >  static struct timer_list periodic_rssi;
> >  static struct wilc_vif *periodic_rssi_vif;
> >  
> > -u8
> > wilc_multicast_mac_addr_list[WILC_MULTICAST_TABLE_SIZE][ETH_ALEN]; -
> >  static u8 rcv_assoc_resp[MAX_ASSOC_RESP_FRAME_SIZE];
> >  
> >  static u8 set_ip[2][4];
> > @@ -2588,7 +2586,7 @@ static void handle_set_mcast_filter(struct
> > work_struct *work) *cur_byte++ = ((hif_set_mc->cnt >> 24) & 0xFF);
> >  
> >  	if (hif_set_mc->cnt > 0)
> > -		memcpy(cur_byte, wilc_multicast_mac_addr_list,
> > +		memcpy(cur_byte, vif->mc_mac_addr_list,  
> 
> A locking mechanism should be used for vif->mc_mac_addr_list. It is
> read here.

Below is my understanding. 

wilc_set_multicast_list() is called from 'ndo_set_rx_mode' callback.
 
wilc_set_multicast_list() calls wilc_setup_multicast_filter() which
only read the value from the array and don't write to it when below
if conditions pass.

if (dev->flags &
IFF_ALLMULTI || dev->mc.count > WILC_MULTICAST_TABLE_SIZE) 

if (dev->mc.count == 0)
 
For the scenario when above 'if' conditions fails then value will be
write to array first followed by read operation which will happen
in different context(worker thread).

Unless ndo_set_rx_mode() gets called quickly I don't think there is any
issue here. 

If required instead of adding the lock how about making
handle_set_mcast_filter() a sync call in further patches, so that it can
complete handle_set_mcast_filter() operation before coming out of
ndo_set_rx_mode() callback.

Actually, I am also worried if its right to add 'lock' at this
point without reproducing the issue and only based on the code
observation.

Regards,
Ajay

> 
> >  		       ((hif_set_mc->cnt) * ETH_ALEN));
> >  
> >  	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
> > diff --git a/drivers/staging/wilc1000/host_interface.h
> > b/drivers/staging/wilc1000/host_interface.h index d026f44..4a84dd2
> > 100644 --- a/drivers/staging/wilc1000/host_interface.h
> > +++ b/drivers/staging/wilc1000/host_interface.h
> > @@ -362,7 +362,6 @@ int wilc_set_tx_power(struct wilc_vif *vif, u8
> > tx_power); int wilc_get_tx_power(struct wilc_vif *vif, u8
> > *tx_power); 
> >  extern u8 wilc_connected_ssid[6];
> > -extern u8
> > wilc_multicast_mac_addr_list[WILC_MULTICAST_TABLE_SIZE][ETH_ALEN]; 
> >  extern int wilc_connecting;
> >  
> > diff --git a/drivers/staging/wilc1000/linux_wlan.c
> > b/drivers/staging/wilc1000/linux_wlan.c index 283bb74..bbaa653
> > 100644 --- a/drivers/staging/wilc1000/linux_wlan.c
> > +++ b/drivers/staging/wilc1000/linux_wlan.c
> > @@ -822,14 +822,14 @@ static void wilc_set_multicast_list(struct
> > net_device *dev) }
> >  
> >  	netdev_for_each_mc_addr(ha, dev) {
> > -		memcpy(wilc_multicast_mac_addr_list[i], ha->addr,
> > ETH_ALEN);
> > +		memcpy(vif->mc_mac_addr_list[i], ha->addr,
> > ETH_ALEN);  
> 
> and set here. The contexts are different. If not in this patch, then
> in a future one.
> 
> >  		netdev_dbg(dev, "Entry[%d]: %x:%x:%x:%x:%x:%x\n",
> > i,
> > -			   wilc_multicast_mac_addr_list[i][0],
> > -			   wilc_multicast_mac_addr_list[i][1],
> > -			   wilc_multicast_mac_addr_list[i][2],
> > -			   wilc_multicast_mac_addr_list[i][3],
> > -			   wilc_multicast_mac_addr_list[i][4],
> > -			   wilc_multicast_mac_addr_list[i][5]);
> > +			   vif->mc_mac_addr_list[i][0],
> > +			   vif->mc_mac_addr_list[i][1],
> > +			   vif->mc_mac_addr_list[i][2],
> > +			   vif->mc_mac_addr_list[i][3],
> > +			   vif->mc_mac_addr_list[i][4],
> > +			   vif->mc_mac_addr_list[i][5]);
> >  		i++;
> >  	}
> >  
> > diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
> > b/drivers/staging/wilc1000/wilc_wfi_netdevice.h index
> > 8cccbbc..ee8eda7 100644 ---
> > a/drivers/staging/wilc1000/wilc_wfi_netdevice.h +++
> > b/drivers/staging/wilc1000/wilc_wfi_netdevice.h @@ -120,6 +120,7 @@
> > struct wilc_vif { u8 ifc_id;
> >  	struct timer_list during_ip_timer;
> >  	bool obtaining_ip;
> > +	u8 mc_mac_addr_list[WILC_MULTICAST_TABLE_SIZE][ETH_ALEN];
> >  };
> >  
> >  struct wilc {
> >   
