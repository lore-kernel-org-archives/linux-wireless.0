Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:42771 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756759Ab3CSWPJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Mar 2013 18:15:09 -0400
Received: by mail-wi0-f173.google.com with SMTP id hq4so4570743wib.6
        for <linux-wireless@vger.kernel.org>; Tue, 19 Mar 2013 15:15:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHwWuAE0MxN9_Bf1aTmpsefMAED-9HVsV7VtxorDvF3hSHZ2Ng@mail.gmail.com>
References: <CAHwWuAE0MxN9_Bf1aTmpsefMAED-9HVsV7VtxorDvF3hSHZ2Ng@mail.gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 20 Mar 2013 09:14:47 +1100
Message-ID: <CAGRGNgWb_y5LXTHzex1SZyoGOK0DEDAwKjbvU-6=kKBo6bC5aA@mail.gmail.com> (sfid-20130319_231513_992549_C3608A53)
Subject: Re: Intel Centrino Advanced-N 6205 master mode support
To: =?ISO-8859-1?B?ROluZXMgTultZXRo?= <mr.nemeth.denes@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dénes,

On Wed, Mar 20, 2013 at 7:54 AM, Dénes Németh <mr.nemeth.denes@gmail.com> wrote:
> Hi
>
> Could you help me the determine if the Intel Centrino Advanced-N 6205
> is supported in AP / master mode?
>
> Your website http://wireless.kernel.org/en/users/Drivers/iwlwifi states
> that the "AP mode (experimental; only on some devices/firmware versions)"
>
> Is the wifi card above supported?
>
> Here is my debug info, at the bottom with the failure of changing to master mode
> dmesg:
>     loaded firmware version 18.168.6.1
>     cfg80211: Regulatory domain changed to country: EU
>
> iw list wlan0
>     Supported interface modes:
>          * IBSS
>          * managed
>          * AP
>          * AP/VLAN
>          * monitor
>     software interface modes (can always be added):
>          * AP/VLAN
>          * monitor
>
> iwconfig wlan0 mode master
> Error for wireless request "Set Mode" (8B06) :
>     SET failed on device wlan0 ; Invalid argument

You're doing it wrong, you _must_ use hostapd to configure master (AP)
mode, the kernel cannot do it itself.

Read this page:

http://wireless.kernel.org/en/users/Documentation/hostapd

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
