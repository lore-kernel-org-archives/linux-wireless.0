Return-Path: <SRS0=FFSH=OD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73F55C43441
	for <linux-wireless@archiver.kernel.org>; Sat, 24 Nov 2018 17:58:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35E45208E7
	for <linux-wireless@archiver.kernel.org>; Sat, 24 Nov 2018 17:58:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 35E45208E7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=i2se.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbeKYErn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 24 Nov 2018 23:47:43 -0500
Received: from mout.kundenserver.de ([212.227.126.134]:45071 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726092AbeKYErn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 24 Nov 2018 23:47:43 -0500
Received: from oxbaltgw61.schlund.de ([172.19.246.148]) by
 mrelayeu.kundenserver.de (mreue010 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1MiaLn-1foFB1446p-00fgIb; Sat, 24 Nov 2018 18:58:40 +0100
Date:   Sat, 24 Nov 2018 18:58:40 +0100 (CET)
From:   Stefan Wahren <stefan.wahren@i2se.com>
To:     =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>
Message-ID: <142675996.139583.1543082320719@email.ionos.de>
Subject: brcmfmac: regression using AP mode
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.8.4-Rev46
X-Originating-Client: open-xchange-appsuite
X-Provags-ID: V03:K1:c90yfQeoLdyyoPt2l6D5yG+/wfebV48+vDu2J0BrhAApMdVNavT
 aYTnGydSStRYVARI4Ze/mhP5oPkbJ8LUrM7TqGzALTZmfRlaTIVCcXAJCo5sAlb2NN5Xsh6
 qy2Ps/UjKtwTmDndevn4mDVVZ5L+VWjY1Ld/bOTzm92o7NlkUkqYU2ZDQTpS2yAaxkKDk0U
 p6eSgJGk41pyFIjUInYuA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:jDT0XQy4E/E=:tmVPCA+zt3iNfy8FpmT9FQ
 Uv9knrBbX4Ws6WDdIJ0971JsSpQaVvyab7pzFj7Q539NZW2DSki6B2BSbeoXoVgvx18l25NhX
 jXtk4jiKNYbpt6IgKtYB0+gQm4Nh53KxUJwolJDzqgSTK2wb/XnGexkQ7UYif6eA3G+kc1uCL
 GiFznjN1yuGm+CXb7ZHCDZSFyilmmuisRj3VL4+AHti/3Lhm4tw7gTX7OUnTQNd82Eh3AKklI
 ST/y0c2eB7AxRnGlXxP/r5bKVNeBaUZSDCrS/4GZkF8EnWqvNjXfoK4tFRnkwe98/+biaEo/E
 VraXKYejQjoi2jeBv4+zV0Ly2zxr61XrMMXIWYvLnPQfoGchuk97UQJNNv5zNzaoi41TsyG5h
 NU/SSo3pc0IBZQML0t/kkrSVA0zs44gkuS3gXbLYH2eNehZ15UjEY6IRXOr6K6hrWKUanJn7+
 TM/nyKLO9auEvx6Xo2S+V/4fXLo2kP2Zn7lRD51agfMS0sanAN6uhRGmA5U46gcb24t2oR9Ab
 2dlnaEO2x9Mjx1z+1TrI7j8BVrc3OauDwYzxaXT2uA8zNXbN8BAMS3LW8uIJqXIe77sqYNJ7/
 0rRWDSxY9Acbm65ndlkQ7QoYXeirWU0gKatm44UeOE9GnEHI55F0w1/BijBby1wmoodkmLFXA
 joGR6cHt2GRGC6qduI4jtqV+wfHiQVRaY26B9Jug++i5aXRdpDs5a6LJjwksGtKpthCT5gyCj
 /avFw3os5x3jztHyO8QT8gB5P6yZoi7XltQD4IIiYpZq6xMaatWAJpHJDgmhp4v++s/5Bv3Yj
 kvLVBn//208xYlQBpYdMzXVlzrUdw==
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi guys,

today i wanted to setup an access point on my Raspberry Pi 3 A+ (BCM43455). Unfortunately the hostapd 2.4 shipped with Raspbian failed with recent Linux kernel:

rfkill: initial event: idx=0 type=2 op=0 soft=0 hard=0
rfkill: initial event: idx=1 type=1 op=0 soft=0 hard=0
nl80211: Using driver-based roaming
nl80211: TDLS supported
nl80211: Supported cipher 00-0f-ac:1
nl80211: Supported cipher 00-0f-ac:5
nl80211: Supported cipher 00-0f-ac:2
nl80211: Supported cipher 00-0f-ac:4
nl80211: Supported cipher 00-0f-ac:6
nl80211: Using driver-based off-channel TX
nl80211: Supported vendor command: vendor_id=0x1018 subcmd=1
nl80211: Use separate P2P group interface (driver advertised support)
nl80211: Enable multi-channel concurrent (driver advertised support)
nl80211: use P2P_DEVICE support
nl80211: Disable use_monitor with device_ap_sme since no monitor mode support detected
nl80211: interface wlan0 in phy phy0
nl80211: Set mode ifindex 3 iftype 3 (AP)
nl80211: Setup AP(wlan0) - device_ap_sme=1 use_monitor=0
nl80211: Subscribe to mgmt frames with AP handle 0x114350 (device SME)
nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION) nl_handle=0x114350 match=
nl80211: Register frame command failed (type=208): ret=-22 (Invalid argument)
nl80211: Register frame match - hexdump(len=0): [NULL]
nl80211: Could not configure driver mode
nl80211: deinit ifname=wlan0 disabled_11b_rates=0
nl80211: Remove monitor interface: refcount=0
nl80211: Remove beacon (ifindex=3)
netlink: Operstate: ifindex=3 linkmode=0 (kernel-control), operstate=6 (IF_OPER_UP)
nl80211: Set mode ifindex 3 iftype 2 (STATION)
nl80211: Teardown AP(wlan0) - device_ap_sme=1 use_monitor=0
nl80211 driver initialization failed.

I was able to bisect this issue down to this commit:

1204aa17f3b4 ("brcmfmac: set WIPHY_FLAG_HAVE_AP_SME flag")

After reverting this commit hostapd works as expected.

Best regards
Stefan
