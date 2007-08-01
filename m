Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.229]:32801 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764378AbXHATd5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2007 15:33:57 -0400
Received: by wr-out-0506.google.com with SMTP id 36so120084wra
        for <linux-wireless@vger.kernel.org>; Wed, 01 Aug 2007 12:33:56 -0700 (PDT)
Message-ID: <3df642dd0708011233p6e515f3aq4b0f9276045cb51c@mail.gmail.com>
Date: Wed, 1 Aug 2007 14:33:55 -0500
From: "Ed Howland" <ed.howland@gmail.com>
To: hostap@shmoo.com, linux-wireless@vger.kernel.org
Subject: Hostapd - does not compile on latest kernel - git 2.6.23-rc1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I got the latest git version of hostap

Compiling against the git version of the linux-wireless-rt2x00 kernel
I get the following error.
2.6.23-rc1 (with merges from today.)

cc -MMD -O2 -Wall -g -DHOSTAPD_DUMP_STATE -I../src -I../src/crypto
-I../src/utils -I../src/common -I../../madwifi-trunk
-I/usr/src/kernels/2.6.22/net/mac80211 -D_LINUX_TYPES_H
-DCONFIG_CTRL_IFACE -DCONFIG_CTRL_IFACE_UNIX -DCONFIG_IAPP
-DCONFIG_RSN_PREAUTH -DCONFIG_PEERKEY -DCONFIG_DRIVER_HOSTAP
-DCONFIG_DRIVER_WIRED -DCONFIG_DRIVER_MADWIFI -DCONFIG_DRIVER_PRISM54
-DCONFIG_DRIVER_DEVICESCAPE -DEAP_MD5 -DEAP_TLS -DEAP_PEAP -DEAP_TTLS
-DEAP_MSCHAPv2 -DEAP_GTC -DEAP_TLV -DEAP_SERVER -DEAP_TLS_FUNCS
-DPKCS12_FUNCS -DINTERNAL_SHA256 -DCONFIG_IPV6   -c -o
driver_devicescape.o driver_devicescape.c
driver_devicescape.c: In function 'i802_if_update':
driver_devicescape.c:1032: error: 'PRISM2_HOSTAPD_UPDATE_IF'
undeclared (first use in this function)
driver_devicescape.c:1032: error: (Each undeclared identifier is
reported only once
driver_devicescape.c:1032: error: for each function it appears in.)
driver_devicescape.c: In function 'handle_frame':
driver_devicescape.c:1358: error: 'ieee80211_msg_set_aid_for_sta'
undeclared (first use in this function)
driver_devicescape.c:1416: error: 'ieee80211_msg_passive_scan'
undeclared (first use in this function)
make: *** [driver_devicescape.o] Error 1

I assume something changed in some header and this define was removed/changed?

Thanks
Ed

-- 
Ed Howland
http://greenprogrammer.blogspot.com
"The information transmitted is intended only for the person or entity
to which it is addressed and may contain proprietary, confidential
and/or legally privileged material. Any review, retransmission,
dissemination or other use of, or taking of any action in reliance
upon, this information by persons or entities other than the intended
recipient is prohibited. If you received this in error, please contact
the sender and delete the material from all computers."
