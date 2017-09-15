Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:33610 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750837AbdIOGBD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Sep 2017 02:01:03 -0400
Received: by mail-io0-f195.google.com with SMTP id j26so2668463iod.0
        for <linux-wireless@vger.kernel.org>; Thu, 14 Sep 2017 23:01:03 -0700 (PDT)
Subject: Re: rtlwifi/rtl8188ee baseband config explanation request
To: Farhan Khan <khanzf@gmail.com>, linux-wireless@vger.kernel.org
References: <f37044ee-d0fb-1a3a-d98b-3233434f68ea@gmail.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <991a4c76-aff0-499f-11d6-59a4629b9d82@lwfinger.net> (sfid-20170915_080106_872685_27973A5C)
Date: Fri, 15 Sep 2017 01:01:01 -0500
MIME-Version: 1.0
In-Reply-To: <f37044ee-d0fb-1a3a-d98b-3233434f68ea@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/15/2017 12:08 AM, Farhan Khan wrote:
> Hi all,
> 
> I am trying to get a high-level understanding of what occurs in
> rtl88e_phy_bb_config() in
> drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c. I understand the
> code up until it runs _rtl88e_phy_bb8188e_config_parafile() .
> 
>>From there, I see that phy_config_bb_with_headerfile() will write the
> values in RTL8188EEPHY_REG_1TARRAY, runs phy_config_bb_with_pghdr(),
> then write the values in RTL8188EEAGCTAB_1TARRAY.
> 
> Please provide a high-level explanation of
> phy_config_bb_with_headerfile(), and more particularly, of
> phy_config_bb_pghdr(). What are their objectives? Also, is there a
> reason for this specific order or can it be in any otherwise?

Why do you want to know this information? Are you trying to reverse-engineer the 
Realtek wifi devices. Note that I do not know much about the internals of any of 
the Realtek devices, but I can read the code. The data in 
RTL8188EEPHY_REG_1TARRAY consists of two parts per entry. The first is an 
address, and the second is the data to be loaded into that address. These data 
are used by the firmware to calibrate radios, etc., and have been determined by 
the Realtek engineers. There is a similar interpretation for 
RTL8188EEAGCTAB_1TARRAY. I do not know for sure, but as the data values here are 
ALL written to the same address, I fully expect that these must be written AFTER 
the PHY_REG information. Something needs to be controlling where the data are 
being stored.

The "high-level" interpretation of this code is this is what must be done for 
the device to work. If you want more information, you will need to investigate 
getting an NDA with Realtek. I do not have one, and I do not want such an agreement.

Larry
