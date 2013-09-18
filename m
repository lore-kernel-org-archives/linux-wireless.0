Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx-sanjose.Cadence.COM ([158.140.2.60]:62137 "EHLO
	mx-sanjose.cadence.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab3IRE7l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Sep 2013 00:59:41 -0400
From: Jason Andrews <jasona@cadence.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Emmanuel Grumbach <egrumbach@gmail.com>
CC: Seth Forshee <seth.forshee@canonical.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 17 Sep 2013 21:59:19 -0700
Subject: RE: guidance on struct alignment for rtl8192cu driver
Message-ID: <985A2B0C3F73B74792F35D4098E1CA7CB14372959B@MAILSJ3.global.cadence.com> (sfid-20130918_065945_040299_1397CEEC)
References: <985A2B0C3F73B74792F35D4098E1CA7CB143670E93@MAILSJ3.global.cadence.com>
 <52346DE2.9090904@lwfinger.net> <20130916143506.GC18593@thinkpad-t410>
 <523724AF.8040506@lwfinger.net>
 <CANUX_P3iBywud0SxXtnwUWby0DNm-UoB-CP=X+tdsS7MbmVg=Q@mail.gmail.com>
 <52375EA3.4090408@lwfinger.net>
In-Reply-To: <52375EA3.4090408@lwfinger.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> -----Original Message-----
> From: Larry Finger [mailto:larry.finger@gmail.com] On Behalf Of Larry
> Finger
> Sent: Monday, September 16, 2013 9:40 PM
> To: Emmanuel Grumbach
> Cc: Seth Forshee; Jason Andrews; linux-wireless@vger.kernel.org
> Subject: Re: guidance on struct alignment for rtl8192cu driver
> 
> On 09/16/2013 02:29 PM, Emmanuel Grumbach wrote:
> >>>> Index: wireless-testing-save/drivers/net/wireless/rtlwifi/wifi.h
> >>>>
> ===================================================================
> >>>> --- wireless-testing-save.orig/drivers/net/wireless/rtlwifi/wifi.h
> >>>> +++ wireless-testing-save/drivers/net/wireless/rtlwifi/wifi.h
> >>>> @@ -2057,7 +2057,7 @@ struct rtl_priv {
> >>>>            that it points to the data allocated
> >>>>            beyond  this structure like:
> >>>>            rtl_pci_priv or rtl_usb_priv */
> >>>> -       u8 priv[0];
> >>>> +       u8 __aligned(4) priv[0];
> >>>>    };
> >>>
> >>>
> >>> __attribute__((aligned)) might be a safer bet, as this will align
> it to
> >>> the largest alignment that could possibly be needed.
> >
> > Or copy the code from mac80211.h:
> >
> > u8 drv_priv[0] __aligned(sizeof(void *));
> >
> > I did the same in iwlwifi.
> > Note the new way to add the __aligned thing. Joe will tell you that
> is
> > better than __attribute__ blablabla
> 
> Thanks. I had noticed that checkpatch.pl complains about the
> __attribute
> construction.
> 
> Larry
> 

Larry,

I confirmed that my original alignment error is properly solved by:

    u8 drv_priv[0] __aligned(sizeof(void *));

The driver is now working for my ARM system.

Regards,
Jason

