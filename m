Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pool-71-115-156-71.gdrpmi.dsl-w.verizon.net ([71.115.156.71]:53763
	"EHLO s0be.servebeer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079AbZBZAK0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2009 19:10:26 -0500
Message-ID: <49A5DDED.1080408@erley.org> (sfid-20090226_011032_103628_F50DCEF8)
Date: Wed, 25 Feb 2009 19:10:21 -0500
From: pat-lkml <pat-lkml@erley.org>
MIME-Version: 1.0
To: Jouni Malinen <j@w1.fi>
CC: Jouni Malinen <jouni.malinen@atheros.com>,
	linux-wireless@vger.kernel.org
Subject: Re: ath9k and TKIP hw crypto in AP mode
References: <20090224114201.GB21933@jm.kir.nu> <49A40320.1040902@erley.org> <20090224150710.GA1419@jm.kir.nu> <49A41315.3030007@erley.org> <49A45378.50009@erley.org> <20090225181953.GA23880@jm.kir.nu> <49A5D83A.1090602@erley.org>
In-Reply-To: <49A5D83A.1090602@erley.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

pat-lkml wrote:
> Jouni Malinen wrote:
>> On Tue, Feb 24, 2009 at 03:07:20PM -0500, pat-lkml wrote:
>>> pass phrase.  Use nohwcrypt=1, hostapd now works perfectly with wep/wpa/wpa2, while
>>> with nohwcrypt=0, I get errors (that I'll need physical access to my computer to 
>>> debug/log) in wpa only.
>> Thanks, I was able to reproduce this and figure out what was happening.
>> It looks like I have not tested TKIP in AP mode before (I've been mainly
>> testing HT and that does not allow TKIP..). Anyway, the Michael MIC
>> TX/RX keys are set incorrectly for the group key which will trigger
>> Michael MIC errors on every broadcast frame.
>>
>> I have more complete cleanup of the key configuration for ath9k in
>> progress, but as far as this particular issue is concerned, the
>> following change should resolve it. So far, I've only tested this with
>> the current hardware revision, but I will test this with older design,
>> too, and submit a proper patch later. Anyway, you may want to test this
>> as a fix for TKIP in AP mode.
>>
>>
> I had to make some changes to get it to build, am going to test shortly.
> 
> The relevant changes were adding:
> 
> struct ieee80211_vif *vif;
> vif = sc->vifs[0];
> 
> to the 'else' condition, like the if(key->keyidx) condition.
That should have read 'below' the else condition.

And it appears to be working.  I have it set to 10 minute rekeying, so I'll
have more success/failure for you then (and am waiting to send this e-mail
until then).

Well, it rekey'd with no interruption in service.  I'd call it a success.

Thanks!

Pat Erley
