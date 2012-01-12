Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from violet.fr.zoreil.com ([92.243.8.30]:40592 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173Ab2ALJNR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jan 2012 04:13:17 -0500
Date: Thu, 12 Jan 2012 09:19:36 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Joe Perches <joe@perches.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/5] rtlwifi: Move RX/TX macros into common file
Message-ID: <20120112081935.GA10347@electric-eye.fr.zoreil.com> (sfid-20120112_101326_201355_08AE4132)
References: <1326323232-21752-1-git-send-email-Larry.Finger@lwfinger.net> <1326323232-21752-2-git-send-email-Larry.Finger@lwfinger.net> <1326328047.7886.21.camel@joe2Laptop> <4F0E332D.1060409@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4F0E332D.1060409@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> :
> On 01/11/2012 06:27 PM, Joe Perches wrote:
[...]
> >static inline u32 le32p_to_cpu_shift_and_mask(__le32 *desc, int shift, u32 mask)
> >{
> >	return (le32_to_cpu(*desc)>>  shift)&  BIT_LEN_MASK_32(mask);
> >}
> 
> I need to think about this one some more.

Joe only told a part of the story here : this change should eventually go
along a definition of the descriptors as a __leXY struct and a specific
registers / bits definition. It will be a bit tedious.

[...]
> >I don't see how centralizing these non-shared
> >macro names helps.
> >
> >Maybe if the code is actually common, have a
> >separate #include for each card with common
> >named #defines as appropriate.
> 
> The idea of centralizing the non-shared names was to have all these
> macros in one place. If any need to be changes, that one file will
> have all of them.

It is paid at the price of the giant #include file and some irrelevant
code pollution in chipset-dedicated parts of the driver. As the main
driver maintainer, you may not win much -if anything- in return.

Joe's suggestion can help with factoring out the code while exhibiting
the differences in the data layout (i.e hardware registers). It is not
automatic though.

-- 
Ueimor
