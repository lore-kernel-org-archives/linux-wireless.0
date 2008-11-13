Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nexus.dynaweb.hu ([195.70.37.87]:50184 "EHLO nexus.dynaweb.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351AbYKMRMB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2008 12:12:01 -0500
Date: Thu, 13 Nov 2008 18:11:55 +0100
From: RUMI Szabolcs <rumi_ml@rtfm.hu>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: ath5k master (AP) mode
Message-Id: <20081113181155.c556bde1.rumi_ml@rtfm.hu> (sfid-20081113_181208_041137_43B0B792)
In-Reply-To: <20081113004632.d8d821c5.rumi_ml@rtfm.hu>
References: <20081112224810.8d4ca179.rumi_ml@rtfm.hu>
	<1226530010.15173.0.camel@dv>
	<20081113004632.d8d821c5.rumi_ml@rtfm.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 13 Nov 2008 00:46:32 +0100
RUMI Szabolcs <rumi_ml@rtfm.hu> wrote:

> On Wed, 12 Nov 2008 17:46:50 -0500
> Pavel Roskin <proski@gnu.org> wrote:
> 
> > On Wed, 2008-11-12 at 22:48 +0100, RUMI Szabolcs wrote:
> > > Hello!
> > > 
> > > I've been trying to set an Atheros NIC to AP mode using the ath5k
> > > driver but it fails:
> > > 
> > > # iwconfig wlan0 mode master
> > > Error for wireless request "Set Mode" (8B06) :
> > >     SET failed on device wlan0 ; Invalid argument.
> > 
> > You need to use hostapd for master mode.
> 
> Well, I have installed hostapd-0.6.5 with the nl80211 driver and it says:
> 
> # hostapd -dd /etc/hostapd/hostapd.conf
> Configuration file: /etc/hostapd/hostapd.conf
> ctrl_interface_group=0
> Failed to set interface wlan0 to master mode.
> nl80211 driver initialization failed.
> wlan0: Unable to setup interface.
> Flushing old station entries
> Deauthenticate all stations
> rmdir[ctrl_interface]: No such file or directory
> ELOOP: remaining socket: sock=8 eloop_data=0x9f4ea98 user_data=(nil) handler=0x8082920

Some news about what I have tried since yesterday:

I have compiled a kernel from wireless-testing git of today (2.6.28-rc4-wl)
then recompiled and tested hostapd-0.6.5 against that, but it exhibited the
same behavior as above. Then I've compiled libnl git of today which did
compile but any version of hostapd failed to compile against it so I gave
up on that. Then I have compiled the hostapd git of today against libnl-1.1
and the wireless-testing kernel which did compile but runtime it exhibited
the same error as above. So basically whatever I do it fails to set master
mode on ath5k...

I have also tried to patch 2.6.27 with a patch that the OpenWRT people
seemed to be using and has this in net/mac80211/cfg.c:

@@ -33,6 +33,10 @@ nl80211_type_to_mac80211_type(enum nl802
       case NL80211_IFTYPE_MESH_POINT:
              return IEEE80211_IF_TYPE_MESH_POINT;
#endif
+      case NL80211_IFTYPE_AP:
+              return IEEE80211_IF_TYPE_AP;
+      case NL80211_IFTYPE_AP_VLAN:
+              return IEEE80211_IF_TYPE_VLAN;

But this also ended up with the same error like anything else.

Thanks,

Sab
