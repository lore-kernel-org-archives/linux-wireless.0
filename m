Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:37365 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758942Ab2HISuh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2012 14:50:37 -0400
Message-ID: <50240673.7070404@hauke-m.de> (sfid-20120809_205047_198416_8D7D0C28)
Date: Thu, 09 Aug 2012 20:50:27 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozancag@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 06/13] compat-wireless: Conditionally build network drivers
References: <1344535292-4451-1-git-send-email-ozancag@gmail.com> <1344535292-4451-7-git-send-email-ozancag@gmail.com>
In-Reply-To: <1344535292-4451-7-git-send-email-ozancag@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/09/2012 08:01 PM, Ozan Çağlayan wrote:
> Separate building of network drivers into its own conditional block.
> 
> Pass network as the last cmdline argument to mimic older compat-wireless
> behaviour.
> 
> Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>
> ---
>  scripts/admin-update.sh | 254 ++++++++++++++++++------------------------------
>  1 file changed, 92 insertions(+), 162 deletions(-)
> 
> diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
> index 1c516e9..05ec449 100755
> --- a/scripts/admin-update.sh
> +++ b/scripts/admin-update.sh
> @@ -75,7 +75,7 @@ patchRefresh() {
>  ###
>  usage() {
>  	printf "Usage: $0 [refresh] [ --help | -h | -s | -n | -p | -c ] <subsystem1 subsystem2 ..>\n
> -  Where subsystems are: wlan, bluetooth, ethernet and drm.\n"
> +  Where subsystems are: network and drm.\n"

Why are you adding the subsystems "wlan, bluetooth, ethernet" in a
previous patch and now remove them? If you reverted your original plan
to add these three subsystems and now came to the conclusion it would
need some more work, this is no problem, but you should modify your
first patch and add only that one network subsystem in the first patch
and just add drm in this one.

>  	printf "\n"
>  	printf "${GREEN}%10s${NORMAL} - Update all your patch offsets using quilt\n" "refresh"
> @@ -199,10 +199,8 @@ copyDirectories() {
>  # can not be applied correctly after a code update in $GIT_URL.
>  
>  # These switches determines which drivers to fetch in.
> -ENABLE_WLAN=
> -ENABLE_ETH=
> +ENABLE_NETWORK=
>  ENABLE_DRM=
> -ENABLE_BT=
>  
>  EXTRA_PATCHES="patches"
>  REFRESH="n"
> @@ -247,16 +245,8 @@ if [ $# -ge 1 ]; then
>  				REFRESH="y"
>  				shift
>  				;;
> -			"wlan")
> -				ENABLE_WLAN=1
> -				shift
> -				;;
> -			"bluetooth")
> -				ENABLE_BT=1
> -				shift
> -				;;
> -			"ethernet")
> -				ENABLE_ETH=1
> +			"net")
> +				ENABLE_NETWORK=1
>  				shift
>  				;;
>  			"drm")
> @@ -323,26 +313,26 @@ INCLUDE_NET_BT="hci_core.h
>  		smp.h
>  		a2mp.h"
>  
> -# Bluetooth related directories
> -NET_BT_DIRS="bluetooth
> -	     bluetooth/bnep
> -	     bluetooth/cmtp
> -	     bluetooth/rfcomm
> -	     bluetooth/hidp"
> -
>  # Required headers from include/linux
> -INCLUDE_LINUX="ieee80211.h
> -	       nl80211.h
> -	       pci_ids.h
> -	       eeprom_93cx6.h
> -	       ath9k_platform.h
> -	       wl12xx.h
> -	       rndis.h"
> +INCLUDE_LINUX_WLAN="ieee80211.h
> +		    nl80211.h
> +		    eeprom_93cx6.h
> +		    ath9k_platform.h
> +		    wl12xx.h
> +		    rndis.h"
>  
>  # For rndis_wext
> -INCLUDE_LINUX_USB="usbnet.h rndis_host.h"
> +INCLUDE_LINUX_USB_WLAN="usbnet.h
> +			rndis_host.h"
>  
> -INCLUDE_LINUX_SPI="libertas_spi.h"
> +# For rndis_wlan, we need a new rndis_host.ko, cdc_ether.ko and usbnet.ko
> +RNDIS_REQUIREMENTS="Makefile
> +		    rndis_host.c
> +		    cdc_ether.c
> +		    usbnet.c"
> +
> +# For libertas
> +INCLUDE_LINUX_LIBERTAS_WLAN="libertas_spi.h"
>  
>  # 802.11 related headers
>  INCLUDE_NET="cfg80211.h
> @@ -352,7 +342,17 @@ INCLUDE_NET="cfg80211.h
>  	     mac80211.h
>  	     regulatory.h"
>  
> -NET_DIRS="wireless mac80211 rfkill"
> +# Core 802.11 and rfkill code
> +NET_WLAN_DIRS="net/wireless
> +	       net/mac80211
> +	       net/rfkill"
> +
> +# Bluetooth related directories
> +NET_BT_DIRS="net/bluetooth
> +	     net/bluetooth/bnep
> +	     net/bluetooth/cmtp
> +	     net/bluetooth/rfcomm
> +	     net/bluetooth/hidp"
>  
>  # WLAN drivers that have their own directory
>  DRIVERS_WLAN="drivers/bcma
> @@ -433,97 +433,58 @@ mkdir -p \
>  	include/trace \
>  	include/pcmcia \
>  	include/crypto \
> -	net/mac80211/ \
> -	net/wireless/ \
> -	net/rfkill/ \
> -	drivers/ssb/ \
> -	drivers/bcma/ \
> -	drivers/net/usb/ \
> -	drivers/net/wireless/ \
> -	drivers/net/ethernet/atheros \
> -	drivers/net/ethernet/broadcom
> -
> -# include/linux
> -DIR="include/linux"
> -for i in $INCLUDE_LINUX; do
> -	echo "Copying $GIT_TREE/$DIR/$i"
> -	cp "$GIT_TREE/$DIR/$i" $DIR/
> -done
> -
> -cp -a $GIT_TREE/include/linux/ssb include/linux/
> -cp -a $GIT_TREE/include/linux/bcma include/linux/
> -cp -a $GIT_TREE/include/linux/rfkill.h include/linux/rfkill_backport.h
> -
> -# include/net
> -DIR="include/net"
> -for i in $INCLUDE_NET; do
> -	echo "Copying $GIT_TREE/$DIR/$i"
> -	cp "$GIT_TREE/$DIR/$i" $DIR/
> -done
> -
> -DIR="include/net/bluetooth"
> -for i in $INCLUDE_NET_BT; do
> -  echo "Copying $GIT_TREE/$DIR/$i"
> -  cp $GIT_TREE/$DIR/$i $DIR/
> -done
> -
> -DIR="include/linux/usb"
> -for i in $INCLUDE_LINUX_USB; do
> -	echo "Copying $GIT_TREE/$DIR/$i"
> -	cp $GIT_TREE/$DIR/$i $DIR/
> -done
> -
> -DIR="include/linux/spi"
> -for i in $INCLUDE_LINUX_SPI; do
> -	echo "Copying $GIT_TREE/$DIR/$i"
> -	cp $GIT_TREE/$DIR/$i $DIR/
> -done
> -
> -# net/wireless and net/mac80211
> -for i in $NET_DIRS; do
> -	echo "Copying $GIT_TREE/net/$i/*.[ch]"
> -	cp $GIT_TREE/net/$i/*.[ch] net/$i/
> -	cp $GIT_TREE/net/$i/Makefile net/$i/
> -	cp $GIT_TREE/net/$i/Kconfig net/$i/
> -done
> -
> -cp $GIT_TREE/MAINTAINERS ./
> -
> -# Copy files needed for statically compiled regulatory rules database
> -cp $GIT_TREE/net/wireless/db.txt net/wireless/
> -cp $GIT_TREE/net/wireless/genregdb.awk net/wireless/
> -
> -# net/bluetooth
> -for i in $NET_BT_DIRS; do
> -	mkdir -p net/$i
> -	echo "Copying $GIT_TREE/net/$i/*.[ch]"
> -	cp $GIT_TREE/net/$i/*.[ch] net/$i/
> -	cp $GIT_TREE/net/$i/Makefile net/$i/
> -done
> -
> -# Drivers in their own directory
> -for i in $DRIVERS; do
> -	mkdir -p $i
> -
> -	# -print -quit will just print once, so we don't burden
> -	# this script with searching for further files if one is
> -	# found
> -	FILES_FOUND=$(find $GIT_TREE/$i/ -maxdepth 1 -type f -name \*.[ch] -print -quit | wc -l)
> -	if [ $FILES_FOUND -eq 1 ]; then
> -		echo "Copying $GIT_TREE/$i/*.[ch]"
> -		cp $GIT_TREE/$i/*.[ch] $i/
> -	fi
> -	if [ -f $GIT_TREE/$i/Makefile ]; then
> -		cp $GIT_TREE/$i/Makefile $i/
> -	fi
> -	if [ -f $GIT_TREE/$i/Kconfig ]; then
> -		cp $GIT_TREE/$i/Kconfig $i/
> -	fi
> -done
> +	drivers/bcma \
> +	drivers/misc/eeprom \
> +	drivers/net/usb \
> +	drivers/net/ethernet/broadcom \
> +	drivers/ssb \
> +	drivers/staging \
> +	$NET_WLAN_DIRS \
> +	$NET_BT_DIRS \
> +	$DRIVERS_WLAN \
> +	$DRIVERS_ETH \
> +	$DRIVERS_BT
> +
> +# Copy pci_ids.h for every situation
> +cp $GIT_TREE/include/linux/pci_ids.h include/linux
> +
> +if [[ -n "$ENABLE_NETWORK" ]]; then
> +	# WLAN and bluetooth files
> +	copyFiles "$INCLUDE_LINUX_WLAN"			"include/linux"
> +	copyFiles "$INCLUDE_NET"			"include/net"
> +	copyFiles "$INCLUDE_NET_BT" 			"include/net/bluetooth"
> +	copyFiles "$INCLUDE_LINUX_USB_WLAN"		"include/linux/usb"
> +	copyFiles "$INCLUDE_LINUX_LIBERTAS_WLAN"	"include/linux/spi"
> +	copyFiles "$DRIVERS_WLAN_FILES"			"drivers/net/wireless"
> +	copyFiles "$RNDIS_REQUIREMENTS"			"drivers/net/usb"
> +
> +	copyDirectories "$NET_WLAN_DIRS"
> +	copyDirectories "$NET_BT_DIRS"
> +	copyDirectories "$DRIVERS_BT"
> +	copyDirectories "$DRIVERS_WLAN"
> +	copyDirectories "$DRIVERS_ETH"
> +
> +	cp -a $GIT_TREE/include/linux/ssb include/linux/
> +	cp -a $GIT_TREE/include/linux/bcma include/linux/
> +	cp -a $GIT_TREE/include/linux/rfkill.h include/linux/rfkill_backport.h
> +
> +	# Misc
> +	cp $GIT_TREE/drivers/misc/eeprom/{Makefile,eeprom_93cx6.c} drivers/misc/eeprom/
> +
> +	# Copy files needed for statically compiled regulatory rules database
> +	cp $GIT_TREE/net/wireless/{db.txt,genregdb.awk} net/wireless/
> +
> +	# Top level wireless driver Makefile
> +	cp $GIT_TREE/drivers/net/wireless/Makefile drivers/net/wireless
> +
> +	# Broadcom case
> +	DIR="drivers/net/ethernet/broadcom"
> +	cp $GIT_TREE/$DIR/b44.[ch] drivers/net/ethernet/broadcom
> +	# Not yet
> +	echo "obj-\$(CONFIG_B44) += b44.o" > drivers/net/ethernet/broadcom/Makefile
> +fi
>  
>  # Staging drivers in their own directory
> -rm -rf drivers/staging/
> -mkdir -p drivers/staging/
>  for i in $STAGING_DRIVERS; do
>  	if [ ! -d $GIT_TREE/$i ]; then
>  		continue
> @@ -534,59 +495,28 @@ for i in $STAGING_DRIVERS; do
>  	cp -a $GIT_TREE/$i drivers/staging/
>  done
>  
> -for i in $DRIVERS_BT; do
> -	mkdir -p $i
> -	echo "Copying $GIT_TREE/$i/*.[ch]"
> -	cp $GIT_TREE/$i/*.[ch] $i/
> -	cp $GIT_TREE/$i/Makefile $i/
> -done
> -
> -# For rndis_wlan, we need a new rndis_host.ko, cdc_ether.ko and usbnet.ko
> -RNDIS_REQS="Makefile rndis_host.c cdc_ether.c usbnet.c"
> -DIR="drivers/net/usb"
> -for i in $RNDIS_REQS; do
> -	echo "Copying $GIT_TREE/$DIR/$i"
> -	cp $GIT_TREE/$DIR/$i $DIR/
> -done
> -
> -DIR="drivers/net/ethernet/broadcom"
> -echo > $DIR/Makefile
> -cp $GIT_TREE/$DIR/b44.[ch] $DIR
> -# Not yet
> -echo "obj-\$(CONFIG_B44) += b44.o" >> $DIR/Makefile
> -
> -# Misc
> -mkdir -p drivers/misc/eeprom/
> -cp $GIT_TREE/drivers/misc/eeprom/eeprom_93cx6.c drivers/misc/eeprom/
> -cp $GIT_TREE/drivers/misc/eeprom/Makefile drivers/misc/eeprom/
> -
> -DIR="drivers/net/wireless"
> -# Drivers part of the wireless directory
> -for i in $DRIVERS_WLAN_FILES; do
> -	cp $GIT_TREE/$DIR/$i $DIR/
> -done
> -
> -# Top level wireless driver Makefile
> -cp $GIT_TREE/$DIR/Makefile $DIR
> +###########################
> +# Suck in compat.git tree #
> +###########################
>  
> -# Compat stuff
>  COMPAT="compat"
>  mkdir -p $COMPAT
>  echo "Copying $GIT_COMPAT_TREE/ files..."
> -cp $GIT_COMPAT_TREE/compat/*.[ch] $COMPAT/
> -cp $GIT_COMPAT_TREE/compat/Makefile $COMPAT/
>  cp -a $GIT_COMPAT_TREE/udev .
>  cp -a $GIT_COMPAT_TREE/scripts $COMPAT/
>  cp $GIT_COMPAT_TREE/bin/ckmake $COMPAT/
> -cp -a $GIT_COMPAT_TREE/include/linux/* include/linux/
> -cp -a $GIT_COMPAT_TREE/include/net/* include/net/
> -cp -a $GIT_COMPAT_TREE/include/trace/* include/trace/
> -cp -a $GIT_COMPAT_TREE/include/pcmcia/* include/pcmcia/
> -cp -a $GIT_COMPAT_TREE/include/crypto/* include/crypto/
> +cp $GIT_COMPAT_TREE/compat/{Makefile,*.[ch]} $COMPAT/
> +DIRS="linux net trace crypto pcmcia"
> +for dir in $DIRS; do
> +	cp -a $GIT_COMPAT_TREE/include/$dir/* include/$dir/
> +done
>  
>  # Clean up possible *.mod.c leftovers
>  find -type f -name "*.mod.c" -exec rm -f {} \;
>  
> +# Finally copy MAINTAINERS file
> +cp $GIT_TREE/MAINTAINERS ./
> +
>  # files we suck in for wireless drivers
>  export WSTABLE="
>  	net/wireless/
> 

