Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:36535 "EHLO
	mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756944AbcCCWhc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2016 17:37:32 -0500
Received: by mail-io0-f179.google.com with SMTP id l127so43929131iof.3
        for <linux-wireless@vger.kernel.org>; Thu, 03 Mar 2016 14:37:32 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 3 Mar 2016 23:37:31 +0100
Message-ID: <CACna6rzA1JcTjBsozR5nhCH9U9bKwceTNwLzeQ-Ds97NECVaeQ@mail.gmail.com> (sfid-20160303_233735_995351_C89C7240)
Subject: Problem with brcmfmac removing extra interface
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: brcm80211 development <brcm80211-dev-list@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

brcmfmac in general is not capable of removing interfaces. If you take
a look at brcmf_cfg80211_del_iface implementation, you'll see it
returns -EOPNOTSUPP (except for p2p interfaces).

However there is problem in handling NL80211_CMD_STOP_AP (with the
brcmf_cfg80211_stop_ap callback). Current implementation calls
brcmf_fil_cmd_int_set(ifp, BRCMF_C_DOWN, 1)
if mbss support is enabled/used.

Above call results in firmware generating BRCMF_E_LINK event. This
event is handled with the following forward-traced functions chain:
1) brcmf_notify_connect_status
2) brcmf_notify_connect_status_ap
3) brcmf_remove_interface
4) brcmf_del_if
5) brcmf_net_detach
6) unregister_netdev

So the result of NL80211_CMD_STOP_AP is interface being removed. The
problem with this behavior is that interface can't be recreated after
that:
# iw phy phy1 interface add wlan1-1 type __ap
[ 3602.929199] brcmfmac: brcmf_ap_add_vif: timeout occurred
command failed: I/O error (-5)

I hit this problem when trying to restart hostapd using BCM43602 and 2 BSSes.

Could you analyze this problem and see if you see some way of solving
this problem, please?

-- 
Rafał
