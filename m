Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:29775 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394Ab0K3Pmy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Nov 2010 10:42:54 -0500
Date: Tue, 30 Nov 2010 16:35:14 +0100
From: David Chosrova <david.chosrova@libertysurf.fr>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, error27@gmail.com,
	andreamrl@tiscali.it, linux-wireless@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [PATCH] Staging: rtl8192u: remove dead code to disable dot11d
Message-ID: <20101130153514.GA6479@debian.home>
References: <1290634903.4ced8697b0603@webmail.aliceadsl.fr> <20101125053626.GS1522@bicker> <4CEE2EE4.1010300@gmail.com> <20101125100402.GU1522@bicker> <20101127223748.GC16462@debian.home> <20101128211955.GD30799@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20101128211955.GD30799@bicker>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


I resend the patch as the one before did not rech the kernel-janitors list.

This patch removes all the ENABLE_DOT11D ifdefs.
It is always defined for this driver.

DOT11D has to do with regulatory domains.

What prompted this patch was a warning message in Sparse:

drivers/staging/rtl8192u/r8192U_core.c:247:1: warning: "eqMacAddr"
redefined in file included from drivers/staging/rtl8192u/:81:81:
drivers/staging/rtl8192u/dot11d.h:35:1: warning: this is the location
of the previous definition

Now there are no idefs around dot11d.h,it made no sense to have this second definition, so I removed that macro as well. ( Thanks Dan ;-) ).

Signed-off-by: David chosrova <david.chosrova@libertysurf.fr>
Acked-by: Dan Carpenter <error27@gmail.com>

---


diff --git a/drivers/staging/rtl8192u/Makefile b/drivers/staging/rtl8192u/Makefile
index 206d924..eefc657 100644
--- a/drivers/staging/rtl8192u/Makefile
+++ b/drivers/staging/rtl8192u/Makefile
@@ -9,7 +9,6 @@ ccflags-y += -DTHOMAS_BEACON -DTHOMAS_TASKLET -DTHOMAS_SKB -DTHOMAS_TURBO
 #ccflags-y += -DUSB_TX_DRIVER_AGGREGATION_ENABLE
 #ccflags-y += -DUSB_RX_AGGREGATION_SUPPORT
 ccflags-y += -DUSE_ONE_PIPE
-ccflags-y += -DENABLE_DOT11D
 ccflags-y += -Idrivers/staging/rtl8192u/ieee80211
 
 r8192u_usb-y := r8192U_core.o r8180_93cx6.o r8192U_wx.o		\
diff --git a/drivers/staging/rtl8192u/dot11d.h b/drivers/staging/rtl8192u/dot11d.h
index d99cc03..92e7a00 100644
--- a/drivers/staging/rtl8192u/dot11d.h
+++ b/drivers/staging/rtl8192u/dot11d.h
@@ -1,7 +1,6 @@
 #ifndef __INC_DOT11D_H
 #define __INC_DOT11D_H
 
-#ifdef ENABLE_DOT11D
 #include "ieee80211/ieee80211.h"
 
 
@@ -98,5 +97,4 @@ int ToLegalChannel(
 	struct ieee80211_device *dev,
 	u8 channel
 );
-#endif /* ENABLE_DOT11D */
 #endif /* #ifndef __INC_DOT11D_H */
diff --git a/drivers/staging/rtl8192u/ieee80211/dot11d.c b/drivers/staging/rtl8192u/ieee80211/dot11d.c
index b91cbfc..ce63fc3 100644
--- a/drivers/staging/rtl8192u/ieee80211/dot11d.c
+++ b/drivers/staging/rtl8192u/ieee80211/dot11d.c
@@ -1,4 +1,3 @@
-#ifdef ENABLE_DOT11D
 //-----------------------------------------------------------------------------
 //	File:
 //		Dot11d.c
@@ -220,4 +219,3 @@ EXPORT_SYMBOL(DOT11D_ScanComplete);
 EXPORT_SYMBOL(IsLegalChannel);
 EXPORT_SYMBOL(ToLegalChannel);
 
-#endif
diff --git a/drivers/staging/rtl8192u/ieee80211/dot11d.h b/drivers/staging/rtl8192u/ieee80211/dot11d.h
index 15b7a4b..029c2ca 100644
--- a/drivers/staging/rtl8192u/ieee80211/dot11d.h
+++ b/drivers/staging/rtl8192u/ieee80211/dot11d.h
@@ -1,7 +1,6 @@
 #ifndef __INC_DOT11D_H
 #define __INC_DOT11D_H
 
