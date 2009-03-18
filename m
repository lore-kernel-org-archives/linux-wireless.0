Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:64264 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924AbZCRKC0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2009 06:02:26 -0400
Received: by nf-out-0910.google.com with SMTP id d21so78308nfb.21
        for <linux-wireless@vger.kernel.org>; Wed, 18 Mar 2009 03:02:23 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Antonio Marques <froz@icix.org>
Subject: Re: rt2x00 mesh support
Date: Wed, 18 Mar 2009 11:02:21 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Andrey Yurovsky <andrey@cozybit.com>,
	linux-wireless@vger.kernel.org
References: <E8FC0565-5438-4AB5-A004-CD31DD9C1AA3@icix.org> <200903180001.07723.IvDoorn@gmail.com> <1237331062.5100.9.camel@johannes.local>
In-Reply-To: <1237331062.5100.9.camel@johannes.local>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_taMwJQbw+3N32Sj"
Message-Id: <200903181102.21380.IvDoorn@gmail.com> (sfid-20090318_110230_866161_5704A02D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Boundary-00=_taMwJQbw+3N32Sj
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wednesday 18 March 2009, Johannes Berg wrote:
> On Wed, 2009-03-18 at 00:01 +0100, Ivo van Doorn wrote:
> 
> > > > This command means that mac80211 uses the start() callback function. This triggers rt2x00 to initialize
> > > > the registers which resets the beacon generation.
> > > 
> > > Strange, that doesn't seem right. If you look at net/mac80211/iface.c,
> > > you'll see it call ->start(), then ->add_interface(), and later
> > > ieee80211_start_mesh(), which calls _if_config() and sets
> > > beacon/beacon_enabled.
> > 
> > ok, I gone through the rt2x00 code a couple of times now to see how this bug can be triggered by rt2x00,
> > But the only other scenario I could find, is when the open() callback for the netdevice structure doesn't end
> > with a call to the config() callback function. But as far as I see it that is happening correctly.
> 
> Maybe log (+dump_stack()) all the relevant calls from mac80211 to the
> driver? That might give us a better idea of what's going on. Also,
> Antonio, make sure you're using the very latest code. I for one need
> sleep now :)

Antonio, could you please use attached patch to add additional debugging to rt2x00.
This will do a dump_stack for all important functions (add_interface, remove_interface, config() and config_interface())

It doesn't matter if this patch is on top of the previous patch or not.

Thanks,

Ivo

--Boundary-00=_taMwJQbw+3N32Sj
Content-Type: text/x-diff;
  charset="iso-8859-15";
  name="debug.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="debug.diff"

diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index c41a0b9..a75f54d 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -198,6 +198,9 @@ int rt2x00mac_add_interface(struct ieee80211_hw *hw,
 	struct queue_entry *entry = NULL;
 	unsigned int i;
 
+	ERROR(rt2x00dev, "===>\n");
+	dump_stack();
+
 	/*
 	 * Don't allow interfaces to be added
 	 * the device has disappeared.
@@ -293,6 +296,8 @@ int rt2x00mac_add_interface(struct ieee80211_hw *hw,
 	 */
 	rt2x00dev->packet_filter = 0;
 
+	ERROR(rt2x00dev, "<===\n");
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_add_interface);
@@ -303,6 +308,9 @@ void rt2x00mac_remove_interface(struct ieee80211_hw *hw,
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	struct rt2x00_intf *intf = vif_to_intf(conf->vif);
 
+	ERROR(rt2x00dev, "===>\n");
+	dump_stack();
+
 	/*
 	 * Don't allow interfaces to be remove while
 	 * either the device has disappeared or when
@@ -330,6 +338,8 @@ void rt2x00mac_remove_interface(struct ieee80211_hw *hw,
 	 */
 	rt2x00lib_config_intf(rt2x00dev, intf,
 			      NL80211_IFTYPE_UNSPECIFIED, NULL, NULL);
+
+	ERROR(rt2x00dev, "<===\n");
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_remove_interface);
 
@@ -339,6 +349,9 @@ int rt2x00mac_config(struct ieee80211_hw *hw, u32 changed)
 	struct ieee80211_conf *conf = &hw->conf;
 	int status;
 
+	ERROR(rt2x00dev, "===>\n");
+	dump_stack();
+
 	/*
 	 * Mac80211 might be calling this function while we are trying
 	 * to remove the device or perhaps suspending it.
@@ -386,6 +399,8 @@ int rt2x00mac_config(struct ieee80211_hw *hw, u32 changed)
 		rt2x00lib_disable_radio(rt2x00dev);
 	}
 
+	ERROR(rt2x00dev, "<===\n");
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_config);
@@ -399,6 +414,9 @@ int rt2x00mac_config_interface(struct ieee80211_hw *hw,
 	int update_bssid = 0;
 	int status = 0;
 
+	ERROR(rt2x00dev, "===>\n");
+	dump_stack();
+
 	/*
 	 * Mac80211 might be calling this function while we are trying
 	 * to remove the device or perhaps suspending it.
@@ -436,6 +454,9 @@ int rt2x00mac_config_interface(struct ieee80211_hw *hw,
 		status = rt2x00queue_update_beacon(rt2x00dev, vif,
 						   conf->enable_beacon);
 
+	ERROR(rt2x00dev, "<===\n");
+	dump_stack();
+
 	return status;
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_config_interface);

--Boundary-00=_taMwJQbw+3N32Sj--
