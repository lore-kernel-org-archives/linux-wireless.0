Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.238]:61206 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbZCEXvE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Mar 2009 18:51:04 -0500
Received: by rv-out-0506.google.com with SMTP id g37so187993rvb.1
        for <linux-wireless@vger.kernel.org>; Thu, 05 Mar 2009 15:51:02 -0800 (PST)
Subject: Re: kernel BUG at drivers/net/wireless/iwlwifi/iwl3945-base.c:3127!
From: Jason Andryuk <jandryuk@gmail.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: Samuel Ortiz <samuel@sortiz.org>, Tomas Winkler <tomasw@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1236211493.6612.90.camel@rc-desk>
References: <760481.57662.qm@web57614.mail.re1.yahoo.com>
	 <c4d76b3b0901261913s23427b19tbbe34ee7b4261068@mail.gmail.com>
	 <c4d76b3b0901261935n1846b675w72cfa7308d198080@mail.gmail.com>
	 <20090127162437.GA3596@sortiz.org>
	 <c4d76b3b0901271531q19578871idbc59b5a23ac868e@mail.gmail.com>
	 <1ba2fa240901272312j270eedb5x33534a9703d26e06@mail.gmail.com>
	 <20090128113751.GA3197@sortiz.org>
	 <c4d76b3b0903011937p6538adbfpc0dab859a6742394@mail.gmail.com>
	 <1236141120.12734.2.camel@rainbow> <1236194370.6612.73.camel@rc-desk>
	 <c4d76b3b0903041147s2138e72bjb39864f87b4cd09e@mail.gmail.com>
	 <1236211493.6612.90.camel@rc-desk>
