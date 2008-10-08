Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web15604.mail.cnb.yahoo.com ([202.165.102.58]:30302 "HELO
	web15619.mail.cnb.yahoo.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1750821AbYJHEYW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2008 00:24:22 -0400
Date: Wed, 8 Oct 2008 12:17:38 +0800 (CST)
From: =?gb2312?q?=CD=F5=ABh?= <wangyue0921@yahoo.com.cn>
Subject: hostap0.6.4 + ath5k
To: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Message-ID: <219053.61757.qm@web15604.mail.cnb.yahoo.com> (sfid-20081008_062427_082530_3F106550)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,all
I deployed hostap0.6.4 + ath5k, and got 2 problems.

My env is: kernel 2.6.26, hostap 0.6.4
compat-wireless-old-2008-10-06.tar.bz2
libnl-1.0-pre8.tar.tar

1. when make wireless souce tree, there are several
WARNINGs:
  Building modules, stage 2.

  MODPOST 39 modules
WARNING: "ieee80211_hdrlen"
[/home/wangyue/VLAN_WPA_ath5k/compat-wireless-2.6-old/drivers/net/wirel=
ess/iwlwifi/iwlcore.ko]
undefined!
WARNING: "ieee80211_hdrlen"
[/home/wangyue/VLAN_WPA_ath5k/compat-wireless-2.6-old/drivers/net/wirel=
ess/iwlwifi/iwl3945.ko]
undefined!
WARNING: "ieee80211_hdrlen"
[/home/wangyue/VLAN_WPA_ath5k/compat-wireless-2.6-old/drivers/net/wirel=
ess/b43legacy/b43legacy.ko]
undefined!
WARNING: "ieee80211_hdrlen"
[/home/wangyue/VLAN_WPA_ath5k/compat-wireless-2.6-old/drivers/net/wirel=
ess/b43/b43.ko]
undefined!
WARNING: "ieee80211_hdrlen"
[/home/wangyue/VLAN_WPA_ath5k/compat-wireless-2.6-old/drivers/net/wirel=
ess/ath5k/ath5k.ko]
undefined!
WARNING: "ieee80211_hdrlen"
[/home/wangyue/VLAN_WPA_ath5k/compat-wireless-2.6-old/drivers/net/wirel=
ess/adm8211.ko]
undefined!

And ath5k.ko can not be insmod properly:
[root@telnetserver ath5k]# insmod ath5k.ko
insmod: error inserting 'ath5k.ko': -1 Unknown symbol
in module
the "dmesg" shows:
ath5k: Unknown symbol ieee80211_hdrlen

So what can i do for this problem.

2. When I insmod the ath5k.ko from the linux kernel=20
2.6.26, the wlan0 can work well.
But the hostapd can not work:

[root@telnetserver hostapd]# ./hostapd -dd
=2E/hostapd.conf
Configuration file: ./hostapd.conf
ctrl_interface_group=3D0
nl80211 not found.
nl80211 driver initialization failed.
wlan0: Unable to setup interface.
=46lushing old station entries
Deauthenticate all stations
rmdir[ctrl_interface]: No such file or directory
Could not remove VLAN iface: vlan1: Illegal seek
Could not remove VLAN iface: vlan2: Illegal seek
Could not remove VLAN iface: vlan3: Illegal seek
Could not remove VLAN iface: guest: Illegal seek

Though i haven't patch the ath5k's driver from linux
kernel 2.6.26 for AP mode, hostapd can not run as AP
mode indeed.=20
But i think this problem happened when nl80211 was=20
initialized (function i802_init) and AP mode will be
set later, not at this time.

=46ollowing is my kernel config and hostap's config.
kernel config(part of the .config):
#
# Wireless
#
CONFIG_CFG80211=3Dy
CONFIG_NL80211=3Dy
CONFIG_WIRELESS_EXT=3Dy
CONFIG_MAC80211=3Dy

#
# Rate control algorithm selection
#
CONFIG_MAC80211_RC_DEFAULT_PID=3Dy
# CONFIG_MAC80211_RC_DEFAULT_NONE is not set

#
# Selecting 'y' for an algorithm will
#

#
# build the algorithm into mac80211.
#
CONFIG_MAC80211_RC_DEFAULT=3D"pid"
CONFIG_MAC80211_RC_PID=3Dy
# CONFIG_MAC80211_MESH is not set
CONFIG_MAC80211_LEDS=3Dy
CONFIG_MAC80211_DEBUGFS=3Dy
CONFIG_MAC80211_DEBUG_PACKET_ALIGNMENT=3Dy
CONFIG_MAC80211_DEBUG=3Dy
# CONFIG_MAC80211_HT_DEBUG is not set
# CONFIG_MAC80211_VERBOSE_DEBUG is not set
# CONFIG_MAC80211_LOWTX_FRAME_DUMP is not set
# CONFIG_TKIP_DEBUG is not set
# CONFIG_MAC80211_DEBUG_COUNTERS is not set
# CONFIG_MAC80211_IBSS_DEBUG is not set
# CONFIG_MAC80211_VERBOSE_PS_DEBUG is not set
CONFIG_IEEE80211=3Dy
CONFIG_IEEE80211_DEBUG=3Dy
CONFIG_IEEE80211_CRYPT_WEP=3Dm
CONFIG_IEEE80211_CRYPT_CCMP=3Dm
CONFIG_IEEE80211_CRYPT_TKIP=3Dm
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set

#
# Wireless LAN
#
CONFIG_WLAN_PRE80211=3Dy
# CONFIG_STRIP is not set
# CONFIG_ARLAN is not set
# CONFIG_WAVELAN is not set
CONFIG_PCMCIA_WAVELAN=3Dm
CONFIG_PCMCIA_NETWAVE=3Dm
CONFIG_WLAN_80211=3Dy
# CONFIG_PCMCIA_RAYCS is not set
CONFIG_IPW2100=3Dm
CONFIG_IPW2100_MONITOR=3Dy
# CONFIG_IPW2100_DEBUG is not set
CONFIG_IPW2200=3Dm
CONFIG_IPW2200_MONITOR=3Dy
CONFIG_IPW2200_RADIOTAP=3Dy
CONFIG_IPW2200_PROMISCUOUS=3Dy
CONFIG_IPW2200_QOS=3Dy
# CONFIG_IPW2200_DEBUG is not set
# CONFIG_LIBERTAS is not set
CONFIG_AIRO=3Dm
CONFIG_HERMES=3Dm
CONFIG_PLX_HERMES=3Dm
CONFIG_TMD_HERMES=3Dm
CONFIG_NORTEL_HERMES=3Dm
CONFIG_PCI_HERMES=3Dm
CONFIG_PCMCIA_HERMES=3Dm
CONFIG_PCMCIA_SPECTRUM=3Dm
CONFIG_ATMEL=3Dm
CONFIG_PCI_ATMEL=3Dm
CONFIG_PCMCIA_ATMEL=3Dm
CONFIG_AIRO_CS=3Dm
CONFIG_PCMCIA_WL3501=3Dm
CONFIG_PRISM54=3Dm
CONFIG_USB_ZD1201=3Dm
# CONFIG_USB_NET_RNDIS_WLAN is not set
# CONFIG_RTL8180 is not set
CONFIG_RTL8187=3Dm
CONFIG_ADM8211=3Dm
CONFIG_P54_COMMON=3Dm
CONFIG_P54_USB=3Dm
CONFIG_P54_PCI=3Dm
CONFIG_ATH5K=3Dm
CONFIG_ATH5K_DEBUG=3Dy
CONFIG_IWLWIFI=3Dm
# CONFIG_IWLCORE is not set
# CONFIG_IWLWIFI_LEDS is not set
# CONFIG_IWL4965 is not set
CONFIG_IWL3945=3Dm
# CONFIG_IWL3945_SPECTRUM_MEASUREMENT is not set
# CONFIG_IWL3945_LEDS is not set
# CONFIG_IWL3945_DEBUG is not set
CONFIG_HOSTAP=3Dm
CONFIG_HOSTAP_FIRMWARE=3Dy
CONFIG_HOSTAP_FIRMWARE_NVRAM=3Dy
CONFIG_HOSTAP_PLX=3Dm
CONFIG_HOSTAP_PCI=3Dm
CONFIG_HOSTAP_CS=3Dm
CONFIG_B43=3Dm
CONFIG_B43_PCI_AUTOSELECT=3Dy
CONFIG_B43_PCICORE_AUTOSELECT=3Dy
CONFIG_B43_PCMCIA=3Dy
CONFIG_B43_PIO=3Dy
CONFIG_B43_LEDS=3Dy
CONFIG_B43_DEBUG=3Dy
# CONFIG_B43_FORCE_PIO is not set
CONFIG_B43LEGACY=3Dm
CONFIG_B43LEGACY_PCI_AUTOSELECT=3Dy
CONFIG_B43LEGACY_PCICORE_AUTOSELECT=3Dy
CONFIG_B43LEGACY_LEDS=3Dy
CONFIG_B43LEGACY_DEBUG=3Dy
CONFIG_B43LEGACY_DMA=3Dy
CONFIG_B43LEGACY_PIO=3Dy
CONFIG_B43LEGACY_DMA_AND_PIO_MODE=3Dy
# CONFIG_B43LEGACY_DMA_MODE is not set
# CONFIG_B43LEGACY_PIO_MODE is not set
# CONFIG_ZD1211RW is not set
CONFIG_RT2X00=3Dm
CONFIG_RT2X00_LIB=3Dm
CONFIG_RT2X00_LIB_PCI=3Dm
CONFIG_RT2X00_LIB_USB=3Dm
CONFIG_RT2X00_LIB_FIRMWARE=3Dy
CONFIG_RT2400PCI=3Dm
# CONFIG_RT2400PCI_RFKILL is not set
# CONFIG_RT2400PCI_LEDS is not set
CONFIG_RT2500PCI=3Dm
# CONFIG_RT2500PCI_RFKILL is not set
# CONFIG_RT2500PCI_LEDS is not set
CONFIG_RT61PCI=3Dm
# CONFIG_RT61PCI_RFKILL is not set
# CONFIG_RT61PCI_LEDS is not set
CONFIG_RT2500USB=3Dm
# CONFIG_RT2500USB_LEDS is not set
CONFIG_RT73USB=3Dm
# CONFIG_RT73USB_LEDS is not set
# CONFIG_RT2X00_LIB_DEBUGFS is not set
# CONFIG_RT2X00_DEBUG is not set

hostapd's config:
# Example hostapd build time configuration
#
# This file lists the configuration options that are
used when building
 the
# hostapd binary. All lines starting with # are
ignored. Configuration
 option
# lines must be commented out complete, if they are
not to be included,
 i.e.,
# just setting VARIABLE=3Dn is not disabling that
variable.
#
# This file is included in Makefile, so variables like
CFLAGS and LIBS
 can also
# be modified from here. In most cass, these lines
should use +=3D in
 order not
# to override previous values of the variables.

# Driver interface for Host AP driver
#CONFIG_DRIVER_HOSTAP=3Dy

# Driver interface for wired authenticator
#CONFIG_DRIVER_WIRED=3Dy

# Driver interface for madwifi driver
#CONFIG_DRIVER_MADWIFI=3Dy
#CFLAGS +=3D -I../head # change to reflect local setup;
directory for
 madwifi src

# Driver interface for Prism54 driver
#CONFIG_DRIVER_PRISM54=3Dy

# Driver interface for drivers using the nl80211
kernel interface
CONFIG_DRIVER_NL80211=3Dy
# driver_nl80211.c requires a rather new libnl,
probably not
# shipped with your distribution yet
LIBNL=3D/home/wangyue/VLAN_WPA_ath5k/libnl-1.0-pre8
CFLAGS +=3D -I$(LIBNL)/include
LIBS +=3D -L$(LIBNL)/lib
#CFLAGS +=3D/usr/local/include/
#LIBS +=3D/usr/local/lib/

# Driver interface for FreeBSD net80211 layer (e.g.,
Atheros driver)
#CONFIG_DRIVER_BSD=3Dy
#CFLAGS +=3D -I/usr/local/include
#LIBS +=3D -L/usr/local/lib

