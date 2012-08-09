Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:37409 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759045Ab2HITBL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2012 15:01:11 -0400
Message-ID: <502408EB.3020905@hauke-m.de> (sfid-20120809_210115_283361_CC768D49)
Date: Thu, 09 Aug 2012 21:00:59 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozancag@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 10/13] compat-wireless: Selectively apply patches
References: <1344535292-4451-1-git-send-email-ozancag@gmail.com> <1344535292-4451-11-git-send-email-ozancag@gmail.com>
In-Reply-To: <1344535292-4451-11-git-send-email-ozancag@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/09/2012 08:01 PM, Ozan Çağlayan wrote:
> Patches are now structured in network/ and drm/ subfolders.
> Apply them only if the relevant subsystem is enabled.
> 
> Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>
> ---
>  scripts/admin-update.sh | 49 +++++++++++++++++++++++++++++++------------------
>  1 file changed, 31 insertions(+), 18 deletions(-)
> 
> diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
> index b5dbc4e..e701406 100755
> --- a/scripts/admin-update.sh
> +++ b/scripts/admin-update.sh
> @@ -143,7 +143,7 @@ nagometer() {
>  
>  	let CHANGES=$ADD+$DEL
>  
> -	case $1 in
> +	case `dirname $1` in
>  	"patches")
>  		brag_backport $ORIG_CODE $CHANGES $ADD $DEL
>  		;;
> @@ -201,6 +201,7 @@ copyDirectories() {
>  # These switches determines which drivers to fetch in.
>  ENABLE_NETWORK=
>  ENABLE_DRM=
> +SUBSYSTEMS=
>  
>  EXTRA_PATCHES="patches"
>  REFRESH="n"
> @@ -262,6 +263,15 @@ if [ $# -ge 1 ]; then
>  	done
>  fi
>  
> +# SUBSYSTEMS is used to select which patches to apply
> +if [[ -n "$ENABLE_NETWORK" ]]; then
> +	SUBSYSTEMS="network"
> +fi
> +
> +if [[ -n "$ENABLE_DRM" ]]; then
> +	SUBSYSTEMS+=" drm"
> +fi
> +
>  # User exported this variable
>  if [ -z $GIT_TREE ]; then
>  	GIT_TREE="$HOME/linux-next"
> @@ -604,25 +614,28 @@ for dir in $EXTRA_PATCHES; do
>  	LAST_ELEM=$dir
>  done
>  
> -for dir in $EXTRA_PATCHES; do
> -	if [[ ! -d $dir ]]; then
> -		echo -e "${RED}Patches: $dir empty, skipping...${NORMAL}\n"
> -		continue
> -	fi
> -	if [[ $LAST_ELEM = $dir && "$REFRESH" = y ]]; then
> -		patchRefresh $dir
> -	fi
> -
> -	for i in $(ls -v $dir/*.patch &> /dev/null); do
> -		echo -e "${GREEN}Applying backport patch${NORMAL}: ${BLUE}$i${NORMAL}"
> -		patch -p1 -N -t < $i
> -		RET=$?
> -		if [[ $RET -ne 0 ]]; then
> -			echo -e "${RED}Patching $i failed${NORMAL}, update it"
> -			exit $RET
> +for subsystem in $SUBSYSTEMS; do
> +	for dir in $EXTRA_PATCHES; do
> +		PATCHDIR="$dir/$subsystem"

The folder network does not exists in this patch, this will break git
bisect. Could you add the move of the patches from patches to network in
this commit.

I do not like the name network for the folder containing the patches,
because it could easily be to mixed up with the net folder. What about
patches-net as the folder name?

> +		if [[ ! -d $PATCHDIR ]]; then
> +			echo -e "${RED}Patches: $PATCHDIR empty, skipping...${NORMAL}\n"
> +			continue
> +		fi
> +		if [[ $LAST_ELEM = $dir && "$REFRESH" = y ]]; then
> +			patchRefresh $dir
>  		fi
> +
> +		for i in $(ls -v $PATCHDIR/*.patch 2> /dev/null); do
> +			echo -e "${GREEN}Applying backport patch${NORMAL}: ${BLUE}$i${NORMAL}"
> +			patch -p1 -N -t < $i
> +			RET=$?
> +			if [[ $RET -ne 0 ]]; then
> +				echo -e "${RED}Patching $i failed${NORMAL}, update it"
> +				exit $RET
> +			fi
> +		done
> +		nagometer $PATCHDIR $ORIG_CODE >> $CODE_METRICS
>  	done
> -	nagometer $dir $ORIG_CODE >> $CODE_METRICS
>  done
>  
>  DIR="$PWD"
> 

