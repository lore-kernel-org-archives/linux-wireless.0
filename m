Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50892 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754911Ab2BSUxy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Feb 2012 15:53:54 -0500
Received: by iacb35 with SMTP id b35so6699041iac.19
        for <linux-wireless@vger.kernel.org>; Sun, 19 Feb 2012 12:53:53 -0800 (PST)
Message-ID: <4F416159.9000305@lwfinger.net> (sfid-20120219_215450_433577_EB514515)
Date: Sun, 19 Feb 2012 14:53:45 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: wireless <linux-wireless@vger.kernel.org>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>
Subject: Instability in brcmsmac
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend,

I have just started testing brcmsmac with my BCM43224 card. I find it rather 
unstable. A typical cycle between authentication and disassociating is as follows:

[ 1066.227729] wlan8: authenticate with 00:1a:70:46:ba:b1
[ 1066.238397] wlan8: send auth to 00:1a:70:46:ba:b1 (try 1/3)
[ 1066.440128] wlan8: send auth to 00:1a:70:46:ba:b1 (try 2/3)
[ 1066.443739] wlan8: authenticated
[ 1066.448139] wlan8: associate with 00:1a:70:46:ba:b1 (try 1/3)
[ 1066.456657] wlan8: RX AssocResp from 00:1a:70:46:ba:b1 (capab=0x411 status=0 
aid=1)
[ 1066.456673] wlan8: associated
[ 1066.458051] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true 
(implement)
[ 1066.458067] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[ 1066.458087] ieee80211 phy0: changing basic rates failed: -22
[ 1066.458101] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: 
enabled true, count 1 (implement)
[ 1076.464670] wlan8: disassociating from 00:1a:70:46:ba:b1 by local choice 
(reason=3)
[ 1076.465981] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false 
(implement)
[ 1076.466051] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[ 1076.466074] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: 
enabled false, count 1 (implement)
[ 1076.490224] cfg80211: Calling CRDA to update world regulatory domain
[ 1076.507338] wlan8: deauthenticating from 00:1a:70:46:ba:b1 by local choice 
(reason=3)

The period of time that the interface is up ranges from 10 - 200 seconds. The 
connection is WPA-TKIP and the kernel is master-2012-02-15-510-g20b79b4 from 
wireless-testing with local patches applied to other drivers. Both brcmsmac and 
bcma are untouched.

Thanks,

Larry

