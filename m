Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f176.google.com ([209.85.211.176]:51775 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453Ab0AZCgy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2010 21:36:54 -0500
Received: by ywh6 with SMTP id 6so3711588ywh.4
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jan 2010 18:36:53 -0800 (PST)
Message-ID: <4B5E5546.20105@twilightblue.net>
Date: Mon, 25 Jan 2010 20:36:54 -0600
From: Don Darling <darling.don@gmail.com>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: Bug: 2.6.32 ath5k, associating with WEP128 AP is unreliable
References: <4B5CD1FF.4090209@twilightblue.net>	 <b6c5339f1001250939r6d136927q51bba86f7102d826@mail.gmail.com>	 <4B5DE859.6080409@lwfinger.net>	 <69e28c911001251121i61be9c0bhed43648a12db42f6@mail.gmail.com> <b6c5339f1001251313u369c571dq5cee9ffa65fcf457@mail.gmail.com>
In-Reply-To: <b6c5339f1001251313u369c571dq5cee9ffa65fcf457@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello folks,

Thanks for the suggestions -- here are a few questions I can answer from 
earlier today:

1)  I didn't realize there was a subtle difference between WEP104 and 
WEP128.  What I can tell you is that the WEP AP is running Tomato 1.23, 
and is set to WEP 128-bit.  However, the key I'm using is only 104 
bits.  This probably means I'm actually using WEP104.

2) I'm definitely not using madwifi in either case -- I've always used 
the ath5k driver on this machine.

3) As far as I can tell, there are no modparams being used with ath5k.  
I checked both /etc/modprobe.d and /etc/sysctl.conf (I'm not sure if the 
latter affects modules or not, actually - I think it might depend on the 
module).

4) I realize WPA+TKIP is more secure and I would use it if I could, but 
I have some old devices that don't support WPA it so I'm limited to WEP.

5) I use -Dwext with wpa_supplicant when I *do* use WPA+TKIP networks.

Also, FWIW:

# lsmod | grep ath
ath5k                 127364  0
mac80211              155788  1 ath5k
ath                     7708  1 ath5k
cfg80211               90364  3 ath5k,mac80211,ath
led_class               4000  1 ath5k

I'm not sure when I might have a chance to bisect, but will certainly 
let you know if I do.

Best regards,
Don


Bob Copeland wrote:
> 2010/1/25 Gábor Stefanik <netrolller.3d@gmail.com>:
>   
>> On Mon, Jan 25, 2010 at 7:52 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>>     
>>> For the record, WEP104 and WEP128 are the same thing. The smaller number
>>> makes it explicit that the 24-bit IV is transmitted in the open. The same
>>> thing applies to WEP40 and WEP64.
>>>
>>>       
>> Only one problem there is another, nonstandard WEP type where the
>> actual key is 128-bit, and this is also sometimes referred to as
>> WEP128 (with the same metric as WEP64, this one would be WEP152). Same
>> goes for "WEP228/WEP256/WEP280".
>>     
>
> Yea, I think ath hw supports that too:
>
> #define AR5K_KEYTABLE_TYPE_40		0x00000000
> #define AR5K_KEYTABLE_TYPE_104		0x00000001
> #define AR5K_KEYTABLE_TYPE_128		0x00000003
>
> at least that's what I assumed it meant.  But there's no way to set it
> from mac80211 (nor should there be).
>
>   

