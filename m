Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:38780 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751111AbdIOG0n (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Sep 2017 02:26:43 -0400
Received: by mail-qt0-f196.google.com with SMTP id f24so922798qte.5
        for <linux-wireless@vger.kernel.org>; Thu, 14 Sep 2017 23:26:43 -0700 (PDT)
Subject: Re: rtlwifi/rtl8188ee baseband config explanation request
To: Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless@vger.kernel.org
References: <f37044ee-d0fb-1a3a-d98b-3233434f68ea@gmail.com>
 <991a4c76-aff0-499f-11d6-59a4629b9d82@lwfinger.net>
From: Farhan Khan <khanzf@gmail.com>
Message-ID: <4e962e58-3e1a-2d97-b952-26a56c652bae@gmail.com> (sfid-20170915_082700_716107_92F1CC38)
Date: Fri, 15 Sep 2017 02:26:44 -0400
MIME-Version: 1.0
In-Reply-To: <991a4c76-aff0-499f-11d6-59a4629b9d82@lwfinger.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thank you for your prompt response.

I am trying to write a FreeBSD port of this driver. The structures of
the two drivers are significantly different, so it is not a trivial
exercise.

The FreeBSD driver also has a similar block of code that writes over an
array of data using an array of registers, and this should be easy to
re-create. But I do not see the equivalent of phy_config_bb_with_pghdr()
anywhere. I do not know if I need to maintain the order for any reason.

I attempted to reach out to Realtek through multiple mediums but did not
receive any replies. Ultimately, I may end up re-playing the same bits
without understanding what is happening.

On 09/15/2017 02:01 AM, Larry Finger wrote:
> On 09/15/2017 12:08 AM, Farhan Khan wrote:
>> Hi all,
>>
>> I am trying to get a high-level understanding of what occurs in
>> rtl88e_phy_bb_config() in
>> drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c. I understand the
>> code up until it runs _rtl88e_phy_bb8188e_config_parafile() .
>>
>>> From there, I see that phy_config_bb_with_headerfile() will write the
>> values in RTL8188EEPHY_REG_1TARRAY, runs phy_config_bb_with_pghdr(),
>> then write the values in RTL8188EEAGCTAB_1TARRAY.
>>
>> Please provide a high-level explanation of
>> phy_config_bb_with_headerfile(), and more particularly, of
>> phy_config_bb_pghdr(). What are their objectives? Also, is there a
>> reason for this specific order or can it be in any otherwise?
> 
> Why do you want to know this information? Are you trying to
> reverse-engineer the Realtek wifi devices. Note that I do not know much
> about the internals of any of the Realtek devices, but I can read the
> code. The data in RTL8188EEPHY_REG_1TARRAY consists of two parts per
> entry. The first is an address, and the second is the data to be loaded
> into that address. These data are used by the firmware to calibrate
> radios, etc., and have been determined by the Realtek engineers. There
> is a similar interpretation for RTL8188EEAGCTAB_1TARRAY. I do not know
> for sure, but as the data values here are ALL written to the same
> address, I fully expect that these must be written AFTER the PHY_REG
> information. Something needs to be controlling where the data are being
> stored.
> 
> The "high-level" interpretation of this code is this is what must be
> done for the device to work. If you want more information, you will need
> to investigate getting an NDA with Realtek. I do not have one, and I do
> not want such an agreement.
> 
> Larry
