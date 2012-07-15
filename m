Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:40993 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750708Ab2GOEtV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Jul 2012 00:49:21 -0400
Received: by lbgc1 with SMTP id c1so13631709lbg.1
        for <linux-wireless@vger.kernel.org>; Sat, 14 Jul 2012 21:49:18 -0700 (PDT)
Message-ID: <1342327755.1196.6.camel@cumari.coelho.fi> (sfid-20120715_064925_427830_C6B6D94E)
Subject: Re: [PATCH 2/2] mac80211: Remove control.sta from struct
 ieee80211_tx_info and restructure tx-path
From: Luciano Coelho <coelho@ti.com>
To: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@venema.h4ckr.net, ath5k-devel@venema.h4ckr.net,
	ilw@linux.intel.com, users@rt2x00.serialmonkey.com,
	b43-dev@lists.infradead.org, brcm80211-dev-list@broadcom.com,
	chunkeey@googlemail.com, buytenh@wantstofly.org, dsd@gentoo.org,
	johannes.berg@intel.com
Date: Sun, 15 Jul 2012 07:49:15 +0300
In-Reply-To: <1342205545-45382-3-git-send-email-thomas@net.t-labs.tu-berlin.de>
References: <1342205545-45382-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
	 <1342205545-45382-3-git-send-email-thomas@net.t-labs.tu-berlin.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-07-13 at 20:52 +0200, Thomas Huehn wrote:
> The pointer control.sta is removed from ieee80211_tx_info to free up sufficient
> memory in SKB_CB on the tx-path to enable new annotations per data packet e.g.
> support of upcoming Transmit Power Control (TPC).
> Now the control.sta pointer is put on the stack where it is passed as function
> parameter to the .tx equivalent (ieee80211_ops) of each affected wireless
> driver. Therefore a new structure ieee80211_tx_control is added to mac80211.h
> which holds the sta structure instead.
> 
> The tx-path of all affected drivers is restructured to respect the chaneged
> layout of struct ieee80211_tx_info. List of modified drivers:
> ath9k
> ath5k
> iwl3954
> iwl4965
> iwl-agn
> mwl8k
> carl9170
> ath9k-htc
> p54
> rt2x00
> rtl8180
> rtl8087
> hwsim
> b43
> b43legacy
> brcmsmac
> zd1211rw
> wl1251
> wlcore
> rtlwifi
> libertas_tf
> at76c50x-usb
> adm8211
> 
> Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
> Signed-off-by: Alina Friedrichsen <x-alina@gmx.net>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---

For the TI drivers part (wl1251/wlcore):

Acked-by: Luciano Coelho <coelho@ti.com>

--
Luca.

