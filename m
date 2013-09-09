Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37247 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755469Ab3IIWKs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Sep 2013 18:10:48 -0400
Message-ID: <1378764913.31180.9.camel@dcbw.foobar.com> (sfid-20130910_001051_120751_64C1CFBF)
Subject: Re: No connection with TP-Link TL-WN823N (rtl8192cu)
From: Dan Williams <dcbw@redhat.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Vincent Thiele <vincentthiele@gmail.com>,
	linux-wireless@vger.kernel.org
Date: Mon, 09 Sep 2013 17:15:13 -0500
In-Reply-To: <522E4315.4040806@lwfinger.net>
References: <CAEZsi7Hde5NyTRgm7Lf_4LvHMAEJouzaqMNUwxr-iSipuEcsyQ@mail.gmail.com>
	 <522E4315.4040806@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-09-09 at 16:52 -0500, Larry Finger wrote:
> On 09/09/2013 03:40 PM, Vincent Thiele wrote:
> > I use TL-WN823N usb-stick with ubuntu but native drivers disconnect
> > few seconds after boot. For wlan i need to install this package:
> > https://code.google.com/p/realtek-8188cus-wireless-drivers-3444749-ubuntu-1304/.
> > But this package can not be used with a kernel > 3.9. Please fix the
> > native drivers. Best regards
> 
> I am sorry that you are having problems with your system, but your log was 
> essentially useless. I saw one disconnect due to reason 4 (disassociation due to 
> inactivity).
> 
> There were many changes in the rtl8192cu driver for kernel 3.11, and you need to 
> run it, or a backports version of the wireless code. Your 3.8.0 kernel is too old.
> 
> I have been running rtl8192cu for the past 24 hours without a permanent 
> disconnect. Under NetworkManager, I see some reason 7 deauthentications, but 

Running wpa_supplicant with debugging on might shed some light on these;
basically:

mv /usr/sbin/wpa_supplicant /
killall -TERM wpa_supplicant
/wpa_supplicant -dddtu <piped to your favorite log file>

and NM should automatically reconnect, and then we can figure out what's
going on in the supplicant.

Dan

> running under ifup, there have been no disassociations or deauthentications in 
> over 6 hours.
> 
> I am using openSUSE KDE. There may be a problem with the Ubuntu user code as it 
> seems to operate differently.
> 
> Larry
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


