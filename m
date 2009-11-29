Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from osmium.mv.net ([199.125.85.152]:58916 "HELO shell.mv.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751455AbZK2SqI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Nov 2009 13:46:08 -0500
Date: Sun, 29 Nov 2009 13:31:28 -0500 (EST)
From: RHS Linux User <xxx@nei.mv.com>
To: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
cc: linux-wireless@vger.kernel.org, hostap@lists.shmoo.com,
	ath9k-devel@lists.ath9k.org
Subject: Re: [ath9k-devel] ath9k based AP stops responding after half a day or so
In-Reply-To: <133e8d7e0911290451p70f07566i1f767176248c6e83@mail.gmail.com>
Message-ID: <Pine.LNX.3.95.1091129131907.3571A-100000@nei>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi,

  I have seen several "similar" sorts of things. I assume that
the chip(s) are not being reset successfully. That is to say, some
particular "dance" is needed to get the chip restarted.

  Being somewhat of a hardware type. "Full" powerdown may be needed for a
significant time period and then maybe will only work sometimes. There may
be one or more flip-flops inside whatever chip that cannot be reset (chip
design bug), so even a "full" powerdown reset still doesn't make sure the
chip will positively come up OK. Or some special sequence... You get the
idea.

  In this case the only strategy left is to do a "full" restart and see if
the circuit is now working? If not (not on the web, etc.) repeat the
process. 

  Pretty sad.... IMHO. But that's what getting complex hardware
to actually work is sometimes like.

  Hope that helps.

  If the manufacturer actually knew how their chip actually works,
it would help. From what I can see often the manufacturer doesn't
publish specs because they really don't know for sure and don't want
to appear stupid about their "industry standard" chips!

  Some big manufacturer like Microsoft may have "accidently"  stumbled
onto how to get whatever chip to actually work and now the "correct" power
up method/sequence becomes somewhat of a proprietary secret since the chip
manufacturer doesn't actually know how to make their own chip work! 

  Good luck!

  Wiz  (pen name)


On Sun, 29 Nov 2009, [ISO-8859-1] Björn Smedman wrote:

> Hi all,
> 
> I'm seeing a similar problem with compat-wireless-2.6.32-rc1 and
> hostapd 0.6.9 on a AR9100 (ath9k) mips/ahb based system. This is with
> an open access point and without ANI so my guess is that Rob's log
> unfortunately does not pinpoint the problem.
> 
> I can spend some time on this but like Rob I'm not sure where to
> start. Any thoughts? It should be somewhere close to the hardware as a
> restart/reload doesn't solve the problem (I haven't been able to try
> this though). Anybody know anything related to
> beacons/monitor/injection that may deteriorate over time and be
> persistent across an rmmod/insmod?
> 
> Best regards,
> 
> Björn
> 
> On Sat, Nov 7, 2009 at 11:18 PM, Rob Browning <rlb@defaultvalue.org> wrote:
> >
> > Rob Browning <rlb@defaultvalue.org> writes:
> >
> > > I have an machine that's running a recent compat-wireless (2009-10-17),
> > > kernel 2.6.30-2-686 (Debian), and a build of hostapd as of 2009-10-17
> > > (08d38568).  The machine also has an AR5008 (ath9k) based PCI card.
> > >
> > > After the machine reboots, wireless clients can connect to the AP
> > > normally for a half day or so.  Then, at some point, all connections
> > > fail, and clients cannot even see the network until the machine is
> > > rebooted.  Reloading the wireless modules, and restarting hostapd
> > > doesn't help.
> >
> > Just as an update, this problem persists with hostapd as of eb999fef,
> > and compat-wireless 2009-11-03.
> >
> > I'd be happy to provide further information.
> > --
> > Rob Browning
> > rlb @defaultvalue.org and @debian.org; previously @cs.utexas.edu
> > GPG as of 2002-11-03 14DD 432F AE39 534D B592 F9A0 25C8 D377 8C7E 73A4
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
> --
> Venatech AB
> Ideon Innovation
> Ole Römers väg 12
> SE-22370 LUND
> Sweden
> 
> +46 (0) 46 286 86 20
> info@venatech.se
> http://www.venatech.se
> _______________________________________________
> ath9k-devel mailing list
> ath9k-devel@lists.ath9k.org
> https://lists.ath9k.org/mailman/listinfo/ath9k-devel
> 

