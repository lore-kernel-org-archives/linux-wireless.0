Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31907 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753693Ab3GPKYx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jul 2013 06:24:53 -0400
Date: Tue, 16 Jul 2013 12:27:44 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Pedro Francisco <pedrogfrancisco@gmail.com>
Cc: Tino Keitel <tino.keitel@tikei.de>,
	ML linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Power saving features for iwl4965
Message-ID: <20130716102743.GA8321@redhat.com> (sfid-20130716_122515_517723_19238429)
References: <20130107110759.GC6931@redhat.com>
 <20130603085239.GA26920@mac.home>
 <20130603141804.GA2146@redhat.com>
 <CAJZjf_xoCOTFsLAB29uLKeW7+O+k255Amspn6GKFMysc7CTsBg@mail.gmail.com>
 <CAJZjf_xGdvStOG0=FR2+2WsVcjyizQukH+RxysZf8f9-Tk9L9w@mail.gmail.com>
 <20130611161924.GB1696@redhat.com>
 <CAJZjf_zOF=qGEE=pWDRe0YDpAYophm93cVM8pfuL0sTRGq56EA@mail.gmail.com>
 <20130614131829.GA5125@redhat.com>
 <20130625142514.GA1938@redhat.com>
 <CAJZjf_z=+QW_Y3yuz6nJ+muVA_6bGRut8EQ7fCopDqqj2Fn9Yw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJZjf_z=+QW_Y3yuz6nJ+muVA_6bGRut8EQ7fCopDqqj2Fn9Yw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 11, 2013 at 10:02:22PM +0100, Pedro Francisco wrote:
> > Pedro, please do the fallowing:
> >
> > Add this line in /etc/rsyslog.conf:
> > kern.*                                                  /var/log/kernel
> >
> > Restart rsyslog services:
> > # systemctl restart rsyslog.service
> >
> > Restart iwl3945 module with verbose debug enabled:
> > modprobe -r iwl3945
> > modprobe iwl3945 debug=0x47ffffff
> >
> > Reproduce the problem.
> >
> > Unload module:
> > modprobe -r iwl3945
> >
> > Then provide me generated /var/log/kernel file (compressed if needed).
> 
> I seem only to be able to trigger it with disable_hw_scan=0, I need
> further testing with disable_hw_scan=1 (I use disable_hw_scan=0
> because it prevents me from getting disconnected from eduroam Cisco
> APs -- haven't tested disable_hw_scan=0 since the VOIP-friendly SW
> scanning patch, however).
> 
> Do you want the log anyway? (modprobe iwl3945 debug=0x47ffffff
> disable_hw_scan=0 and runtime PCI powersave also enabled -- I don't
> know if it matters).

To test that patch powersave has to be explicitly enabled, since
it is disabled by default.

As this is not causing troubles with default disable_hw_scan option,
I'll post that patch.

You can provide me logs with disable_hw_scan=0, if you manage to
trigger a Microcode error.

Thanks
Stanislaw

  

> --
> Pedro
