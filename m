Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f43.google.com ([209.85.219.43]:58920 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab3K3TEj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Nov 2013 14:04:39 -0500
Received: by mail-oa0-f43.google.com with SMTP id i7so11529094oag.2
        for <linux-wireless@vger.kernel.org>; Sat, 30 Nov 2013 11:04:39 -0800 (PST)
Message-ID: <529A36C5.4060209@lwfinger.net> (sfid-20131130_200443_809035_BCEC7D2E)
Date: Sat, 30 Nov 2013 13:04:37 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "Nikita N." <nikitan@operamail.com>, linux-wireless@vger.kernel.org
Subject: Re: RTL8187 bugs
References: <1385589961.19021.52907237.3EE33E5B@webmail.messagingengine.com> <52966D64.2030805@lwfinger.net> <1385593188.3627.52911717.4E0712D9@webmail.messagingengine.com> <52968893.6060405@lwfinger.net> <1385812990.14905.53777877.7646278B@webmail.messagingengine.com> <529A1B52.6040605@lwfinger.net> <1385835820.6559.53858669.5FD3F3A6@webmail.messagingengine.com>
In-Reply-To: <1385835820.6559.53858669.5FD3F3A6@webmail.messagingengine.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/30/2013 12:23 PM, Nikita N. wrote:
>
> Hi Larry, thanks for your answer, I respect your experience, because in
> fact I have 20+ years heavy professional experience in programming, but
> very little indeed in linux kernel programming.
> The frames I see in monitor mode are real, not made up.. are real probe,
> beacons, acks, auth, and so on, I can see the same using laptop
> interface of my friend, which never got in contact with 3.11 - and he
> gets also all data frames too.. lucky him! :)
> What do you mean "make up the data"?

I have no idea how it worked at all Without the entry points in the EEPROM 
routine, module loading should have gotten an error. I hope you did not force 
the module to load. The driver had to generate a random MAC address. That is 
made up data.

> About the kernel behavior I know.. but what you say is illogical.. if
> what you say is true, how can you explain that before exposing my two
> interfaces to 3.11, my kernel was nice, and after 3.11 got "severely
> broken" ?? if what you say its true, also kernel configuration of BT5
> all versions, Kali all versions, Weaknet all version became suddenly
> broken just a few days ago.. by what, a collapsed star passing on Hearth
> orbit, a Solar Storm ? :))
> The issue appears *EVERYWHERE* now.. before *EXPOSING* my two interfaces
> to 3.11 I had no problems whatsoever.. is that concept clear?
> Sorry, I dont know how to explain that better..

Your attitude is really putting me off!

> Infact in the little free time I got today I have been analyzing some
> code.. and I see there are several calls to eeprom_93cx6_read and
> eeprom_93cx6_write.. so it looks possible to write data into eeprom,
> isnt it?
> Also the read operations imply some bit write into eeprom, isnt it?
> So, I think its possible that some bit got "flipped", due to some little
> bug/whatever around, isn'it?
> So, how can I "re-flip" back the right bit?
> I dont know.. but I guess you know what is the right bit to flip.. isn't
> it? ;)

When you want to read data from the PROM, you need to set up its controller to 
allow the read. The PROM is not mapped to memory. That is what the write 
operations do. As far as I know, there is no way to modify the data written into 
the PROM.

>
> THAT IS EXACTLY WHAT I WANT TO DO! :D
> But for doing so I need my interfaces to go back operational, so I can
> reproduce all steps of last time, and catch the damned bug!
> Like that I cant see sh*t! if sh*t will happen again will mix with sh*t
> and I will keep seeing only sh*t! :))
>
>
> Nice to know that something is working.. ;)
> So, are you going to give me some help or not?
> And I repeat, its not for me only, its for the whole community, for
> whoever will fall in that issue too!
> Thanks :)

If you want to send me one of your devices, I'll check it out. Otherwise, there 
is little I can do. It would be impossible to duplicate the path you have followed.

Larry