-#ifdef ENABLE_DOT11D
 #include "ieee80211.h"
 
 //#define ENABLE_DOT11D
@@ -98,5 +97,4 @@ int ToLegalChannel(
 	struct ieee80211_device * dev,
 	u8 channel
 );
-#endif //ENABLE_DOT11D
 #endif // #ifndef __INC_DOT11D_H
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211.h b/drivers/staging/rtl8192u/ieee80211/ieee80211.h
index e1216b7..c0b844d 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211.h
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211.h
@@ -1572,10 +1572,8 @@ struct ieee80211_network {
 #ifdef THOMAS_TURBO
 	u8 Turbo_Enable;//enable turbo mode, added by thomas
 #endif
-#ifdef ENABLE_DOT11D
 	u16 CountryIeLen;
 	u8 CountryIeBuf[MAX_IE_LEN];
-#endif
 	// HT Related, by amy, 2008.04.29
 	BSS_HT	bssht;
 	// Add to handle broadcom AP management frame CCK rate.
@@ -1769,7 +1767,6 @@ typedef u32 RT_RF_CHANGE_SOURCE;
 #define RF_CHANGE_BY_IPS BIT28
 #define RF_CHANGE_BY_INIT	0	// Do not change the RFOff reason. Defined by Bruce, 2008-01-17.
 
-#ifdef ENABLE_DOT11D
 typedef enum
 {
 	COUNTRY_CODE_FCC = 0,
@@ -1784,7 +1781,6 @@ typedef enum
 	COUNTRY_CODE_MIC,
 	COUNTRY_CODE_GLOBAL_DOMAIN
 }country_code_type_t;
-#endif
 
 #define RT_MAX_LD_SLOT_NUM	10
 typedef struct _RT_LINK_DETECT_T{
@@ -1970,12 +1966,8 @@ struct ieee80211_device {
 
 	/* map of allowed channels. 0 is dummy */
 	// FIXME: remeber to default to a basic channel plan depending of the PHY type
-#ifdef ENABLE_DOT11D
 	void* pDot11dInfo;
 	bool bGlobalDomain;
-#else
-	int channel_map[MAX_CHANNEL_NUMBER+1];
-#endif
 	int rate;       /* current rate */
 	int basic_rate;
 	//FIXME: pleace callback, see if redundant with softmac_features
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
index c8ca9d8..b34dc52 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
@@ -43,10 +43,7 @@
 #include <asm/uaccess.h>
 #include <linux/ctype.h>
 
-#include "ieee80211.h"
-#ifdef ENABLE_DOT11D
 #include "dot11d.h"
-#endif
 static inline void ieee80211_monitor_rx(struct ieee80211_device *ieee,
 					struct sk_buff *skb,
 					struct ieee80211_rx_stats *rx_stats)
@@ -1599,7 +1596,6 @@ static const char *get_info_element_string(u16 id)
 }
 #endif
 
-#ifdef ENABLE_DOT11D
 static inline void ieee80211_extract_country_ie(
 	struct ieee80211_device *ieee,
 	struct ieee80211_info_element *info_element,
@@ -1632,7 +1628,6 @@ static inline void ieee80211_extract_country_ie(
 	}
 
 }
-#endif
 
 int ieee80211_parse_info_param(struct ieee80211_device *ieee,
 		struct ieee80211_info_element *info_element,
@@ -2086,14 +2081,12 @@ int ieee80211_parse_info_param(struct ieee80211_device *ieee,
 			       "QoS Error need to parse QOS_PARAMETER IE\n");
 			break;
 
-#ifdef ENABLE_DOT11D
 		case MFIE_TYPE_COUNTRY:
 			IEEE80211_DEBUG_SCAN("MFIE_TYPE_COUNTRY: %d bytes\n",
 					     info_element->len);
 			//printk("=====>Receive <%s> Country IE\n",network->ssid);
 			ieee80211_extract_country_ie(ieee, info_element, network, network->bssid);//addr2 is same as addr3 when from an AP
 			break;
-#endif
 /* TODO */
 		default:
 			IEEE80211_DEBUG_MGMT
@@ -2229,10 +2222,8 @@ static inline int ieee80211_network_init(
 #ifdef THOMAS_TURBO
 	network->Turbo_Enable = 0;
 #endif
-#ifdef ENABLE_DOT11D
 	network->CountryIeLen = 0;
 	memset(network->CountryIeBuf, 0, MAX_IE_LEN);
-#endif
 //Initialize HT parameters
 	//ieee80211_ht_initialize(&network->bssht);
 	HTInitializeBssDesc(&network->bssht);
@@ -2399,10 +2390,8 @@ static inline void update_network(struct ieee80211_network *dst,
 	dst->Turbo_Enable = src->Turbo_Enable;
 #endif
 
-#ifdef ENABLE_DOT11D
 	dst->CountryIeLen = src->CountryIeLen;
 	memcpy(dst->CountryIeBuf, src->CountryIeBuf, src->CountryIeLen);
-#endif
 
 	//added by amy for LEAP
 	dst->bWithAironetIE = src->bWithAironetIE;
@@ -2470,7 +2459,6 @@ static inline void ieee80211_process_probe_response(
 		return;
 	}
 
-#ifdef ENABLE_DOT11D
 	// For Asus EeePc request,
 	// (1) if wireless adapter receive get any 802.11d country code in AP beacon,
 	//	   wireless adapter should follow the country code.
@@ -2527,7 +2515,6 @@ static inline void ieee80211_process_probe_response(
 			}
 		}
 	}
-#endif
 
 	/* The network parsed correctly -- so now we scan our known networks
 	 * to see if we can find it in our list.
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
index bc8c425..1285888 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
@@ -21,9 +21,7 @@
 #include <linux/slab.h>
 #include <linux/version.h>
 #include <asm/uaccess.h>
-#ifdef ENABLE_DOT11D
 #include "dot11d.h"
-#endif
 
 u8 rsn_authen_cipher_suite[16][4] = {
 	{0x00,0x0F,0xAC,0x00}, //Use group key, //Reserved
@@ -430,10 +428,8 @@ void ieee80211_send_probe_requests(struct ieee80211_device *ieee)
 void ieee80211_softmac_scan_syncro(struct ieee80211_device *ieee)
 {
 	short ch = 0;
-#ifdef ENABLE_DOT11D
 	u8 channel_map[MAX_CHANNEL_NUMBER+1];
 	memcpy(channel_map, GET_DOT11D_INFO(ieee)->channel_map, MAX_CHANNEL_NUMBER+1);
-#endif
 	down(&ieee->scan_sem);
 
 	while(1)
@@ -443,11 +439,7 @@ void ieee80211_softmac_scan_syncro(struct ieee80211_device *ieee)
 			ch++;
 			if (ch > MAX_CHANNEL_NUMBER)
 				goto out; /* scan completed */
-#ifdef ENABLE_DOT11D
 		}while(!channel_map[ch]);
-#else
-		}while(!ieee->channel_map[ch]);
-#endif
 
 		/* this function can be called in two situations
 		 * 1- We have switched to ad-hoc mode and we are
@@ -471,9 +463,7 @@ void ieee80211_softmac_scan_syncro(struct ieee80211_device *ieee)
 		if (ieee->state == IEEE80211_LINKED)
 			goto out;
 		ieee->set_chan(ieee->dev, ch);
-#ifdef ENABLE_DOT11D
 		if(channel_map[ch] == 1)
-#endif
 		ieee80211_send_probe_requests(ieee);
 
 		/* this prevent excessive time wait when we
@@ -496,10 +486,8 @@ out:
 	}
 	else{
 	ieee->sync_scan_hurryup = 0;
-#ifdef ENABLE_DOT11D
 	if(IS_DOT11D_ENABLE(ieee))
 		DOT11D_ScanComplete(ieee);
-#endif
 	up(&ieee->scan_sem);
 }
 }
@@ -510,10 +498,8 @@ void ieee80211_softmac_scan_wq(struct work_struct *work)
 	struct delayed_work *dwork = container_of(work, struct delayed_work, work);
 	struct ieee80211_device *ieee = container_of(dwork, struct ieee80211_device, softmac_scan_wq);
 	static short watchdog = 0;
-#ifdef ENABLE_DOT11D
 	u8 channel_map[MAX_CHANNEL_NUMBER+1];
 	memcpy(channel_map, GET_DOT11D_INFO(ieee)->channel_map, MAX_CHANNEL_NUMBER+1);
-#endif
 	if(!ieee->ieee_up)
 		return;
 	down(&ieee->scan_sem);
@@ -523,25 +509,15 @@ void ieee80211_softmac_scan_wq(struct work_struct *work)
 		if (watchdog++ > MAX_CHANNEL_NUMBER)
 		{
 		//if current channel is not in channel map, set to default channel.
-		#ifdef ENABLE_DOT11D
 			if (!channel_map[ieee->current_network.channel]);
-		#else
-			if (!ieee->channel_map[ieee->current_network.channel]);
-		#endif
 				ieee->current_network.channel = 6;
 				goto out; /* no good chans */
 		}
