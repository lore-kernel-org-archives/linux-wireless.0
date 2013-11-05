Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:40951 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755541Ab3KEXRQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Nov 2013 18:17:16 -0500
Received: by mail-we0-f169.google.com with SMTP id q58so4250845wes.28
        for <linux-wireless@vger.kernel.org>; Tue, 05 Nov 2013 15:17:15 -0800 (PST)
Message-ID: <52797C7D.9020906@gmail.com> (sfid-20131106_001720_449018_037175FA)
Date: Tue, 05 Nov 2013 23:17:17 +0000
From: Dave Kilroy <kilroyd@googlemail.com>
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: zaphod@berentweb.com, linux-wireless@vger.kernel.org
Subject: Re: orinoco (Lucent/Agere 9.48) unable to connect
References: <CAPSTskvByfGWTyDmq9WeX7Em1N0DAAZ3eKDV5eV6qfkH2gDzdA@mail.gmail.com>  <1383581905.17589.0.camel@dcbw.foobar.com>  <CAPSTskvZALnaNYfBxCx_fFhYuTPW8AOVkyN9DTBeErfO67hQBw@mail.gmail.com> <1383596955.29469.2.camel@dcbw.foobar.com>
In-Reply-To: <1383596955.29469.2.camel@dcbw.foobar.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/11/2013 20:29, Dan Williams wrote:
> On Mon, 2013-11-04 at 20:42 +0200, Beeblebrox wrote:
>>> What kind of access point are you trying to connect to?  These devices
>>> only support 802.11b, so if the access point is newer and is using
>>> 802.11n, there are some 11n configurations that simply don't support
>>> connections from 11b clients.
>>> Dan
>> Hi Dan, thanks for your answer.
>> The test A/P is a USR-5451-maxG with ddwrt as OS. A/P is on mixed mode
>> (B+G), but after your mail I tried B-Only mode, which failed also.
>> While observing the connection process, I got the feeling that the
>> orinoco card (eth1) is unable to set an IP. I have tried static and
>> dhclient, with same effect. Shortly after the connection process
>> starts, the card status shows as connected, but does not finalize .
>> Process then terminates (assuming because no IP is agreed on with AP).
>>
>> Please advise what other info/test I can try.
> If you're able, can you use wireshark on another computer to capture the
> 802.11 frames exchanged between the orinico device and the AP?
>
Check whether you're using wext or cfg80211. IIRC, you have to use wext. 
If that's not working, the relevant bits of wpa_supplicant log (-ddd) 
would be helpful.


Dave.
