Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4352 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751879Ab1GTR3h (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jul 2011 13:29:37 -0400
Message-ID: <4E27106F.6020606@broadcom.com> (sfid-20110720_192942_811808_13D20AA1)
Date: Wed, 20 Jul 2011 10:29:19 -0700
From: "Franky Lin" <frankyl@broadcom.com>
MIME-Version: 1.0
To: "Hao Han" <hhanwm@gmail.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Looking for tuning beacon interval on BCM4329
References: <CAGwCZhoYDW-V2a6tmb+hntXvVxcq9RUTf4NFYvfbPprVrAGeSA@mail.gmail.com>
In-Reply-To: <CAGwCZhoYDW-V2a6tmb+hntXvVxcq9RUTf4NFYvfbPprVrAGeSA@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7/14/2011 8:40:14 PM, Hao Han <hhanwm@gmail.com> wrote:
> Dear All,
>
> Using BCM4329 driver, my Nexus One can serve in AP mode with default
> beacon interval of 100ms. I am really hoping to be able to tuning such
> a value for some tests. After downloading and searching the source
> code from
>
> http://android.git.kernel.org/?p=kernel/msm.git;a=tree;f=drivers/net/wireless/bcm4329;h=01f09252ff9b80379e6db6dbb22af4fcba004982;hb=HEAD
>
> I cannot find any place where the default value of beacon interval is
> assgined to 100ms. All beacon related lines are parsed in the
> following
>
> ./include/wlioctl.h:98:	uint16		beacon_period;		
> ./include/wlioctl.h:966:#define VNDR_IE_BEACON_FLAG	0x1
> ./include/wlioctl.h:1103:	uint32	rxbeaconmbss;	
> ./include/wlioctl.h:1105:	uint32	rxbeaconobss;	
> ./include/proto/802.11.h:86:#define DOT11_MIN_BEACON_PERIOD		1	
> ./include/proto/802.11.h:87:#define DOT11_MAX_BEACON_PERIOD		0xFFFF	
> ./include/proto/802.11.h:224:	uint16			beacon_interval;
> ./include/proto/802.11.h:746:#define FC_SUBTYPE_BEACON		8	
> ./include/proto/802.11.h:802:#define FC_BEACON	FC_KIND(FC_TYPE_MNG,
> FC_SUBTYPE_BEACON)
> ./include/proto/802.11.h:862:#define DOT11_MNG_BEACON_INT_LEN	2	
> ./include/proto/bcmevent.h:92:#define WLC_E_BEACON_RX		15	
> ./dhd_common.c:548:		{WLC_E_BEACON_RX, "BEACON_RX"},
> ./dhd_common.c:693:	case WLC_E_BEACON_RX:
> ./dhd_common.c:1311:	uint32 listen_interval = LISTEN_INTERVAL; /*
> Default Listen Interval in Beacons */
> ./dhd_common.c:1398:	/* Setup timeout if Beacons are lost and roam is
> off to report link down */
> ./wl_iw.c:8022:	wstats->miss.beacon = 0;
>
> Any feedback would be extremely appreciated :)

Hi Hao,

I am afraid there is no interface exposed for the configuration of 
beacon interval.

BRs
Franky


