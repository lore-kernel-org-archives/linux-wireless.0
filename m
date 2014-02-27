Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:37524 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751785AbaB0QrF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 11:47:05 -0500
Message-ID: <530F6BF8.8040801@hauke-m.de> (sfid-20140227_174712_348743_E9EB0859)
Date: Thu, 27 Feb 2014 17:46:48 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Joe Kodweis <kodweisdev@gmail.com>, backports@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: backports-3.13.2-1 ath9k defconfig fails
References: <CAL6TERTJPPF0tMDeUQMqqPqdc4fo00K-GmpiTeWAu6tfH_H-xA@mail.gmail.com> <CAL6TERTfnnHT6XuwZ3UhXoDyBdV+u8PknrGKTfymmanMZAkT3A@mail.gmail.com>
In-Reply-To: <CAL6TERTfnnHT6XuwZ3UhXoDyBdV+u8PknrGKTfymmanMZAkT3A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/25/2014 05:44 PM, Joe Kodweis wrote:
> Running make with defconfig-ath9k produces .config that does not
> actually build ATH9K. This is observed on 3.13.2-1 and also
> development retrieved 2014-02-25.
> 
> The previous stable version 3.12.8-1 does actually build ATH9K.
> Something happened between 3.12.8-1 and 3.13.2-1 that is preventing
> ATH9K from being built properly.
> 
> See the difference in resulting .config files after running "make
> defconfig-ath9k" in these two versions of stable releases:
> 
> grep ATH  backports-3.13.2-1/.config
> CPTCFG_ATH_CARDS=m
> # CPTCFG_ATH_DEBUG is not set
> # CPTCFG_ATH6KL is not set
> 
> grep ATH backports-3.12.8-1/.config
> CPTCFG_ATH_COMMON=m
> CPTCFG_ATH_CARDS=m
> # CPTCFG_ATH_DEBUG is not set
> CPTCFG_ATH9K_HW=m
> CPTCFG_ATH9K_COMMON=m
> CPTCFG_ATH9K_BTCOEX_SUPPORT=y
> CPTCFG_ATH9K=m
> # CPTCFG_ATH9K_AHB is not set
> # CPTCFG_ATH9K_LEGACY_RATE_CONTROL is not set
> CPTCFG_ATH9K_HTC=m
> # CPTCFG_ATH9K_HTC_DEBUGFS is not set
> # CPTCFG_ATH6KL is not set
> # CPTCFG_ATH10K is not set

It looks like ath9k, mac80211 or cfg80211 are depending on some kernel
configuration you do not have set in your kernel. mac80211 depends on
CONFIG_CRYPTO_CCM, you have to set it in your kernel configuration and
rebuild the kernel if it was not set.

Hauke

