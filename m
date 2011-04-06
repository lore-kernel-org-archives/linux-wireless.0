Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41368 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954Ab1DFAhr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2011 20:37:47 -0400
Received: by iwn34 with SMTP id 34so925662iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 05 Apr 2011 17:37:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4D9B5473.6040003@lwfinger.net>
References: <BANLkTimnXJGy07-8gt=O7ruH-Hyt=NqtuQ@mail.gmail.com> <4D9B5473.6040003@lwfinger.net>
From: Gottfried Haider <gottfried.haider@gmail.com>
Date: Wed, 6 Apr 2011 02:37:27 +0200
Message-ID: <BANLkTi=ueo0Vm5VPRh=LMCQ-huGzXMyvFQ@mail.gmail.com>
Subject: Re: rtl8192ce: odd ping behavior
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry,

> I repeated your test. My ping results were much better than yours:
>
> I do not see the deauthentication/authentication results that you see. Those
> would definitely cause network delays.
>
> There are one difference in our systems. I have a 10ec:8178 device, but I
> have an 8176 here that I will try now. I have also received a new version of
> the driver from Realtek. If my 8176 has the same problems as yours, perhaps
> that will help.

Thanks for testing. I had hoped that the ping results could make a
light go on somewhere..

I am only starting to get into rolling my own kernels again - but if I
can test something, please let me know.

One thing that appears to me as being broken with this driver is the
LPS mode. I was watching the debug messages go by while having another
terminal continuously ping my WiFi router:


[ 3751.605727] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0>
Readback Thermal Meter = 0x10 pre thermal meter 0xf
eeprom_thermalmeter 0xf delta 0x1 delta_lck 0x0 delta_iqk 0x2
[ 3751.605744] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0>
<===
[ 3751.605757] rtlwifi:rtl_lps_enter():<0-0> Enter 802.11 power save mode...
[ 3751.605767] rtlwifi:rtl_lps_set_psmode():<0-0> FW LPS enter ps_mode:3
[ 3751.605778] rtl8192c_common:rtl92c_set_fw_pwrmode_cmd():<0-0> FW LPS mode = 3
[ 3751.605787] rtl8192c_common: In process "kworker/0:1" (pid
2323):rtl92c_set_fw_rsvdpagepkt(): u1_h2c_set_pwrmode
[ 3751.605799] 03 01 05
[ 3751.605806]
[ 3751.605812] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> come in
[ 3751.606120] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> Write
element_id box_reg( 1dc) =  1
[ 3751.606132] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0>
pHalData->last_hmeboxnum  = 0
[ 3751.606143] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> go out

(then every second a)
[ 3751.789003] rtl8192ce:rtl92ce_led_control():<200-1> ledaction 4,
(until)

[ 3856.004637] rtlwifi:rtl_op_sw_scan_start():<0-0>
[ 3856.004655] rtlwifi:rtl_lps_leave():<0-0> Busy Traffic,Leave 802.11
power save..
[ 3856.004666] rtlwifi:rtl_lps_set_psmode():<0-0> FW LPS leave ps_mode:0
[ 3856.004725] rtl8192c_common:rtl92c_set_fw_pwrmode_cmd():<0-0> FW LPS mode = 0


and when I afterwards looked at the second terminal I saw that the
pings were just being replied to again - and before I had a long list
of failed ping requests. Now maybe this is policy-wise totally the
expected behavior - waiting for a storm till leaving the power saving
mode - but for debugging it would be good to iron this out, as it's a
bit hard to track when it kicks in (and it's obviously _not_
completely transparent to the user).

On the ThinkPad Wiki, LPS is also mentioned as a source of problems
[1] - though I don't know how similar the in-kernel driver is to the
version that the text refers to.


send trough my USB-tethered phone ;)

Gottfried

[1] http://www.thinkwiki.org/wiki/ThinkPad_11b/g/n_Wireless_LAN_Mini-PCI_Express_Adapter_II