# IEEE 802.11F/IAPP
CONFIG_IAPP=3Dy

# WPA2/IEEE 802.11i RSN pre-authentication
CONFIG_RSN_PREAUTH=3Dy

# PeerKey handshake for Station to Station Link (IEEE
802.11e DLS)
CONFIG_PEERKEY=3Dy

# IEEE 802.11w (management frame protection)
# This version is an experimental implementation based
on IEEE
 802.11w/D1.0
# draft and is subject to change since the standard
has not yet been
 finalized.
# Driver support is also needed for IEEE 802.11w.
#CONFIG_IEEE80211W=3Dy

# Integrated EAP server
CONFIG_EAP=3Dy

# EAP-MD5 for the integrated EAP server
CONFIG_EAP_MD5=3Dy

# EAP-TLS for the integrated EAP server
CONFIG_EAP_TLS=3Dy

# EAP-MSCHAPv2 for the integrated EAP server
CONFIG_EAP_MSCHAPV2=3Dy

# EAP-PEAP for the integrated EAP server
CONFIG_EAP_PEAP=3Dy

# EAP-GTC for the integrated EAP server
CONFIG_EAP_GTC=3Dy

# EAP-TTLS for the integrated EAP server
CONFIG_EAP_TTLS=3Dy

# EAP-SIM for the integrated EAP server
#CONFIG_EAP_SIM=3Dy

