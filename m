Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:47493 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754692Ab3EQJVj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 May 2013 05:21:39 -0400
Received: by mail-pd0-f174.google.com with SMTP id u10so3142459pdi.5
        for <linux-wireless@vger.kernel.org>; Fri, 17 May 2013 02:21:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5195F5BB.6030306@uni-dortmund.de>
References: <CAFTPBc+jVwNnAirFCR9ZvHKCjy_AO1ce=ZpnLs3tPZUNGe75aQ@mail.gmail.com>
	<5195F5BB.6030306@uni-dortmund.de>
Date: Fri, 17 May 2013 11:21:39 +0200
Message-ID: <CAFTPBcLZXs9oYJEs36T5wwJMQUPTr+7wnG8UZkMzo4tMyJFwnQ@mail.gmail.com> (sfid-20130517_112144_258631_EFA1F00C)
Subject: Re: AR9227: Can't set master mode
From: Felix Blanke <felixblanke@gmail.com>
To: Thomas Klute <thomas2.klute@uni-dortmund.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I knew about hostapd, but I wanted to test the master mode first. You
can still find a lot of tutorials that uses this command to set it to
master mode :( So those are all outdated?

I'll try messing around with hostapd. Thanks for your reply!

On Fri, May 17, 2013 at 11:17 AM, Thomas Klute
<thomas2.klute@uni-dortmund.de> wrote:
> Am 17.05.2013 10:54, schrieb Felix Blanke:
>> Hi,
>>
>> first: Please CC me as I'm not subscribed to the list.
>>
>> I have the following wireless card: 04:02.0 Network controller:
>> Atheros Communications Inc. AR9227 Wireless Network Adapter (rev 01)
>>
>> I can't set it to master mode, but this card should support it:
>>
>> server ~ # iwconfig wlp4s2
>> wlp4s2    IEEE 802.11bgn  ESSID:off/any
>>           Mode:Managed  Access Point: Not-Associated   Tx-Power=19 dBm
>>           Retry  long limit:7   RTS thr:off   Fragment thr:off
>>           Encryption key:off
>>           Power Management:off
>>
>> server ~ # iwconfig wlp4s2 mode Master
>> Error for wireless request "Set Mode" (8B06) :
>>     SET failed on device wlp4s2 ; Invalid argument.
>
> You cannot set any card to master mode this way, you have to use hostapd
> to set up the access point interface. The documentation at
> http://wireless.kernel.org/en/users/Documentation/hostapd should help. :-)
>
> I'd also recommend using iw instead of iwconfig, see
> http://wireless.kernel.org/en/users/Documentation/iw
>
>> My kernel config should be correct:
>>
>> server linux # cat .config | grep ATH9K
>> CONFIG_ATH9K_HW=y
>> CONFIG_ATH9K_COMMON=y
>> # CONFIG_ATH9K_BTCOEX_SUPPORT is not set
>> CONFIG_ATH9K=y
>> CONFIG_ATH9K_PCI=y
>> # CONFIG_ATH9K_AHB is not set
>> # CONFIG_ATH9K_DEBUGFS is not set
>> CONFIG_ATH9K_RATE_CONTROL=y
>> # CONFIG_ATH9K_HTC is not set
>>
>> server linux # cat .config | grep MAC80211
>> CONFIG_MAC80211=y
>> CONFIG_MAC80211_HAS_RC=y
>> CONFIG_MAC80211_RC_MINSTREL=y
>> CONFIG_MAC80211_RC_MINSTREL_HT=y
>> CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
>> CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
>> # CONFIG_MAC80211_MESH is not set
>> CONFIG_MAC80211_LEDS=y
>> # CONFIG_MAC80211_DEBUGFS is not set
>> # CONFIG_MAC80211_MESSAGE_TRACING is not set
>> # CONFIG_MAC80211_DEBUG_MENU is not set
>> # CONFIG_MAC80211_HWSIM is not set
>>
>>
>> I can scan for wireless networks and probably also connect to them
>> (never tested because this is not an use case for me).
>>
>> Any ideas? Thanks in advance!
>>
>> Kind regards,
>> Felix
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
