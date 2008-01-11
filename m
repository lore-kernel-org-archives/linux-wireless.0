Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.180]:60822 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512AbYAKBjB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jan 2008 20:39:01 -0500
Received: by py-out-1112.google.com with SMTP id u52so1348371pyb.10
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jan 2008 17:39:00 -0800 (PST)
Message-ID: <b25c3fa70801101738j512a6189i3e4541bf0348b91f@mail.gmail.com> (sfid-20080111_013908_782150_442FF0A1)
Date: Fri, 11 Jan 2008 10:38:59 +0900
From: "Joonwoo Park" <joonwpark81@gmail.com>
To: "Zhu Yi" <yi.zhu@intel.com>
Subject: Re: [ipw3945-devel] [PATCH 4/5] iwlwifi: iwl3945 eliminate sleepable task queue from context
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	lkml <linux-kernel@vger.kernel.org>,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1200013607.3530.128.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <11998765783953-git-send-email-joonwpark81@gmail.com>
	 <1200013607.3530.128.camel@debian.sh.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/1/11, Zhu Yi <yi.zhu@intel.com>:
> Hi Joonwoo,
>
> We already did something similiar in our code base. Could you please
> take a look at this patch?
>
> http://intellinuxwireless.org/repos/?p=iwlwifi.git;a=commitdiff;h=57aa02255e9d7be5e2494683fc2793bd1d0707e2
>
> Thanks,
> -yi

Ooops :-)
I should have checked code base, it's my fault.
it's seems very similar, but I could not made build unfortunately.
Can you introduce to me how to build it please?

my build error is here:
jason@ehus ~/SRC/DRIVERS/iwlwifi $ KSRC=/home/jason/SRC/LINUX/linux-2.6 make
make -C /home/jason/SRC/LINUX/linux-2.6 O=
M=/home/jason/SRC/DRIVERS/iwlwifi/compatible/
EXTRA_CFLAGS="-DCONFIG_IWL3945_DEBUG=y -DCONFIG_IWL4965_DEBUG=y
-DCONFIG_IWL3945_SPECTRUM_MEASUREMENT=y
-DCONFIG_IWL4965_SPECTRUM_MEASUREMENT=y -DCONFIG_IWL4965_SENSITIVITY=y
-DCONFIG_IWL3945_QOS=y -DCONFIG_IWL4965_QOS=y" modules
make[1]: Entering directory `/home/jason/SRC/LINUX/linux-2.6'
  CC [M]  /home/jason/SRC/DRIVERS/iwlwifi/compatible/iwl3945-base.o
In file included from
/home/jason/SRC/DRIVERS/iwlwifi/compatible/iwl3945-base.c:51:
/home/jason/SRC/DRIVERS/iwlwifi/compatible/iwl-3945.h:443: error:
expected specifier-qualifier-list before 'ieee80211_key_alg'
/home/jason/SRC/DRIVERS/iwlwifi/compatible/iwl3945-base.c: In function
'iwl3945_add_station':
/home/jason/SRC/DRIVERS/iwlwifi/compatible/iwl3945-base.c:539: error:
implicit declaration of function 'MAC_ARG'
/home/jason/SRC/DRIVERS/iwlwifi/compatible/iwl3945-base.c:539:
warning: too few arguments for format
/home/jason/SRC/DRIVERS/iwlwifi/compatible/iwl3945-base.c: In function
'iwl3945_commit_rxon':
/home/jason/SRC/DRIVERS/iwlwifi/compatible/iwl3945-base.c:1161:
warning: too few arguments for format
/home/jason/SRC/DRIVERS/iwlwifi/compatible/iwl3945-base.c: In function
'iwl3945_update_sta_key_info':
/home/jason/SRC/DRIVERS/iwlwifi/compatible/iwl3945-base.c:1400: error:
'struct iwl3945_hw_key' has no member named 'alg'
/home/jason/SRC/DRIVERS/iwlwifi/compatible/iwl3945-base.c:1401: error:
'struct iwl3945_hw_key' has no member named 'keylen'
/home/jason/SRC/DRIVERS/iwlwifi/compatible/iwl3945-base.c:1402: error:
'struct iwl3945_hw_key' has no member named 'key'
/home/jason/SRC/DRIVERS/iwlwifi/compatible/iwl3945-base.c:1402: error:
'struct iwl3945_hw_key' has no member named 'key'
/home/jason/SRC/DRIVERS/iwlwifi/compatible/iwl3945-base.c: In function
'iwl3945_build_tx_cmd_hwcrypto':
/home/jason/SRC/DRIVERS/iwlwifi/compatible/iwl3945-base.c:2594: error:
'struct iwl3945_hw_key' has no member named 'alg'
/home/jason/SRC/DRIVERS/iwlwifi/compatible/iwl3945-base.c:2597: error:
'struct iwl3945_hw_key' has no member named 'keylen'
/home/jason/SRC/DRIVERS/iwlwifi/compatible/iwl3945-base.c:2597: error:
'struct iwl3945_hw_key' has no member named 'key'
/home/jason/SRC/DRIVERS/iwlwifi/compatible/iwl3945-base.c:2597: error:
'struct iwl3945_hw_key' has no member named 'keylen'
/home/jason/SRC/DRIVERS/iwlwifi/compatible/iwl3945-base.c:2597: error:
'struct iwl3945_hw_key' has no member named 'key'
/home/jason/SRC/DRIVERS/iwlwifi/compatible/iwl3945-base.c:2597: error:
'struct iwl3945_hw_key' has no member named 'keylen'


Thanks,
Joonwoo