-#ifdef ENABLE_DOT11D
 	}while(!channel_map[ieee->current_network.channel]);
-#else
-	}while(!ieee->channel_map[ieee->current_network.channel]);
-#endif
 	if (ieee->scanning == 0 )
 		goto out;
 	ieee->set_chan(ieee->dev, ieee->current_network.channel);
-#ifdef ENABLE_DOT11D
 	if(channel_map[ieee->current_network.channel] == 1)
-#endif
 	ieee80211_send_probe_requests(ieee);
 
 
@@ -550,10 +526,8 @@ void ieee80211_softmac_scan_wq(struct work_struct *work)
 	up(&ieee->scan_sem);
 	return;
 out:
-#ifdef ENABLE_DOT11D
 	if(IS_DOT11D_ENABLE(ieee))
 		DOT11D_ScanComplete(ieee);
-#endif
 	ieee->actscanning = false;
 	watchdog = 0;
 	ieee->scanning = 0;
@@ -635,7 +609,6 @@ void ieee80211_stop_scan(struct ieee80211_device *ieee)
 /* called with ieee->lock held */
 void ieee80211_start_scan(struct ieee80211_device *ieee)
 {
-#ifdef ENABLE_DOT11D
 	if(IS_DOT11D_ENABLE(ieee) )
 	{
 		if(IS_COUNTRY_IE_VALID(ieee))
@@ -643,7 +616,6 @@ void ieee80211_start_scan(struct ieee80211_device *ieee)
 			RESET_CIE_WATCHDOG(ieee);
 		}
 	}
