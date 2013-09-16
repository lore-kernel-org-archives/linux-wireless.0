Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:41820 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab3IPTkW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Sep 2013 15:40:22 -0400
Received: by mail-ob0-f172.google.com with SMTP id gq1so4394369obb.3
        for <linux-wireless@vger.kernel.org>; Mon, 16 Sep 2013 12:40:22 -0700 (PDT)
Message-ID: <52375EA3.4090408@lwfinger.net> (sfid-20130916_214046_131523_40526E0D)
Date: Mon, 16 Sep 2013 14:40:19 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Emmanuel Grumbach <egrumbach@gmail.com>
CC: Seth Forshee <seth.forshee@canonical.com>,
	Jason Andrews <jasona@cadence.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: guidance on struct alignment for rtl8192cu driver
References: <985A2B0C3F73B74792F35D4098E1CA7CB143670E93@MAILSJ3.global.cadence.com> <52346DE2.9090904@lwfinger.net> <20130916143506.GC18593@thinkpad-t410> <523724AF.8040506@lwfinger.net> <CANUX_P3iBywud0SxXtnwUWby0DNm-UoB-CP=X+tdsS7MbmVg=Q@mail.gmail.com>
In-Reply-To: <CANUX_P3iBywud0SxXtnwUWby0DNm-UoB-CP=X+tdsS7MbmVg=Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/16/2013 02:29 PM, Emmanuel Grumbach wrote:
>>>> Index: wireless-testing-save/drivers/net/wireless/rtlwifi/wifi.h
>>>> ===================================================================
>>>> --- wireless-testing-save.orig/drivers/net/wireless/rtlwifi/wifi.h
>>>> +++ wireless-testing-save/drivers/net/wireless/rtlwifi/wifi.h
>>>> @@ -2057,7 +2057,7 @@ struct rtl_priv {
>>>>            that it points to the data allocated
>>>>            beyond  this structure like:
>>>>            rtl_pci_priv or rtl_usb_priv */
>>>> -       u8 priv[0];
>>>> +       u8 __aligned(4) priv[0];
>>>>    };
>>>
>>>
>>> __attribute__((aligned)) might be a safer bet, as this will align it to
>>> the largest alignment that could possibly be needed.
>
> Or copy the code from mac80211.h:
>
> u8 drv_priv[0] __aligned(sizeof(void *));
>
> I did the same in iwlwifi.
> Note the new way to add the __aligned thing. Joe will tell you that is
> better than __attribute__ blablabla

Thanks. I had noticed that checkpatch.pl complains about the __attribute 
construction.

Larry


