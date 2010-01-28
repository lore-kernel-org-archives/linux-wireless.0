Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redfish-solutions.com ([66.232.79.143]:52454 "EHLO
	mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752652Ab0A1T1s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2010 14:27:48 -0500
Message-ID: <4B61E530.1060008@redfish-solutions.com>
Date: Thu, 28 Jan 2010 11:27:44 -0800
From: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	linux-bluetooth <linux-bluetooth@vger.kernel.org>
Subject: Re: Hacking documentation updated for compat-wireless
References: <43e72e891001221318p695f0923hea4f3573cedbd78d@mail.gmail.com>
In-Reply-To: <43e72e891001221318p695f0923hea4f3573cedbd78d@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/22/2010 01:18 PM, Luis R. Rodriguez wrote:
> I've updated the hacking documentation for compat-wireless, please let
> me know if there are any questions:
> 
> http://wireless.kernel.org/en/users/Download/hacking
> 
>   Luis

Hi Luis,

Finally got around to reading this.  A couple of things weren't clear to me.

On the page, if the $HOME is assumed to be /home/user, then:

$HOME/wireless-testing is where the generated snapshot is left;

the "git clone" of linux-next, compat, and compat-wireless-2.6 all happen directly in $HOME;

Running this, however, doesn't work:

[philipp@builder ~/cw]$ env | grep GIT
GIT_TREE=/home/philipp/cw/wireless-testing
GIT_COMPAT_TREE=/home/philipp/cw/compat
[philipp@builder ~/cw]$ cd compat-wireless-2.6/
[philipp@builder compat-wireless-2.6]$ scripts/admin-clean.sh
Cleaned wireless-bt-compat-2.6
[philipp@builder compat-wireless-2.6]$ scripts/admin-update.sh
You said to use git tree at: /home/philipp/cw/wireless-testing for linux-next
You said to use git tree at: /home/philipp/cw/compat for compat
Copying /home/philipp/cw/wireless-testing/include/linux/ieee80211.h
cp: cannot stat `/home/philipp/cw/wireless-testing/include/linux/ieee80211.h': No such file or directory
Copying /home/philipp/cw/wireless-testing/include/linux/nl80211.h
cp: cannot stat `/home/philipp/cw/wireless-testing/include/linux/nl80211.h': No such file or directory
Copying /home/philipp/cw/wireless-testing/include/linux/wireless.h
cp: cannot stat `/home/philipp/cw/wireless-testing/include/linux/wireless.h': No such file or directory
Copying /home/philipp/cw/wireless-testing/include/linux/pci_ids.h
cp: cannot stat `/home/philipp/cw/wireless-testing/include/linux/pci_ids.h': No such file or directory
Copying /home/philipp/cw/wireless-testing/include/linux/eeprom_93cx6.h
cp: cannot stat `/home/philipp/cw/wireless-testing/include/linux/eeprom_93cx6.h': No such file or directory
Copying /home/philipp/cw/wireless-testing/include/linux/ath9k_platform.h
cp: cannot stat `/home/philipp/cw/wireless-testing/include/linux/ath9k_platform.h': No such file or directory
cp: cannot stat `/home/philipp/cw/wireless-testing/include/linux/ssb': No such file or directory
cp: cannot stat `/home/philipp/cw/wireless-testing/include/linux/rfkill.h': No such file or directory
Copying /home/philipp/cw/wireless-testing/include/net/cfg80211.h
cp: cannot stat `/home/philipp/cw/wireless-testing/include/net/cfg80211.h': No such file or directory
Copying /home/philipp/cw/wireless-testing/include/net/ieee80211_radiotap.h
cp: cannot stat `/home/philipp/cw/wireless-testing/include/net/ieee80211_radiotap.h': No such file or directory
Copying /home/philipp/cw/wireless-testing/include/net/mac80211.h
cp: cannot stat `/home/philipp/cw/wireless-testing/include/net/mac80211.h': No such file or directory
Copying /home/philipp/cw/wireless-testing/include/net/wext.h
cp: cannot stat `/home/philipp/cw/wireless-testing/include/net/wext.h': No such file or directory
Copying /home/philipp/cw/wireless-testing/include/net/lib80211.h
cp: cannot stat `/home/philipp/cw/wireless-testing/include/net/lib80211.h': No such file or directory
Copying /home/philipp/cw/wireless-testing/include/net/regulatory.h
cp: cannot stat `/home/philipp/cw/wireless-testing/include/net/regulatory.h': No such file or directory
Copying /home/philipp/cw/wireless-testing/include/net/bluetooth/hci_core.h
cp: cannot stat `/home/philipp/cw/wireless-testing/include/net/bluetooth/hci_core.h': No such file or directory
Copying /home/philipp/cw/wireless-testing/include/net/bluetooth/l2cap.h
cp: cannot stat `/home/philipp/cw/wireless-testing/include/net/bluetooth/l2cap.h': No such file or directory
Copying /home/philipp/cw/wireless-testing/include/net/bluetooth/bluetooth.h
cp: cannot stat `/home/philipp/cw/wireless-testing/include/net/bluetooth/bluetooth.h': No such file or directory
Copying /home/philipp/cw/wireless-testing/include/net/bluetooth/rfcomm.h
cp: cannot stat `/home/philipp/cw/wireless-testing/include/net/bluetooth/rfcomm.h': No such file or directory
Copying /home/philipp/cw/wireless-testing/include/net/bluetooth/hci.h
cp: cannot stat `/home/philipp/cw/wireless-testing/include/net/bluetooth/hci.h': No such file or directory
Copying /home/philipp/cw/wireless-testing/include/linux/usb/usbnet.h
cp: cannot stat `/home/philipp/cw/wireless-testing/include/linux/usb/usbnet.h': No such file or directory
Copying /home/philipp/cw/wireless-testing/include/linux/usb/rndis_host.h
cp: cannot stat `/home/philipp/cw/wireless-testing/include/linux/usb/rndis_host.h': No such file or directory
Copying /home/philipp/cw/wireless-testing/include/linux/spi/wl12xx.h
cp: cannot stat `/home/philipp/cw/wireless-testing/include/linux/spi/wl12xx.h': No such file or directory
Copying /home/philipp/cw/wireless-testing/include/linux/spi/libertas_spi.h
cp: cannot stat `/home/philipp/cw/wireless-testing/include/linux/spi/libertas_spi.h': No such file or directory
Copying /home/philipp/cw/wireless-testing/net/wireless/*.[ch]
cp: cannot stat `/home/philipp/cw/wireless-testing/net/wireless/*.[ch]': No such file or directory
cp: cannot stat `/home/philipp/cw/wireless-testing/net/wireless/Makefile': No such file or directory
Copying /home/philipp/cw/wireless-testing/net/mac80211/*.[ch]
cp: cannot stat `/home/philipp/cw/wireless-testing/net/mac80211/*.[ch]': No such file or directory
cp: cannot stat `/home/philipp/cw/wireless-testing/net/mac80211/Makefile': No such file or directory
Copying /home/philipp/cw/wireless-testing/net/rfkill/*.[ch]
cp: cannot stat `/home/philipp/cw/wireless-testing/net/rfkill/*.[ch]': No such file or directory
cp: cannot stat `/home/philipp/cw/wireless-testing/net/rfkill/Makefile': No such file or directory
Copying /home/philipp/cw/wireless-testing/net/bluetooth/*.[ch]
cp: cannot stat `/home/philipp/cw/wireless-testing/net/bluetooth/*.[ch]': No such file or directory
cp: cannot stat `/home/philipp/cw/wireless-testing/net/bluetooth/Makefile': No such file or directory
Copying /home/philipp/cw/wireless-testing/net/bluetooth/bnep/*.[ch]
cp: cannot stat `/home/philipp/cw/wireless-testing/net/bluetooth/bnep/*.[ch]': No such file or directory
cp: cannot stat `/home/philipp/cw/wireless-testing/net/bluetooth/bnep/Makefile': No such file or directory
Copying /home/philipp/cw/wireless-testing/net/bluetooth/cmtp/*.[ch]
cp: cannot stat `/home/philipp/cw/wireless-testing/net/bluetooth/cmtp/*.[ch]': No such file or directory
cp: cannot stat `/home/philipp/cw/wireless-testing/net/bluetooth/cmtp/Makefile': No such file or directory
Copying /home/philipp/cw/wireless-testing/net/bluetooth/rfcomm/*.[ch]
cp: cannot stat `/home/philipp/cw/wireless-testing/net/bluetooth/rfcomm/*.[ch]': No such file or directory
cp: cannot stat `/home/philipp/cw/wireless-testing/net/bluetooth/rfcomm/Makefile': No such file or directory
Copying /home/philipp/cw/wireless-testing/net/bluetooth/hidp/*.[ch]
cp: cannot stat `/home/philipp/cw/wireless-testing/net/bluetooth/hidp/*.[ch]': No such file or directory
cp: cannot stat `/home/philipp/cw/wireless-testing/net/bluetooth/hidp/Makefile': No such file or directory
Copying /home/philipp/cw/wireless-testing/drivers/net/wireless/ath/*.[ch]
cp: cannot stat `/home/philipp/cw/wireless-testing/drivers/net/wireless/ath/*.[ch]': No such file or directory
cp: cannot stat `/home/philipp/cw/wireless-testing/drivers/net/wireless/ath/Makefile': No such file or directory
Copying /home/philipp/cw/wireless-testing/drivers/net/wireless/ath/ar9170/*.[ch]
cp: cannot stat `/home/philipp/cw/wireless-testing/drivers/net/wireless/ath/ar9170/*.[ch]': No such file or directory
cp: cannot stat `/home/philipp/cw/wireless-testing/drivers/net/wireless/ath/ar9170/Makefile': No such file or directory
Copying /home/philipp/cw/wireless-testing/drivers/net/wireless/ath/ath5k/*.[ch]
cp: cannot stat `/home/philipp/cw/wireless-testing/drivers/net/wireless/ath/ath5k/*.[ch]': No such file or directory
cp: cannot stat `/home/philipp/cw/wireless-testing/drivers/net/wireless/ath/ath5k/Makefile': No such file or directory
Copying /home/philipp/cw/wireless-testing/drivers/net/wireless/ath/ath9k/*.[ch]
cp: cannot stat `/home/philipp/cw/wireless-testing/drivers/net/wireless/ath/ath9k/*.[ch]': No such file or directory
cp: cannot stat `/home/philipp/cw/wireless-testing/drivers/net/wireless/ath/ath9k/Makefile': No such file or directory
Copying /home/philipp/cw/wireless-testing/drivers/ssb/*.[ch]
cp: cannot stat `/home/philipp/cw/wireless-testing/drivers/ssb/*.[ch]': No such file or directory
cp: cannot stat `/home/philipp/cw/wireless-testing/drivers/ssb/Makefile': No such file or directory
Copying /home/philipp/cw/wireless-testing/drivers/net/wireless/b43/*.[ch]
cp: cannot stat `/home/philipp/cw/wireless-testing/drivers/net/wireless/b43/*.[ch]': No such file or directory
cp: cannot stat `/home/philipp/cw/wireless-testing/drivers/net/wireless/b43/Makefile': No such file or directory
Copying /home/philipp/cw/wireless-testing/drivers/net/wireless/b43legacy/*.[ch]
cp: cannot stat `/home/philipp/cw/wireless-testing/drivers/net/wireless/b43legacy/*.[ch]': No such file or directory
cp: cannot stat `/home/philipp/cw/wireless-testing/drivers/net/wireless/b43legacy/Makefile': No such file or directory
Copying /home/philipp/cw/wireless-testing/drivers/net/wireless/iwlwifi/*.[ch]
cp: cannot stat `/home/philipp/cw/wireless-testing/drivers/net/wireless/iwlwifi/*.[ch]': No such file or directory
cp: cannot stat `/home/philipp/cw/wireless-testing/drivers/net/wireless/iwlwifi/Makefile': No such file or directory
Copying /home/philipp/cw/wireless-testing/drivers/net/wireless/rt2x00/*.[ch]
cp: cannot stat `/home/philipp/cw/wireless-testing/drivers/net/wireless/rt2x00/*.[ch]': No such file or directory
cp: cannot stat `/home/philipp/cw/wireless-testing/drivers/net/wireless/rt2x00/Makefile': No such file or directory
Copying /home/philipp/cw/wireless-testing/drivers/net/wireless/zd1211rw/*.[ch]
cp: cannot stat `/home/philipp/cw/wireless-testing/drivers/net/wireless/zd1211rw/*.[ch]': No such file or directory
cp: cannot stat `/home/philipp/cw/wireless-testing/drivers/net/wireless/zd1211rw/Makefile': No such file or directory
Copying /home/philipp/cw/wireless-testing/drivers/net/wireless/libertas/*.[ch]
cp: cannot stat `/home/philipp/cw/wireless-testing/drivers/net/wireless/libertas/*.[ch]': No such file or directory
cp: cannot stat `/home/philipp/cw/wireless-testing/drivers/net/wireless/libertas/Makefile': No such file or directory
Copying /home/philipp/cw/wireless-testing/drivers/net/wireless/p54/*.[ch]
cp: cannot stat `/home/philipp/cw/wireless-testing/drivers/net/wireless/p54/*.[ch]': No such file or directory
cp: cannot stat `/home/philipp/cw/wireless-testing/drivers/net/wireless/p54/Makefile': No such file or directory
Copying /home/philipp/cw/wireless-testing/drivers/net/wireless/rtl818x/*.[ch]
cp: cannot stat `/home/philipp/cw/wireless-testing/drivers/net/wireless/rtl818x/*.[ch]': No such file or directory
cp: cannot stat `/home/philipp/cw/wireless-testing/drivers/net/wireless/rtl818x/Makefile': No such file or directory
Copying /home/philipp/cw/wireless-testing/drivers/net/wireless/libertas_tf/*.[ch]
cp: cannot stat `/home/philipp/cw/wireless-testing/drivers/net/wireless/libertas_tf/*.[ch]': No such file or directory
cp: cannot stat `/home/philipp/cw/wireless-testing/drivers/net/wireless/libertas_tf/Makefile': No such file or directory
Copying /home/philipp/cw/wireless-testing/drivers/net/wireless/ipw2x00/*.[ch]
cp: cannot stat `/home/philipp/cw/wireless-testing/drivers/net/wireless/ipw2x00/*.[ch]': No such file or directory
cp: cannot stat `/home/philipp/cw/wireless-testing/drivers/net/wireless/ipw2x00/Makefile': No such file or directory
Copying /home/philipp/cw/wireless-testing/drivers/net/wireless/wl12xx/*.[ch]
cp: cannot stat `/home/philipp/cw/wireless-testing/drivers/net/wireless/wl12xx/*.[ch]': No such file or directory
cp: cannot stat `/home/philipp/cw/wireless-testing/drivers/net/wireless/wl12xx/Makefile': No such file or directory
Copying /home/philipp/cw/wireless-testing/drivers/net/wireless/iwmc3200wifi/*.[ch]
cp: cannot stat `/home/philipp/cw/wireless-testing/drivers/net/wireless/iwmc3200wifi/*.[ch]': No such file or directory
cp: cannot stat `/home/philipp/cw/wireless-testing/drivers/net/wireless/iwmc3200wifi/Makefile': No such file or directory
Copying /home/philipp/cw/wireless-testing/drivers/net/atl1c/*.[ch]
cp: cannot stat `/home/philipp/cw/wireless-testing/drivers/net/atl1c/*.[ch]': No such file or directory
cp: cannot stat `/home/philipp/cw/wireless-testing/drivers/net/atl1c/Makefile': No such file or directory
Copying /home/philipp/cw/wireless-testing/drivers/net/atl1e/*.[ch]
cp: cannot stat `/home/philipp/cw/wireless-testing/drivers/net/atl1e/*.[ch]': No such file or directory
cp: cannot stat `/home/philipp/cw/wireless-testing/drivers/net/atl1e/Makefile': No such file or directory
Copying /home/philipp/cw/wireless-testing/drivers/net/atlx/*.[ch]
cp: cannot stat `/home/philipp/cw/wireless-testing/drivers/net/atlx/*.[ch]': No such file or directory
cp: cannot stat `/home/philipp/cw/wireless-testing/drivers/net/atlx/Makefile': No such file or directory
Copying /home/philipp/cw/wireless-testing/drivers/bluetooth/*.[ch]
cp: cannot stat `/home/philipp/cw/wireless-testing/drivers/bluetooth/*.[ch]': No such file or directory
cp: cannot stat `/home/philipp/cw/wireless-testing/drivers/bluetooth/Makefile': No such file or directory
Copying /home/philipp/cw/wireless-testing/drivers/net/usb/Makefile
cp: cannot stat `/home/philipp/cw/wireless-testing/drivers/net/usb/Makefile': No such file or directory
Copying /home/philipp/cw/wireless-testing/drivers/net/usb/rndis_host.c
cp: cannot stat `/home/philipp/cw/wireless-testing/drivers/net/usb/rndis_host.c': No such file or directory
Copying /home/philipp/cw/wireless-testing/drivers/net/usb/cdc_ether.c
cp: cannot stat `/home/philipp/cw/wireless-testing/drivers/net/usb/cdc_ether.c': No such file or directory
Copying /home/philipp/cw/wireless-testing/drivers/net/usb/usbnet.c
cp: cannot stat `/home/philipp/cw/wireless-testing/drivers/net/usb/usbnet.c': No such file or directory
cp: cannot stat `/home/philipp/cw/wireless-testing/drivers/net/b44.[ch]': No such file or directory
cp: cannot stat `/home/philipp/cw/wireless-testing/drivers/misc/eeprom/eeprom_93cx6.c': No such file or directory
cp: cannot stat `/home/philipp/cw/wireless-testing/drivers/misc/eeprom/Makefile': No such file or directory
cp: cannot stat `/home/philipp/cw/wireless-testing/drivers/net/wireless/adm8211.c': No such file or directory
cp: cannot stat `/home/philipp/cw/wireless-testing/drivers/net/wireless/adm8211.h': No such file or directory
cp: cannot stat `/home/philipp/cw/wireless-testing/drivers/net/wireless/rndis_wlan.c': No such file or directory
cp: cannot stat `/home/philipp/cw/wireless-testing/drivers/net/wireless/mac80211_hwsim.c': No such file or directory
cp: cannot stat `/home/philipp/cw/wireless-testing/drivers/net/wireless/at76c50x-usb.c': No such file or directory
cp: cannot stat `/home/philipp/cw/wireless-testing/drivers/net/wireless/at76c50x-usb.h': No such file or directory
cp: cannot stat `/home/philipp/cw/wireless-testing/drivers/net/wireless/mwl8k.c': No such file or directory
cp: cannot stat `/home/philipp/cw/wireless-testing/drivers/net/wireless/Makefile': No such file or directory
Copying /home/philipp/cw/compat/ files...
Applying backport patch: patches/01-netdev.patch
can't find file to patch at input line 11
Perhaps you used the wrong -p or --strip option?
The text leading up to this was:
--------------------------
|
|This patch backports the struct net_device_ops changes added
|on 2.6.29. It also backports the namespace changes added
|through net/wireless/wext.c. Note that there is another
|patch file which also addresses netns changes, we leave
|them separate as there is no easy way to split the stuff
|without creating a headache on maintenance of the pathes.
|
|--- a/drivers/net/usb/rndis_host.c
|+++ b/drivers/net/usb/rndis_host.c
--------------------------
No file to patch.  Skipping patch.
3 out of 3 hunks ignored
can't find file to patch at input line 41
Perhaps you used the wrong -p or --strip option?
The text leading up to this was:
--------------------------
|--- a/drivers/net/usb/usbnet.c
|+++ b/drivers/net/usb/usbnet.c
--------------------------
No file to patch.  Skipping patch.
3 out of 3 hunks ignored
can't find file to patch at input line 75
Perhaps you used the wrong -p or --strip option?
The text leading up to this was:
--------------------------
|--- a/drivers/net/wireless/rndis_wlan.c
|+++ b/drivers/net/wireless/rndis_wlan.c
--------------------------
No file to patch.  Skipping patch.
3 out of 3 hunks ignored
can't find file to patch at input line 105
Perhaps you used the wrong -p or --strip option?
The text leading up to this was:
--------------------------
|--- a/net/mac80211/iface.c
|+++ b/net/mac80211/iface.c
--------------------------
No file to patch.  Skipping patch.
9 out of 9 hunks ignored
can't find file to patch at input line 214
Perhaps you used the wrong -p or --strip option?
The text leading up to this was:
--------------------------
|--- a/drivers/net/b44.c
|+++ b/drivers/net/b44.c
--------------------------
No file to patch.  Skipping patch.
3 out of 3 hunks ignored
can't find file to patch at input line 259
Perhaps you used the wrong -p or --strip option?
The text leading up to this was:
--------------------------
|--- a/net/wireless/wext-core.c
|+++ b/net/wireless/wext-core.c
--------------------------
No file to patch.  Skipping patch.
4 out of 4 hunks ignored
can't find file to patch at input line 327
Perhaps you used the wrong -p or --strip option?
The text leading up to this was:
--------------------------
|--- a/drivers/net/wireless/ipw2x00/ipw2100.c
|+++ b/drivers/net/wireless/ipw2x00/ipw2100.c
--------------------------
No file to patch.  Skipping patch.
3 out of 3 hunks ignored
can't find file to patch at input line 362
Perhaps you used the wrong -p or --strip option?
The text leading up to this was:
--------------------------
|--- a/drivers/net/wireless/ipw2x00/ipw2200.c
|+++ b/drivers/net/wireless/ipw2x00/ipw2200.c
--------------------------
No file to patch.  Skipping patch.
6 out of 6 hunks ignored
can't find file to patch at input line 426
Perhaps you used the wrong -p or --strip option?
The text leading up to this was:
--------------------------
|--- a/drivers/net/wireless/ipw2x00/libipw_module.c
|+++ b/drivers/net/wireless/ipw2x00/libipw_module.c
--------------------------
No file to patch.  Skipping patch.
1 out of 1 hunk ignored
can't find file to patch at input line 439
Perhaps you used the wrong -p or --strip option?
The text leading up to this was:
--------------------------
|--- a/drivers/net/wireless/libertas/main.c
|+++ b/drivers/net/wireless/libertas/main.c
--------------------------
No file to patch.  Skipping patch.
5 out of 5 hunks ignored
can't find file to patch at input line 502
Perhaps you used the wrong -p or --strip option?
The text leading up to this was:
--------------------------
|--- a/drivers/net/wireless/libertas/mesh.c
|+++ b/drivers/net/wireless/libertas/mesh.c
--------------------------
No file to patch.  Skipping patch.
3 out of 3 hunks ignored
can't find file to patch at input line 536
Perhaps you used the wrong -p or --strip option?
The text leading up to this was:
--------------------------
|--- a/drivers/net/wireless/libertas/defs.h
|+++ b/drivers/net/wireless/libertas/defs.h
--------------------------
No file to patch.  Skipping patch.
1 out of 1 hunk ignored
can't find file to patch at input line 553
Perhaps you used the wrong -p or --strip option?
The text leading up to this was:
--------------------------
|--- a/drivers/net/wireless/mac80211_hwsim.c
|+++ b/drivers/net/wireless/mac80211_hwsim.c
--------------------------
No file to patch.  Skipping patch.
1 out of 1 hunk ignored
can't find file to patch at input line 578
Perhaps you used the wrong -p or --strip option?
The text leading up to this was:
--------------------------
|--- a/net/bluetooth/bnep/netdev.c
|+++ b/net/bluetooth/bnep/netdev.c
--------------------------
No file to patch.  Skipping patch.
4 out of 4 hunks ignored
can't find file to patch at input line 639
Perhaps you used the wrong -p or --strip option?
The text leading up to this was:
--------------------------
|--- a/drivers/net/atl1e/atl1e_main.c
|+++ b/drivers/net/atl1e/atl1e_main.c
--------------------------
No file to patch.  Skipping patch.
3 out of 3 hunks ignored
can't find file to patch at input line 681
Perhaps you used the wrong -p or --strip option?
The text leading up to this was:
--------------------------
|--- a/drivers/net/atl1c/atl1c_main.c
|+++ b/drivers/net/atl1c/atl1c_main.c
--------------------------
No file to patch.  Skipping patch.
3 out of 3 hunks ignored
can't find file to patch at input line 723
Perhaps you used the wrong -p or --strip option?
The text leading up to this was:
--------------------------
|--- a/drivers/net/atlx/atl1.c
|+++ b/drivers/net/atlx/atl1.c
--------------------------
No file to patch.  Skipping patch.
3 out of 3 hunks ignored
can't find file to patch at input line 764
Perhaps you used the wrong -p or --strip option?
The text leading up to this was:
--------------------------
|--- a/drivers/net/atlx/atl2.c
|+++ b/drivers/net/atlx/atl2.c
--------------------------
No file to patch.  Skipping patch.
3 out of 3 hunks ignored
Patching patches/01-netdev.patch failed, update it
[philipp@builder compat-wireless-2.6]$


What am I missing?