# EAP-AKA for the integrated EAP server
#CONFIG_EAP_AKA=3Dy

# EAP-PAX for the integrated EAP server
#CONFIG_EAP_PAX=3Dy

# EAP-PSK for the integrated EAP server (this is _not_
needed for
 WPA-PSK)
#CONFIG_EAP_PSK=3Dy

# EAP-SAKE for the integrated EAP server
#CONFIG_EAP_SAKE=3Dy

# EAP-GPSK for the integrated EAP server
#CONFIG_EAP_GPSK=3Dy
# Include support for optional SHA256 cipher suite in
EAP-GPSK
#CONFIG_EAP_GPSK_SHA256=3Dy

# EAP-FAST for the integrated EAP server
# Note: Default OpenSSL package does not include
support for all the
# functionality needed for EAP-FAST. If EAP-FAST is
enabled with
 OpenSSL,
# the OpenSSL library must be patched
 (openssl-0.9.9-session-ticket.patch)
# to add the needed functions.
#CONFIG_EAP_FAST=3Dy

# EAP-IKEv2
#CONFIG_EAP_IKEV2=3Dy

# Trusted Network Connect (EAP-TNC)
#CONFIG_EAP_TNC=3Dy

# PKCS#12 (PFX) support (used to read private key and
certificate file
 from
