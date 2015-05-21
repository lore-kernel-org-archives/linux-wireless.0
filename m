Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:32996 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422758AbbEUVzD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2015 17:55:03 -0400
Received: by obbnx5 with SMTP id nx5so626668obb.0
        for <linux-wireless@vger.kernel.org>; Thu, 21 May 2015 14:55:02 -0700 (PDT)
Message-ID: <555E5433.7000904@lwfinger.net> (sfid-20150521_235509_688673_95CCC940)
Date: Thu, 21 May 2015 16:54:59 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?windows-1252?Q?Michael_B=FCsch?= <m@bues.ch>,
	Chaoming Li <chaoming_li@realsil.com.cn>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: Fix EFUSE_ANA8M map value
References: <20150521214421.15983b0a@milhouse>
In-Reply-To: <20150521214421.15983b0a@milhouse>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/21/2015 02:44 PM, Michael Büsch wrote:
> The map entry EFUSE_ANA8M is supposed to be a bit mask of the SYS_CLK register (see efuse.c)
> It doesn't make sense to assign the enumeration value EFUSE_ANA8M. Assign the bitmask ANA8M instead.
> rtl8192se does not have ANA8M, so use 0 as bitmask.
>
> Signed-off-by: Michael Buesch <m@bues.ch>
>
> ---
>
> This is RFC, because I don't really know the device.
> The rtl8192se part of the patch is just a guess, because this driver's reg.h doesn't have an ANA8M define.

I think the patch is correct. Certainly loading an array entry with the offset 
of the array makes little sense. This change makes the older drivers 
(rtl8192c{e,u} and rtl8192se match the newer ones.

Once I test the patch, I will send it on to Kalle with my S-o-b.

Thanks,

Larry


