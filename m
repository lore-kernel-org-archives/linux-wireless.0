Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53026 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754983Ab2DIIk4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Apr 2012 04:40:56 -0400
Received: by iagz16 with SMTP id z16so5615442iag.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 Apr 2012 01:40:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4F7F4A0F.2050300@lwfinger.net>
References: <4F0EEA1B.3040501@wut.de>
	<4F0FA4DD.5020601@lwfinger.net>
	<loom.20120405T091556-756@post.gmane.org>
	<4F7D90AF.2040109@gtri.gatech.edu>
	<4F7E4F2A.1030404@lwfinger.net>
	<CAL9MRr=U+CCzjP-cSOkPJpvw=AQuHX23grj1atfkT9uxLzEM4w@mail.gmail.com>
	<4F7F4A0F.2050300@lwfinger.net>
Date: Mon, 9 Apr 2012 11:40:56 +0300
Message-ID: <CAL9MRrkeh629QuOTg7fuqPFSsnNiRNW-kTB=gPiqoMipOQfq6Q@mail.gmail.com> (sfid-20120409_104101_117509_77A97F8B)
Subject: Re: Problem with the rtl8192cu - kernelmodule after ifdown, ifup
From: Nicu Pavel <npavel@mini-box.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
	Joshua Roys <Joshua.Roys@gtri.gatech.edu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Fri, Apr 6, 2012 at 10:54 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 04/06/2012 03:48 AM, Nicu Pavel wrote:
>>
>> ---->  ifdown/ifup no scanning results.
>>
>> <6>rtl8192cu: MAC auto ON okay!
>> <6>rtl8192cu: Tx queue select: 0x05
>> <7>rtl8192c_common:rtl92c_phy_set_bw_mode():<0-0>  FALSE driver sleep or
>> unload
>> <6>rtl8192c_common: Loading firmware file rtlwifi/rtl8192cufw.bin
>> <7>rtl8192cu:rtl92cu_set_hw_reg():<0-0>  ### Set RCR(0xf0002ace) ###
>> <7>rtlwifi:rtl_op_conf_tx():<0-0>  queue number -954253944 is incorrect!
>> <7>rtlwifi:rtl_op_conf_tx():<0-0>  queue number -954253944 is incorrect!
>> <7>rtlwifi:rtl_op_conf_tx():<0-0>  queue number -954253944 is incorrect!
>> <7>rtlwifi:rtl_op_conf_tx():<0-0>  queue number -954253944 is incorrect!
>> <7>rtl8192cu:rtl92cu_set_hw_reg():<0-0>  ### Set RCR(0xf0002a0e) ###
>>
>> ---->  ifdown/ifup no scanning results.
>
>
> Please try the attached patch. After looking at the backtraces for the calls
> that set the BSSID filters, I could see no reason for the driver to fail,
> yet it did. Once I kept those bits clear you did in the beginning, then it
> works. The amount of extra overhead will be minimal as the bits were only
> set for a short time.
>
> If this patch works for you, then I will send it upstream for mainline and
> stable. The best place to keep the bits clear would be in the calling
> routine, not in rtl92cu_set_hw_reg(); however, that patch will be much more
> intrusive and would not be accepted for 3.4.

It works if I change:
rtl_write_dword(rtlpriv, REG_RCR, ((u32 *) (val))[0]);
to:
rtl_write_dword(rtlpriv, REG_RCR, mac->rx_conf);

Thanks,
Nicu
>
> Larry
>