# a file that usually has extension .p12 or .pfx)
CONFIG_PKCS12=3Dy

# RADIUS authentication server. This provides access
to the integrated
 EAP
# server from external hosts using RADIUS.
#CONFIG_RADIUS_SERVER=3Dy

# Build IPv6 support for RADIUS operations
CONFIG_IPV6=3Dy

# IEEE 802.11r/D4.1 (Fast BSS Transition)
# This enables an experimental implementation of a
draft version of
# IEEE 802.11r. This draft is still subject to change,
so it should be
 noted
# that this version may not comply with the final
standard.
#CONFIG_IEEE80211R=3Dy

# Use the hostapd's IEEE 802.11 authentication (ACL),
but without
# the IEEE 802.11 Management capability (e.g., madwifi
or
 FreeBSD/net80211)
#CONFIG_DRIVER_RADIUS_ACL=3Dy

CONFIG_FULL_DYNAMIC_VLAN=3Dy


libnl was installed at default path:
/usr/local/include/netlink
/usr/local/lib

There are some troubles on my deployment "hostap +=20
nl80211 + ath5k".Thanks for ur kindly response.

Best regards,
WangYue



      ___________________________________________________________=20
 =D1=C5=BB=A2=D3=CA=CF=E4=A3=AC=C4=FA=B5=C4=D6=D5=C9=FA=D3=CA=CF=E4=A3=A1=
=20
http://cn.mail.yahoo.com/
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
