Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:42421 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753389Ab1KXTNe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Nov 2011 14:13:34 -0500
Message-ID: <4ECE9759.5040605@hauke-m.de> (sfid-20111124_201337_768644_946D9601)
Date: Thu, 24 Nov 2011 20:13:29 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: sedat.dilek@gmail.com
CC: Sedat Dilek <sedat.dilek@googlemail.com>, mcgrof@gmail.com,
	mcgrof@qca.qualcomm.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] compat-wireless: adapt moving brcm80211 to main area
References: <1318515394-9284-1-git-send-email-hauke@hauke-m.de> <CA+icZUV_0nBu5o2xFSeDS-3T0O7AqbwqK1+iFq7DAD4T9HEjZA@mail.gmail.com>
In-Reply-To: <CA+icZUV_0nBu5o2xFSeDS-3T0O7AqbwqK1+iFq7DAD4T9HEjZA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/23/2011 11:42 PM, Sedat Dilek wrote:
> On Thu, Oct 13, 2011 at 4:16 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
>> brcm80211 is no staging driver any more and can be found in the main
>> area where all the other wireless drivers are now. There where some
>> changes needed for the move.
>> And BRCMFMAC does not depend on WEXT any more so remove that from
>> config.
>> BRCMFMAC does not build with kernel < 2.6.29, because
>> ndev->netdev_ops = NULL and ndev->netdev_ops == &brcmf_netdev_ops_pri
>> are not supported by the backport code for netdev_ops.
>>
>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
>> ---
> [...]
>> --- a/scripts/driver-select
>> +++ b/scripts/driver-select
> [...]
>> -       brcm80211)
>> +       brcmsmac)
>> +               disable_staging
>> +               disable_bt_usb_ethernet_var
>> +               select_drivers          CONFIG_BRCMUTIL CONFIG_BRCMFMAC
>> +               select_brcm80211_driver CONFIG_BRCMSMAC
>> +               ;;
> 
> On IRC someone reported problems building brcmsmac.ko, while trying to
> help I fell over this:
> Shouldn't that be CONFIG_BRCM*S*MAC in select_drivers line?
> ( Just FYI: The guy tried building linux-2.6.39 with
> compat-wireless-3.2-rc1-1.tar.bz2 )
Yes just CONFIG_BRCM*S*MAC should be selected there, but it does not
cause any problems if the wrong Broadcom driver is selected there,
because select_drivers just changes something in
drivers/net/wireless/Makefile and not
drivers/net/wireless/brcm80211/Makefile. The select_drivers line just
makes the compiler also use drivers/net/wireless/brcm80211/Makefile.
select_brcm80211_driver selects the actual Broadcom driver to build.
> 
> - Sedat -
> 
>> +       brcmfmac)
>> +               disable_staging
>>                disable_bt_usb_ethernet_var
>> -               select_driver           CONFIG_NOTHING
>> +               select_drivers          CONFIG_BRCMUTIL CONFIG_BRCMFMAC
>> +               select_brcm80211_driver CONFIG_BRCMFMAC
>>                ;;
>>        zd1211rw)
>>                select_driver           CONFIG_COMPAT_ZD1211RW
