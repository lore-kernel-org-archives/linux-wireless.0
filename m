Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:40327 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932391Ab3CMPLi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Mar 2013 11:11:38 -0400
Received: by mail-we0-f175.google.com with SMTP id x8so1106738wey.20
        for <linux-wireless@vger.kernel.org>; Wed, 13 Mar 2013 08:11:37 -0700 (PDT)
From: "Alessandro Lannocca" <alessandro.lannocca@gmail.com>
To: "'Jussi Kivilinna'" <jussi.kivilinna@iki.fi>,
	"'Larry Finger'" <Larry.Finger@lwfinger.net>
Cc: <linux-wireless@vger.kernel.org>,
	"'George0505'" <george0505@realtek.com>
Subject: Re: rtl8192cu gets confused when scan is aborted by bringing interface down (Re: rtl8192cu goes silent/dead after some time...)
Date: Wed, 13 Mar 2013 16:11:36 +0100
Message-ID: <000001ce1ffd$0ecd5e10$2c681a30$@gmail.com> (sfid-20130313_161141_264045_130AB650)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, some months ago I reported some bugs about this chipset; now I tried latest stable compat-drivers (3.9-rc2-2-su) with the modified patch by Jussi Kivilinna, and I'm happy to report that it works  with my alfa AWUS036NHR on ubuntu 12.10 with kernel 3.5; The card now sustains multiple connection/disconnection cicles, and doesn't go mute, even after changing mac address.

Some problems still remains: 

-led is always solid, no blinking whatsoever.
-in monitor mode, every client appears as not associated, even when it really is.
-power/signal strength readings (in networkmanager) seem to be fuzzy, almost inverse; nearest APs have lowest signal representation, while farest ones get strongest signal (this could very well be a networkmanager bug/misrepresentation); signal appears normal when the card is connected (only the reading relative to the connected AP)

I know you're probably understaffed and have a lot of work to do, however if you're willing to have a look at this secondary problems (Mr. Finger perhaps), I'm willing to recompile, test and report back to help squash these bugs.

I'm attaching a debug=5 log to show my tests.

As of now, this chipset/card is usable (signal reading is annoying btw)

Thank you all for your work.

Alessandro Lannocca

-----Messaggio originale-----
Da: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-owner@vger.kernel.org] Per conto di Jussi Kivilinna
Inviato: martedì 12 marzo 2013 20.49
A: Larry Finger
Cc: linux-wireless@vger.kernel.org; 'George0505'
Oggetto: Re: rtl8192cu gets confused when scan is aborted by bringing interface down (Re: rtl8192cu goes silent/dead after some time...)

On 12.03.2013 18:51, Larry Finger wrote:
> On 03/12/2013 04:10 AM, Jussi Kivilinna wrote:
>>
>> That patch alone did not help.. however replacing
>> _rtl92cu_set_check_bssid()
>> with that new rtl92cu_set_check_bssid() does fix the issue (patch 
>> attached).
>>
>> But I think _rtl92cu_set_check_bssid() needs to be rechecked since it 
>> has '(IS_NORMAL_CHIP(rtlhal->version))' conditional etc.
> 
> I doubt that that IS_NORMAL_CHIP business affects us - the test chips 
> are not supposed to be in the wild, but I modified your patch to 
> include that test.
> 

Modified patch works here.

> With that patch I am getting watchdog_wq callbacks that force a 
> reconnection every 6 seconds, but that is due to other changes in my 
> code. The result is a 34% loss of pings, but the connection stays up.
> 

No problems here.. <1% loss and can do large transfers, rtl8192cu being able to reconnect is connection is dropped.

-Jussi
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html

