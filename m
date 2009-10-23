Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx03.syneticon.net ([78.111.66.105]:59020 "EHLO
	mx03.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbZJWNPZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2009 09:15:25 -0400
Message-ID: <4AE1AC69.7010904@wpkg.org>
Date: Fri, 23 Oct 2009 15:15:21 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org, linux-netdev@vger.kernel.org,
	linux-mips@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Subject: Re: ath5k AP kernel panic when client uses SCP
References: <4AD21AB4.6010208@wpkg.org>
In-Reply-To: <4AD21AB4.6010208@wpkg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland wrote:
> 
> CONFIG_DEBUG_INFO is the basic switch.  I don't know if MIPS needs
> CONFIG_FRAME_POINTER but that could help too.

I don't see CONFIG_FRAME_POINTER available.
I compiled with CONFIG_DEBUG_INFO; let me know if I should enable some 
other DEBUG options as well (see below what's enabled and available).

Before it oopses, I see lots of order 0 page allocation failures (there 
are some extra spaces at the end of each line due to the broken konsole 
in KDE4):

http://www1.wpkg.org/oops2.txt


Once, the device hanged without producing an oops (with lots of page 
allocation failures before).


No clue about disassembling here, sorry.


# zgrep DEBUG /proc/config.gz

# CONFIG_PCI_DEBUG is not set
# CONFIG_NETFILTER_DEBUG is not set
# CONFIG_NETFILTER_XT_MATCH_LAYER7_DEBUG is not set
CONFIG_CFG80211_REG_DEBUG=y
# CONFIG_CFG80211_DEBUGFS is not set
CONFIG_LIB80211_DEBUG=y
# CONFIG_MAC80211_DEBUGFS is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_MTD_DEBUG is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_DM_DEBUG is not set
CONFIG_LIBERTAS_DEBUG=y
CONFIG_ATH5K_DEBUG=y
CONFIG_ATH9K_DEBUG=y
CONFIG_IPW2100_DEBUG=y
CONFIG_IPW2200_DEBUG=y
CONFIG_LIBIPW_DEBUG=y
CONFIG_IWLWIFI_DEBUG=y
CONFIG_B43_DEBUG=y
CONFIG_B43LEGACY_DEBUG=y
CONFIG_ZD1211RW_DEBUG=y
CONFIG_RT2X00_DEBUG=y
# CONFIG_HISAX_DEBUG is not set
# CONFIG_SSB_DEBUG is not set
# CONFIG_USB_DEBUG is not set
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_SERIAL_DEBUG is not set
# CONFIG_JBD_DEBUG is not set
# CONFIG_JBD2_DEBUG is not set
# CONFIG_JFS_DEBUG is not set
# CONFIG_XFS_DEBUG is not set
# CONFIG_NTFS_DEBUG is not set
CONFIG_JFFS2_FS_DEBUG=0
# CONFIG_CIFS_DEBUG2 is not set
CONFIG_DEBUG_FS=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
CONFIG_SCHED_DEBUG=y
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_DEBUG_SLAB is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_RUNTIME_DEBUG is not set


> Another option in the absence of debug info is disassembling the
> Code: section of the oops and trying to find the corresponding
> code via objdump, but this only really works well if you have some
> idea which module is causing the error.



-- 
Tomasz Chmielewski
http://wpkg.org

