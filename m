Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pool-71-115-156-71.gdrpmi.dsl-w.verizon.net ([71.115.156.71]:43485
	"EHLO s0be.servebeer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754532AbZBXWpR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2009 17:45:17 -0500
Message-ID: <49A47878.3030202@erley.org> (sfid-20090224_234521_771856_B2D576BC)
Date: Tue, 24 Feb 2009 17:45:12 -0500
From: pat-lkml <pat-lkml@erley.org>
MIME-Version: 1.0
To: Jouni Malinen <j@w1.fi>
CC: Jouni Malinen <jouni.malinen@atheros.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k: Add module parameter to disable hardware crypto
References: <20090224114201.GB21933@jm.kir.nu> <49A40320.1040902@erley.org> <20090224150710.GA1419@jm.kir.nu> <49A41315.3030007@erley.org> <49A45378.50009@erley.org>
In-Reply-To: <49A45378.50009@erley.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

pat-lkml wrote:
> pat-lkml wrote:
>> pat-lkml wrote:
>>> Jouni Malinen wrote:
>>> Which client are you using? Are you sure that the passphrase/PSK is set
>>> correctly? The nohwcrypt patch should make absolutely no difference for
>>> this part (this is key handshake which in the initial phase is sent
>>> without encrypted EAPOL-Key frames, so neither sw nor hw crypto used).
>> I've tried 3 different clients with identical behavior:
>>
>> 1.  Playstation 3
>> 2.  Dell Axim / WM6
>> 3.  ath5k Laptop
>>
>> I get that (afore mentioned invalid MIC in msg 2/4) with nohwcrypt=1, while
>> nohwcrypt=0 I get 'STA Detected Michael MIC error' during stage 3 I believe. 
>>
>> I'll have more time after about 6:00PM EST to test this and provide the full
>> logs of each client associating, along with  wpa_supplicant logs.  I'm running
>> git hostapd, and I've NEVER had wpa1 work correctly with it, which is why I said
>> that that report wasn't an 'ACK/NACK' just reporting that I see a difference in 
>> behavior with it.  
>>
>> Pat
> 
> Ok, I feel VERY sheepish now.  In doing further testing, I discovered a typo in my
> hostapd.conf for the wpa config, specifically, an extra char that snuck into my wpa
> pass phrase.  Use nohwcrypt=1, hostapd now works perfectly with wep/wpa/wpa2, while
> with nohwcrypt=0, I get errors (that I'll need physical access to my computer to 
> debug/log) in wpa only.  I'm testing with my usual, rate limited scp transfer over 
> wireless right now, as previous 'issues' have arisen when a re-key occurs during a 
> transfer.

Here are 2 sets of logs: [linked as they're ~60K total]

http://wireless.erley.org/ath9k-nohwcrypto0.txt
http://wireless.erley.org/ath9k-nohwcrypto1.txt

As can be deduced from the file names, the first one is with nohwcrypto=0
while the second is with nohwcrypto=1.

I set this module param with the modprobe.conf line: options ath9k nohwcrypt=1

I made NO changes in hostapd between these two log runs, only removing and 
reloading the ath9k driver.  nohwcrypto=0 resulted in the Michael MIC error and
a non functioning client (PS3, in this example) while nohwcrypto=1 resulted in
a working PS3 client.  I was able to stream 3 hours of video (in total) today
while working on other things, with hostapd set to 30s re-keying.  Any other tests
I could do/log/provide for getting hwcrypto to work in AP mode would be great.

I've done no testing in station mode, as I don't have any interests in using ath9k
in station mode at the moment.

Pat Erley