-#endif
 	if (ieee->softmac_features & IEEE_SOFTMAC_SCAN){
 		if (ieee->scanning == 0){
 			ieee->scanning = 1;
@@ -657,7 +629,6 @@ void ieee80211_start_scan(struct ieee80211_device *ieee)
 /* called with wx_sem held */
 void ieee80211_start_scan_syncro(struct ieee80211_device *ieee)
 {
-#ifdef ENABLE_DOT11D
 	if(IS_DOT11D_ENABLE(ieee) )
 	{
 		if(IS_COUNTRY_IE_VALID(ieee))
@@ -665,7 +636,6 @@ void ieee80211_start_scan_syncro(struct ieee80211_device *ieee)
 			RESET_CIE_WATCHDOG(ieee);
 		}
 	}
-#endif
 	ieee->sync_scan_hurryup = 0;
 	if (ieee->softmac_features & IEEE_SOFTMAC_SCAN)
 		ieee80211_softmac_scan_syncro(ieee);
@@ -2390,11 +2360,9 @@ void ieee80211_start_ibss_wq(struct work_struct *work)
 	ieee80211_softmac_check_all_nets(ieee);
 
 
-#ifdef ENABLE_DOT11D //if creating an ad-hoc, set its channel to 10 temporarily--this is the requirement for ASUS, not 11D, so disable 11d.
 //	if((IS_DOT11D_ENABLE(ieee)) && (ieee->state == IEEE80211_NOLINK))
 	if (ieee->state == IEEE80211_NOLINK)
 		ieee->current_network.channel = 6;
-#endif
 	/* if not then the state is not linked. Maybe the user swithced to
 	 * ad-hoc mode just after being in monitor mode, or just after
 	 * being very few time in managed mode (so the card have had no
@@ -2483,7 +2451,6 @@ inline void ieee80211_start_ibss(struct ieee80211_device *ieee)
 void ieee80211_start_bss(struct ieee80211_device *ieee)
 {
 	unsigned long flags;
-#ifdef ENABLE_DOT11D
 	//
 	// Ref: 802.11d 11.1.3.3
 	// STA shall not start a BSS unless properly formed Beacon frame including a Country IE.
@@ -2495,7 +2462,6 @@ void ieee80211_start_bss(struct ieee80211_device *ieee)
 			return;
 		}
 	}
-#endif
 	/* check if we have already found the net we
 	 * are interested in (if any).
 	 * if not (we are disassociated and we are not
@@ -2530,10 +2496,8 @@ void ieee80211_disassociate(struct ieee80211_device *ieee)
 
 	if (ieee->data_hard_stop)
 			ieee->data_hard_stop(ieee->dev);
-#ifdef ENABLE_DOT11D
 	if(IS_DOT11D_ENABLE(ieee))
 		Dot11d_Reset(ieee);
-#endif
 	ieee->state = IEEE80211_NOLINK;
 	ieee->is_set_key = false;
 	ieee->link_change(ieee->dev);
@@ -2669,11 +2633,7 @@ void ieee80211_start_protocol(struct ieee80211_device *ieee)
 			ch++;
 			if (ch > MAX_CHANNEL_NUMBER)
 				return; /* no channel found */
-#ifdef ENABLE_DOT11D
 		}while(!GET_DOT11D_INFO(ieee)->channel_map[ch]);
-#else
-		}while(!ieee->channel_map[ch]);
-#endif
 		ieee->current_network.channel = ch;
 	}
 
