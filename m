Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:46411 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735AbYCJPHd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Mar 2008 11:07:33 -0400
Subject: Re: [PATCH] mac80211: fix races between siwessid and siwencode
From: Dan Williams <dcbw@redhat.com>
To: Helge Hafting <helgehaf@mail.aitel.hist.no>
Cc: Tomas Winkler <tomasw@gmail.com>,
	Helge Hafting <helge.hafting@aitel.hist.no>,
	Joonwoo Park <joonwpark81@gmail.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <47D3CF6B.8080703@mail.aitel.hist.no>
References: <1204710009-10040-1-git-send-email-joonwpark81@gmail.com>
	 <20080305094859.GA10077@ehus.geninetworks.com>
	 <47CEA5CB.6040001@aitel.hist.no>
	 <1ba2fa240803050701y57913de2s635eaf8b5e3b4f96@mail.gmail.com>
	 <47CFF955.4010501@mail.aitel.hist.no>
	 <1204813814.29410.23.camel@localhost.localdomain>
	 <47D3CF6B.8080703@mail.aitel.hist.no>
Content-Type: text/plain
Date: Mon, 10 Mar 2008 11:02:50 -0400
Message-Id: <1205161370.3347.42.camel@localhost.localdomain> (sfid-20080310_150738_033011_CC497F1F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2008-03-09 at 12:52 +0100, Helge Hafting wrote:
> Dan Williams wrote:
> >> I am not sure what you mean by the question.
> >> This network uses WEP encryption (some users have older wireless equipment)
> >> there is one essid and a single shared password that everybody uses.
> >> Security is not that important, this is mostly to keep out outside bandwith
> >> wasters/pirates.
> >>     
> >
> > WEP has two authentication modes, "Shared Key" and "Open System".  He
> > wants to know which method your access point is using.  During
> > authentication, Open System is a simple two-frame request/response.  For
> > Shared Key, there's an additional challenge/response where the AP sends
> > a block of data, the client encrypts it with the WEP key, and sends it
> > back to the AP where it's verified.  Only if it verifies does the AP
> > complete association with the client.
> >   
> Well, how can I know? The access point at home is set to support
> WEP and WPA, and of course I can specify the key. There doesn't
> seem to be much more than that. I have no control over the
> access points at work, although I could ask the people involved.

With WEP, you can't know what authentication mode the AP is set to.
It's not broadcast in the beacons or probe responses.  You also can't
know whether the key length is 40 or 104 bits either.  WEP sucks.  You
just have to know what parameters your admin is using, or try a couple
times.

> > You need to ensure that the mode matches between clients and the AP.
> > Some APs have an "Auto" option that just accepts both methods from the
> > client.
> >   
> I have to ensure this? I thought this was a driver-internal thing, I 
> have not
> seen any mention of this in wireless documentation before.
> 'man iwconfig' doesn't seem to mention this, and it used to be sufficient
> to get a connection before.

You simply have to know what WEP authentication your wireless network is
using.

> If this is debug stuff, please tell how I can get the information. I can
> add debugging options to the kernel command line if need be. (The driver
> is compiled-in, modules tend to cause bootup delays.)

The way to associate with Shared Key is:

iwconfig wlan0 key xxxxxxx restricted essid foobar

Open System is:

iwconfig wlan0 key xxxxxxx open essid foobar

> I tried to sniff wlan0 with wireshark. I did not get anything there until
> after the association completed. Then I got normal stuff like dhcp
> and other traffic. So I don't have any sniff of the association itself.
> Is there some special options for enabling this, or do I need a 
> different tool?

You might need another machine that can sniff the traffic between your
first one and the AP.  I'm not completely up on the monitor mode/rtap
stuff.

> The siwencode/siwessid patch has helped a lot. The machine sometimes
> succeed to connect at first try (during bootup) and almost
> always at the second try.  The driver is not perfect yet, but it improved
> a _lot_ for me.  Thanks - and I hope this gets into the next regular 
> linux kernel. :-)

That's nice, but the patch is still wrong.  It's not going to go into
the next kernel release until it's right.  I'm certainly going to give
it a big fat NAK if it shows up again in its current form.  No driver
should ever block in the SIWESSID or SIWBSSID handlers; they have to
handle the options correctly.

> Another problem is that going out of range for an hour means I have to
> do something to get a net connection again. This does not seem to
> happen automatic, although I have not yet checked if it merely is
> a dhcp timeout problem.

The driver isn't supposed to contain a ton of logic and policy about
what networks you connect to and what ones you don't.  That's what
userspace does.  You'll likely need some userspace program
(NetworkManager, wpa_supplicant, etc) that stores that policy and
controls what you connect to, including reconnecting to your last used
networks.

Dan


