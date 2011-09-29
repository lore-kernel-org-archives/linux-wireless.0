Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56988 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754141Ab1I2X7V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Sep 2011 19:59:21 -0400
Received: by wwf22 with SMTP id 22so1835043wwf.1
        for <linux-wireless@vger.kernel.org>; Thu, 29 Sep 2011 16:59:19 -0700 (PDT)
Message-ID: <4E850616.3040003@gmail.com> (sfid-20110930_015924_413730_4ED1D855)
Date: Fri, 30 Sep 2011 01:58:14 +0200
From: Stefan Zwanenburg <stefanhetzwaantje@gmail.com>
MIME-Version: 1.0
To: =?UTF-8?B?5p2O5pyd5piO?= <chaoming_li@realsil.com.cn>
CC: 'Larry Finger' <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: =?UTF-8?B?562U5aSNOiDnrZTlpI06IOetlOWkjTog562U5aSNOiBSVEw4MTk=?=
 =?UTF-8?B?MlNFIGFuZCA4MDIuMTFuIHByb2JsZW0=?=
References: <4E77AECF.7090001@gmail.com> <4E820130.7080801@gmail.com> <4E823976.2090407@lwfinger.net> <4E824D75.1070509@gmail.com> <4E82A8E9.60409@lwfinger.net> <4E83AD85.8050005@gmail.com> <4E83E5C4.3060905@lwfinger.net> <0EF5E594196F41B48B0B4D168B714838@realsil.com.cn> <4E84FBF6.2020609@gmail.com>
In-Reply-To: <4E84FBF6.2020609@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/30/2011 01:15 AM, Stefan Zwanenburg wrote:
> On 09/29/2011 10:55 AM, 李朝明 wrote:
>> Dear Larry:
>>
>> 	I don't kown why this efuse is wrong, did Zwanenburg use the same
>> driver with yours ?
> Hi!
> I may be no Larry, but I just diffed the latest version of the
> drivers/net/wireless/rtlwifi directory (obtained from the github mirror
> of linus' repository) with the one from the kernel I'm currently
> running, and I don't notice a whole lot of changes (besides code
> cleanups and differences in the debugging macro "calls"), but there is
> something going on in efuse.c with no more "hoffset" variable in
> efuse_get_current size, but that shouldn't matter, as the variable was
> assigned but never used again.
> I also see there was a whole lot of work put into pci.c, as it looks
> it's had a revamp. I'm not sure it will fix my problems, but I'm going
> to try to run 3.1-rc4 and see if I can get an 802.11n link going.
>
> I'll get back to you on how that went later!
>
> Stefan Zwanenburg
Well, I just compiled 3.0-rc4, and I'm now running it, but alas, still
no 802.11n link to my AP, and (perhaps unsurprisingly) the EEPROM that
gets dumped upon detecting the PCI NIC is exactly the same as it was
before, so there couldn't be some problem with the EFUSE reading code.
I guess that leaves us with the possibility my AP is not sending some
packets (see Larry's message about that) during the association, which
makes the driver not work as it should...
Is there anything else I can try to help you guys figure out what may be
wrong?

Stefan Zwanenburg

PS: I'll keep running this kernel for a few days to see if I get the
same problem as in mentioned in the discussion "3.1-rc6 + rtl8192se
issue", even though I apparently don't have the very latest kernel source.
