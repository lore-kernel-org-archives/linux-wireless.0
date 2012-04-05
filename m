Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47656 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609Ab2DEQXW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Apr 2012 12:23:22 -0400
Received: by ghrr11 with SMTP id r11so786910ghr.19
        for <linux-wireless@vger.kernel.org>; Thu, 05 Apr 2012 09:23:21 -0700 (PDT)
Message-ID: <4F7DC6F1.50304@lwfinger.net> (sfid-20120405_182334_562823_4B16538C)
Date: Thu, 05 Apr 2012 11:23:13 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: Joshua Roys <Joshua.Roys@gtri.gatech.edu>,
	Nicu Pavel <npavel@mini-box.com>
Subject: Re: Problem with the rtl8192cu - kernelmodule after ifdown, ifup
References: <4F0EEA1B.3040501@wut.de> <4F0FA4DD.5020601@lwfinger.net> <loom.20120405T091556-756@post.gmane.org> <4F7D90AF.2040109@gtri.gatech.edu>
In-Reply-To: <4F7D90AF.2040109@gtri.gatech.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/05/2012 07:31 AM, Joshua Roys wrote:
> On 04/05/2012 03:27 AM, Nicu Pavel wrote:
>> After mode debugging with DBG_LOUD I found out that the difference when the
>> driver is loaded/modprobed and ifdown/ifup to be a receive configuration
>> register (RCR) value.
>>
>> On bootup/modprobe: ### Set RCR(0xf0002a0e) ###
>> On ifdown/ifup: ### Set RCR(0xf0002ace) ###
>>
>> If I force RCR value to 0x2a0e in rtl92cu_set_hw_reg()inside HW_VAR_RCR case
>> everything works ok.
>>
>> This seems to work with 3 different vendors USB sticks based on 8192cu chipset
>> (Edimax, EDUP and some unknown vendor).
>>
>> I tried looking up the bit values meanings from that register but couldn't find
>> a proper spec.
>
> Hello,
>
> I found a header file that seems to have better definitions and comments than
> what is currently in-tree (I think it's a copy of the Realtek sources). It says
> that the "8192C (RCR) Receive Configuration Register" BIT 6 and 7 are,
> respectively: RCR_CBSSID_DATA [Accept BSSID match packet (Data)] and
> RCR_CBSSID_BCN [Accept BSSID match packet (Rx beacon, probe rsp)].
> These bits are set/cleared in _rtl92cu_set_check_bssid (it calls set_hw_reg
> w/HW_VAR_RCR) which is called by rtl92cu_set_network_type. The set/clear choice
> is made based on the rtlphy->current_io_type which is set in
> rtl8192c/phy_common.c:rtl92c_phy_scan_operation_backup which in turn is called
> from core.c:rtl_op_sw_scan_start/_complete.
> It would be interesting to see the output from rtl8192c/phy_common.c functions
> rtl92c_phy_set_io_cmd and rtl92c_phy_set_io to see if the current_io_type
> perhaps isn't being updated properly.

I have a low-priority patch that will add the definitions of the bits in the 
Receive Control Register. Bits 6 & 7 should be set when the interface is 
associated with an AP. That will let the hardware filter out any traffic not 
coming from the AP and reduce the driver's work load. When the interface is not 
associated, those bits should be clear. Forcing them off will work at the 
expense of extra overhead.

When NetworkManager controls the interface, I think these bits are set correctly 
- it is when manual ifup/ifdown is used that the wrong settings result. I will 
need to switch my system into manual mode to see if I can find the place where 
it goes wrong.

Larry
