Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:35369 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757267AbXKGOsl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Nov 2007 09:48:41 -0500
Subject: Re: airo WPA
From: Dan Williams <dcbw@redhat.com>
To: Matteo Croce <rootkit85@yahoo.it>
Cc: Michal Schmidt <xschmi00@stud.feec.vutbr.cz>,
	Matthieu Castet <castet.matthieu@free.fr>,
	Fabrice Bellet <fabrice@bellet.info>,
	"John W. Linville" <linville@tuxdriver.com>,
	PReDaCoN <alessandroferrari@gmail.com>,
	Benjamin Reed <breed@users.sourceforge.net>,
	Javier Achirica <achirica@users.sourceforge.net>,
	Jean Tourrilhes <jt@hpl.hp.com>,
	linux-wireless@vger.kernel.org, linux-net@vger.kernel.org
In-Reply-To: <200711071515.16623.rootkit85@yahoo.it>
References: <200711070307.09832.rootkit85@yahoo.it>
	 <20071107103445.28907089@brian.englab.brq.redhat.com>
	 <200711071515.16623.rootkit85@yahoo.it>
Content-Type: text/plain
Date: Wed, 07 Nov 2007 09:41:00 -0500
Message-Id: <1194446460.23444.6.camel@localhost.localdomain> (sfid-20071107_144851_561369_0D7C39EE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2007-11-07 at 15:15 +0100, Matteo Croce wrote:
> New patch against current git

NAK at the moment; we've got too many patches for this floating around.
I'm currently working out some issues with WPA with a pull from
Matthieu's svn repo plus a set from Fabrice.  There's an issue with that
set (that your patch also has) that causes WPA associations to fail
because frames are driver-MIC-ed at the wrong times.  The patches also
have some style issues that I'd like to clean up.

So here's what I'd like to do with the airo WPA patches.  They need to
go through _one_ place.  Either I'll volunteer the time to handle them
and people can feed them through me, or we need some other place where
people can coordinate the work.  I'm happy to push this stuff through
since it seems like most of the dual-mode issues have been solved.

The immediate bug is that the driver mis-MICs the first few EAPOL frames
that come back during the 4-way handshake, failing the WPA association
for PCMCIA cards at least.  I haven't tested with my mini-PCI part yet
and won't until this can be fixed.  Once that appears to work, I'd like
to run through a bunch of setups and make sure the driver behaves as
expected for both WPA-capable and non-WPA-capable firmware versions, and
with a number of different RADIUS setups and encryption modes including
Dynamic WEP.

Dan

> diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
> index 074055e..5620c42 100644
> --- a/drivers/net/wireless/airo.c
> +++ b/drivers/net/wireless/airo.c
> @@ -16,6 +16,7 @@
>      Code was also integrated from the Cisco Aironet driver for Linux.
>      Support for MPI350 cards was added by Fabrice Bellet
>      <fabrice@bellet.info>.
> +    (C) 2005-2007 Matthieu CASTET <castet.matthieu@free.fr> for WPA support
>  
>  ======================================================================*/
>  
> @@ -92,6 +93,11 @@ static struct pci_driver airo_driver = {
>  #include <linux/delay.h>
>  #endif
>  
> +/* enable rx mic checking
> + *disable because it takes some time in ISR
> + */
> +#define WPA_CHECK_RX_MIC
> +
>  /* Hack to do some power saving */
>  #define POWER_ON_DOWN
>  
> @@ -224,6 +230,7 @@ static
>  int maxencrypt /* = 0 */; /* The highest rate that the card can encrypt at.
>  		       0 means no limit.  For old cards this was 4 */
>  
> +static int wpa_enabled; /* If set the card is in WPA mode. This is incompatible with WEP or open mode */
>  static int auto_wep /* = 0 */; /* If set, it tries to figure out the wep mode */
>  static int aux_bap /* = 0 */; /* Checks to see if the aux ports are needed to read
>  		    the bap, needed on some older cards and buses. */
> @@ -251,6 +258,9 @@ module_param(basic_rate, int, 0);
>  module_param_array(rates, int, NULL, 0);
>  module_param_array(ssids, charp, NULL, 0);
>  module_param(auto_wep, int, 0);
> +module_param(wpa_enabled, int, 0);
> +MODULE_PARM_DESC(wpa_enabled, "If non-zero, the driver can use WPA \
> +but Open and WEP mode won't be possible");
>  MODULE_PARM_DESC(auto_wep, "If non-zero, the driver will keep looping through \
>  the authentication options until an association is made.  The value of \
>  auto_wep is number of the wep keys to check.  A value of 2 will try using \
> @@ -453,6 +463,7 @@ static int do8bitIO = 0;
>  #define RID_UNKNOWN22  0xFF22
>  #define RID_LEAPUSERNAME 0xFF23
>  #define RID_LEAPPASSWORD 0xFF24
> +#define RID_WPA        0xFF25
>  #define RID_STATUS     0xFF50
>  #define RID_BEACON_HST 0xFF51
>  #define RID_BUSY_HST   0xFF52
> @@ -507,6 +518,14 @@ typedef struct {
>  	u8 key[16];
>  } WepKeyRid;
>  
> +typedef struct {
> +	u16 len;
> +	u16 kindex;
> +	u8 mac[ETH_ALEN];
> +	u16 klen;
> +	u8 key[48];
> +} WpaKeyRid;
> +
>  /* These structures are from the Aironet's PC4500 Developers Manual */
>  typedef struct {
>  	u16 len;
> @@ -526,6 +545,19 @@ typedef struct {
>  #define MOD_MOK 2
>  } ModulationRid;
>  
> +/* Only present on firmware >= 5.30.17 */
> +typedef struct {
> +	u16 _reserved5[4];
> +	u16 auth_cipher;
> +#define AUTH_CIPHER_NONE 1
> +#define AUTH_CIPHER_WEP 0xc
> +#define AUTH_CIPHER_TKIP 0x210
> +	u16 auth_key;
> +#define AUTH_KEY_MGMT_NONE 1
> +#define AUTH_KEY_MGMT_802_1X 4
> +#define AUTH_KEY_MGMT_PSK 8
> +} ConfigRidExtra;
> +
>  typedef struct {
>  	u16 len; /* sizeof(ConfigRid) */
>  	u16 opmode; /* operating mode */
> @@ -581,6 +613,7 @@ typedef struct {
>  #define AUTH_ENCRYPT 0x101
>  #define AUTH_SHAREDKEY 0x102
>  #define AUTH_ALLOW_UNENCRYPTED 0x200
> +#define AUTH_ENCRYPT_WPA 0xc101
>  	u16 associationTimeout;
>  	u16 specifiedApTimeout;
>  	u16 offlineScanInterval;
> @@ -644,6 +677,8 @@ typedef struct {
>  #define MAGIC_STAY_IN_CAM (1<<10)
>  	u8 magicControl;
>  	u16 autoWake;
> +	/* Only present on firmware >= 5.30.17 */
> +	ConfigRidExtra extra;
>  } ConfigRid;
>  
>  typedef struct {
> @@ -1143,6 +1178,8 @@ static u8 airo_dbm_to_pct (tdsRssiEntry *rssi_rid, u8 dbm);
>  
>  static void airo_networks_free(struct airo_info *ai);
>  
> +static void airo_interrupt_tasklet(unsigned long data);
> +
>  struct airo_info {
>  	struct net_device_stats	stats;
>  	struct net_device             *dev;
> @@ -1229,6 +1266,19 @@ struct airo_info {
>  	unsigned int bssListFirst;
>  	unsigned int bssListNext;
>  	unsigned int bssListRidLen;
> +	unsigned int ConfigRidLen;
> +	unsigned char wpa_tx_key [8];
> +	unsigned char wpa_rx_key [8];
> +	unsigned char wpa_rx_key_m [8];
> +	unsigned char wpa_rx_key_m_old [8];
> +	u8 LLC [10];
> +	struct crypto_hash *tfm_michael;
> +	int wpa_enabled;
> +	int wpa_key_enabled;
> +
> +
> +	spinlock_t tasklet_lock;
> +	struct tasklet_struct isr_tasklet;
>  
>  	struct list_head network_list;
>  	struct list_head network_free_list;
> @@ -1725,6 +1775,55 @@ static void emmh32_final(emmh32_context *context, u8 digest[4])
>  	digest[3] = val & 0xFF;
>  }
>  
> +static void wpa_compute_mic(struct airo_info *ai ,char *pPacket, u8 *mic, int len, char *key)
> +{
> +	struct scatterlist sg[3];
> +	struct hash_desc desc;
> +
> +	sg[0].page = virt_to_page(pPacket);
> +	sg[0].offset = offset_in_page(pPacket);
> +	sg[0].length = sizeof(etherHead);
> +
> +
> +	sg[1].page = virt_to_page(ai->LLC);
> +	sg[1].offset = offset_in_page(ai->LLC);
> +	sg[1].length = sizeof(ai->LLC);
> +
> +	sg[2].page = virt_to_page(pPacket + sizeof(etherHead));
> +	sg[2].offset = offset_in_page(pPacket + sizeof(etherHead));
> +	sg[2].length = len - sizeof(etherHead);
> +
> +	crypto_hash_setkey(ai->tfm_michael, key, 8);
> +
> +	desc.tfm = ai->tfm_michael;
> +	desc.flags = 0;
> +
> +	crypto_hash_digest(&desc, sg, len + sizeof(ai->LLC),
> +			mic);
> +}
> +
> +#ifdef WPA_CHECK_RX_MIC
> +static int wpa_check_rx_mic(struct airo_info *ai ,char *buffer, int len)
> +{
> +	u8 mic[8];
> +	/* multicast */
> +	if (buffer[0] & 1) {
> +		wpa_compute_mic(ai, buffer, mic, len, ai->wpa_rx_key_m);
> +		if (memcmp(mic, buffer + len, 8)) {
> +			/* we don't know the current index, try the old one */
> +			wpa_compute_mic(ai, buffer, mic, len, ai->wpa_rx_key_m_old);
> +			return memcmp(mic, buffer + len, 8);
> +		}
> +	}
> +	else {
> +		wpa_compute_mic(ai, buffer, mic, len, ai->wpa_rx_key);
> +		return memcmp(mic, buffer + len, 8);
> +	}
> +	return 0;
> +}
> +#endif
> +
> +
>  static int readBSSListRid(struct airo_info *ai, int first,
>  		      BSSListRid *list) {
>  	int rc;
> @@ -1788,6 +1887,18 @@ static int writeWepKeyRid(struct airo_info*ai, WepKeyRid *pwkr, int perm, int lo
>  	return rc;
>  }
>  
> +static int writeWpaKeyRid(struct airo_info*ai, WpaKeyRid *pwkr, int lock) {
> +	int rc;
> +	WpaKeyRid wkr = *pwkr;
> +
> +	wkr.len = cpu_to_le16(wkr.len);
> +	wkr.kindex = cpu_to_le16(wkr.kindex);
> +	wkr.klen = cpu_to_le16(wkr.klen);
> +	rc = PC4500_writerid(ai, RID_WPA, &wkr, sizeof(wkr), lock);
> +	if (rc!=SUCCESS) airo_print_err(ai->dev->name, "WPA set %x", rc);
> +	return rc;
> +}
> +
>  static int readSsidRid(struct airo_info*ai, SsidRid *ssidr) {
>  	int i;
>  	int rc = PC4500_readrid(ai, RID_SSID, ssidr, sizeof(*ssidr), 1);
> @@ -1818,7 +1929,7 @@ static int readConfigRid(struct airo_info*ai, int lock) {
>  	if (ai->config.len)
>  		return SUCCESS;
>  
> -	rc = PC4500_readrid(ai, RID_ACTUALCONFIG, &cfg, sizeof(cfg), lock);
> +	rc = PC4500_readrid(ai, RID_ACTUALCONFIG, &cfg, ai->ConfigRidLen, lock);
>  	if (rc != SUCCESS)
>  		return rc;
>  
> @@ -1881,7 +1992,7 @@ static int writeConfigRid(struct airo_info*ai, int lock) {
>  	for(s = &cfgr.autoWake; s <= &cfgr.autoWake; s++)
>  		*s = cpu_to_le16(*s);
>  
> -	return PC4500_writerid( ai, RID_CONFIG, &cfgr, sizeof(cfgr), lock);
> +	return PC4500_writerid( ai, RID_CONFIG, &cfgr, ai->ConfigRidLen, lock);
>  }
>  static int readStatusRid(struct airo_info*ai, StatusRid *statr, int lock) {
>  	int rc = PC4500_readrid(ai, RID_STATUS, statr, sizeof(*statr), lock);
> @@ -2068,7 +2179,20 @@ static int mpi_send_packet (struct net_device *dev)
>  	 * Firmware automaticly puts 802 header on so
>  	 * we don't need to account for it in the length
>  	 */
> -	if (test_bit(FLAG_MIC_CAPABLE, &ai->flags) && ai->micstats.enabled &&
> +	if (ai->wpa_key_enabled) {
> +		u8 mic [8];
> +
> +		*payloadLen = cpu_to_le16(len-sizeof(etherHead)+8);
> +		ai->txfids[0].tx_desc.len += 8;
> +
> +		wpa_compute_mic(ai, buffer, mic, len, ai->wpa_tx_key);
> +
> +		dev->trans_start = jiffies;
> +		/* copy data into airo dma buffer */
> +		memcpy(sendbuf, buffer, len);
> +		memcpy(sendbuf + len, mic, 8);
> +	}
> +    else if (test_bit(FLAG_MIC_CAPABLE, &ai->flags) && ai->micstats.enabled &&
>  		(ntohs(((u16 *)buffer)[6]) != 0x888E)) {
>  		MICBuffer pMic;
>  
> @@ -2341,7 +2465,9 @@ static void airo_set_promisc(struct airo_info *ai) {
>  	cmd.cmd=CMD_SETMODE;
>  	clear_bit(JOB_PROMISC, &ai->jobs);
>  	cmd.parm0=(ai->flags&IFF_PROMISC) ? PROMISC : NOPROMISC;
> -	issuecommand(ai, &cmd, &rsp);
> +	/* when wpa is active, promisc mode can't be set */
> +	if (ai->wpa_key_enabled && cmd.parm0 != PROMISC)
> +		issuecommand(ai, &cmd, &rsp);
>  	up(&ai->sem);
>  }
>  
> @@ -2475,6 +2601,8 @@ void stop_airo_card( struct net_device *dev, int freeres )
>  		}
>          }
>  	crypto_free_cipher(ai->tfm);
> +	if (ai->tfm_michael)
> +		crypto_free_hash(ai->tfm_michael);
>  	del_airo_dev(ai);
>  	free_netdev( dev );
>  }
> @@ -2628,6 +2756,8 @@ static int mpi_map_card(struct airo_info *ai, struct pci_dev *pci)
>  		goto free_auxmap;
>  	}
>  
> +	tasklet_kill(&ai->isr_tasklet);
> +
>  	/*
>  	 * Setup descriptor RX, TX, CONFIG
>  	 */
> @@ -2804,6 +2934,7 @@ static int airo_test_wpa_capable(struct airo_info *ai)
>  	if ((cap_rid.softVer > 0x530)
>  	  || ((cap_rid.softVer == 0x530) && (cap_rid.softSubVer >= 17))) {
>  		airo_print_info("", "WPA is supported.");
> +		airo_print_info("", "Version 5.41 is recomended");
>  		return 1;
>  	}
>  
> @@ -2830,6 +2961,11 @@ static struct net_device *_init_airo_card( unsigned short irq, int port,
>  	}
>  
>  	ai = dev->priv;
> +	/* this is needed for initialisation, the firware check will be done
> +	 * latter. The windows driver, do it a different way : it reads
> +	 * ConfigRid.len .
> +	 */
> +	ai->ConfigRidLen = sizeof(ConfigRid) - sizeof(ConfigRidExtra);
>  	ai->wifidev = NULL;
>  	ai->flags = 1 << FLAG_RADIO_DOWN;
>  	ai->jobs = 0;
> @@ -2838,6 +2974,8 @@ static struct net_device *_init_airo_card( unsigned short irq, int port,
>  		airo_print_dbg("", "Found an MPI350 card");
>  		set_bit(FLAG_MPI, &ai->flags);
>  	}
> +	spin_lock_init(&ai->tasklet_lock);
> +	tasklet_init(&ai->isr_tasklet, airo_interrupt_tasklet, (unsigned long)dev);
>  	spin_lock_init(&ai->aux_lock);
>  	sema_init(&ai->sem, 1);
>  	ai->config.len = 0;
> @@ -2901,15 +3039,29 @@ static struct net_device *_init_airo_card( unsigned short irq, int port,
>  	}
>  
>  	/* Test for WPA support */
> -	if (airo_test_wpa_capable(ai)) {
> +	if (airo_test_wpa_capable(ai) && wpa_enabled) {
> +		char LLC1 [] = {0, 0, 0, 0, 0xaa, 0xaa, 0x03, 0x00, 0x00, 0x00};
>  		set_bit(FLAG_WPA_CAPABLE, &ai->flags);
>  		ai->bssListFirst = RID_WPA_BSSLISTFIRST;
>  		ai->bssListNext = RID_WPA_BSSLISTNEXT;
>  		ai->bssListRidLen = sizeof(BSSListRid);
> +		ai->ConfigRidLen = sizeof(ConfigRid);
> +		memcpy(ai->LLC, LLC1, sizeof(ai->LLC));
> +		ai->tfm_michael = crypto_alloc_hash("michael_mic", 0, CRYPTO_ALG_ASYNC);
> +		if (ai->tfm_michael == NULL) {
> +			printk(KERN_DEBUG "crypto API michael_mic failed. Removing WPA\n");
> +		}
> +		else {
> +			ai->wpa_enabled = 1;
> +			/* we don't want to enable wep mode : it will make the firmware 
> +			 * hanging */
> +			auto_wep = 0;
> +		}
>  	} else {
>  		ai->bssListFirst = RID_BSSLISTFIRST;
>  		ai->bssListNext = RID_BSSLISTNEXT;
>  		ai->bssListRidLen = sizeof(BSSListRid) - sizeof(BSSListRidExtra);
> +		ai->ConfigRidLen = sizeof(ConfigRid) - sizeof(ConfigRidExtra);
>  	}
>  
>  	strcpy(dev->name, "eth%d");
> @@ -3177,36 +3329,31 @@ static int airo_thread(void *data) {
>  	return 0;
>  }
>  
> -static irqreturn_t airo_interrupt ( int irq, void* dev_id) {
> -	struct net_device *dev = (struct net_device *)dev_id;
> +static void airo_interrupt_tasklet(unsigned long data)
> +{
> +	struct net_device *dev = (struct net_device *)data;
> +	unsigned long flags;
>  	u16 status;
>  	u16 fid;
>  	struct airo_info *apriv = dev->priv;
> -	u16 savedInterrupts = 0;
> -	int handled = 0;
>  
> -	if (!netif_device_present(dev))
> -		return IRQ_NONE;
> +	spin_lock_irqsave(&apriv->tasklet_lock, flags);
>  
>  	for (;;) {
>  		status = IN4500( apriv, EVSTAT );
>  		if ( !(status & STATUS_INTS) || status == 0xffff ) break;
>  
> -		handled = 1;
> -
>  		if ( status & EV_AWAKE ) {
>  			OUT4500( apriv, EVACK, EV_AWAKE );
>  			OUT4500( apriv, EVACK, EV_AWAKE );
>  		}
>  
> -		if (!savedInterrupts) {
> -			savedInterrupts = IN4500( apriv, EVINTEN );
> -			OUT4500( apriv, EVINTEN, 0 );
> -		}
>  
>  		if ( status & EV_MIC ) {
>  			OUT4500( apriv, EVACK, EV_MIC );
> -			if (test_bit(FLAG_MIC_CAPABLE, &apriv->flags)) {
> +			if (apriv->wpa_enabled) {
> +			}
> +			else if (test_bit(FLAG_MIC_CAPABLE, &apriv->flags)) {
>  				set_bit(JOB_MIC, &apriv->jobs);
>  				wake_up_interruptible(&apriv->thr_wait);
>  			}
> @@ -3250,6 +3397,8 @@ static irqreturn_t airo_interrupt ( int irq, void* dev_id) {
>  			  leaving BSS */
>  #define RC_NOAUTH 9 /* Station requesting (Re)Association is not
>  		       Authenticated with the responding station */
> +			printk("status : %x\n", newStatus);
> +
>  			if (newStatus == FORCELOSS && apriv->scan_timeout > 0)
>  				scan_forceloss = 1;
>  			if(newStatus == ASSOCIATED || newStatus == REASSOCIATED) {
> @@ -3376,7 +3525,9 @@ static irqreturn_t airo_interrupt ( int irq, void* dev_id) {
>  			} else {
>  				MICBuffer micbuf;
>  				bap_read (apriv, buffer, ETH_ALEN*2, BAP0);
> -				if (apriv->micstats.enabled) {
> +				if (apriv->wpa_key_enabled) {
> +				}
> +				else if (apriv->micstats.enabled) {
>  					bap_read (apriv,(u16*)&micbuf,sizeof(micbuf),BAP0);
>  					if (ntohs(micbuf.typelen) > 0x05DC)
>  						bap_setup (apriv, fid, 0x44, BAP0);
> @@ -3389,7 +3540,20 @@ static irqreturn_t airo_interrupt ( int irq, void* dev_id) {
>  					}
>  				}
>  				bap_read(apriv,buffer+ETH_ALEN,len,BAP0);
> -				if (decapsulate(apriv,&micbuf,(etherHead*)buffer,len)) {
> +				if (apriv->wpa_key_enabled) {
> +					len -= 8;
> +
> +					//this is easy to do, but take some time in ISR
> +#ifdef WPA_CHECK_RX_MIC
> +					if (wpa_check_rx_mic(apriv, skb->data, len + hdrlen)) {
> +						airo_print_err(apriv->dev->name, "Bad mic on RX");
> +						goto badmic;
> +					}
> +	
> +#endif
> +					skb_trim (skb, len + hdrlen);
> +				}
> +				else if (decapsulate(apriv,&micbuf,(etherHead*)buffer,len)) {
>  badmic:
>  					dev_kfree_skb_irq (skb);
>  badrx:
> @@ -3428,8 +3592,10 @@ badrx:
>  				skb->pkt_type = PACKET_OTHERHOST;
>  				skb->dev = apriv->wifidev;
>  				skb->protocol = htons(ETH_P_802_2);
> -			} else
> +			} else {
> +				skb->dev = dev;
>  				skb->protocol = eth_type_trans(skb,dev);
> +			}
>  			skb->dev->last_rx = jiffies;
>  			skb->ip_summed = CHECKSUM_NONE;
>  
> @@ -3495,8 +3661,28 @@ exittx:
>  				status & ~STATUS_INTS & ~IGNORE_INTS );
>  	}
>  
> -	if (savedInterrupts)
> -		OUT4500( apriv, EVINTEN, savedInterrupts );
> +	enable_interrupts(apriv);
> +
> +	spin_unlock_irqrestore(&apriv->tasklet_lock, flags);
> +}
> +
> +static irqreturn_t airo_interrupt ( int irq, void* dev_id) {
> +	struct net_device *dev = (struct net_device *)dev_id;
> +	struct airo_info *apriv = dev->priv;
> +	int handled;
> +	u16 status;
> +
> +	if (!netif_device_present(dev))
> +		return IRQ_NONE;
> +	status = IN4500( apriv, EVSTAT );
> +	if ( !(status & STATUS_INTS) || status == 0xffff )
> +		handled = 0;
> +	else {
> +		handled = 1;
> +		disable_interrupts(apriv);
> +		tasklet_schedule(&apriv->isr_tasklet);
> +	}
> +
>  
>  	/* done.. */
>  	return IRQ_RETVAL(handled);
> @@ -3624,7 +3810,9 @@ static void mpi_receive_802_3(struct airo_info *ai)
>  		}
>  		buffer = skb_put(skb,len);
>  		memcpy(buffer, ai->rxfids[0].virtual_host_addr, ETH_ALEN * 2);
> -		if (ai->micstats.enabled) {
> +		if (ai->wpa_key_enabled) {
> +		}
> +		else if (ai->micstats.enabled) {
>  			memcpy(&micbuf,
>  				ai->rxfids[0].virtual_host_addr + ETH_ALEN * 2,
>  				sizeof(micbuf));
> @@ -3639,7 +3827,19 @@ static void mpi_receive_802_3(struct airo_info *ai)
>  		memcpy(buffer + ETH_ALEN * 2,
>  			ai->rxfids[0].virtual_host_addr + ETH_ALEN * 2 + off,
>  			len - ETH_ALEN * 2 - off);
> -		if (decapsulate (ai, &micbuf, (etherHead*)buffer, len - off - ETH_ALEN * 2)) {
> +		if (ai->wpa_key_enabled) {
> +			len -= 8;
> +
> +#ifdef WPA_CHECK_RX_MIC
> +			if (wpa_check_rx_mic(ai, buffer, len)) {
> +				airo_print_err(ai->dev->name, "Bad mic on RX");
> +				goto badmic;
> +			}
> +#endif
> +
> +			skb_trim (skb, len);
> +		}
> +		else if (decapsulate (ai, &micbuf, (etherHead*)buffer, len - off - ETH_ALEN * 2)) {
>  badmic:
>  			dev_kfree_skb_irq (skb);
>  			goto badrx;
> @@ -3658,6 +3858,7 @@ badmic:
>  		}
>  #endif /* WIRELESS_SPY */
>  
> +		skb->dev = ai->dev;
>  		skb->ip_summed = CHECKSUM_NONE;
>  		skb->protocol = eth_type_trans(skb, ai->dev);
>  		skb->dev->last_rx = jiffies;
> @@ -4332,7 +4533,10 @@ static int transmit_802_3_packet(struct airo_info *ai, int len, char *pPacket)
>  	}
>  	len -= ETH_ALEN * 2;
>  
> -	if (test_bit(FLAG_MIC_CAPABLE, &ai->flags) && ai->micstats.enabled && 
> +	if (ai->wpa_key_enabled) {
> +		miclen = 8;
> +	}
> +	else if (test_bit(FLAG_MIC_CAPABLE, &ai->flags) && ai->micstats.enabled && 
>  	    (ntohs(((u16 *)pPacket)[6]) != 0x888E)) {
>  		if (encapsulate(ai,(etherHead *)pPacket,&pMic,len) != SUCCESS)
>  			return ERROR;
> @@ -4346,9 +4550,27 @@ static int transmit_802_3_packet(struct airo_info *ai, int len, char *pPacket)
>  	payloadLen = cpu_to_le16(len + miclen);
>  	bap_write(ai, &payloadLen, sizeof(payloadLen),BAP1);
>  	bap_write(ai, (const u16*)pPacket, sizeof(etherHead), BAP1);
> -	if (miclen)
> -		bap_write(ai, (const u16*)&pMic, miclen, BAP1);
> -	bap_write(ai, (const u16*)(pPacket + sizeof(etherHead)), len, BAP1);
> +	if (ai->wpa_key_enabled) {
> +		u8 mic[8];
> +
> +		wpa_compute_mic(ai, pPacket, mic, len + sizeof(etherHead), ai->wpa_tx_key);
> +		//XXX ugly hack because we write per 16 bits packet
> +		bap_write(ai, (const u16*)(pPacket + sizeof(etherHead)), len - (len&1), BAP1);
> +		if (len&1) {
> +			u8 tmp [2];
> +			tmp [0] = pPacket [sizeof(etherHead) + len-1];
> +			tmp [1] = mic[0];
> +			bap_write(ai, (const u16*)tmp, 2, BAP1);
> +			bap_write(ai, (const u16*)(mic+1), sizeof(mic)-1, BAP1);
> +		}
> +		else
> +			bap_write(ai, (const u16*)mic, sizeof(mic), BAP1);
> +	}
> +	else {
> +		if (miclen)
> +			bap_write(ai, (const u16*)&pMic, miclen, BAP1);
> +		bap_write(ai, (const u16*)(pPacket + sizeof(etherHead)), len, BAP1);
> +	}
>  	// issue the transmit command
>  	memset( &cmd, 0, sizeof( cmd ) );
>  	cmd.cmd = CMD_TRANSMIT;
> @@ -6350,6 +6572,10 @@ static int airo_set_encode(struct net_device *dev,
>  	int perm = ( dwrq->flags & IW_ENCODE_TEMP ? 0 : 1 );
>  	u16 currentAuthType = local->config.authType;
>  
> +	/* In wpa mode, only wpa is allowed */
> +	if (local->wpa_enabled)
> +		return -EINVAL;
> +
>  	/* Is WEP supported ? */
>  	readCapabilityRid(local, &cap_rid, 1);
>  	/* Older firmware doesn't support this...
> @@ -6445,6 +6671,7 @@ static int airo_get_encode(struct net_device *dev,
>  	readConfigRid(local, 1);
>  	/* Check encryption mode */
>  	switch(local->config.authType)	{
> +		case AUTH_ENCRYPT_WPA:
>  		case AUTH_ENCRYPT:
>  			dwrq->flags = IW_ENCODE_OPEN;
>  			break;
> @@ -6476,6 +6703,85 @@ static int airo_get_encode(struct net_device *dev,
>  /*
>   * Wireless Handler : set extended Encryption parameters
>   */
> +static int airo_set_encodeext_wpa(struct airo_info *local,
> +							struct iw_encode_ext *ext,
> +							struct iw_point *encoding)
> +{
> +	static const unsigned char macaddr[ETH_ALEN] = { 0x01, 0, 0, 0, 0, 0 };
> +	WpaKeyRid wkr;
> +	int index = (encoding->flags & IW_ENCODE_INDEX) - 1;
> +
> +	printk("set wpa : %d %d %d %x\n", ext->alg, ext->key_len, index, ext->ext_flags);
> +
> +	memset(&wkr, 0, sizeof(wkr));
> +	wkr.len = sizeof(wkr);
> +
> +	if ((encoding->flags & IW_ENCODE_DISABLED) ||
> +			ext->alg == IW_ENCODE_ALG_NONE || ext->key_len == 0) {
> +		wkr.kindex = index;
> +		memcpy( wkr.mac, macaddr, ETH_ALEN );
> +		printk(KERN_INFO "Wpa Removing key %d\n", index);
> +		memset(local->wpa_tx_key, 0, 8);
> +		memset(local->wpa_rx_key, 0, 8);
> +		memset(local->wpa_rx_key_m, 0, 8);
> +		memset(local->wpa_rx_key_m_old, 0, 8);
> +		local->wpa_key_enabled = 0;
> +	}
> +	else if (ext->alg == IW_ENCODE_ALG_WEP)
> +		return -EOPNOTSUPP;
> +	else if (ext->alg == IW_ENCODE_ALG_TKIP && ext->key_len == 32) {
> +		// we cannot set a WPA key in a non-WPA mode
> +		if (local->config.authType != AUTH_ENCRYPT_WPA)
> +			return -EINVAL;
> +		wkr.kindex = index;
> +		memcpy( wkr.mac, macaddr, ETH_ALEN );
> +		wkr.klen = 0x30;
> +
> +		/* firmware use ndis order + a hole at 16-21 */
> +		memcpy(wkr.key, ext->key, 16); /* temporal key */
> +		memcpy(wkr.key + 40, ext->key + 16, 8); /*TX*/
> +		memcpy(wkr.key + 32, ext->key + 24, 8); /*RX*/
> +
> +		if (ext->ext_flags & IW_ENCODE_EXT_RX_SEQ_VALID) {
> +			memcpy(wkr.key + 22, ext->rx_seq, 6);
> +		}
> +
> +		if (ext->ext_flags & IW_ENCODE_EXT_GROUP_KEY) {
> +			memcpy(local->wpa_rx_key_m_old, local->wpa_rx_key_m, 8);
> +			memcpy(local->wpa_rx_key_m, ext->key+24, 8);
> +		}
> +		else {
> +			memcpy(local->wpa_tx_key, ext->key+16, 8);
> +			memcpy(local->wpa_rx_key, ext->key+24, 8);
> +		}
> +	}
> +	else
> +		return -EINVAL;
> +
> +
> +
> +	if (down_interruptible(&local->sem))
> +		return ERROR;
> +
> +	writeWpaKeyRid(local, &wkr, 0);
> +
> +	if (ext->ext_flags & IW_ENCODE_EXT_SET_TX_KEY) {
> +		memset(&wkr, 0, sizeof(wkr));
> +		wkr.len = sizeof(wkr);
> +		wkr.kindex = 0xffff;
> +		wkr.mac[0] = (char)index;
> +		wkr.klen = 0x30;
> +
> +		printk(KERN_INFO "Setting default tx key to %d\n", index);
> +		writeWpaKeyRid(local, &wkr, 0);
> +
> +		local->wpa_key_enabled = 1;
> +	}
> +
> +	up(&local->sem);
> +	return 0;
> +}
> +
>  static int airo_set_encodeext(struct net_device *dev,
>  			   struct iw_request_info *info,
>  			    union iwreq_data *wrqu,
> @@ -6498,6 +6804,8 @@ static int airo_set_encodeext(struct net_device *dev,
>  	} */
>  	readConfigRid(local, 1);
>  
> +	if (local->wpa_enabled)
> +		return airo_set_encodeext_wpa(local, ext, encoding);
>  	/* Determine and validate the key index */
>  	idx = encoding->flags & IW_ENCODE_INDEX;
>  	if (idx) {
> @@ -6572,6 +6880,7 @@ static int airo_get_encodeext(struct net_device *dev,
>  	struct iw_encode_ext *ext = (struct iw_encode_ext *)extra;
>  	CapabilityRid cap_rid;		/* Card capability info */
>  	int idx, max_key_len;
> +	printk("get_encode\n");
>  
>  	/* Is it supported ? */
>  	readCapabilityRid(local, &cap_rid, 1);
> @@ -6597,6 +6906,7 @@ static int airo_get_encodeext(struct net_device *dev,
>  
>  	/* Check encryption mode */
>  	switch(local->config.authType) {
> +		case AUTH_ENCRYPT_WPA:
>  		case AUTH_ENCRYPT:
>  			encoding->flags = IW_ENCODE_ALG_WEP | IW_ENCODE_ENABLED;
>  			break;
> @@ -6622,6 +6932,20 @@ static int airo_get_encodeext(struct net_device *dev,
>  }
>  
> 
> +static void wpa_off(struct airo_info *local)
> +{
> +	printk(KERN_INFO"WPA dis\n");
> +	local->config.authType=AUTH_OPEN;
> +	local->config.extra.auth_key=AUTH_KEY_MGMT_NONE;
> +}
> +
> +static void wpa_on(struct airo_info *local)
> +{
> +	printk(KERN_INFO"WPA enable\n");
> +	local->config.authType=AUTH_ENCRYPT_WPA;
> +	local->config.extra.auth_cipher=AUTH_CIPHER_TKIP;
> +	//local->config.extra._reserved5[0]=0x40;
> +}
>  /*------------------------------------------------------------------*/
>  /*
>   * Wireless Handler : set extended authentication parameters
> @@ -6636,17 +6960,55 @@ static int airo_set_auth(struct net_device *dev,
>  
>  	switch (param->flags & IW_AUTH_INDEX) {
>  	case IW_AUTH_WPA_VERSION:
> +		if (param->value == IW_AUTH_WPA_VERSION_WPA)
> +			wpa_on(local);
> +		else if (param->value == IW_AUTH_WPA_VERSION_DISABLED)
> +			wpa_off(local);
> +		else
> +			return -EINVAL;
> +		break;
>  	case IW_AUTH_CIPHER_PAIRWISE:
>  	case IW_AUTH_CIPHER_GROUP:
> +		if ((param->value == IW_AUTH_CIPHER_TKIP) && (local->config.authType == AUTH_ENCRYPT_WPA))
> +			return 0;
> +		else if (((param->value == IW_AUTH_CIPHER_WEP40) ||(param->value == IW_AUTH_CIPHER_WEP104))
> +				&& (local->config.authType != AUTH_ENCRYPT_WPA))
> +			return 0;
> +		else if ((param->value == IW_AUTH_CIPHER_NONE) && (local->config.authType != AUTH_ENCRYPT_WPA))
> +			local->config.authType = AUTH_OPEN;
> +		else
> +			return -EINVAL;
> +		break;
>  	case IW_AUTH_KEY_MGMT:
> -	case IW_AUTH_RX_UNENCRYPTED_EAPOL:
> +		if (local->config.authType != AUTH_ENCRYPT_WPA)
> +			return -EINVAL;
> +		if (param->value == IW_AUTH_KEY_MGMT_802_1X)
> +			local->config.extra.auth_key=AUTH_KEY_MGMT_802_1X;
> +		else if (param->value == IW_AUTH_KEY_MGMT_PSK)
> +			local->config.extra.auth_key=AUTH_KEY_MGMT_PSK;
> +		else
> +			return -EINVAL;
> +		break;
>  	case IW_AUTH_PRIVACY_INVOKED:
> +		if (!param->value) {
> +			if (local->config.authType == AUTH_ENCRYPT_WPA)
> +				wpa_off(local);
> +			else
> +				wpa_on(local);
> +		}
> +		else
> +			return 0;
> +		break;
> +	case IW_AUTH_RX_UNENCRYPTED_EAPOL:
> +	case IW_AUTH_TKIP_COUNTERMEASURES:
>  		/*
>  		 * airo does not use these parameters
>  		 */
>  		break;
>  
>  	case IW_AUTH_DROP_UNENCRYPTED:
> +		if (local->wpa_enabled)
> +			break;
>  		if (param->value) {
>  			/* Only change auth type if unencrypted */
>  			if (currentAuthType == AUTH_OPEN)
> @@ -6655,15 +7017,16 @@ static int airo_set_auth(struct net_device *dev,
>  			local->config.authType = AUTH_OPEN;
>  		}
>  
> -		/* Commit the changes to flags if needed */
> -		if (local->config.authType != currentAuthType)
> -			set_bit (FLAG_COMMIT, &local->flags);
>  		break;
>  
>  	case IW_AUTH_80211_AUTH_ALG: {
>  			/* FIXME: What about AUTH_OPEN?  This API seems to
>  			 * disallow setting our auth to AUTH_OPEN.
>  			 */
> +			/* does not make sense with WPA */
> +			if (local->config.authType == AUTH_ENCRYPT_WPA)
> +				return 0;
> +
>  			if (param->value & IW_AUTH_ALG_SHARED_KEY) {
>  				local->config.authType = AUTH_SHAREDKEY;
>  			} else if (param->value & IW_AUTH_ALG_OPEN_SYSTEM) {
> @@ -6671,21 +7034,20 @@ static int airo_set_auth(struct net_device *dev,
>  			} else
>  				return -EINVAL;
>  			break;
> -
> -			/* Commit the changes to flags if needed */
> -			if (local->config.authType != currentAuthType)
> -				set_bit (FLAG_COMMIT, &local->flags);
>  		}
>  
>  	case IW_AUTH_WPA_ENABLED:
> -		/* Silently accept disable of WPA */
> -		if (param->value > 0)
> -			return -EOPNOTSUPP;
> +		if (param->value == 0)
> +			wpa_off(local);
> +		else
> +			wpa_on(local);
>  		break;
>  
>  	default:
>  		return -EOPNOTSUPP;
>  	}
> +
> +	set_bit (FLAG_COMMIT, &local->flags);
>  	return -EINPROGRESS;
>  }
>  
> @@ -6737,6 +7099,28 @@ static int airo_get_auth(struct net_device *dev,
>  	return 0;
>  }
>  
> +static int airo_disasociate(struct net_device *dev,
> +		struct iw_request_info *info,
> +		struct iw_point *data, char *extra)
> +{
> +	struct airo_info *local = dev->priv;
> +	SsidRid SSID_rid;		/* SSIDs */
> +
> +	/* reset the list */
> +	memset(&SSID_rid, 0, sizeof(SSID_rid));
> +
> +	/* Set the SSID */
> +	strcpy(SSID_rid.ssids[0].ssid, "tsunami");
> +	SSID_rid.ssids[0].len = 7;
> +	SSID_rid.len = sizeof(SSID_rid);
> +	/* Write it to the card */
> +	disable_MAC(local, 1);
> +	writeSsidRid(local, &SSID_rid, 1);
> +	enable_MAC(local, 1);
> +
> +	return 0;
> +}
> +
>  
>  /*------------------------------------------------------------------*/
>  /*
> @@ -7553,6 +7937,7 @@ static const iw_handler		airo_handler[] =
>  	(iw_handler) airo_set_encodeext,	/* SIOCSIWENCODEEXT */
>  	(iw_handler) airo_get_encodeext,	/* SIOCGIWENCODEEXT */
>  	(iw_handler) NULL,			/* SIOCSIWPMKSA */
> +	[SIOCSIWMLME-SIOCSIWCOMMIT] = (iw_handler) airo_disasociate,
>  };
>  
>  /* Note : don't describe AIROIDIFC and AIROOLDIDIFC in here.
> Chiacchiera con i tuoi amici in tempo reale! 
>  http://it.yahoo.com/mail_it/foot/*http://it.messenger.yahoo.com 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