@@ -2721,11 +2681,9 @@ void ieee80211_softmac_init(struct ieee80211_device *ieee)
 	for(i = 0; i < 5; i++) {
 	  ieee->seq_ctrl[i] = 0;
 	}
-#ifdef ENABLE_DOT11D
 	ieee->pDot11dInfo = kzalloc(sizeof(RT_DOT11D_INFO), GFP_ATOMIC);
 	if (!ieee->pDot11dInfo)
 		IEEE80211_DEBUG(IEEE80211_DL_ERR, "can't alloc memory for DOT11D\n");
-#endif
 	//added for  AP roaming
 	ieee->LinkDetectInfo.SlotNum = 2;
 	ieee->LinkDetectInfo.NumRecvBcnInPeriod=0;
@@ -2796,13 +2754,11 @@ void ieee80211_softmac_init(struct ieee80211_device *ieee)
 void ieee80211_softmac_free(struct ieee80211_device *ieee)
 {
 	down(&ieee->wx_sem);
-#ifdef ENABLE_DOT11D
 	if(NULL != ieee->pDot11dInfo)
 	{
 		kfree(ieee->pDot11dInfo);
 		ieee->pDot11dInfo = NULL;
 	}
-#endif
 	del_timer_sync(&ieee->associate_timer);
 
 	cancel_delayed_work(&ieee->associate_retry_wq);
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac_wx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac_wx.c
index f335c25..cb5a3c3 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac_wx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac_wx.c
@@ -15,9 +15,7 @@
 
 
 #include "ieee80211.h"
-#ifdef ENABLE_DOT11D
 #include "dot11d.h"
-#endif
 /* FIXME: add A freqs */
 
 const long ieee80211_wlan_frequencies[] = {
@@ -63,12 +61,10 @@ int ieee80211_wx_set_freq(struct ieee80211_device *ieee, struct iw_request_info
 
 	}else { /* Set the channel */
 
-#ifdef ENABLE_DOT11D
 		if (!(GET_DOT11D_INFO(ieee)->channel_map)[fwrq->m]) {
 			ret = -EINVAL;
 			goto out;
 		}
-#endif
 		ieee->current_network.channel = fwrq->m;
 		ieee->set_chan(ieee->dev, ieee->current_network.channel);
 
diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index 494f180..0bdeacf 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -77,9 +77,7 @@ double __extendsfdf2(float a) {return a;}
 #include "r8192_pm.h"
 #endif
 
-#ifdef ENABLE_DOT11D
 #include "dot11d.h"
-#endif
 //set here to open your trace code. //WB
 u32 rt_global_debug_component = \
 			//	COMP_INIT    	|
@@ -166,7 +164,6 @@ static struct usb_driver rtl8192_usb_driver = {
 #endif
 };
 
-#ifdef ENABLE_DOT11D
 
 typedef struct _CHANNEL_LIST
 {
@@ -242,9 +239,7 @@ static void rtl819x_set_channel_map(u8 channel_plan, struct r8192_priv* priv)
 	}
 	return;
 }
-#endif
 
-#define eqMacAddr(a,b) ( ((a)[0]==(b)[0] && (a)[1]==(b)[1] && (a)[2]==(b)[2] && (a)[3]==(b)[3] && (a)[4]==(b)[4] && (a)[5]==(b)[5]) ? 1:0 )
 
 #define 	rx_hal_is_cck_rate(_pdrvinfo)\
 			(_pdrvinfo->RxRate == DESC90_RATE1M ||\
@@ -3155,7 +3150,6 @@ static void rtl8192_read_eeprom_info(struct net_device* dev)
 short rtl8192_get_channel_map(struct net_device * dev)
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
-#ifdef ENABLE_DOT11D
 	if(priv->ChannelPlan > COUNTRY_CODE_GLOBAL_DOMAIN){
 		printk("rtl8180_init:Error channel plan! Set to default.\n");
 		priv->ChannelPlan= 0;
@@ -3163,21 +3157,6 @@ short rtl8192_get_channel_map(struct net_device * dev)
 	RT_TRACE(COMP_INIT, "Channel plan is %d\n",priv->ChannelPlan);
 
 	rtl819x_set_channel_map(priv->ChannelPlan, priv);
-#else
-	int ch,i;
-	//Set Default Channel Plan
-	if(!channels){
-		DMESG("No channels, aborting");
-		return -1;
-	}
-	ch=channels;
-	priv->ChannelPlan= 0;//hikaru
-	 // set channels 1..14 allowed in given locale
-	for (i=1; i<=14; i++) {
-		(priv->ieee80211->channel_map)[i] = (u8)(ch & 0x01);
-		ch >>= 1;
-	}
-#endif
 	return 0;
 }
 
diff --git a/drivers/staging/rtl8192u/r8192U_wx.c b/drivers/staging/rtl8192u/r8192U_wx.c
index 25d5c87..f6408f9 100644
--- a/drivers/staging/rtl8192u/r8192U_wx.c
+++ b/drivers/staging/rtl8192u/r8192U_wx.c
@@ -21,9 +21,7 @@
 #include "r8192U.h"
 #include "r8192U_hw.h"
 
-#ifdef ENABLE_DOT11D
 #include "dot11d.h"
-#endif
 
 #define RATE_COUNT 12
 u32 rtl8180_rates[] = {1000000,2000000,5500000,11000000,
@@ -458,11 +456,7 @@ static int rtl8180_wx_get_range(struct net_device *dev,
 	for (i = 0, val = 0; i < 14; i++) {
 
 		// Include only legal frequencies for some countries
-#ifdef ENABLE_DOT11D
 		if ((GET_DOT11D_INFO(priv->ieee80211)->channel_map)[i+1]) {
-#else
-		if ((priv->ieee80211->channel_map)[i+1]) {
-#endif
 			range->freq[val].i = i + 1;
 			range->freq[val].m = ieee80211_wlan_frequencies[i] * 100000;
 			range->freq[val].e = 1;
diff --git a/drivers/staging/rtl8192u/r819xU_phy.c b/drivers/staging/rtl8192u/r819xU_phy.c
index a3adaed..ac84ff7 100644
--- a/drivers/staging/rtl8192u/r819xU_phy.c
+++ b/drivers/staging/rtl8192u/r819xU_phy.c
@@ -6,9 +6,7 @@
 #include "r8192U_dm.h"
 #include "r819xU_firmware_img.h"
 
-#ifdef ENABLE_DOT11D
 #include "dot11d.h"
-#endif
 static u32 RF_CHANNEL_TABLE_ZEBRA[] = {
 	0,
 	0x085c, //2412 1
@@ -1257,13 +1255,11 @@ u8 rtl8192_phy_SwChnlStepByStep(struct net_device *dev, u8 channel, u8* stage, u
 
 	RT_TRACE(COMP_CH, "====>%s()====stage:%d, step:%d, channel:%d\n", __FUNCTION__, *stage, *step, channel);
 //	RT_ASSERT(IsLegalChannel(Adapter, channel), ("illegal channel: %d\n", channel));
-#ifdef ENABLE_DOT11D
 	if (!IsLegalChannel(priv->ieee80211, channel))
 	{
 		RT_TRACE(COMP_ERR, "=============>set to illegal channel:%d\n", channel);
 		return true; //return true to tell upper caller function this channel setting is finished! Or it will in while loop.
 	}
-#endif
 //FIXME:need to check whether channel is legal or not here.WB
diff --git a/drivers/staging/rtl8192u/ieee80211/Makefile b/drivers/staging/rtl8192u/ieee80211/Makefile
index 45704f8..0775c55 100644
--- a/drivers/staging/rtl8192u/ieee80211/Makefile
+++ b/drivers/staging/rtl8192u/ieee80211/Makefile
@@ -20,7 +20,6 @@ ifeq ($(NIC_SELECT),RTL8192U)
 endif
 #ccflags-y := -DJOHN_NOCPY
 #flags to enable or disble 80211D feature
-ccflags-y += -DENABLE_DOT11D
 ieee80211-rsl-objs := ieee80211_rx.o \
 		      ieee80211_softmac.o \
 		      ieee80211_tx.o \
@@ -75,7 +74,6 @@ CFLAGS += -I$(KSRC)/include -I.
 CFLAGS += -DMODVERSIONS -DEXPORT_SYMTAB -include $(KSRC)/include/linux/modversions.h
 #Kernel 2.4.20
 #CFLAGS += -D__NO_VERSION__ -DEXPORT_SYMTAB
-#CFLAGS += -DENABLE_DOT11D
 SMP := $(shell $(CC) $(MODCFLAGS) -E -dM $(CONFIG_FILE) | \
    grep CONFIG_SMP | awk '{print $$3}')
 ifneq ($(SMP),1)
diff --git a/drivers/staging/rtl8192u/ieee80211/dot11d.h b/drivers/staging/rtl8192u/ieee80211/dot11d.h
index 029c2ca..54f2b4c 100644
--- a/drivers/staging/rtl8192u/ieee80211/dot11d.h
+++ b/drivers/staging/rtl8192u/ieee80211/dot11d.h
@@ -3,7 +3,6 @@
 
 #include "ieee80211.h"
 
-//#define ENABLE_DOT11D
 
 //#define DOT11D_MAX_CHNL_NUM 83
 








On Mon, Nov 29, 2010 at 12:19:55AM +0300, Dan Carpenter wrote:
> On Sat, Nov 27, 2010 at 11:37:48PM +0100, David Chosrova wrote:
> > Hello,
> > 
> >  In this patch I have removed the #ifdef ENABLE_DOT11D. 
> > 
> 
> Cool man.  Looks good.
> 
> There are several places where ENABLE_DOT11D is still there in the
> comments.  Can do a: grep ENABLE_DOT11D drivers/staging/rtl8192u/ -R
> and remove all those?
> 
> Then add an:
> Acked-by: Dan Carpenter <error27@gmail.com>
> 
> When people apply patches they try to automate the process.  They
> have scripts that automatically take an email and creates a kernel
> patch.  So choose a good subject and write a patch description.
> I would normally write this:
> 
> Subject: [patch] Staging: rtl8192u: remove dead code to disable dot11d
> 
> This patch removes all the ENABLE_DOT11D ifdefs.  It's always enabled
> for this driver.  DOT11D has to do with regulatory domains.
> 
> What prompted this patch was a warning message in Sparse:
> 
> drivers/staging/rtl8192u/r8192U_core.c:247:1: warning: "eqMacAddr"
> redefined in file included from drivers/staging/rtl8192u/:81:81:
> drivers/staging/rtl8192u/dot11d.h:35:1: warning: this is the location
> of the previous definition                                                                                                   
> 
> Now there are no ifdefs around dot11d.h it made no sense to have this
> second definition, so I removed that macro as well.
> 
> ---
> Edit that however you want.  That's just an idea.
> 
> Don't put the "Hello etc" into the message because Greg will have to
> strip those bits out of the patch description by hand.
> 
> After the Signed-off-by: line put three dashes "---".  Things below that
> line get stripped out of the patch description.  That's where you can
> put the "Compile tested."  or "Feedback requested" stuff if you want.
> 
> Send your email to: gregkh@suse.de
> CC these addresses: devel@driverdev.osuosl.org, error27@gmail.com, 
> andreamrl@tiscali.it, linux-wireless@vger.kernel.org,
> kernel-janitors@vger.kernel.org
> 
> regards,
> dan carpenter
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
