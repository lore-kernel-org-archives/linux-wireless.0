Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:60768 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbaIJOW7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2014 10:22:59 -0400
Message-ID: <54105EBF.1020506@broadcom.com> (sfid-20140910_162306_758050_EB3831C9)
Date: Wed, 10 Sep 2014 16:22:55 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: "Peer, Ilan" <ilan.peer@intel.com>
CC: Jouni Malinen <j@w1.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	brcm80211 development <brcm80211-dev-list@broadcom.com>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>
Subject: Re: P2P_DEVICE support in Android KitKat
References: <540FFDFD.2070302@broadcom.com> <20140910111040.GA5269@w1.fi> <CB3B3D4774441E42AA3EA0E1BA8230A03487FB54@HASMSX106.ger.corp.intel.com>
In-Reply-To: <CB3B3D4774441E42AA3EA0E1BA8230A03487FB54@HASMSX106.ger.corp.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/10/14 16:00, Peer, Ilan wrote:
> Hi Arend,
>
> We've encountered this issue in the past, and resolved it by passing the wpa_supplicant a P2P specific configuration file using the -m option. Try using -m but do not populate it with any network blocks that are not P2P groups.
>
> Hope this helps,

Thanks, Ilan

Got the hint from brcm colleague as well.

Regards,
Arend

> Ilan.
>
>> -----Original Message-----
>> From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-
>> owner@vger.kernel.org] On Behalf Of Jouni Malinen
>> Sent: Wednesday, September 10, 2014 14:11
>> To: Arend van Spriel
>> Cc: linux-wireless@vger.kernel.org; brcm80211 development;
>> hostap@lists.shmoo.com
>> Subject: Re: P2P_DEVICE support in Android KitKat
>>
>> On Wed, Sep 10, 2014 at 09:30:05AM +0200, Arend van Spriel wrote:
>>> I am running some tests on a haswell target with Android KitKat
>>> (3.10.20 kernel). In this configuration our brcmfmac driver is used
>>> with driver param 'p2p_device=1'. So we end up with wlan0 and
>>> p2p-dev-wlan0 interfaces (can blame myself for that). The
>>> configuration has a network configured, but I did not expect
>>> wpa_supplicant to start association using the p2p device interface.
>>> The wlan0 interface is already connected to the AP. How can I fix this
>>> to assure p2p-dev-wlan0 is only used for p2p management scenarios.
>>
>> Hmm.. Can you please show the wpa_supplicant command line that is used
>> here and describe how that network block gets configured for the
>> p2p-dev-wlan0 "interface"? I would have expected that there would never
>> be a configuration with an enabled network block being passed for the P2P
>> management interface.. Internally, wpa_supplicant should not add such for
>> P2P groups, but I don't think there is any filtering on configuration if
>> something is externally trying to make wpa_supplicant use that management
>> interface for a station mode connection.
>>
>> --
>> Jouni Malinen                                            PGP id EFC895FA
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in the
>> body of a message to majordomo@vger.kernel.org More majordomo info at
>> http://vger.kernel.org/majordomo-info.html

