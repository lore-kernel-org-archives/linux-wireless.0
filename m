Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8C8AC282C2
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 18:30:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4B712147C
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 18:30:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726916AbfBGSaz convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 13:30:55 -0500
Received: from mail.3eti.com ([65.220.88.139]:40598 "EHLO mail.ultra-3eti.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726319AbfBGSaz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 13:30:55 -0500
X-ASG-Debug-ID: 1549564226-0542992020015e0001-9xRsGE
Received: from webmail.3eti.com ([192.168.200.4]) by mail.ultra-3eti.com with ESMTP id wXyTJhSs0wEwWNKB (version=TLSv1.2 cipher=AES128-SHA256 bits=128 verify=NO) for <linux-wireless@vger.kernel.org>; Thu, 07 Feb 2019 13:30:26 -0500 (EST)
X-Barracuda-Envelope-From: Chaoxing.Lin@ultra-3eti.com
Received: from EXCHMBX01.rock.corp ([192.168.200.89]) by RockMX01.rock.corp
 ([fe80::5def:57af:7b19:da5a%14]) with mapi id 14.03.0415.000; Thu, 7 Feb 2019
 13:30:22 -0500
From:   Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Help: 4-address interface NL80211_IFTYPE_AP_VLAN not supported any
 more??
Thread-Topic: Help: 4-address interface NL80211_IFTYPE_AP_VLAN not supported
 any more??
X-ASG-Orig-Subj: Help: 4-address interface NL80211_IFTYPE_AP_VLAN not supported any
 more??
Thread-Index: AdS/EgJMNLL5R+DGST2PgK/EG0LHng==
Date:   Thu, 7 Feb 2019 18:30:21 +0000
Message-ID: <E0249DC1E88AC941A5535F80928B4ADF12462523@EXCHMBX01.rock.corp>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.201.12]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Barracuda-Connect: UNKNOWN[192.168.200.4]
X-Barracuda-Start-Time: 1549564226
X-Barracuda-Encrypted: AES128-SHA256
X-Barracuda-URL: https://192.168.200.200:443/cgi-mod/mark.cgi
X-Barracuda-Scan-Msg-Size: 1832
X-Barracuda-BRTS-Status: 1
X-Virus-Scanned: by bsmtpd at ultra-3eti.com
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.67189
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------------------------
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello Linux wireless maintainers,

I was testing hostapd 4-address mode and found out the interface of type NL80211_IFTYPE_AP_VLAN is no longer created in recent kernel version.

Setup
	Hostapd version 2.6
	Wpa_supplicant version 2.6
	Linux kernel 4.19.20

	"wds_sta=1" is added in hostapd.conf
	"iw wlan0 set 4addr on" is set on client side.

For kernel 4.14.16,
	wpa_supplicant connects to hostapd well and hostapd would create wlan0.sta1 interface with type NL80211_IFTYPE_AP_VLAN. The traffic runs well over the AP<---->client. Everything is good.

For kernel 4.19.20,
	wpa_supplicant connects to hostapd well, but hostapd fail to create wlan0.sta1 interface with type NL80211_IFTYPE_AP_VLAN.  No traffic is possible between AP and client.
GDB shows that when creating wlan0.sta1 interface with type NL80211_IFTYPE_AP_VLAN, kernel return -95 (EOPNOTSUPP) to hostapd.
Inside kernel, this - EOPNOTSUPP seems to be returned from 
nl80211_new_interface()--> nl80211_valid_4addr() which complains WIPHY_FLAG_4ADDR_AP flag is not set.

Reading kernel 4.19.20 source, I found that WIPHY_FLAG_4ADDR_AP flag is only possible in simulated hardware.
The only place that sets WIPHY_FLAG_4ADDR_AP flag is ieee80211_alloc_hw_nm()
The only place that calls ieee80211_alloc_hw_nm() is from drivers/net/wireless/mac80211_hwsim.c

So, does it mean that interface with type NL80211_IFTYPE_AP_VLAN will no longer be supported in any real hardware radio?
Or I did not understand kernel source right?

Please help.  

For many years, we have been using this 4-address mode interface in our wireless bridge(proprietary mesh) product. To be backward compatible, we have to maintain the same feature in our new product. This 4-address AP<---->client connection is very import to us.


Thanks for your help,

Chaoxing
