Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.234]:15792 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933458AbZHEDms (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2009 23:42:48 -0400
Received: by rv-out-0506.google.com with SMTP id f6so1365625rvb.1
        for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2009 20:42:49 -0700 (PDT)
Message-ID: <4A78FFB8.7020605@lwfinger.net>
Date: Tue, 04 Aug 2009 22:42:48 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Carl Purvis <carl.purvis@security-assessment.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: rtl818x driver (linux-2.6.30.4)
References: <4F889FF7-D1AF-4F0D-B478-BD8672DE476F@security-assessment.com>
In-Reply-To: <4F889FF7-D1AF-4F0D-B478-BD8672DE476F@security-assessment.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Carl Purvis wrote:
> 
> Not sure of the proper process for this but I found your email in the
> driver source.
> It looks like the rtl8187 driver no longer allows TX Power to be set
> above 100mw (20dBm), Previous incarnations of the driver would allow
> txpower to be set to 27dbm (501mw). 
> I have an alfa USB wifi card. 
> 
> safe:/usr/src/linux-2.6.30.4/drivers/net/wireless/rtl818x# iwconfig
> wlan0 txpower 27
> Error for wireless request "Set Tx Power" (8B26) :
>     SET failed on device wlan0 ; Invalid argument.
> 
> safe:/usr/src/linux-2.6.30.4/drivers/net/wireless/rtl818x# iwconfig
> wlan0 txpower 20
--snip--
> 
> Sorry if this is the incorrect way to contact you/the people doing
> driver work. 

The correct way to address wireless issues through the mailing list
linux-wireless@vger.kernel.org, which I have Cc'd in my reply.

The change is not that the driver has been modified to restrict the
power, but the entire wireless system is modified to abide by
regulatory domain data.

How are you setting the regulatory info? You should be using the CRDA
system (http://linuxwireless.org/en/developers/Regulatory/CRDA) and
set the country code to your location. Based on the mention of the
"New Zealand Electronic Transactions Act 2002" in your signature, I
guess that you would need to add the line

options cfg80211 ieee80211_regdom=NZ"

to the file /etc/modprobe.conf.local. When you do that, you will see
the following in the log:

cfg80211: Regulatory domain changed to country: NZ
        (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
        (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 3000 mBm)

With that data, your device could have a maximum power of 30 dBm (3000
mBm). I didn't check if the device could handle that much power, but
if it can, the regulatory authorities would allow it.

In the US, we get the following:

cfg80211: Regulatory domain changed to country: US
        (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
        (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)

By regulation, we may use as much as 2700 mBm. From the frequency
data, you can use channels 12 and 13, which I cannot.

Based on your report, you are effectively getting the same as

(2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm).

What you see is the result of considerable work to make Linux abide by
the broadcast rules. Unfortunately, there is no reliable way to
determine the geographic location of a computer.

Larry
