Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:33871 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013Ab2GQMsa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jul 2012 08:48:30 -0400
Received: by weyx8 with SMTP id x8so236938wey.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 Jul 2012 05:48:29 -0700 (PDT)
From: =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@kernel.org,
	=?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
Subject: [PATCH] compat: Use a bash function to colorify the messages
Date: Tue, 17 Jul 2012 15:48:22 +0300
Message-Id: <1342529302-29687-1-git-send-email-ozancag@gmail.com> (sfid-20120717_144834_288814_91C9A051)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Declare a prettify() function that takes a color and a message
parameter instead of wrapping every message in the script with
ANSI codes.

Also add a nocolor mode which will be enabled with the -n flag.

Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>
---
 bin/ckmake |   72 +++++++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 50 insertions(+), 22 deletions(-)

diff --git a/bin/ckmake b/bin/ckmake
index 8e98c34..d408160 100755
--- a/bin/ckmake
+++ b/bin/ckmake
@@ -11,15 +11,6 @@
 # found. This relies on distribution specific kernels, but can handle
 # your own custom list of target kernels. Log is setnt to LOG variable.
 
-# Pretty colors
-GREEN="\033[01;32m"
-YELLOW="\033[01;33m"
-NORMAL="\033[00m"
-BLUE="\033[34m"
-RED="\033[31m"
-PURPLE="\033[35m"
-CYAN="\033[36m"
-UNDERLINE="\033[02m"
 
 #export KCFLAGS="-Wno-unused-but-set-variable"
 KERNEL_DIR="/lib/modules"
@@ -28,9 +19,10 @@ LOG="ckmake.log"
 LOG_TMP="ckmake-tmp.log"
 REPORT="ckmake-report.log"
 TIME="0"
-QUIET=""
-DEBUG=""
+DEBUG="0"
+NOCOLOR="0"
 ARGS=""
+QUIET=""
 RET_FILE="ret-tmp.txt"
 
 # First and last kernels to use
@@ -47,6 +39,42 @@ if [[ -d "$HOME/compat-ksrc" ]]; then
 	KSRC_PREFIX="$HOME/compat-ksrc"
 fi
 
+# Colorify output if NOCOLOR != 1 or -n is not given
+function prettify()
+{
+	if [[ $NOCOLOR == "1" ]]; then
+		echo -n "$2"
+	else
+		ANSI_CODE=
+		NORMAL="\033[00m"
+		case $1 in
+			"green")
+				ANSI_CODE="\033[01;32m"
+				;;
+			"yellow")
+				ANSI_CODE="\033[01;33m"
+				;;
+			"blue")
+				ANSI_CODE="\033[34m"
+				;;
+			"red")
+				ANSI_CODE="\033[31m"
+				;;
+			"purple")
+				ANSI_CODE="\033[35m"
+				;;
+			"cyan")
+				ANSI_CODE="\033[36m"
+				;;
+			"underline")
+				ANSI_CODE="\033[02m"
+				;;
+		esac
+
+		echo -e -n "${ANSI_CODE}$2${NORMAL}"
+	fi
+}
+
 function tee_color_split()
 {
 	while read; do
@@ -57,9 +85,7 @@ function tee_color_split()
 
 function log_try_kernel()
 {
-	echo -en "Trying kernel ${BLUE}"
-	printf "%40s\t" "${1}"
-	echo -en "${NORMAL}"
+	printf "Trying kernel %40s\t" "$(prettify blue $1)"
 }
 
 function usage()
@@ -68,6 +94,7 @@ function usage()
 	echo -e "-t   will run: 'time ckmake; time ckmake' account for"
 	echo -e "     benchmark how long it takes to compile without ccache"
 	echo -e "     and a run after cache kicks in"
+	echo -e "-n   Do not use colors in the output"
 	echo -e "-q   will ask ckmake to run make with -s to only output errors"
 	echo
 	echo -e "<optional-target>  is the arguments you want to pass to the"
@@ -93,6 +120,10 @@ for i in $@ ; do
 			TIME="1"
 			shift
 			;;
+		"-n")
+			NOCOLOR="1"
+			shift
+			;;
 		"-s")
 			QUIET="-s"
 			shift
@@ -107,7 +138,7 @@ for i in $@ ; do
 				FIRST=$(echo $i | sed 's|\.\.|-|' | awk -F"-" '{print $1}')
 				LAST=$(echo $i | sed 's|\.\.|-|' | awk -F"-" '{print $2}')
 				RANGE="${FIRST}..${LAST}"
-				echo -e "Going to use kernel ranges: ${BLUE}${FIRST}${NORMAL}..${BLUE}${LAST}${NORMAL}"
+				echo -e "Going to use kernel ranges: $(prettify blue $FIRST)..$(prettify blue $LAST)"
 				shift
 			fi
 
@@ -127,10 +158,7 @@ function run_ckmake()
 			continue
 		fi
 
-		# We cannot use tee_color_split() as bash read only spits
-		# out output when a newline comes in. We can modif IFS but
-		# I am still not sure how to do this properly.
-		log_try_kernel $KERNEL | perl -pe 's|(\e)\[(\d+)(;*)(\d*)(\w)||g' >> $LOG
+		NOCOLOR="1" log_try_kernel $KERNEL >> $LOG
 		log_try_kernel $KERNEL
 
 		#ionice -c 3 nice -n 20 make $QUIET KLIB=$DIR KLIB_BUILD=$DIR -j6 -Wunused-but-set-variable $ARGS &>> $LOG
@@ -142,9 +170,9 @@ function run_ckmake()
 		fi
 
 		if [[ $CUR_RET -eq 0 ]]; then
-			echo -e "${GREEN}[OK]${NORMAL}" | tee_color_split $LOG
+			echo -e "$(prettify green [OK])" | tee_color_split $LOG
 		else
-			echo -e "${RED}[FAILED]${NORMAL}" | tee_color_split $LOG
+			echo -e "$(prettify red [FAILED])" | tee_color_split $LOG
 			RET=$CUR_RET
 		fi
 
@@ -199,7 +227,7 @@ for i in $(find $KSRC_PREFIX/lib/modules/ -type d -name \*generic\* | sort -n -r
 		fi
 
 		if [[ ! -z $DEBUG ]]; then
-			echo -e "${CYAN}${FIRST}${NORMAL} $(kernel_version $FIRST) <= ${GREEN}${KERNEL}${NORMAL} $(kernel_version $KERNEL) <= ${CYAN}${LAST}${NORMAL} $(kernel_version $LAST)"
+			echo -e "$(prettify cyan $FIRST) $(kernel_version $FIRST) <= $(prettify green $KERNEL) $(kernel_version $KERNEL) <= $(prettify cyan $LAST) $(kernel_version $LAST)"
 		fi
 	fi
 
-- 
1.7.10.4