Content-Type: text/plain
Date: Thu, 05 Mar 2009 18:50:52 -0500
Message-Id: <1236297052.6153.4.camel@rainbow> (sfid-20090306_005113_246702_F81ACE62)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-03-04 at 16:04 -0800, reinette chatre wrote:
> On Wed, 2009-03-04 at 11:47 -0800, Jason Andryuk wrote:
> > On Wed, Mar 4, 2009 at 2:19 PM, reinette chatre
> > <reinette.chatre@intel.com> wrote:
> > > On Tue, 2009-03-03 at 20:32 -0800, Jason Andryuk wrote:
> > >> On Sun, Mar 1, 2009 at 10:37 PM, Jason Andryuk <jandryuk@gmail.com> wrote:
> > >> > I tested c2a0aa3cb733452e749727680e380dca6cc10a68 "iwl3945: use
> > >> > iwl_rb_status" with the additional patches to initialize rb_stts
> > >> > (copied from iwl_rx_queue_alloc) and to convert the BUG_ON to a
> > >> > WARN_ON.
> > >> >
> > >> > The driver runs without segfaulting.  So far the WARN_ON has not been
> > >> > triggered, but the driver fails to finish authentication with the AP.
> > >> > I receive "wlan0: authentication with AP 00:30:bd:c0:90:24 timed out"
> > >>
> > >> Ok, I started poking around with manually checking interesting commits instead of git bisect.
> > >>
> > >> 55b3e21... iwl3945: use iwl-io.h and delete iwl-3945-io.h with BUG->WARN patch works.
> > >>
> > >> bb64785... iwlwifi: use iwl_cmd instead of iwl3945_cmd
> > >> fails to authenticate to the AP.  It generates a Microcode SW Error attached below.
> > >>
> > >> The previous revision:
> > >> a0dedce... iwlwifi: replace IWL_ERROR with IWL_ERR
> > >> Authenticates to the AP and works just fine.
> > >>
> > >> I keep looking over commitdiff bb64785... but I cannot see what is causing problems.  I even tried modifying iwl3945_cmd in various ways from a0dedce... but those attempts kept working.
> > >>
> > >> During testing, I saw a lot of UNKNOWN 0x1b
> > >> [ 8892.625374] ieee80211 phy0: I iwl3945_rx_handle r = 162, i = 160, UNKNOWN, 0x1b
> > >> Currently in the logs for commit a0dedce... it shows up as REPLY_3945_RX.
> > >>
> > >> Any ideas?
> > >
> > > Thank you very much for this digging.
> > >
> > > Are you running on 64bit?
> > 
> > Yes, 64bit.
> 
> could you please try this patch on top of latest wireless-testing?
> 
> Thanks
> 
> Reinette
> 
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
> index 0a75053..00b25a8 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-3945.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
> @@ -743,6 +743,7 @@ void iwl3945_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq)
>  	struct iwl3945_tfd *tfd_tmp = (struct iwl3945_tfd *)txq->tfds;
>  	struct iwl3945_tfd *tfd = &tfd_tmp[txq->q.read_ptr];
>  	struct pci_dev *dev = priv->pci_dev;
> +	int index = txq->q.read_ptr;
>  	int i;
>  	int counter;
>  
> @@ -759,6 +760,13 @@ void iwl3945_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq)
>  		return;
>  	}
>  
> +	/* Unmap tx_cmd */
> +	if (counter)
> +		pci_unmap_single(dev,
> +				pci_unmap_addr(&txq->cmd[index]->meta, mapping),
> +				pci_unmap_len(&txq->cmd[index]->meta, len),
> +				PCI_DMA_TODEVICE);
> +
>  	/* unmap chunks if any */
>  
>  	for (i = 1; i < counter; i++) {

Reinette,

I applied the patch, but iwl3945 did not authenticate with my AP

Jason

Mar  5 18:41:38 rainbow kernel: [   24.955251] iwl3945 0000:03:00.0: firmware: requesting iwlwifi-3945-2.ucode
Mar  5 18:41:39 rainbow kernel: [   25.018529] iwl3945 0000:03:00.0: loaded firmware version 15.28.2.8
Mar  5 18:41:39 rainbow kernel: [   25.034449] ieee80211 phy0: I iwl3945_rx_handle r = 1, i = 0, REPLY_ALIVE, 0x01
Mar  5 18:41:39 rainbow kernel: [   25.045803] ieee80211 phy0: I iwl3945_rx_handle r = 2, i = 1, REPLY_ALIVE, 0x01
Mar  5 18:41:39 rainbow kernel: [   25.060717] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_BT_CONFIG (#9b), seq: 0x0400, 16 bytes at 0[0]:4
Mar  5 18:41:39 rainbow kernel: [   25.060810] ieee80211 phy0: I iwl3945_rx_handle r 3 i 2 No handler needed for REPLY_BT_CONFIG, 0x9b
Mar  5 18:41:39 rainbow kernel: [   25.060825] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x0401, 48 bytes at 1[1]:4
Mar  5 18:41:39 rainbow kernel: [   25.062153] ieee80211 phy0: I iwl3945_rx_handle r 4 i 3 No handler needed for REPLY_RXON, 0x10
Mar  5 18:41:39 rainbow kernel: [   25.062192] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x0402, 56 bytes at 2[2]:4
Mar  5 18:41:39 rainbow kernel: [   25.062329] ieee80211 phy0: I iwl3945_rx_handle r 5 i 4 No handler needed for REPLY_TX_PWR_TABLE_CMD, 0x97
Mar  5 18:41:39 rainbow kernel: [   25.062342] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0403, 68 bytes at 3[3]:4
Mar  5 18:41:39 rainbow kernel: [   25.062449] ieee80211 phy0: I iwl3945_rx_handle r = 6, i = 5, REPLY_ADD_STA, 0x18
Mar  5 18:41:39 rainbow kernel: [   25.062495] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0404, 56 bytes at 4[4]:4
Mar  5 18:41:39 rainbow kernel: [   25.062595] ieee80211 phy0: I iwl3945_rx_handle r 7 i 6 No handler needed for REPLY_RATE_SCALE, 0x47
Mar  5 18:41:39 rainbow kernel: [   25.062606] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0405, 56 bytes at 5[5]:4
Mar  5 18:41:39 rainbow kernel: [   25.062698] ieee80211 phy0: I iwl3945_rx_handle r 8 i 7 No handler needed for REPLY_RATE_SCALE, 0x47
Mar  5 18:41:39 rainbow kernel: [   25.062755] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x0406, 56 bytes at 6[6]:4
Mar  5 18:41:39 rainbow kernel: [   25.063085] ieee80211 phy0: I iwl3945_rx_handle r 9 i 8 No handler needed for REPLY_TX_PWR_TABLE_CMD, 0x97
Mar  5 18:41:39 rainbow kernel: [   25.063136] Registered led device: iwl-phy0::radio
Mar  5 18:41:39 rainbow kernel: [   25.063140] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0407, 12 bytes at 7[7]:4
Mar  5 18:41:39 rainbow kernel: [   25.063154] Registered led device: iwl-phy0::assoc
Mar  5 18:41:39 rainbow kernel: [   25.063167] Registered led device: iwl-phy0::RX
Mar  5 18:41:39 rainbow kernel: [   25.063180] Registered led device: iwl-phy0::TX
Mar  5 18:41:39 rainbow kernel: [   25.063200] ieee80211 phy0: I iwl3945_rx_handle r 10 i 9 No handler needed for REPLY_LEDS_CMD, 0x48
Mar  5 18:41:39 rainbow kernel: [   25.063212] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0408, 12 bytes at 8[8]:4
Mar  5 18:41:39 rainbow kernel: [   25.063218] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x0409, 48 bytes at 9[9]:4
Mar  5 18:41:39 rainbow kernel: [   25.063303] ieee80211 phy0: I iwl3945_rx_handle r 11 i 10 No handler needed for REPLY_LEDS_CMD, 0x48
Mar  5 18:41:39 rainbow kernel: [   25.063442] ieee80211 phy0: I iwl3945_rx_handle r 12 i 11 No handler needed for REPLY_RXON, 0x10
Mar  5 18:41:39 rainbow kernel: [   25.063492] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x040A, 56 bytes at 10[10]:4
Mar  5 18:41:39 rainbow kernel: [   25.064901] ieee80211 phy0: I iwl3945_rx_handle r = 14, i = 12, REPLY_3945_RX, 0x1b
Mar  5 18:41:39 rainbow kernel: [   25.064911] ieee80211 phy0: I iwl3945_rx_handle r 14 i 13 No handler needed for REPLY_TX_PWR_TABLE_CMD, 0x97
Mar  5 18:41:39 rainbow kernel: [   25.064925] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x040B, 68 bytes at 11[11]:4
Mar  5 18:41:39 rainbow kernel: [   25.064965] ieee80211 phy0: I iwl3945_rx_handle r = 15, i = 14, REPLY_ADD_STA, 0x18
Mar  5 18:41:39 rainbow kernel: [   25.064970] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x040C, 56 bytes at 12[12]:4
Mar  5 18:41:39 rainbow kernel: [   25.065010] ieee80211 phy0: I iwl3945_rx_handle r 16 i 15 No handler needed for REPLY_RATE_SCALE, 0x47
Mar  5 18:41:39 rainbow kernel: [   25.065010] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x040D, 56 bytes at 13[13]:4
Mar  5 18:41:39 rainbow kernel: [   25.065090] ieee80211 phy0: I iwl3945_rx_handle r 17 i 16 No handler needed for REPLY_RATE_SCALE, 0x47
Mar  5 18:41:39 rainbow kernel: [   25.074052] ieee80211 phy0: I iwl3945_rx_handle r = 18, i = 17, REPLY_3945_RX, 0x1b
Mar  5 18:41:39 rainbow kernel: [   25.078664] ieee80211 phy0: I iwl3945_rx_handle r = 19, i = 18, REPLY_3945_RX, 0x1b
Mar  5 18:41:39 rainbow kernel: [   25.081337] ieee80211 phy0: I iwl3945_rx_handle r = 20, i = 19, REPLY_3945_RX, 0x1b
Mar  5 18:41:39 rainbow kernel: [   25.095453] ieee80211 phy0: I iwl3945_rx_handle r = 21, i = 20, REPLY_3945_RX, 0x1b
Mar  5 18:41:39 rainbow kernel: [   25.104505] ieee80211 phy0: I iwl3945_rx_handle r = 22, i = 21, REPLY_3945_RX, 0x1b
Mar  5 18:41:39 rainbow kernel: [   25.110285] ieee80211 phy0: I iwl3945_rx_handle r = 23, i = 22, REPLY_3945_RX, 0x1b
Mar  5 18:41:39 rainbow kernel: [   25.112078] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x040E, 48 bytes at 14[14]:4
Mar  5 18:41:39 rainbow kernel: [   25.112251] ieee80211 phy0: I iwl3945_rx_handle r 24 i 23 No handler needed for REPLY_RXON, 0x10
Mar  5 18:41:39 rainbow kernel: [   25.112409] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x040F, 56 bytes at 15[15]:4
Mar  5 18:41:39 rainbow kernel: [   25.112497] ieee80211 phy0: I iwl3945_rx_handle r 25 i 24 No handler needed for REPLY_TX_PWR_TABLE_CMD, 0x97
Mar  5 18:41:39 rainbow kernel: [   25.112510] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0410, 68 bytes at 16[16]:4
Mar  5 18:41:39 rainbow kernel: [   25.112601] ieee80211 phy0: I iwl3945_rx_handle r = 26, i = 25, REPLY_ADD_STA, 0x18
Mar  5 18:41:39 rainbow kernel: [   25.112613] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0411, 56 bytes at 17[17]:4
Mar  5 18:41:39 rainbow kernel: [   25.112675] ieee80211 phy0: I iwl3945_rx_handle r 27 i 26 No handler needed for REPLY_RATE_SCALE, 0x47
Mar  5 18:41:39 rainbow kernel: [   25.112716] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0412, 56 bytes at 18[18]:4
Mar  5 18:41:39 rainbow kernel: [   25.112803] ieee80211 phy0: I iwl3945_rx_handle r 28 i 27 No handler needed for REPLY_RATE_SCALE, 0x47
Mar  5 18:41:39 rainbow kernel: [   25.113244] ADDRCONF(NETDEV_UP): wlan0: link is not ready
Mar  5 18:41:39 rainbow kernel: [   25.119058] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x4413, 350 bytes at 19[32]:4
Mar  5 18:41:39 rainbow kernel: [   25.119221] ieee80211 phy0: I iwl3945_rx_handle r = 29, i = 28, REPLY_SCAN_CMD, 0x80
Mar  5 18:41:39 rainbow kernel: [   25.120367] ieee80211 phy0: I iwl3945_rx_handle r = 31, i = 29, STATISTICS_NOTIFICATION, 0x9d
Mar  5 18:41:39 rainbow kernel: [   25.120372] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0414, 12 bytes at 20[20]:4
Mar  5 18:41:39 rainbow kernel: [   25.120382] ieee80211 phy0: I iwl3945_rx_handle r = 31, i = 30, SCAN_START_NOTIFICATION, 0x82
Mar  5 18:41:39 rainbow kernel: [   25.120956] ieee80211 phy0: I iwl3945_rx_handle r 32 i 31 No handler needed for REPLY_LEDS_CMD, 0x48
Mar  5 18:41:39 rainbow kernel: [   25.133028] ieee80211 phy0: I iwl3945_rx_handle r = 33, i = 32, SCAN_RESULTS_NOTIFICATION, 0x83
Mar  5 18:41:39 rainbow kernel: [   25.134022] ieee80211 phy0: I iwl3945_rx_handle r = 35, i = 33, STATISTICS_NOTIFICATION, 0x9d
Mar  5 18:41:39 rainbow kernel: [   25.134030] ieee80211 phy0: I iwl3945_rx_handle r = 35, i = 34, SCAN_START_NOTIFICATION, 0x82
Mar  5 18:41:39 rainbow kernel: [   25.136851] ieee80211 phy0: I iwl3945_rx_handle r = 36, i = 35, REPLY_3945_RX, 0x1b
Mar  5 18:41:39 rainbow kernel: [   25.142085] ieee80211 phy0: I iwl3945_rx_handle r = 37, i = 36, REPLY_3945_RX, 0x1b
Mar  5 18:41:39 rainbow kernel: [   25.148130] ieee80211 phy0: I iwl3945_rx_handle r = 38, i = 37, REPLY_3945_RX, 0x1b
Mar  5 18:41:39 rainbow kernel: [   25.158296] ieee80211 phy0: I iwl3945_rx_handle r = 39, i = 38, REPLY_3945_RX, 0x1b
Mar  5 18:41:39 rainbow kernel: [   25.173946] ieee80211 phy0: I iwl3945_rx_handle r = 40, i = 39, SCAN_RESULTS_NOTIFICATION, 0x83
Mar  5 18:41:39 rainbow kernel: [   25.174910] ieee80211 phy0: I iwl3945_rx_handle r = 42, i = 40, STATISTICS_NOTIFICATION, 0x9d
Mar  5 18:41:39 rainbow kernel: [   25.174919] ieee80211 phy0: I iwl3945_rx_handle r = 42, i = 41, SCAN_START_NOTIFICATION, 0x82
Mar  5 18:41:39 rainbow kernel: [   25.177743] ieee80211 phy0: I iwl3945_rx_handle r = 43, i = 42, REPLY_3945_RX, 0x1b
Mar  5 18:41:39 rainbow kernel: [   25.181083] ieee80211 phy0: I iwl3945_rx_handle r = 44, i = 43, REPLY_3945_RX, 0x1b
Mar  5 18:41:39 rainbow kernel: [   25.199082] ieee80211 phy0: I iwl3945_rx_handle r = 45, i = 44, REPLY_3945_RX, 0x1b
Mar  5 18:41:39 rainbow kernel: [   25.214867] ieee80211 phy0: I iwl3945_rx_handle r = 46, i = 45, SCAN_RESULTS_NOTIFICATION, 0x83
Mar  5 18:41:39 rainbow kernel: [   25.215913] ieee80211 phy0: I iwl3945_rx_handle r = 48, i = 46, STATISTICS_NOTIFICATION, 0x9d
Mar  5 18:41:39 rainbow kernel: [   25.215927] ieee80211 phy0: I iwl3945_rx_handle r = 48, i = 47, SCAN_START_NOTIFICATION, 0x82
Mar  5 18:41:39 rainbow kernel: [   25.229182] ieee80211 phy0: I iwl3945_rx_handle r = 49, i = 48, SCAN_RESULTS_NOTIFICATION, 0x83
Mar  5 18:41:39 rainbow kernel: [   25.230146] ieee80211 phy0: I iwl3945_rx_handle r = 51, i = 49, STATISTICS_NOTIFICATION, 0x9d
Mar  5 18:41:39 rainbow kernel: [   25.230167] ieee80211 phy0: I iwl3945_rx_handle r = 51, i = 50, SCAN_START_NOTIFICATION, 0x82
Mar  5 18:41:39 rainbow kernel: [   25.231417] NET: Registered protocol family 17
Mar  5 18:41:39 rainbow kernel: [   25.239284] ieee80211 phy0: I iwl3945_rx_handle r = 52, i = 51, REPLY_3945_RX, 0x1b
Mar  5 18:41:39 rainbow kernel: [   25.243016] ieee80211 phy0: I iwl3945_rx_handle r = 53, i = 52, SCAN_RESULTS_NOTIFICATION, 0x83
Mar  5 18:41:39 rainbow kernel: [   25.244042] ieee80211 phy0: I iwl3945_rx_handle r = 55, i = 53, STATISTICS_NOTIFICATION, 0x9d
Mar  5 18:41:39 rainbow kernel: [   25.244063] ieee80211 phy0: I iwl3945_rx_handle r = 55, i = 54, SCAN_START_NOTIFICATION, 0x82
Mar  5 18:41:39 rainbow kernel: [   25.246868] ieee80211 phy0: I iwl3945_rx_handle r = 56, i = 55, REPLY_3945_RX, 0x1b
Mar  5 18:41:39 rainbow kernel: [   25.249107] ieee80211 phy0: I iwl3945_rx_handle r = 57, i = 56, REPLY_3945_RX, 0x1b
Mar  5 18:41:39 rainbow kernel: [   25.250619] ieee80211 phy0: I iwl3945_rx_handle r = 58, i = 57, REPLY_3945_RX, 0x1b
Mar  5 18:41:39 rainbow kernel: [   25.252101] ieee80211 phy0: I iwl3945_rx_handle r = 59, i = 58, REPLY_3945_RX, 0x1b
Mar  5 18:41:39 rainbow kernel: [   25.255401] ieee80211 phy0: I iwl3945_rx_handle r = 60, i = 59, REPLY_3945_RX, 0x1b
Mar  5 18:41:39 rainbow kernel: [   25.259940] ieee80211 phy0: I iwl3945_rx_handle r = 61, i = 60, REPLY_3945_RX, 0x1b
Mar  5 18:41:39 rainbow kernel: [   25.260990] ieee80211 phy0: I iwl3945_rx_handle r = 62, i = 61, REPLY_3945_RX, 0x1b
Mar  5 18:41:39 rainbow kernel: [   25.265644] ieee80211 phy0: I iwl3945_rx_handle r = 63, i = 62, REPLY_3945_RX, 0x1b
Mar  5 18:41:39 rainbow kernel: [   25.274360] ieee80211 phy0: I iwl3945_rx_handle r = 64, i = 63, REPLY_3945_RX, 0x1b
Mar  5 18:41:39 rainbow kernel: [   25.280280] ieee80211 phy0: I iwl3945_rx_handle r = 65, i = 64, REPLY_3945_RX, 0x1b
Mar  5 18:41:39 rainbow kernel: [   25.281763] ieee80211 phy0: I iwl3945_rx_handle r = 66, i = 65, REPLY_3945_RX, 0x1b
Mar  5 18:41:39 rainbow kernel: [   25.283977] ieee80211 phy0: I iwl3945_rx_handle r = 67, i = 66, SCAN_RESULTS_NOTIFICATION, 0x83
Mar  5 18:41:39 rainbow kernel: [   25.285016] ieee80211 phy0: I iwl3945_rx_handle r = 69, i = 67, STATISTICS_NOTIFICATION, 0x9d
Mar  5 18:41:39 rainbow kernel: [   25.285036] ieee80211 phy0: I iwl3945_rx_handle r = 69, i = 68, SCAN_START_NOTIFICATION, 0x82
Mar  5 18:41:39 rainbow kernel: [   25.296494] ieee80211 phy0: I iwl3945_rx_handle r = 70, i = 69, REPLY_3945_RX, 0x1b
Mar  5 18:41:39 rainbow kernel: [   25.297617] ieee80211 phy0: I iwl3945_rx_handle r = 71, i = 70, SCAN_RESULTS_NOTIFICATION, 0x83
Mar  5 18:41:39 rainbow kernel: [   25.298591] ieee80211 phy0: I iwl3945_rx_handle r = 73, i = 71, STATISTICS_NOTIFICATION, 0x9d
Mar  5 18:41:39 rainbow kernel: [   25.298610] ieee80211 phy0: I iwl3945_rx_handle r = 73, i = 72, SCAN_START_NOTIFICATION, 0x82
Mar  5 18:41:39 rainbow kernel: [   25.301568] ieee80211 phy0: I iwl3945_rx_handle r = 74, i = 73, REPLY_3945_RX, 0x1b
Mar  5 18:41:39 rainbow kernel: [   25.318490] ieee80211 phy0: I iwl3945_rx_handle r = 75, i = 74, REPLY_3945_RX, 0x1b
Mar  5 18:41:39 rainbow kernel: [   25.323609] ieee80211 phy0: I iwl3945_rx_handle r = 76, i = 75, REPLY_3945_RX, 0x1b
Mar  5 18:41:39 rainbow kernel: [   25.338544] ieee80211 phy0: I iwl3945_rx_handle r = 77, i = 76, SCAN_RESULTS_NOTIFICATION, 0x83
Mar  5 18:41:39 rainbow kernel: [   25.339513] ieee80211 phy0: I iwl3945_rx_handle r = 79, i = 77, STATISTICS_NOTIFICATION, 0x9d
Mar  5 18:41:39 rainbow kernel: [   25.339535] ieee80211 phy0: I iwl3945_rx_handle r = 79, i = 78, SCAN_START_NOTIFICATION, 0x82
Mar  5 18:41:39 rainbow kernel: [   25.347864] ieee80211 phy0: I iwl3945_rx_handle r = 80, i = 79, REPLY_3945_RX, 0x1b
Mar  5 18:41:39 rainbow kernel: [   25.351726] ieee80211 phy0: I iwl3945_rx_handle r = 81, i = 80, SCAN_RESULTS_NOTIFICATION, 0x83
Mar  5 18:41:39 rainbow kernel: [   25.352722] ieee80211 phy0: I iwl3945_rx_handle r = 83, i = 81, STATISTICS_NOTIFICATION, 0x9d
Mar  5 18:41:39 rainbow kernel: [   25.352742] ieee80211 phy0: I iwl3945_rx_handle r = 83, i = 82, SCAN_START_NOTIFICATION, 0x82
Mar  5 18:41:39 rainbow kernel: [   25.354452] ieee80211 phy0: I iwl3945_rx_handle r = 84, i = 83, REPLY_3945_RX, 0x1b
Mar  5 18:41:39 rainbow kernel: [   25.357216] ieee80211 phy0: I iwl3945_rx_handle r = 85, i = 84, REPLY_3945_RX, 0x1b
Mar  5 18:41:39 rainbow kernel: [   25.368593] ieee80211 phy0: I iwl3945_rx_handle r = 86, i = 85, REPLY_3945_RX, 0x1b
Mar  5 18:41:39 rainbow kernel: [   25.382392] ieee80211 phy0: I iwl3945_rx_handle r = 87, i = 86, REPLY_3945_RX, 0x1b
Mar  5 18:41:39 rainbow kernel: [   25.392771] ieee80211 phy0: I iwl3945_rx_handle r = 88, i = 87, SCAN_RESULTS_NOTIFICATION, 0x83
Mar  5 18:41:39 rainbow kernel: [   25.393742] ieee80211 phy0: I iwl3945_rx_handle r = 90, i = 88, STATISTICS_NOTIFICATION, 0x9d
Mar  5 18:41:39 rainbow kernel: [   25.393762] ieee80211 phy0: I iwl3945_rx_handle r = 90, i = 89, SCAN_START_NOTIFICATION, 0x82
Mar  5 18:41:39 rainbow kernel: [   25.395424] ieee80211 phy0: I iwl3945_rx_handle r = 91, i = 90, REPLY_3945_RX, 0x1b
Mar  5 18:41:39 rainbow kernel: [   25.409243] ieee80211 phy0: I iwl3945_rx_handle r = 92, i = 91, REPLY_3945_RX, 0x1b
Mar  5 18:41:39 rainbow kernel: [   25.413219] ieee80211 phy0: I iwl3945_rx_handle r = 93, i = 92, REPLY_3945_RX, 0x1b
Mar  5 18:41:39 rainbow kernel: [   25.414709] ieee80211 phy0: I iwl3945_rx_handle r = 94, i = 93, REPLY_3945_RX, 0x1b
Mar  5 18:41:39 rainbow kernel: [   25.423149] ieee80211 phy0: I iwl3945_rx_handle r = 95, i = 94, REPLY_3945_RX, 0x1b
Mar  5 18:41:39 rainbow kernel: [   25.433720] ieee80211 phy0: I iwl3945_rx_handle r = 96, i = 95, SCAN_RESULTS_NOTIFICATION, 0x83
Mar  5 18:41:39 rainbow kernel: [   25.434803] ieee80211 phy0: I iwl3945_rx_handle r = 97, i = 96, SCAN_COMPLETE_NOTIFICATION, 0x84
Mar  5 18:41:39 rainbow kernel: [   25.434855] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x4415, 366 bytes at 21[32]:4
Mar  5 18:41:39 rainbow kernel: [   25.435083] ieee80211 phy0: I iwl3945_rx_handle r = 98, i = 97, REPLY_SCAN_CMD, 0x80
Mar  5 18:41:39 rainbow kernel: [   25.436031] ieee80211 phy0: I iwl3945_rx_handle r = 100, i = 98, STATISTICS_NOTIFICATION, 0x9d
Mar  5 18:41:39 rainbow kernel: [   25.436051] ieee80211 phy0: I iwl3945_rx_handle r = 100, i = 99, SCAN_START_NOTIFICATION, 0x82
Mar  5 18:41:39 rainbow kernel: [   25.548696] ieee80211 phy0: I iwl3945_rx_handle r = 101, i = 100, SCAN_RESULTS_NOTIFICATION, 0x83
Mar  5 18:41:39 rainbow kernel: [   25.549634] ieee80211 phy0: I iwl3945_rx_handle r = 103, i = 101, STATISTICS_NOTIFICATION, 0x9d
Mar  5 18:41:39 rainbow kernel: [   25.549656] ieee80211 phy0: I iwl3945_rx_handle r = 103, i = 102, SCAN_START_NOTIFICATION, 0x82
Mar  5 18:41:39 rainbow kernel: [   25.662227] ieee80211 phy0: I iwl3945_rx_handle r = 104, i = 103, SCAN_RESULTS_NOTIFICATION, 0x83
Mar  5 18:41:39 rainbow kernel: [   25.663193] ieee80211 phy0: I iwl3945_rx_handle r = 106, i = 104, STATISTICS_NOTIFICATION, 0x9d
Mar  5 18:41:39 rainbow kernel: [   25.663214] ieee80211 phy0: I iwl3945_rx_handle r = 106, i = 105, SCAN_START_NOTIFICATION, 0x82
Mar  5 18:41:39 rainbow kernel: [   25.775869] ieee80211 phy0: I iwl3945_rx_handle r = 107, i = 106, SCAN_RESULTS_NOTIFICATION, 0x83
Mar  5 18:41:39 rainbow kernel: [   25.776818] ieee80211 phy0: I iwl3945_rx_handle r = 109, i = 107, STATISTICS_NOTIFICATION, 0x9d
Mar  5 18:41:39 rainbow kernel: [   25.776826] ieee80211 phy0: I iwl3945_rx_handle r = 109, i = 108, SCAN_START_NOTIFICATION, 0x82
Mar  5 18:41:39 rainbow kernel: [   25.889494] ieee80211 phy0: I iwl3945_rx_handle r = 110, i = 109, SCAN_RESULTS_NOTIFICATION, 0x83
Mar  5 18:41:39 rainbow kernel: [   25.890426] ieee80211 phy0: I iwl3945_rx_handle r = 112, i = 110, STATISTICS_NOTIFICATION, 0x9d
Mar  5 18:41:39 rainbow kernel: [   25.890447] ieee80211 phy0: I iwl3945_rx_handle r = 112, i = 111, SCAN_START_NOTIFICATION, 0x82
Mar  5 18:41:40 rainbow kernel: [   26.003031] ieee80211 phy0: I iwl3945_rx_handle r = 113, i = 112, SCAN_RESULTS_NOTIFICATION, 0x83
Mar  5 18:41:40 rainbow kernel: [   26.003980] ieee80211 phy0: I iwl3945_rx_handle r = 115, i = 113, STATISTICS_NOTIFICATION, 0x9d
Mar  5 18:41:40 rainbow kernel: [   26.004002] ieee80211 phy0: I iwl3945_rx_handle r = 115, i = 114, SCAN_START_NOTIFICATION, 0x82
Mar  5 18:41:40 rainbow kernel: [   26.116638] ieee80211 phy0: I iwl3945_rx_handle r = 116, i = 115, SCAN_RESULTS_NOTIFICATION, 0x83
Mar  5 18:41:40 rainbow kernel: [   26.117599] ieee80211 phy0: I iwl3945_rx_handle r = 118, i = 116, STATISTICS_NOTIFICATION, 0x9d
Mar  5 18:41:40 rainbow kernel: [   26.117621] ieee80211 phy0: I iwl3945_rx_handle r = 118, i = 117, SCAN_START_NOTIFICATION, 0x82
Mar  5 18:41:40 rainbow kernel: [   26.230227] ieee80211 phy0: I iwl3945_rx_handle r = 119, i = 118, SCAN_RESULTS_NOTIFICATION, 0x83
Mar  5 18:41:40 rainbow kernel: [   26.231490] ieee80211 phy0: I iwl3945_rx_handle r = 121, i = 119, STATISTICS_NOTIFICATION, 0x9d
Mar  5 18:41:40 rainbow kernel: [   26.231513] ieee80211 phy0: I iwl3945_rx_handle r = 121, i = 120, SCAN_START_NOTIFICATION, 0x82
Mar  5 18:41:40 rainbow kernel: [   26.344178] ieee80211 phy0: I iwl3945_rx_handle r = 122, i = 121, SCAN_RESULTS_NOTIFICATION, 0x83
Mar  5 18:41:40 rainbow kernel: [   26.345472] ieee80211 phy0: I iwl3945_rx_handle r = 124, i = 122, STATISTICS_NOTIFICATION, 0x9d
Mar  5 18:41:40 rainbow kernel: [   26.345494] ieee80211 phy0: I iwl3945_rx_handle r = 124, i = 123, SCAN_START_NOTIFICATION, 0x82
Mar  5 18:41:40 rainbow kernel: [   26.458159] ieee80211 phy0: I iwl3945_rx_handle r = 125, i = 124, SCAN_RESULTS_NOTIFICATION, 0x83
Mar  5 18:41:40 rainbow kernel: [   26.459086] ieee80211 phy0: I iwl3945_rx_handle r = 127, i = 125, STATISTICS_NOTIFICATION, 0x9d
Mar  5 18:41:40 rainbow kernel: [   26.459107] ieee80211 phy0: I iwl3945_rx_handle r = 127, i = 126, SCAN_START_NOTIFICATION, 0x82
Mar  5 18:41:40 rainbow kernel: [   26.571742] ieee80211 phy0: I iwl3945_rx_handle r = 128, i = 127, SCAN_RESULTS_NOTIFICATION, 0x83
Mar  5 18:41:40 rainbow kernel: [   26.572680] ieee80211 phy0: I iwl3945_rx_handle r = 130, i = 128, STATISTICS_NOTIFICATION, 0x9d
Mar  5 18:41:40 rainbow kernel: [   26.572700] ieee80211 phy0: I iwl3945_rx_handle r = 130, i = 129, SCAN_START_NOTIFICATION, 0x82
Mar  5 18:41:40 rainbow kernel: [   26.685332] ieee80211 phy0: I iwl3945_rx_handle r = 131, i = 130, SCAN_RESULTS_NOTIFICATION, 0x83
Mar  5 18:41:40 rainbow kernel: [   26.686266] ieee80211 phy0: I iwl3945_rx_handle r = 133, i = 131, STATISTICS_NOTIFICATION, 0x9d
Mar  5 18:41:40 rainbow kernel: [   26.686288] ieee80211 phy0: I iwl3945_rx_handle r = 133, i = 132, SCAN_START_NOTIFICATION, 0x82
Mar  5 18:41:40 rainbow kernel: [   26.798899] ieee80211 phy0: I iwl3945_rx_handle r = 134, i = 133, SCAN_RESULTS_NOTIFICATION, 0x83
Mar  5 18:41:40 rainbow kernel: [   26.799797] ieee80211 phy0: I iwl3945_rx_handle r = 136, i = 134, STATISTICS_NOTIFICATION, 0x9d
Mar  5 18:41:40 rainbow kernel: [   26.799821] ieee80211 phy0: I iwl3945_rx_handle r = 136, i = 135, SCAN_START_NOTIFICATION, 0x82
Mar  5 18:41:40 rainbow kernel: [   26.912514] ieee80211 phy0: I iwl3945_rx_handle r = 137, i = 136, SCAN_RESULTS_NOTIFICATION, 0x83
Mar  5 18:41:40 rainbow kernel: [   26.913612] ieee80211 phy0: I iwl3945_rx_handle r = 138, i = 137, SCAN_COMPLETE_NOTIFICATION, 0x84
Mar  5 18:41:40 rainbow kernel: [   26.913660] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x0416, 56 bytes at 22[22]:4
Mar  5 18:41:40 rainbow kernel: [   26.913820] ieee80211 phy0: I iwl3945_rx_handle r 139 i 138 No handler needed for REPLY_TX_PWR_TABLE_CMD, 0x97
Mar  5 18:41:40 rainbow kernel: [   26.913900] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x0417, 48 bytes at 23[23]:4
Mar  5 18:41:40 rainbow kernel: [   26.914137] ieee80211 phy0: I iwl3945_rx_handle r 140 i 139 No handler needed for REPLY_RXON, 0x10
Mar  5 18:41:40 rainbow kernel: [   26.914167] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x0418, 56 bytes at 24[24]:4
Mar  5 18:41:40 rainbow kernel: [   26.914321] ieee80211 phy0: I iwl3945_rx_handle r 141 i 140 No handler needed for REPLY_TX_PWR_TABLE_CMD, 0x97
Mar  5 18:41:40 rainbow kernel: [   26.914351] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0419, 68 bytes at 25[25]:4
Mar  5 18:41:40 rainbow kernel: [   26.914466] ieee80211 phy0: I iwl3945_rx_handle r = 142, i = 141, REPLY_ADD_STA, 0x18
Mar  5 18:41:40 rainbow kernel: [   26.914494] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x041A, 56 bytes at 26[26]:4
Mar  5 18:41:40 rainbow kernel: [   26.914598] ieee80211 phy0: I iwl3945_rx_handle r 143 i 142 No handler needed for REPLY_RATE_SCALE, 0x47
Mar  5 18:41:40 rainbow kernel: [   26.914625] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x041B, 56 bytes at 27[27]:4
Mar  5 18:41:40 rainbow kernel: [   26.914730] ieee80211 phy0: I iwl3945_rx_handle r 144 i 143 No handler needed for REPLY_RATE_SCALE, 0x47
Mar  5 18:41:40 rainbow kernel: [   26.914763] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x041C, 48 bytes at 28[28]:4
Mar  5 18:41:40 rainbow kernel: [   26.915004] ieee80211 phy0: I iwl3945_rx_handle r 145 i 144 No handler needed for REPLY_RXON, 0x10
Mar  5 18:41:40 rainbow kernel: [   26.915036] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x041D, 56 bytes at 29[29]:4
Mar  5 18:41:40 rainbow kernel: [   26.915185] ieee80211 phy0: I iwl3945_rx_handle r 146 i 145 No handler needed for REPLY_TX_PWR_TABLE_CMD, 0x97
Mar  5 18:41:40 rainbow kernel: [   26.915212] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x041E, 68 bytes at 30[30]:4
Mar  5 18:41:40 rainbow kernel: [   26.915333] ieee80211 phy0: I iwl3945_rx_handle r = 147, i = 146, REPLY_ADD_STA, 0x18
Mar  5 18:41:40 rainbow kernel: [   26.915360] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x041F, 56 bytes at 31[31]:4
Mar  5 18:41:40 rainbow kernel: [   26.915464] ieee80211 phy0: I iwl3945_rx_handle r 148 i 147 No handler needed for REPLY_RATE_SCALE, 0x47
Mar  5 18:41:40 rainbow kernel: [   26.915492] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0420, 56 bytes at 32[0]:4
Mar  5 18:41:40 rainbow kernel: [   26.915596] ieee80211 phy0: I iwl3945_rx_handle r 149 i 148 No handler needed for REPLY_RATE_SCALE, 0x47
Mar  5 18:41:40 rainbow kernel: [   26.915621] wlan0: authenticate with AP 00:1b:63:24:77:79
Mar  5 18:41:40 rainbow kernel: [   26.915793] ieee80211 phy0: I iwl3945_rx_handle r = 150, i = 149, REPLY_TX, 0x1c
Mar  5 18:41:41 rainbow kernel: [   27.113071] wlan0: authenticate with AP 00:1b:63:24:77:79
Mar  5 18:41:41 rainbow kernel: [   27.115758] iwl3945 0000:03:00.0: Microcode SW error detected. Restarting 0x82000008.
Mar  5 18:41:41 rainbow kernel: [   27.115786] iwl3945 0000:03:00.0: Start IWL Error Log Dump:
Mar  5 18:41:41 rainbow kernel: [   27.115787] iwl3945 0000:03:00.0: Status: 0x000202E4, count: 1
Mar  5 18:41:41 rainbow kernel: [   27.115872] iwl3945 0000:03:00.0: Desc                               Time       data1      data2      line
Mar  5 18:41:41 rainbow kernel: [   27.115874] iwl3945 0000:03:00.0: SYSASSERT                    (#05) 0000000000 0x0000004E 0x00000000 0
Mar  5 18:41:41 rainbow kernel: [   27.115876] iwl3945 0000:03:00.0: blink1  blink2  ilink1  ilink2
Mar  5 18:41:41 rainbow kernel: [   27.115878] iwl3945 0000:03:00.0: 0x0089A 0x0025E 0x00304 0x04BC6
Mar  5 18:41:41 rainbow kernel: [   27.115944] iwl3945 0000:03:00.0: Start IWL Event Log Dump: display count 512, wraps 7
Mar  5 18:41:41 rainbow kernel: [   27.115974] iwl3945 0000:03:00.0: EVT_LOGT:0000000256:0x00000452:200805
Mar  5 18:41:41 rainbow kernel: [   27.116009] iwl3945 0000:03:00.0: EVT_LOGT:0000000010:0x00000453:1118688
Mar  5 18:41:41 rainbow kernel: [   27.116039] iwl3945 0000:03:00.0: EVT_LOGT:0000000010:0x00000451:1119202
Mar  5 18:41:41 rainbow kernel: [   27.116069] iwl3945 0000:03:00.0: EVT_LOGT:0000001247:0x00000452:1119203
Mar  5 18:41:41 rainbow kernel: [   27.116098] iwl3945 0000:03:00.0: EVT_LOGT:0000000001:0x00000452:1119207
Mar  5 18:41:41 rainbow kernel: [   27.116127] iwl3945 0000:03:00.0: EVT_LOGT:0000000015:0x00000451:1119208
Mar  5 18:41:41 rainbow kernel: [   27.116157] iwl3945 0000:03:00.0: EVT_LOGT:0000001253:0x0000045b:1119209
Mar  5 18:41:41 rainbow kernel: [   27.116186] iwl3945 0000:03:00.0: EVT_LOGT:0000001256:0x000001d0:1119212
Mar  5 18:41:41 rainbow kernel: [   27.116216] iwl3945 0000:03:00.0: EVT_LOGT:0000000064:0x000001cd:1119219
Mar  5 18:41:41 rainbow kernel: [   27.116245] iwl3945 0000:03:00.0: EVT_LOGT:0000000064:0x00000454:1119220
Mar  5 18:41:41 rainbow kernel: [   27.116280] iwl3945 0000:03:00.0: EVT_LOGT:0000000149:0x0000044d:1231907
Mar  5 18:41:41 rainbow kernel: [   27.116310] iwl3945 0000:03:00.0: EVT_LOGT:0000000014:0x0000044e:1231909
Mar  5 18:41:41 rainbow kernel: [   27.116339] iwl3945 0000:03:00.0: EVT_LOGT:0006815796:0x0000044e:1231910
Mar  5 18:41:41 rainbow kernel: [   27.116368] iwl3945 0000:03:00.0: EVT_LOGT:0006815797:0x0000044e:1231911
Mar  5 18:41:41 rainbow kernel: [   27.116398] iwl3945 0000:03:00.0: EVT_LOGT:0008126518:0x0000044e:1231913
Mar  5 18:41:41 rainbow kernel: [   27.116427] iwl3945 0000:03:00.0: EVT_LOGT:0008192055:0x0000044e:1231914
Mar  5 18:41:41 rainbow kernel: [   27.116456] iwl3945 0000:03:00.0: EVT_LOGT:0000000056:0x0000044e:1231916
Mar  5 18:41:41 rainbow kernel: [   27.116486] iwl3945 0000:03:00.0: EVT_LOGT:0008585298:0x0000044e:1231918
Mar  5 18:41:41 rainbow kernel: [   27.116515] iwl3945 0000:03:00.0: EVT_LOGT:0008585299:0x0000044e:1231919
Mar  5 18:41:41 rainbow kernel: [   27.116544] iwl3945 0000:03:00.0: EVT_LOGT:0008323156:0x0000044e:1231921
Mar  5 18:41:41 rainbow kernel: [   27.116574] iwl3945 0000:03:00.0: EVT_LOGT:0008192085:0x0000044e:1231922
Mar  5 18:41:41 rainbow kernel: [   27.116603] iwl3945 0000:03:00.0: EVT_LOGT:0000000086:0x0000044e:1231924
Mar  5 18:41:41 rainbow kernel: [   27.116632] iwl3945 0000:03:00.0: EVT_LOGT:0000028752:0x0000044e:1231925
Mar  5 18:41:41 rainbow kernel: [   27.116661] iwl3945 0000:03:00.0: EVT_LOGT:0000094289:0x0000044e:1231927
Mar  5 18:41:41 rainbow kernel: [   27.116691] iwl3945 0000:03:00.0: EVT_LOGT:0000033284:0x0000044e:1231929
Mar  5 18:41:41 rainbow kernel: [   27.116720] iwl3945 0000:03:00.0: EVT_LOGT:0000098821:0x0000044d:1231931
Mar  5 18:41:41 rainbow kernel: [   27.116749] iwl3945 0000:03:00.0: EVT_LOGT:0000000001:0x0000044e:1231934
Mar  5 18:41:41 rainbow kernel: [   27.116778] iwl3945 0000:03:00.0: EVT_LOGT:0009109603:0x00000450:1231935
Mar  5 18:41:41 rainbow kernel: [   27.116808] iwl3945 0000:03:00.0: EVT_LOGT:0000000029:0x0000044d:1231937
Mar  5 18:41:41 rainbow kernel: [   27.116837] iwl3945 0000:03:00.0: EVT_LOGT:0000000002:0x0000044e:1231939
Mar  5 18:41:41 rainbow kernel: [   27.116866] iwl3945 0000:03:00.0: EVT_LOGT:0008556607:0x0000044e:1231940
Mar  5 18:41:41 rainbow kernel: [   27.116895] iwl3945 0000:03:00.0: EVT_LOGT:0000053779:0x0000044d:1231942
Mar  5 18:41:41 rainbow kernel: [   27.116924] iwl3945 0000:03:00.0: EVT_LOGT:0000000002:0x0000044e:1231945
Mar  5 18:41:41 rainbow kernel: [   27.116954] iwl3945 0000:03:00.0: EVT_LOGT:0000381446:0x0000044e:1231946
Mar  5 18:41:41 rainbow kernel: [   27.116983] iwl3945 0000:03:00.0: EVT_LOGT:0008884286:0x0000044d:1231948
Mar  5 18:41:41 rainbow kernel: [   27.117018] iwl3945 0000:03:00.0: EVT_LOGT:0000000090:0x0000044d:1231951
Mar  5 18:41:41 rainbow kernel: [   27.117048] iwl3945 0000:03:00.0: EVT_LOGT:0000000019:0x00000453:1232053
Mar  5 18:41:41 rainbow kernel: [   27.117077] iwl3945 0000:03:00.0: EVT_LOGT:0000000013:0x00000456:1232069
Mar  5 18:41:41 rainbow kernel: [   27.117107] iwl3945 0000:03:00.0: EVT_LOGT:0201425206:0x000001c6:1232586
Mar  5 18:41:41 rainbow kernel: [   27.117136] iwl3945 0000:03:00.0: EVT_LOGT:4294967121:0x000001d8:1232598
Mar  5 18:41:41 rainbow kernel: [   27.117165] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x000001d0:1232599
Mar  5 18:41:41 rainbow kernel: [   27.117195] iwl3945 0000:03:00.0: EVT_LOGT:0000000064:0x00000457:1232611
Mar  5 18:41:41 rainbow kernel: [   27.117224] iwl3945 0000:03:00.0: EVT_LOGT:4294967121:0x00000452:1232613
Mar  5 18:41:41 rainbow kernel: [   27.117259] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1232635
Mar  5 18:41:41 rainbow kernel: [   27.117289] iwl3945 0000:03:00.0: EVT_LOGT:0000000010:0x00000453:1232635
Mar  5 18:41:41 rainbow kernel: [   27.117318] iwl3945 0000:03:00.0: EVT_LOGT:0000000014:0x00000451:1233149
Mar  5 18:41:41 rainbow kernel: [   27.117347] iwl3945 0000:03:00.0: EVT_LOGT:0000001247:0x00000452:1233150
Mar  5 18:41:41 rainbow kernel: [   27.117376] iwl3945 0000:03:00.0: EVT_LOGT:0000000001:0x00000452:1233154
Mar  5 18:41:41 rainbow kernel: [   27.117406] iwl3945 0000:03:00.0: EVT_LOGT:0000000015:0x00000451:1233155
Mar  5 18:41:41 rainbow kernel: [   27.117435] iwl3945 0000:03:00.0: EVT_LOGT:0000001253:0x0000045b:1233156
Mar  5 18:41:41 rainbow kernel: [   27.117464] iwl3945 0000:03:00.0: EVT_LOGT:0000001256:0x000001d0:1233159
Mar  5 18:41:41 rainbow kernel: [   27.117493] iwl3945 0000:03:00.0: EVT_LOGT:0000000149:0x000001ce:1233166
Mar  5 18:41:41 rainbow kernel: [   27.117522] iwl3945 0000:03:00.0: EVT_LOGT:0000000149:0x00000454:1233167
Mar  5 18:41:41 rainbow kernel: [   27.117552] iwl3945 0000:03:00.0: EVT_LOGT:0000000153:0x0000044d:1345854
Mar  5 18:41:41 rainbow kernel: [   27.117581] iwl3945 0000:03:00.0: EVT_LOGT:0000000014:0x0000044e:1345855
Mar  5 18:41:41 rainbow kernel: [   27.117610] iwl3945 0000:03:00.0: EVT_LOGT:0006815796:0x0000044e:1345856
Mar  5 18:41:41 rainbow kernel: [   27.117639] iwl3945 0000:03:00.0: EVT_LOGT:0006815797:0x0000044e:1345858
Mar  5 18:41:41 rainbow kernel: [   27.117669] iwl3945 0000:03:00.0: EVT_LOGT:0008126518:0x0000044e:1345859
Mar  5 18:41:41 rainbow kernel: [   27.117698] iwl3945 0000:03:00.0: EVT_LOGT:0008192055:0x0000044e:1345861
Mar  5 18:41:41 rainbow kernel: [   27.117727] iwl3945 0000:03:00.0: EVT_LOGT:0000000056:0x0000044e:1345862
Mar  5 18:41:41 rainbow kernel: [   27.117757] iwl3945 0000:03:00.0: EVT_LOGT:0008585298:0x0000044e:1345864
Mar  5 18:41:41 rainbow kernel: [   27.117786] iwl3945 0000:03:00.0: EVT_LOGT:0008585299:0x0000044e:1345865
Mar  5 18:41:41 rainbow kernel: [   27.117815] iwl3945 0000:03:00.0: EVT_LOGT:0008323156:0x0000044e:1345867
Mar  5 18:41:41 rainbow kernel: [   27.117845] iwl3945 0000:03:00.0: EVT_LOGT:0008192085:0x0000044e:1345868
Mar  5 18:41:41 rainbow kernel: [   27.117874] iwl3945 0000:03:00.0: EVT_LOGT:0000000086:0x0000044e:1345870
Mar  5 18:41:41 rainbow kernel: [   27.117903] iwl3945 0000:03:00.0: EVT_LOGT:0000028752:0x0000044e:1345871
Mar  5 18:41:41 rainbow kernel: [   27.117932] iwl3945 0000:03:00.0: EVT_LOGT:0000094289:0x0000044e:1345873
Mar  5 18:41:41 rainbow kernel: [   27.117962] iwl3945 0000:03:00.0: EVT_LOGT:0000033284:0x0000044e:1345875
Mar  5 18:41:41 rainbow kernel: [   27.117991] iwl3945 0000:03:00.0: EVT_LOGT:0000098821:0x0000044d:1345877
Mar  5 18:41:41 rainbow kernel: [   27.118020] iwl3945 0000:03:00.0: EVT_LOGT:0000000001:0x0000044e:1345880
Mar  5 18:41:41 rainbow kernel: [   27.118050] iwl3945 0000:03:00.0: EVT_LOGT:0009109603:0x00000450:1345881
Mar  5 18:41:41 rainbow kernel: [   27.118079] iwl3945 0000:03:00.0: EVT_LOGT:0000000029:0x0000044d:1345883
Mar  5 18:41:41 rainbow kernel: [   27.118108] iwl3945 0000:03:00.0: EVT_LOGT:0000000002:0x0000044e:1345885
Mar  5 18:41:41 rainbow kernel: [   27.118138] iwl3945 0000:03:00.0: EVT_LOGT:0008556607:0x0000044e:1345886
Mar  5 18:41:41 rainbow kernel: [   27.118167] iwl3945 0000:03:00.0: EVT_LOGT:0000053779:0x0000044d:1345888
Mar  5 18:41:41 rainbow kernel: [   27.118196] iwl3945 0000:03:00.0: EVT_LOGT:0000000002:0x0000044e:1345891
Mar  5 18:41:41 rainbow kernel: [   27.118225] iwl3945 0000:03:00.0: EVT_LOGT:0000381446:0x0000044e:1345892
Mar  5 18:41:41 rainbow kernel: [   27.118255] iwl3945 0000:03:00.0: EVT_LOGT:0008884286:0x0000044d:1345894
Mar  5 18:41:41 rainbow kernel: [   27.118284] iwl3945 0000:03:00.0: EVT_LOGT:0000000090:0x0000044d:1345898
Mar  5 18:41:41 rainbow kernel: [   27.118313] iwl3945 0000:03:00.0: EVT_LOGT:0000000019:0x00000453:1345999
Mar  5 18:41:41 rainbow kernel: [   27.118342] iwl3945 0000:03:00.0: EVT_LOGT:0000000014:0x00000456:1346016
Mar  5 18:41:41 rainbow kernel: [   27.118372] iwl3945 0000:03:00.0: EVT_LOGT:0218190876:0x000001c6:1346532
Mar  5 18:41:41 rainbow kernel: [   27.118401] iwl3945 0000:03:00.0: EVT_LOGT:4294967122:0x000001d8:1346544
Mar  5 18:41:41 rainbow kernel: [   27.118430] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x000001d0:1346545
Mar  5 18:41:41 rainbow kernel: [   27.118459] iwl3945 0000:03:00.0: EVT_LOGT:0000000149:0x00000457:1346557
Mar  5 18:41:41 rainbow kernel: [   27.118489] iwl3945 0000:03:00.0: EVT_LOGT:4294967122:0x00000452:1346559
Mar  5 18:41:41 rainbow kernel: [   27.118518] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1346581
Mar  5 18:41:41 rainbow kernel: [   27.118547] iwl3945 0000:03:00.0: EVT_LOGT:0000000014:0x00000452:1346581
Mar  5 18:41:41 rainbow kernel: [   27.118577] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1346586
Mar  5 18:41:41 rainbow kernel: [   27.118606] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1346590
Mar  5 18:41:41 rainbow kernel: [   27.118635] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1346594
Mar  5 18:41:41 rainbow kernel: [   27.118664] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1346598
Mar  5 18:41:41 rainbow kernel: [   27.118694] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1346603
Mar  5 18:41:41 rainbow kernel: [   27.118723] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1346607
Mar  5 18:41:41 rainbow kernel: [   27.118752] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1346611
Mar  5 18:41:41 rainbow kernel: [   27.118781] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1346616
Mar  5 18:41:41 rainbow kernel: [   27.118810] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1346620
Mar  5 18:41:41 rainbow kernel: [   27.118840] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1346624
Mar  5 18:41:41 rainbow kernel: [   27.118869] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1346628
Mar  5 18:41:41 rainbow kernel: [   27.118898] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1346633
Mar  5 18:41:41 rainbow kernel: [   27.118927] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1346637
Mar  5 18:41:41 rainbow kernel: [   27.118957] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1346641
Mar  5 18:41:41 rainbow kernel: [   27.118985] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1346645
Mar  5 18:41:41 rainbow kernel: [   27.119015] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1346650
Mar  5 18:41:41 rainbow kernel: [   27.119044] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1346654
Mar  5 18:41:41 rainbow kernel: [   27.119073] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1346658
Mar  5 18:41:41 rainbow kernel: [   27.119102] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1346663
Mar  5 18:41:41 rainbow kernel: [   27.119132] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1346667
Mar  5 18:41:41 rainbow kernel: [   27.119161] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1346671
Mar  5 18:41:41 rainbow kernel: [   27.119190] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1346675
Mar  5 18:41:41 rainbow kernel: [   27.119219] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1346680
Mar  5 18:41:41 rainbow kernel: [   27.119249] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1346684
Mar  5 18:41:41 rainbow kernel: [   27.119278] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1346688
Mar  5 18:41:41 rainbow kernel: [   27.119307] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1346692
Mar  5 18:41:41 rainbow kernel: [   27.119336] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1346697
Mar  5 18:41:41 rainbow kernel: [   27.119366] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1346701
Mar  5 18:41:41 rainbow kernel: [   27.119395] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1346705
Mar  5 18:41:41 rainbow kernel: [   27.119424] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1346710
Mar  5 18:41:41 rainbow kernel: [   27.119453] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1346714
Mar  5 18:41:41 rainbow kernel: [   27.119482] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1346718
Mar  5 18:41:41 rainbow kernel: [   27.119512] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1346722
Mar  5 18:41:41 rainbow kernel: [   27.119541] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1346727
Mar  5 18:41:41 rainbow kernel: [   27.119570] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1346731
Mar  5 18:41:41 rainbow kernel: [   27.119599] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1346735
Mar  5 18:41:41 rainbow kernel: [   27.119629] iwl3945 0000:03:00.0: EVT_LOGT:0000000001:0x00000452:1346739
Mar  5 18:41:41 rainbow kernel: [   27.119658] iwl3945 0000:03:00.0: EVT_LOGT:0000000015:0x00000451:1346740
Mar  5 18:41:41 rainbow kernel: [   27.119687] iwl3945 0000:03:00.0: EVT_LOGT:0000000893:0x0000045b:1346742
Mar  5 18:41:41 rainbow kernel: [   27.119717] iwl3945 0000:03:00.0: EVT_LOGT:0000001256:0x000001d0:1346745
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000153:0x000001ce:1346752
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000153:0x00000454:1346753
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000157:0x0000044d:1459439
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000014:0x0000044e:1459441
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0006815796:0x0000044e:1459442
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0006815797:0x0000044e:1459444
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0008126518:0x0000044e:1459445
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0008192055:0x0000044e:1459447
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000056:0x0000044e:1459448
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0008585298:0x0000044e:1459450
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0008585299:0x0000044e:1459451
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0008323156:0x0000044e:1459453
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0008192085:0x0000044e:1459454
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000086:0x0000044e:1459456
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000028752:0x0000044e:1459457
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000094289:0x0000044e:1459459
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000033284:0x0000044e:1459461
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000098821:0x0000044d:1459463
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000001:0x0000044e:1459466
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0009109603:0x00000450:1459467
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000029:0x0000044d:1459469
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000002:0x0000044e:1459471
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0008556607:0x0000044e:1459472
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000053779:0x0000044d:1459474
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000002:0x0000044e:1459477
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000381446:0x0000044e:1459478
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0008884286:0x0000044d:1459480
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000090:0x0000044d:1459484
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000019:0x00000453:1459585
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000014:0x00000456:1459602
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0234956906:0x000001c6:1460118
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:4294967122:0x000001d8:1460130
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x000001d0:1460131
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000153:0x00000457:1460143
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:4294967122:0x00000452:1460145
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1460168
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000014:0x00000452:1460168
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1460173
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1460177
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1460181
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1460185
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1460190
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1460194
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1460198
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1460203
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1460207
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1460211
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1460215
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1460220
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1460224
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1460228
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1460232
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1460237
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1460241
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1460245
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1460250
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1460254
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1460258
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1460262
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1460267
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1460271
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1460275
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1460279
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1460284
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1460288
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1460292
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1460297
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1460301
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1460305
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1460309
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1460314
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1460318
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1460322
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1460326
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1460331
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000001:0x00000452:1460335
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000015:0x00000451:1460336
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000901:0x0000045b:1460338
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000001256:0x000001d0:1460341
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000157:0x000001ce:1460346
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000157:0x00000454:1460347
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000161:0x0000044d:1573033
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000014:0x0000044e:1573035
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0006815796:0x0000044e:1573036
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0006815797:0x0000044e:1573037
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0008126518:0x0000044e:1573039
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0008192055:0x0000044e:1573040
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000056:0x0000044e:1573042
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0008585298:0x0000044e:1573043
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0008585299:0x0000044e:1573045
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0008323156:0x0000044e:1573046
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0008192085:0x0000044e:1573048
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000086:0x0000044e:1573050
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000028752:0x0000044e:1573051
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000094289:0x0000044e:1573053
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000033284:0x0000044e:1573055
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000098821:0x0000044d:1573057
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000001:0x0000044e:1573060
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0009109603:0x00000450:1573061
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000029:0x0000044d:1573063
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000002:0x0000044e:1573065
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0008556607:0x0000044e:1573066
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000053779:0x0000044d:1573068
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000002:0x0000044e:1573071
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000381446:0x0000044e:1573072
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0008884286:0x0000044d:1573073
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000090:0x0000044d:1573077
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000019:0x00000453:1573179
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000014:0x00000456:1573195
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0251722928:0x000001c6:1573712
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:4294967123:0x000001d8:1573724
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x000001d0:1573725
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000157:0x00000457:1573736
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:4294967123:0x00000452:1573738
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1573761
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000014:0x00000452:1573761
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1573766
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1573770
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1573774
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1573778
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1573783
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1573787
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1573791
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1573796
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1573800
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1573804
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1573808
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1573813
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1573817
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1573821
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1573825
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1573830
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1573834
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1573838
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1573843
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1573847
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1573851
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1573855
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1573860
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1573864
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1573868
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1573872
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1573877
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1573881
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1573885
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1573890
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1573894
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1573898
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1573902
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1573907
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1573911
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000001:0x00000452:1573915
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000015:0x00000451:1573916
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000888:0x0000045b:1573918
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000001256:0x000001d0:1573921
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000161:0x000001ce:1573927
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000161:0x00000454:1573928
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000165:0x0000044d:1686615
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000014:0x0000044e:1686617
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0006815796:0x0000044e:1686618
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0006815797:0x0000044e:1686619
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0008126518:0x0000044e:1686621
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0008192055:0x0000044e:1686622
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000056:0x0000044e:1686624
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0008585298:0x0000044e:1686625
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0008585299:0x0000044e:1686627
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0008323156:0x0000044e:1686628
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0008192085:0x0000044e:1686630
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000086:0x0000044e:1686631
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000028752:0x0000044e:1686633
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000094289:0x0000044e:1686635
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000033284:0x0000044e:1686637
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000098821:0x0000044d:1686639
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000001:0x0000044e:1686642
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0009109603:0x00000450:1686643
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000028:0x0000044d:1686645
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000002:0x0000044e:1686646
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0008556607:0x0000044e:1686647
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000053779:0x0000044d:1686649
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000002:0x0000044e:1686652
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000381446:0x0000044e:1686653
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0008884286:0x0000044d:1686655
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000090:0x0000044d:1686659
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000019:0x00000453:1686760
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000014:0x00000456:1686777
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0268488962:0x000001c6:1687294
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:4294967123:0x000001d8:1687306
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x000001d0:1687307
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000161:0x00000457:1687319
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:4294967123:0x00000452:1687321
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1687343
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000014:0x00000452:1687343
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1687348
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1687352
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1687356
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1687360
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1687365
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1687369
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1687373
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1687378
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1687382
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1687386
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1687390
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1687395
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1687399
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1687403
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1687407
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1687412
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1687416
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1687420
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1687425
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1687429
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1687433
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1687437
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1687442
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1687446
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1687450
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1687454
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1687459
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1687463
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1687467
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1687472
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1687476
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1687480
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1687484
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1687489
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1687493
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1687497
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1687501
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000001:0x00000452:1687506
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000015:0x00000451:1687507
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000897:0x0000045b:1687508
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000001256:0x000001d0:1687512
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000165:0x000001ce:1687517
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000165:0x000003ed:1687518
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000440:0x00000454:1800195
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000257:0x0000044d:1800199
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000014:0x0000044e:1800201
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0006815796:0x0000044e:1800202
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0006750261:0x0000044e:1800203
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0008257590:0x0000044e:1800205
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0008126519:0x0000044e:1800206
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000056:0x0000044e:1800208
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000047:0x0000044e:8397512
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0008650835:0x0000044e:1800211
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0008257620:0x0000044e:1800213
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0008192085:0x0000044e:1800214
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000086:0x0000044e:1800216
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000028752:0x0000044e:1800217
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000094289:0x0000044e:1800219
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000033284:0x0000044e:1800221
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000098821:0x0000044d:1800223
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000001:0x0000044e:1800226
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0009109603:0x00000450:1800227
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000029:0x0000044d:1800229
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000002:0x0000044e:1800231
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0008622143:0x0000044e:1800232
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000119315:0x0000044d:1800234
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000002:0x0000044e:1800237
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000250374:0x0000044e:1800238
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0008622142:0x0000044d:1800240
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000089:0x0000044d:1800243
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000019:0x00000453:1800344
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000004:0x00000456:1800361
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0285254995:0x000001c6:1800877
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:4294967124:0x000001d8:1800889
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x000001d0:1800890
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000165:0x00000457:1800901
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:4294967124:0x00000452:1800904
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1800930
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000014:0x00000452:1800931
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1800935
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1800940
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1800944
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1800948
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1800953
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1800957
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1800961
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1800965
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1800970
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1800974
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1800978
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1800982
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1800987
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1800991
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1800995
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1801000
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1801004
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1801008
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1801012
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1801017
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1801021
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1801025
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1801030
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1801034
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1801038
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1801042
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1801047
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1801051
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1801055
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1801059
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1801064
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1801068
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1801072
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1801077
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1801081
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1801085
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1801089
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1801094
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1801098
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1801102
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1801106
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1801111
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1801115
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1801119
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1801124
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1801128
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1801132
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1801136
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1801141
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1801145
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1801149
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1801153
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1801158
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1801162
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1801166
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1801171
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1801175
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1801179
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1801183
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1801188
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1801192
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1801196
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1801201
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1801205
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1801209
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1801213
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1801218
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1801222
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1801226
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1801230
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1801235
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1801239
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1801243
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1801248
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1801252
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000452:1801256
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000001:0x00000452:1801260
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000015:0x00000451:1801261
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000001065:0x0000045b:1801263
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000001256:0x000001cf:1801266
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000001:0x000001ce:1801270
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000001:0x00000191:1801271
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0068550807:0x000001c3:1801476
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000001:0x000001c3:1801478
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000191:1801498
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0068616208:0x000003ed:1801714
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000373:0x000003e9:1801771
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x000003ea:1801772
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x000003ed:1801773
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000440:0x00000067:0012
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000170:0x00000191:0040
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0068681879:0x000001c3:0195
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000001:0x000001c3:0198
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000191:0218
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0068747288:0x00000191:0380
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0068812871:0x00000191:0522
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0068878407:0x00000191:0654
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0068943888:0x000003ed:0791
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000373:0x000003e9:0848
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x000003ea:0849
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x000003ed:0850
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000440:0x00000067:0012
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000170:0x00000191:0040
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0069009559:0x000001c3:0201
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000001:0x000001c3:0204
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000000:0x00000191:0224
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0069074968:0x00000191:0377
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0069140551:0x00000191:0526
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0069206087:0x000001cf:0657
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000001:0x000000fa:0824
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000065671:0x000000da:0827
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000028:0x0000007b:0833
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: EVT_LOGT:0000000002:0x0000007d:200802
Mar  5 18:41:41 rainbow kernel: [   27.119720] ieee80211 phy0: I iwl_irq_handle_error Restarting adapter due to uCode error.
Mar  5 18:41:41 rainbow kernel: [   27.119720] ieee80211 phy0: I iwl3945_rx_handle r = 151, i = 150, REPLY_ERROR, 0x02
Mar  5 18:41:41 rainbow kernel: [   27.119720] iwl3945 0000:03:00.0: Error Reply type 0x00000005 cmd REPLY_PHY_CALIBRATION_CMD (0xB0) seq 0x013A ser 0x004E0000
Mar  5 18:41:41 rainbow kernel: [   27.148414] ieee80211 phy0: I iwl3945_rx_handle r = 1, i = 0, REPLY_ALIVE, 0x01
Mar  5 18:41:41 rainbow kernel: [   27.157798] ieee80211 phy0: I iwl3945_rx_handle r = 2, i = 1, REPLY_ALIVE, 0x01
Mar  5 18:41:41 rainbow kernel: [   27.175684] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_BT_CONFIG (#9b), seq: 0x0400, 16 bytes at 0[0]:4
Mar  5 18:41:41 rainbow kernel: [   27.175758] ieee80211 phy0: I iwl3945_rx_handle r 3 i 2 No handler needed for REPLY_BT_CONFIG, 0x9b
Mar  5 18:41:41 rainbow kernel: [   27.175802] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x0401, 48 bytes at 1[1]:4
Mar  5 18:41:41 rainbow kernel: [   27.177006] ieee80211 phy0: I iwl3945_rx_handle r 4 i 3 No handler needed for REPLY_RXON, 0x10
Mar  5 18:41:41 rainbow kernel: [   27.177050] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x0402, 56 bytes at 2[2]:4
Mar  5 18:41:41 rainbow kernel: [   27.177137] ieee80211 phy0: I iwl3945_rx_handle r 5 i 4 No handler needed for REPLY_TX_PWR_TABLE_CMD, 0x97
Mar  5 18:41:41 rainbow kernel: [   27.177178] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0403, 68 bytes at 3[3]:4
Mar  5 18:41:41 rainbow kernel: [   27.177372] ieee80211 phy0: I iwl3945_rx_handle r = 6, i = 5, REPLY_ADD_STA, 0x18
Mar  5 18:41:41 rainbow kernel: [   27.177389] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0404, 56 bytes at 4[4]:4
Mar  5 18:41:41 rainbow kernel: [   27.177566] ieee80211 phy0: I iwl3945_rx_handle r 7 i 6 No handler needed for REPLY_RATE_SCALE, 0x47
Mar  5 18:41:41 rainbow kernel: [   27.177606] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0405, 56 bytes at 5[5]:4
Mar  5 18:41:41 rainbow kernel: [   27.177700] ieee80211 phy0: I iwl3945_rx_handle r 8 i 7 No handler needed for REPLY_RATE_SCALE, 0x47
Mar  5 18:41:41 rainbow kernel: [   27.177733] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x0406, 56 bytes at 6[6]:4
Mar  5 18:41:41 rainbow kernel: [   27.177819] ieee80211 phy0: I iwl3945_rx_handle r 9 i 8 No handler needed for REPLY_TX_PWR_TABLE_CMD, 0x97
Mar  5 18:41:41 rainbow kernel: [   27.177909] Registered led device: iwl-phy0::radio
Mar  5 18:41:41 rainbow kernel: [   27.177915] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0407, 12 bytes at 7[7]:4
Mar  5 18:41:41 rainbow kernel: [   27.177940] Registered led device: iwl-phy0::assoc
Mar  5 18:41:41 rainbow kernel: [   27.177981] ieee80211 phy0: I iwl3945_rx_handle r 10 i 9 No handler needed for REPLY_LEDS_CMD, 0x48
Mar  5 18:41:41 rainbow kernel: [   27.178011] Registered led device: iwl-phy0::RX
Mar  5 18:41:41 rainbow kernel: [   27.178035] Registered led device: iwl-phy0::TX
Mar  5 18:41:41 rainbow kernel: [   27.215335] ieee80211 phy0: I iwl3945_rx_handle r = 11, i = 10, REPLY_3945_RX, 0x1b
Mar  5 18:41:41 rainbow kernel: [   27.224500] ieee80211 phy0: I iwl3945_rx_handle r = 12, i = 11, REPLY_3945_RX, 0x1b
Mar  5 18:41:41 rainbow kernel: [   27.229078] ieee80211 phy0: I iwl3945_rx_handle r = 13, i = 12, REPLY_3945_RX, 0x1b
Mar  5 18:41:41 rainbow kernel: [   27.231945] ieee80211 phy0: I iwl3945_rx_handle r = 14, i = 13, REPLY_3945_RX, 0x1b
Mar  5 18:41:41 rainbow kernel: [   27.245884] ieee80211 phy0: I iwl3945_rx_handle r = 15, i = 14, REPLY_3945_RX, 0x1b
Mar  5 18:41:41 rainbow kernel: [   27.254964] ieee80211 phy0: I iwl3945_rx_handle r = 16, i = 15, REPLY_3945_RX, 0x1b
Mar  5 18:41:41 rainbow kernel: [   27.261102] ieee80211 phy0: I iwl3945_rx_handle r = 17, i = 16, REPLY_3945_RX, 0x1b
Mar  5 18:41:41 rainbow kernel: [   27.281658] ieee80211 phy0: I iwl3945_rx_handle r = 18, i = 17, REPLY_3945_RX, 0x1b
Mar  5 18:41:41 rainbow kernel: [   27.312072] wlan0: authenticate with AP 00:1b:63:24:77:79
Mar  5 18:41:41 rainbow kernel: [   27.312219] ieee80211 phy0: I iwl3945_rx_handle r = 19, i = 18, REPLY_TX, 0x1c
Mar  5 18:41:41 rainbow kernel: [   27.512101] wlan0: authentication with AP 00:1b:63:24:77:79 timed out
Mar  5 18:41:59 rainbow kernel: [   45.307229] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x4408, 350 bytes at 8[32]:4
Mar  5 18:41:59 rainbow kernel: [   45.804108] iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms.
Mar  5 18:41:59 rainbow kernel: [   45.804173] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x0409, 56 bytes at 9[9]:4
Mar  5 18:42:00 rainbow kernel: [   46.305033] iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms.
Mar  5 18:42:29 rainbow kernel: [   75.306821] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x440A, 350 bytes at 10[32]:4
Mar  5 18:42:29 rainbow kernel: [   75.804344] iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms.
Mar  5 18:42:29 rainbow kernel: [   75.804385] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x040B, 56 bytes at 11[11]:4
Mar  5 18:42:30 rainbow kernel: [   76.304128] iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms.
Mar  5 18:43:09 rainbow kernel: [  115.307319] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x440C, 350 bytes at 12[32]:4
Mar  5 18:43:09 rainbow kernel: [  115.804120] iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms.
Mar  5 18:43:09 rainbow kernel: [  115.804163] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x040D, 56 bytes at 13[13]:4
Mar  5 18:43:10 rainbow kernel: [  116.304126] iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms.
Mar  5 18:43:59 rainbow kernel: [  165.309678] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x440E, 350 bytes at 14[32]:4
Mar  5 18:43:59 rainbow kernel: [  165.808104] iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms.
Mar  5 18:43:59 rainbow kernel: [  165.808156] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x040F, 56 bytes at 15[15]:4
Mar  5 18:44:00 rainbow kernel: [  166.308120] iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms.

