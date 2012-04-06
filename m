Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47144 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571Ab2DFIs6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Apr 2012 04:48:58 -0400
Received: by iagz16 with SMTP id z16so2845300iag.19
        for <linux-wireless@vger.kernel.org>; Fri, 06 Apr 2012 01:48:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4F7E4F2A.1030404@lwfinger.net>
References: <4F0EEA1B.3040501@wut.de>
	<4F0FA4DD.5020601@lwfinger.net>
	<loom.20120405T091556-756@post.gmane.org>
	<4F7D90AF.2040109@gtri.gatech.edu>
	<4F7E4F2A.1030404@lwfinger.net>
Date: Fri, 6 Apr 2012 11:48:57 +0300
Message-ID: <CAL9MRr=U+CCzjP-cSOkPJpvw=AQuHX23grj1atfkT9uxLzEM4w@mail.gmail.com> (sfid-20120406_104902_976250_C13C17BE)
Subject: Re: Problem with the rtl8192cu - kernelmodule after ifdown, ifup
From: Nicu Pavel <npavel@mini-box.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
	Joshua Roys <Joshua.Roys@gtri.gatech.edu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On 04/05/2012 07:31 AM, Joshua Roys wrote:
>>
>> On 04/05/2012 03:27 AM, Nicu Pavel wrote:
>>>
>>> After mode debugging with DBG_LOUD I found out that the difference when
>>> the
>>> driver is loaded/modprobed and ifdown/ifup to be a receive configuration
>>> register (RCR) value.
>>>
>>> On bootup/modprobe: ### Set RCR(0xf0002a0e) ###
>>> On ifdown/ifup: ### Set RCR(0xf0002ace) ###
>>>
>>> If I force RCR value to 0x2a0e in rtl92cu_set_hw_reg()inside HW_VAR_RCR
>>> case
>>> everything works ok.
>>>
>>> This seems to work with 3 different vendors USB sticks based on 8192cu
>>> chipset
>>> (Edimax, EDUP and some unknown vendor).
>>>
>>> I tried looking up the bit values meanings from that register but
>>> couldn't find
>>> a proper spec.
>>
>>
>> Hello,
>>
>> I found a header file that seems to have better definitions and comments
>> than
>> what is currently in-tree (I think it's a copy of the Realtek sources). It
>> says
>> that the "8192C (RCR) Receive Configuration Register" BIT 6 and 7 are,
>> respectively: RCR_CBSSID_DATA [Accept BSSID match packet (Data)] and
>> RCR_CBSSID_BCN [Accept BSSID match packet (Rx beacon, probe rsp)].
>> These bits are set/cleared in _rtl92cu_set_check_bssid (it calls
>> set_hw_reg
>> w/HW_VAR_RCR) which is called by rtl92cu_set_network_type. The set/clear
>> choice
>> is made based on the rtlphy->current_io_type which is set in
>> rtl8192c/phy_common.c:rtl92c_phy_scan_operation_backup which in turn is
>> called
>> from core.c:rtl_op_sw_scan_start/_complete.
>> It would be interesting to see the output from rtl8192c/phy_common.c
>> functions
>> rtl92c_phy_set_io_cmd and rtl92c_phy_set_io to see if the current_io_type
>> perhaps isn't being updated properly.
>
>
> Attached is a patch that I think will help. The main thing it changes is
> that routine rtl92cu_set_check_bssid() has been coded to update RCR. The
> other thing that was changed is to make the RCR setting always log even with
> the default debug option of 0. That will be temporary and that change will
> be deleted once we get this problem fixed.
>
> Let me know if the patch helps.
[..]

Tried the patch, but didn't help:

<7>rtl8192cu:rtl92cu_set_hw_reg():<0-0> ### Set RCR(0xf0002a0e) ###
<7>rtlwifi:rtl_op_conf_tx():<0-0> queue number -954253944 is incorrect!
<7>rtlwifi:rtl_op_conf_tx():<0-0> queue number -954253944 is incorrect!
<7>rtlwifi:rtl_op_conf_tx():<0-0> queue number -954253944 is incorrect!
<7>rtlwifi:rtl_op_conf_tx():<0-0> queue number -954253944 is incorrect!
<7>rtl8192cu:rtl92cu_set_hw_reg():<0-0> ### Set RCR(0xf0002a0e) ###

----> Driver loaded scanning gets results ok.

<6>rtl8192cu: MAC auto ON okay!
<6>rtl8192cu: Tx queue select: 0x05
<7>rtl8192c_common:rtl92c_phy_set_bw_mode():<0-0> FALSE driver sleep or unload
<6>rtl8192c_common: Loading firmware file rtlwifi/rtl8192cufw.bin
<7>rtl8192cu:rtl92cu_set_hw_reg():<0-0> ### Set RCR(0xf0002ace) ###
<7>rtlwifi:rtl_op_conf_tx():<0-0> queue number -954253944 is incorrect!
<7>rtlwifi:rtl_op_conf_tx():<0-0> queue number -954253944 is incorrect!
<7>rtlwifi:rtl_op_conf_tx():<0-0> queue number -954253944 is incorrect!
<7>rtlwifi:rtl_op_conf_tx():<0-0> queue number -954253944 is incorrect!
<7>rtl8192cu:rtl92cu_set_hw_reg():<0-0> ### Set RCR(0xf0002a0e) ###

----> ifdown/ifup no scanning results.

<6>rtl8192cu: MAC auto ON okay!
<6>rtl8192cu: Tx queue select: 0x05
<7>rtl8192c_common:rtl92c_phy_set_bw_mode():<0-0> FALSE driver sleep or unload
<6>rtl8192c_common: Loading firmware file rtlwifi/rtl8192cufw.bin
<7>rtl8192cu:rtl92cu_set_hw_reg():<0-0> ### Set RCR(0xf0002ace) ###
<7>rtlwifi:rtl_op_conf_tx():<0-0> queue number -954253944 is incorrect!
<7>rtlwifi:rtl_op_conf_tx():<0-0> queue number -954253944 is incorrect!
<7>rtlwifi:rtl_op_conf_tx():<0-0> queue number -954253944 is incorrect!
<7>rtlwifi:rtl_op_conf_tx():<0-0> queue number -954253944 is incorrect!
<7>rtl8192cu:rtl92cu_set_hw_reg():<0-0> ### Set RCR(0xf0002a0e) ###

----> ifdown/ifup no scanning results.

Nicu
