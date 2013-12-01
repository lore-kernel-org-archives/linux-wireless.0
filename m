Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:46294 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750909Ab3LAJXF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Dec 2013 04:23:05 -0500
Message-Id: <1385889783.6507.54014729.756D4BA0@webmail.messagingengine.com> (sfid-20131201_102338_666616_CE3D1E6D)
From: "Nikita N." <nikitan@operamail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain
In-Reply-To: <529A36C5.4060209@lwfinger.net>
References: <1385589961.19021.52907237.3EE33E5B@webmail.messagingengine.com>
 <52966D64.2030805@lwfinger.net>
 <1385593188.3627.52911717.4E0712D9@webmail.messagingengine.com>
 <52968893.6060405@lwfinger.net>
 <1385812990.14905.53777877.7646278B@webmail.messagingengine.com>
 <529A1B52.6040605@lwfinger.net>
 <1385835820.6559.53858669.5FD3F3A6@webmail.messagingengine.com>
 <529A36C5.4060209@lwfinger.net>
Subject: Re: RTL8187 bugs
Date: Sun, 01 Dec 2013 01:23:03 -0800
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Sat, Nov 30, 2013, at 11:04 AM, Larry Finger wrote:
> On 11/30/2013 12:23 PM, Nikita N. wrote:
> >
> > Hi Larry, thanks for your answer, I respect your experience, because in
> > fact I have 20+ years heavy professional experience in programming, but
> > very little indeed in linux kernel programming.
> > The frames I see in monitor mode are real, not made up.. are real probe,
> > beacons, acks, auth, and so on, I can see the same using laptop
> > interface of my friend, which never got in contact with 3.11 - and he
> > gets also all data frames too.. lucky him! :)
> > What do you mean "make up the data"?
> 
> I have no idea how it worked at all Without the entry points in the
> EEPROM 
> routine, module loading should have gotten an error. I hope you did not
> force 
> the module to load. The driver had to generate a random MAC address. That
> is 
> made up data.

Good day Larry :) As Hauke Mehrtens confirmed me, they removed eeprom
modules from backports, in order to rely on distro native eeprom
libraries.. unfortunately Slitaz doesnt seems to have such evolved
eeprom native libraries.. :P hence I dont know which strange kind of
library was called to generate that mac=00..
Anyway, now Im going to fill all your code of debug messages, so we will
know whats going on, you bet! :)
You said you run successfully monitor mode on your rtl8187, what distro
exactly did you use? I want to download it too and try tests also
there.. what do you think?

> 
> > About the kernel behavior I know.. but what you say is illogical.. if
> > what you say is true, how can you explain that before exposing my two
> > interfaces to 3.11, my kernel was nice, and after 3.11 got "severely
> > broken" ?? if what you say its true, also kernel configuration of BT5
> > all versions, Kali all versions, Weaknet all version became suddenly
> > broken just a few days ago.. by what, a collapsed star passing on Hearth
> > orbit, a Solar Storm ? :))
> > The issue appears *EVERYWHERE* now.. before *EXPOSING* my two interfaces
> > to 3.11 I had no problems whatsoever.. is that concept clear?
> > Sorry, I dont know how to explain that better..
> 
> Your attitude is really putting me off!
> 
> > Infact in the little free time I got today I have been analyzing some
> > code.. and I see there are several calls to eeprom_93cx6_read and
> > eeprom_93cx6_write.. so it looks possible to write data into eeprom,
> > isnt it?
> > Also the read operations imply some bit write into eeprom, isnt it?
> > So, I think its possible that some bit got "flipped", due to some little
> > bug/whatever around, isn'it?
> > So, how can I "re-flip" back the right bit?
> > I dont know.. but I guess you know what is the right bit to flip.. isn't
> > it? ;)
> 
> When you want to read data from the PROM, you need to set up its
> controller to 
> allow the read. The PROM is not mapped to memory. That is what the write 
> operations do. As far as I know, there is no way to modify the data
> written into 
> the PROM

Maybe the circuit allows permanent changes only for some selected data
range?
Can I dump (read only op) the whole eeprom memory using sequential calls
to eeprom_93cx6_read?

> 
> >
> > THAT IS EXACTLY WHAT I WANT TO DO! :D
> > But for doing so I need my interfaces to go back operational, so I can
> > reproduce all steps of last time, and catch the damned bug!
> > Like that I cant see sh*t! if sh*t will happen again will mix with sh*t
> > and I will keep seeing only sh*t! :))
> >
> >
> > Nice to know that something is working.. ;)
> > So, are you going to give me some help or not?
> > And I repeat, its not for me only, its for the whole community, for
> > whoever will fall in that issue too!
> > Thanks :)
> 
> If you want to send me one of your devices, I'll check it out. Otherwise,
> there 
> is little I can do. It would be impossible to duplicate the path you have
> followed.

So nice from you Larry! :) but for now I just need some remote support,
as I want to see if I can fix that here. Im going to write an article
about that indeed. If you search around forums, you will see quite few
users suffered this issue, but no solution was proposed.. hence most of
users "trashed" their rtl8187 and purchased other chipsets.. very sad
indeed, dont you think? :(
Now we have the chance to find a solution for that issue once and for
all, so yes, we have to take advantage of it.. ;) 

-- 
http://www.fastmail.fm - Faster than the air-speed velocity of an
                          unladen european swallow

