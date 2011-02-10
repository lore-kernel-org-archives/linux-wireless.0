Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web36102.mail.mud.yahoo.com ([66.163.179.216]:27926 "HELO
	web36102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757171Ab1BJXIk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Feb 2011 18:08:40 -0500
Message-ID: <937938.34583.qm@web36102.mail.mud.yahoo.com>
References: <875258.44241.qm@web36104.mail.mud.yahoo.com> <20110210212508.GA2508@tuxdriver.com>
Date: Thu, 10 Feb 2011 15:08:38 -0800 (PST)
From: Noel Milton Vega <nmvega@nyceyes.com>
Reply-To: Noel Milton Vega <nmvega@nyceyes.com>
Subject: Re: UPDATE -- Need Linux driver (preferably 64 bit) for "Intel Corporation Centrino Advanced-N 6230 (rev 34)" WiFI & Bluetooth card ...
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Julian Calaby <julian.calaby@gmail.com>, ozan@pardus.org.tr,
	linux-wireless@vger.kernel.org
In-Reply-To: <20110210212508.GA2508@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


  > > In working with the kernel.org linux-wireless  developers, the conclusion
  > > from one developer was that, though generally  speaking the
  > > "Centrino Advanced-N 6230 AGN" card is supported by the  "iwlagn" kernel
  > > module, it seems that the stock kernel module provided  in the
  > > Fedora 14 kernel package (circa 2.6.35.10-74.fc14.x86_64), does  not
  > > support the this card.
  > > 
  > > In other words, though code  in the main kernel.org git repository does
  > > show support for the card  (via iwlagn kernel module), Fedora 14's
  > > rendition/distribution of that  does not.
  > 
  > The point you seem to be missing is that your hardware is very  new,
  > and the current Fedora 14 kernel is an "ancient" 6+ months  old.
  >
The point wasn't missed. In fact I highlighted the Fedora kernel
version, and my card model to expressly make the point. Moreover,
one of my suggested work-arounds was to try a newer kernel module
(via compat-wireless) so as to bridge bridge that gap for this issue.

  > > Command  output during my debugging session with the developers is
  > > shown below  for completeness, and in case the Fedora folks are
  > >  monitoring.
  > 
  > I'm sorry, but your acquisition of bleeding-edge hardware  does not
  > merit a change in the normal Fedora release  policy.
  >
Nothing in my email asked or expected them to. Still, the community
in general should know what's going on. And, I did suggest two
work-arounds in my email, neither of which asks anything of Fedora. 

  > P.S. I apologize if this seems rude -- that is  not my intent.
  >
Ah... This postscript repairs everything.





----- Original Message ----
> From: John W. Linville <linville@tuxdriver.com>
> To: Noel Milton Vega <nmvega@nyceyes.com>
> Cc: Julian Calaby <julian.calaby@gmail.com>; ozan@pardus.org.tr; 
>linux-wireless@vger.kernel.org; Noel Milton Vega 
><nmvega@ComputingArchitects.Com>
> Sent: Thu, February 10, 2011 4:25:08 PM
> Subject: Re: UPDATE -- Need Linux driver (preferably 64 bit) for "Intel 
>Corporation Centrino Advanced-N 6230 (rev 34)" WiFI & Bluetooth card ...
> 
> On Thu, Feb 10, 2011 at 12:31:02PM -0800, Noel Milton Vega wrote:
> 
> > Hi  Friends....
> > 
> > UPDATE:
> > 
> > In working with the kernel.org linux-wireless  developers, the conclusion
> > from one developer was that, though generally  speaking the
> > "Centrino Advanced-N 6230 AGN" card is supported by the  "iwlagn" kernel
> > module, it seems that the stock kernel module provided  in the
> > Fedora 14 kernel package (circa 2.6.35.10-74.fc14.x86_64), does  not
> > support the this card.
> > 
> > In other words, though code  in the main kernel.org git repository does
> > show support for the card  (via iwlagn kernel module), Fedora 14's
> > rendition/distribution of that  does not.
> 
> The point you seem to be missing is that your hardware is very  new,
> and the current Fedora 14 kernel is an "ancient" 6+ months  old.
> 
> > "lspci(8) -v" did show the hardware (Intel Corporation Centrino  Advanced-N 
>6230
> > (rev 34)), the necessary driver and firmware packages  were installed, and 
>the
> > laptop RF toggle switches are set to enable  wireless communications.
> > Yet manually performing "modprobe(8) iwlagn"  does not produce a wlan0
> > interface in "ifconfig(8) -a" output; and  although "dmesg(8)" shows the
> > module being loaded, it does not show it  detecting the card.
> > 
> > The two work arounds were suggested (I  haven't tried either):
> > 
> >   (1) Update the kernel. Since I  have the latest one provided
> >       by Fedora for Fedora  14, this implies a manual compile
> >       of a kernel.org  kernel. Note that if Fedora is not aware of
> >       this  issue, it's not likely that the next kernel update
> >        will remedy this.
> 
> You could update to a Fedora Rawhide kernel.
> 
> As  root:
> 
>     yum install  fedora-release-rawhide
> 
>     yum --enablerepo=rawhide  install kernel
> 
> Please note that Rawhide is not known for its  stability...
> 
> >   (2) Using a compat-wireless technique described  here,
> >        http://wireless.kernel.org/en/users/Download
> > 
> > 
> > Command  output during my debugging session with the developers is
> > shown below  for completeness, and in case the Fedora folks are
> >  monitoring.
> 
> I'm sorry, but your acquisition of bleeding-edge hardware  does not
> merit a change in the normal Fedora release  policy.
> 
> John
> 
> P.S.  I apologize if this seems rude -- that is  not my intent.
> -- 
> John W. Linville         Someday the world will need a hero, and you
> linville@tuxdriver.com             might be all we have.  Be ready.
> 
