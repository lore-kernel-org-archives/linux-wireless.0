Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mantis.wzyboy.im ([199.83.51.51]:35247 "EHLO mantis.wzyboy.im"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316AbaAMGQK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 01:16:10 -0500
MIME-Version: 1.0
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB303D3C00A@HASMSX103.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB301DEA052@HASMSX103.ger.corp.intel.com>
 <CAErSpo77vnfRvEdgj470WWKo_8p8cv2xQUdaGQvvkY3tPBXzyQ@mail.gmail.com>
 <52828364.6080103@gmail.com> <CAErSpo6JdKgU0M-wu84_U2Hb4-4mdSr_V8f70Pi-ox8H45+Diw@mail.gmail.com>
 <CALkVjQZZVHUxuBkS+ret23Bt61TV_x_kj-ey=y93gC0e3cw__Q@mail.gmail.com>
 <CAErSpo6xCUDqfvKB66nZJYBOWnZLEcSJ39+aTGnKKnuZP6+dRQ@mail.gmail.com>
 <CALkVjQaTnocYnV4GM=LHuYwMRZ=sOZnSrtna4C6anNAWr4O7=A@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB301E02E49@HASMSX103.ger.corp.intel.com>
 <CALkVjQZdPuE2F+ZARBLha-+iOMA4AjDWHO4=ssnuF2Uu87RyuQ@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB301E02EC1@HASMSX103.ger.corp.intel.com>
 <CALkVjQbPTkGuEa8hLVZE0OVatw7ho=D+D51Qu68PRx-0dYay7w@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB301E02FC6@HASMSX103.ger.corp.intel.com>
 <CAErSpo6bKOpycD=cp08aBqp2U-u7sdbTSBYoHop1-1Hkmr3F-g@mail.gmail.com>
 <CALkVjQaOHix5uxFGd-62negbfubz-rdP+zmj9w5wDEa1rCA75Q@mail.gmail.com>
 <5285E028.20906@gmail.com> <CALkVjQYT9P--dgez064je4vM-xve4uF5ptOVVk3DuVoQiWQvew@mail.gmail.com>
 <CANUX_P1j9QNGQ2n02KpXsuMQcZo9uOsSN-zZ8yNS1e5+Y9bJOA@mail.gmail.com>
 <CALkVjQYFJzP1E_YayPOjRu3u85WdpDojDD+DmU9ZehY7ZHF0AA@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB303D297F0@HASMSX103.ger.corp.intel.com>
 <CALkVjQaJ94osfBwnrpKBk4tE_+=XMqznXY=qVv5KdzSkvsthaA@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB303D2D2C5@HASMSX103.ger.corp.intel.com>
 <CALkVjQaWBq6--sekifyGfJt9FDigsk56eXMUv9YR3sDVnVcX=Q@mail.gmail.com>
 <CAErSpo4ZxJ8T8ih1+svqjpUNbJo-WezP=9OatDTuLk3u=zkCLw@mail.gmail.com>
 <CALkVjQbjnAk0mFZ-3zjx_15xXEaaiMaVxMMLD1HEUJhVtYXg4g@mail.gmail.com> <0BA3FCBA62E2DC44AF3030971E174FB303D3C00A@HASMSX103.ger.corp.intel.com>
From: wzyboy <wzyboy@wzyboy.org>
Date: Mon, 13 Jan 2014 14:15:54 +0800
Message-ID: <CALkVjQZ9Tc7Xx9ANzcp_4_7_=BCLM7EHS+oJUxQ57QXuSiv+YA@mail.gmail.com> (sfid-20140113_071634_164921_788EADEC)
Subject: Re: [Ilw] Intel Wireless 7260 hardware timed out randomly
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	Emmanuel Grumbach <egrumbach@gmail.com>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	"Bj?rn Mork" <bjorn@mork.no>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2014/1/13 Grumbach, Emmanuel <emmanuel.grumbach@intel.com>:
> Small update from the bugzilla (https://bugzilla.kernel.org/show_bug.cgi?id=64541).
> The bug is solved... There seem to be a hardware bug with the L1 OFF exit timer. To solve this bug we need *not* to rely on the internal clock and need to keep using the external clock. The internal clock isn't reliable enough and can lead to loss of synchronization between the bridge and the device upon L1 OFF transition.
> This issue has been seen in simulation and not on real hardware... until now... The windows driver has a workaround for this hardware bug, this is why the issue wasn't seen on Windows. I am porting the work around to the Linux driver.
>
> Thank you wzyboy for your patience...
>
> Then end.


So this is a hardware bug instead of a driver bug? Oh...

I'm glad this is finally solved since 2013-11-03. Thanks to all,
providing me with wordarounds, without which I could only use wired
network. :-)

Cheers.

-- 
wzyboy
