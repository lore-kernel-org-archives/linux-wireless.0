Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:37905 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752511Ab1FBXtp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2011 19:49:45 -0400
Message-ID: <4DE82191.3010205@openwrt.org> (sfid-20110603_014948_207000_799286D1)
Date: Fri, 03 Jun 2011 01:49:37 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Matt Smith <smithm@qca.qualcomm.com>,
	Sundar Sankaran <sunsanka@qca.qualcomm.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	hostap@lists.shmoo.com
Subject: Re: Initial automatic channel selection implementation
References: <BANLkTi=-MDn9eAsRsoXtAetDOZehkMEhJw@mail.gmail.com> <201105241627.49201.helmut.schaa@googlemail.com> <BANLkTikcEsKYo=c=ZmzJRbmfgjmrFmx9bg@mail.gmail.com> <BANLkTin4MvdbqugTjtXvmjz5N8_TyTY7OA@mail.gmail.com> <BANLkTi=xfv_0C1mVAtO=w5JqyXLvh=vtAQ@mail.gmail.com> <BANLkTimMXbZE=vY95C0b2H3hx=4XWdU2Qg@mail.gmail.com> <BANLkTi=rS_kDhB8oKBLsz2Mk2nvRJMu5mg@mail.gmail.com> <4DDD5691.2040205@openwrt.org> <BANLkTi=1uj52P208p--5NU=Ow4rDndMkAw@mail.gmail.com> <BANLkTimRiU9Pv1B1=VC3XuREbmnpLk3S7w@mail.gmail.com> <4DDE2F5B.3020804@openwrt.org> <BANLkTimuaOoV0uvyzs9PbeK_k6vwOG=+YA@mail.gmail.com> <4DDEEEEC.6010800@openwrt.org> <BANLkTi=fT-Hdio9ArZKFMZCPX0LGLjGB=A@mail.gmail.com> <BANLkTikhihyTqg+yR8MnR1cp5wJ35sybNA@mail.gmail.com>
In-Reply-To: <BANLkTikhihyTqg+yR8MnR1cp5wJ35sybNA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-06-03 12:36 AM, Luis R. Rodriguez wrote:
> On Thu, May 26, 2011 at 5:59 PM, Luis R. Rodriguez<mcgrof@gmail.com>  wrote:
>>    What I'd like to do is to affect the ratio to nullify it if the noise
>>    is very low on the channel. Given that noise is logarithmic we'd have
>>    to use a logarithmic function as well. Working on that now.
>
> OK I've figured a way to plug the noise into this, I designed the
> following function we can use as a factor:
>
> 1.1^(x+110)
>
> Wolfram|Alpha boring details of this function:
>
> http://bit.ly/mJNXE9
>
> x,y results of different noise values in dBm, using apcalc:
>
> mcgrof@tux ~ $ calc
> C-style arbitrary precision calculator (version 2.12.3.3)
> Calc is open software. For license details type:  help copyright
> [Type "exit" to exit, or "help" for help.]
>
> ; define f(x) = 1.1^(x+110)
> f(x) defined
>
> ; f(-130)
> 	~0.14864362802414368640
> ; f(-120)
> 	~0.38554328942953174736
> ; f(-119)
> 	~0.42409761837248492210
> ; f(-118)
> 	~0.46650738020973341431
> ; f(-117)
> 	~0.51315811823070675574
> ; f(-116)
> 	~0.56447393005377743132
> ; f(-115)
> 	~0.62092132305915517445
> ; f(-114)
> 	~0.68301345536507069189
> ; f(-113)
> 	~0.75131480090157776108
> ; f(-112)
> 	~0.82644628099173553719
> ; f(-111)
> 	~0.90909090909090909091
> ; f(-110)
> 	1
> ; f(-109)
> 	1.1
> ; f(-108)
> 	1.21
> ; f(-107)
> 	1.331
>
> So then, we'd use a frequency for initiating beaconing (AP, Mesh, P2P)
> which uses the lowest value from the following computation:
>
> (busy time - tx time) / (active time - tx time) * 1.1^(noise + 110)
>
> The 1.1 factor can be modified more accurately to represent the
> exponential factor of how noise should affect interference decisions,
> the 110 value here can be modified for any other arbitrary value we
> find as representative of a regular noise value from a simple AP on
> the frequency we are observing, my assumption here was -110 dBm.
-110 dBm is not a real noise value. It's an unrealistic, ath9k-specific 
value. I have a patch that changes ath9k to make noise and signal 
strength values more realistic, and I'll submit it soon, as soon as I've 
made it a bit more precise.

- Felix
