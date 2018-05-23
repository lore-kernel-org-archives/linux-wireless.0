Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lelnx194.ext.ti.com ([198.47.27.80]:44194 "EHLO
        lelnx194.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753985AbeEWHEf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 May 2018 03:04:35 -0400
From: "Reizer, Eyal" <eyalr@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
        KISHON VIJAY ABRAHAM <kishon@ti.com>,
        "Mishol, Guy" <guym@ti.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        "Hahn, Maital" <maitalm@ti.com>,
        "Altshul, Maxim" <maxim.altshul@ti.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Loewy, Chen" <c-loewy@ti.com>
Subject: RE: [EXTERNAL] [PATCHv2 0/5] Runtime PM support for wlcore
Date: Wed, 23 May 2018 07:04:28 +0000
Message-ID: <f84fbac4ff84496db852f8d0275c84c3@ti.com> (sfid-20180523_090440_894987_969EDC3F)
References: <20180517185029.71716-1-tony@atomide.com>
 <bff51dcc6fd441d9ab42db273219aaf4@ti.com>
 <20180521163830.GZ98604@atomide.com> <20180521224339.GD98604@atomide.com>
 <38ddca4c73bb4dbf835a84133035dbfb@ti.com>
 <20180522133158.GE98604@atomide.com>
 <eae7c720c09549f0b4ff83f88ad6959b@ti.com>
 <20180522135511.GI98604@atomide.com>
 <92eff64ea59740bfa395b53ff22c07d3@ti.com>
 <20180522150111.GJ98604@atomide.com> <20180522172343.GK98604@atomide.com>
In-Reply-To: <20180522172343.GK98604@atomide.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>=20
> Here's a modified version of your patch, does that put wlcore to
> idle with wowlan during suspend for you?
>=20

Still no joy.
It suspends/resumes ok but leaves the firmware disabled from entering ELP.
You can see the log below with some prints added to wlcore_runtime_suspend(=
)
And wlcore_runtime_resume().
What you can see is that normally after each transaction, such as scan belo=
w,
It ends where the firmware is allowed to enter ELP based on its internal lo=
gic.
You can see the print "chip allowed to entered elp" below.

root@am335x-evm:~#
root@am335x-evm:~#
root@am335x-evm:~# iw wlan0 scan | grep SSID
[  106.010879] disabling the FW from enering ELP
[  106.026780] wlcore_runtime_suspend -> enter
[  106.033331] allowing chip to entered elp
 [  106.037823] chip allowed to entered elp
...
...
 [  110.110140] disabling the FW from enering ELP
[  110.224902] wlcore_runtime_suspend -> enter
[  110.229208] allowing chip to entered elp
        SSID: IOTLP_521
        SSID: Reizer
        SSID: LinksysADSL
        SSID: RT2880_AP
        SSID: net4guest
[  110.252460] chip allowed to entered elp
        SSID: halekoa75
        SSID: externalhotspot84
        SSID: cpn84
        SSID: WPS_AP_5G
        SSID: MarvellAP95
[  110.266707] disabling the FW from enering ELP
[  110.279297] wlcore_runtime_suspend -> enter
        SSID:
        SSID:
[  110.292041] allowing chip to entered elp
        SSID: net4guest
[  110.303485] chip allowed to entered elp
        SSID: halekoa75
        SSID: externalhotspot84
        SSID: cpn84
        SSID: net4guest
        SSID: halekoa75
        SSID: externalhotspot84
        SSID: cpn84
root@am335x-evm:~#
root@am335x-evm:~#
root@am335x-evm:~#

This is not the case when suspending.
You can see below that the message " PM: Successfully put all powerdomains =
to target state"
Comes before the call to pm_runtime_suspend() was executed and the firmware
Remained in full active state consuming full power during the whole time th=
e system was=20
suspended.
The call to pm_runtime_suspend is only seen on resume:

[  124.153960] Restarting tasks ...=20
[  124.154702] wlcore_runtime_suspend -> enter

I have also verified that this is not just a print issue by using a firmwar=
e logger that=20
Shows the internal state of the firmware and can see that the call to allow=
 ELP
Actually comes only after resume.
This is what I am trying to chase now. Something is not right here with pm_=
runtime.
Any ideas here?

root@am335x-evm:~#
root@am335x-evm:~# echo mem > /sys/power/state
[  123.444472] PM: suspend entry (deep)
[  123.448119] PM: Syncing filesystems ... done.
[  123.467382] Freezing user space processes ... (elapsed 0.002 seconds) do=
ne.
[  123.477144] OOM killer disabled.
[  123.480424] Freezing remaining freezable tasks ... (elapsed 0.001 second=
s) done.
[  123.489880] Suspending console(s) (use no_console_suspend to debug)
[  123.505821] disabling the FW from enering ELP
[  123.861590] pm33xx pm33xx: PM: Successfully put all powerdomains to targ=
et state
[  123.861590] PM: Wakeup source UART
[  123.886091] net eth0: initializing cpsw version 1.12 (0)
[  123.984353] SMSC LAN8710/LAN8720 4a101000.mdio:00: attached PHY driver [=
SMSC LAN8710/LAN8720] (mii_bus:phy_addr=3D4a101000.mdio:00, irq=3DPOLL)
[  124.150623] OOM killer enabled.
[  124.153960] Restarting tasks ...
[  124.154702] wlcore_runtime_suspend -> enter
[  124.171414] done.
[  124.190085] allowing chip to entered elp
[  124.199877] chip allowed to entered elp
[  124.208633] PM: suspend exit
root@am335x-evm:~#

Best Regards,
Eyal
