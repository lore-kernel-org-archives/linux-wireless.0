Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.221.174]:41647 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099AbZJWPYy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2009 11:24:54 -0400
Received: by qyk4 with SMTP id 4so6750976qyk.33
        for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2009 08:24:59 -0700 (PDT)
Content-Type: text/plain; charset=UTF-8
Subject: Re: [REGRESSION] EAPOL Key Timeout 1/4
From: Ben Gamari <bgamari.foss@gmail.com>
To: linux-wireless@vger.kernel.org, hostap <hostap@lists.shmoo.com>
In-reply-to: <65691fa00910210001w150d3d9dx2c0eb530c423e18c@mail.gmail.com>
References: <65691fa00910140011xacab35eja047bd8036fd5ae5@mail.gmail.com> <20091014174751.GA12365@jm.kir.nu> <65691fa00910150218o1c2f247fkedeb8dae9b2deeb0@mail.gmail.com> <65691fa00910210001w150d3d9dx2c0eb530c423e18c@mail.gmail.com>
Date: Fri, 23 Oct 2009 11:24:55 -0400
Message-Id: <1256311350-sup-7290@ben-laptop>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I can also reproduce this with kernel 2.6.31. Looks like a regression.
What could be done to localize the issue?

- Ben


Excerpts from Daniel Rönnqvist's message of Wed Oct 21 03:01:07 -0400 2009:
> Hi again,
> 
> when running hostapd (nl80211/bcm4306 on a ppc mac) with kernel 2.6.30
> it works kind of ok. One of my two laptops at home can connect and
> that's the one usually having better connection to any AP (stronger
> signal). The other one can connect but will get disconnected after a
> few minutes. Both are WinXP.
> 
> When running with kernel 2.6.31 it wont work at all, the EAPOL keys
> are only rarely seen going out on wlan0 when I use tshark. If they go
> out they are answered by the client (verified with wireshark on
> client) but the response is never seen on the AP side. This was my
> problem when I first posted this issue.
> 
> With and 2.6.32-rc I get kernel scheduler errors in my dmesg and soon
> after starting to send traffic over the wlan the machine crashes, it's
> an RC after all.
> 
> So going back to 2.6.30 kind of solves my problem, except for one of
> my XP machines but I can't really blame hostapd for that, can I? ;)
> 
> Just thought I would let you know if there's anyone having the same problem.
> 
> BR,
> Daniel
> 
> Den 15 oktober 2009 11.18 skrev Daniel Rönnqvist <kdronnqvist@gmail.com>:
> > 2009/10/14 Jouni Malinen <j@w1.fi>:
> >> On Wed, Oct 14, 2009 at 09:11:00AM +0200, Daniel Rönnqvist wrote:
> >>
> >>> * Is hostapd from git supposed to work with nl80211 (with a bcm4306 rev3)?
> >>
> >> I don't know about bcm4306, but at least the current snapshot of hostapd
> >> seems to be working fine with the ath9k driver.
> >>
> >>> * What does "deauthenticated due to local death" mean?
> >>
> >> It means that hostapd requested a station to be deauthenticated (in this
> >> case, I would assume it happened due to the WPA 4-way handshake timing
> >> out).
> >>
> >>> * The only messages i see with tshark during the authentication
> >>> process is "EAPOL Key" and some "LLC" messages coming from the client
> >>> MAC. The hostapd log says EAPOL Key Timeout on handshake 1/4. Is this
> >>> enough to guess what ballpark my problem is in?
> >>
> >> Have you verified that your client is receiving the EAPOL-Key message
> >> 1/4 and replying with 2/4?
> >>
> >> --
> >> Jouni Malinen                                            PGP id EFC895FA
> >
> > I see EAPOL key coming in on the client and it is answering to the
> > correct MAC address, but the AP is always just saying EAPOL key
> > timeout on 1/4. On the AP side i do "tshark -i wlan0" and see the
> > EAPOL key going out but nothing is coming back. However, I am reading
> > up on the subject because as of now I must admit that I do not know
> > how this works. I should be able to give a better description of my
> > problem in a week or so (after becoming junior guru of wifi) :) I did
> > get this setup to work before but after upgrading to Debian testing it
> > just wont.
> >
> > BR,
> > Daniel
> >
