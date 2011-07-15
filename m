Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:47326 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932617Ab1GODkP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2011 23:40:15 -0400
Received: by vws1 with SMTP id 1so640614vws.19
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jul 2011 20:40:14 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 15 Jul 2011 11:40:14 +0800
Message-ID: <CAGwCZhoYDW-V2a6tmb+hntXvVxcq9RUTf4NFYvfbPprVrAGeSA@mail.gmail.com> (sfid-20110715_054024_244552_C5E18441)
Subject: Looking for tuning beacon interval on BCM4329
From: Hao Han <hhanwm@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear All,

Using BCM4329 driver, my Nexus One can serve in AP mode with default
beacon interval of 100ms. I am really hoping to be able to tuning such
a value for some tests. After downloading and searching the source
code from

http://android.git.kernel.org/?p=kernel/msm.git;a=tree;f=drivers/net/wireless/bcm4329;h=01f09252ff9b80379e6db6dbb22af4fcba004982;hb=HEAD

I cannot find any place where the default value of beacon interval is
assgined to 100ms. All beacon related lines are parsed in the
following

./include/wlioctl.h:98:	uint16		beacon_period;		
./include/wlioctl.h:966:#define VNDR_IE_BEACON_FLAG	0x1
./include/wlioctl.h:1103:	uint32	rxbeaconmbss;	
./include/wlioctl.h:1105:	uint32	rxbeaconobss;	
./include/proto/802.11.h:86:#define DOT11_MIN_BEACON_PERIOD		1	
./include/proto/802.11.h:87:#define DOT11_MAX_BEACON_PERIOD		0xFFFF	
./include/proto/802.11.h:224:	uint16			beacon_interval;
./include/proto/802.11.h:746:#define FC_SUBTYPE_BEACON		8	
./include/proto/802.11.h:802:#define FC_BEACON	FC_KIND(FC_TYPE_MNG,
FC_SUBTYPE_BEACON)
./include/proto/802.11.h:862:#define DOT11_MNG_BEACON_INT_LEN	2	
./include/proto/bcmevent.h:92:#define WLC_E_BEACON_RX		15	
./dhd_common.c:548:		{WLC_E_BEACON_RX, "BEACON_RX"},
./dhd_common.c:693:	case WLC_E_BEACON_RX:
./dhd_common.c:1311:	uint32 listen_interval = LISTEN_INTERVAL; /*
Default Listen Interval in Beacons */
./dhd_common.c:1398:	/* Setup timeout if Beacons are lost and roam is
off to report link down */
./wl_iw.c:8022:	wstats->miss.beacon = 0;

Any feedback would be extremely appreciated :)

Thanks,
Hao
