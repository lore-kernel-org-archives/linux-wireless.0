Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55177 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201Ab2CALfG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2012 06:35:06 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1S34Ho-0003zr-7p
	for linux-wireless@vger.kernel.org; Thu, 01 Mar 2012 12:35:04 +0100
Received: from numa-i.igpm.rwth-aachen.de ([134.130.161.252])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 01 Mar 2012 12:35:04 +0100
Received: from jarausch by numa-i.igpm.rwth-aachen.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 01 Mar 2012 12:35:04 +0100
To: linux-wireless@vger.kernel.org
From: Helmut Jarausch <jarausch@igpm.rwth-aachen.de>
Subject: brcmsmac crashed 3.3-rc5 kernel
Date: Thu, 1 Mar 2012 11:33:56 +0000 (UTC)
Message-ID: <jinmr4$pej$1@dough.gmane.org> (sfid-20120301_123519_459569_D1C55F3D)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

on an HP625 I have the following device

06:00.0 Network controller [0280]: Broadcom Corporation BCM4313 802.11b/g/
n Wireless LAN Controller [14e4:4727] (rev 01)
        Subsystem: Hewlett-Packard Company Device [103c:145c]
        Kernel driver in use: bcma-pci-bridge


This device isn't recognized by the brcmfmac driver but only by the 
brcmsfac driver.

My kernel configuration is

# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
# CONFIG_BCMA_DEBUG is not set

# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
CONFIG_BRCMUTIL=m
CONFIG_BRCMSMAC=m
# CONFIG_BRCMFMAC is not set
CONFIG_BRCMDBG=y

CONFIG_CFG80211=y
# CONFIG_NL80211_TESTMODE is not set
CONFIG_CFG80211_DEVELOPER_WARNINGS=y
CONFIG_CFG80211_REG_DEBUG=y
CONFIG_CFG80211_DEFAULT_PS=y

CONFIG_MAC80211=y
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_MINSTREL_HT=y
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_LEDS=y

The device is recognized :
wlan0     IEEE 802.11bgn  ESSID:off/any  
          Mode:Managed  Access Point: Not-Associated   Tx-Power=0 dBm   
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:on
          
but doing  /etc/init.d/net.wlan0 start
crashes the kernel - even <Ctrl><Alt><Shift><SysRq>  doesn't work anymore.
I've tried strace, but the output file doesn't get closed so it's missing 
after reboot.

Any help is very much appreciated.

P.S. the GRML64 live CD system does work on that hardware but it uses a 
3.1 kernel and a staging driver.

Since I'd like to use BTRFS I'd like to use a 3.3 kernel.
Helmut.


