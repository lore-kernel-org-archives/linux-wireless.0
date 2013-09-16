Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:47219 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388Ab3IPT3n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Sep 2013 15:29:43 -0400
Received: by mail-lb0-f179.google.com with SMTP id x18so4510729lbi.24
        for <linux-wireless@vger.kernel.org>; Mon, 16 Sep 2013 12:29:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <523724AF.8040506@lwfinger.net>
References: <985A2B0C3F73B74792F35D4098E1CA7CB143670E93@MAILSJ3.global.cadence.com>
	<52346DE2.9090904@lwfinger.net>
	<20130916143506.GC18593@thinkpad-t410>
	<523724AF.8040506@lwfinger.net>
Date: Mon, 16 Sep 2013 22:29:42 +0300
Message-ID: <CANUX_P3iBywud0SxXtnwUWby0DNm-UoB-CP=X+tdsS7MbmVg=Q@mail.gmail.com> (sfid-20130916_212948_526810_2839EE33)
Subject: Re: guidance on struct alignment for rtl8192cu driver
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Seth Forshee <seth.forshee@canonical.com>,
	Jason Andrews <jasona@cadence.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>>> Index: wireless-testing-save/drivers/net/wireless/rtlwifi/wifi.h
>>> ===================================================================
>>> --- wireless-testing-save.orig/drivers/net/wireless/rtlwifi/wifi.h
>>> +++ wireless-testing-save/drivers/net/wireless/rtlwifi/wifi.h
>>> @@ -2057,7 +2057,7 @@ struct rtl_priv {
>>>           that it points to the data allocated
>>>           beyond  this structure like:
>>>           rtl_pci_priv or rtl_usb_priv */
>>> -       u8 priv[0];
>>> +       u8 __aligned(4) priv[0];
>>>   };
>>
>>
>> __attribute__((aligned)) might be a safer bet, as this will align it to
>> the largest alignment that could possibly be needed.

Or copy the code from mac80211.h:

u8 drv_priv[0] __aligned(sizeof(void *));

I did the same in iwlwifi.
Note the new way to add the __aligned thing. Joe will tell you that is
better than __attribute__ blablabla
