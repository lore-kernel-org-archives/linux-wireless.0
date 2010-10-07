Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48724 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760464Ab0JGNPH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 09:15:07 -0400
Date: Thu, 7 Oct 2010 09:06:51 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH] mac80211: avoid uninitialized var warning in
 ieee80211_scan_cancel
Message-ID: <20101007130651.GA13496@tuxdriver.com>
References: <1286397743-21687-1-git-send-email-linville@tuxdriver.com>
 <20101007061515.GA25616@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20101007061515.GA25616@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 07, 2010 at 08:15:16AM +0200, Stanislaw Gruszka wrote:
> On Wed, Oct 06, 2010 at 04:42:23PM -0400, John W. Linville wrote:
> > net/mac80211/scan.c: In function ‘ieee80211_scan_cancel’:
> > net/mac80211/scan.c:794: warning: ‘finish’ may be used uninitialized in this function
> > 
> > Signed-off-by: John W. Linville <linville@tuxdriver.com>
> 
> Hi John
> 
> What compiler are you using? I have no warning with gcc 4.4.4 from RHEL6.
> That's correct, as "finish" variable can not be uninitialized, because is used
> only when abortscan == true;

[linville-8530p.local]:> gcc -v
Using built-in specs.
Target: x86_64-redhat-linux
Configured with: ../configure --prefix=/usr --mandir=/usr/share/man --infodir=/usr/share/info --with-bugurl=http://bugzilla.redhat.com/bugzilla --enable-bootstrap --enable-shared
--enable-threads=posix --enable-checking=release --with-system-zlib --enable-__cxa_atexit --disable-libunwind-exceptions --enable-gnu-unique-object
--enable-languages=c,c++,objc,obj-c++,java,fortran,ada --enable-java-awt=gtk --disable-dssi --with-java-home=/usr/lib/jvm/java-1.5.0-gcj-1.5.0.0/jre --enable-libgcj-multifile
--enable-java-maintainer-mode --with-ecj-jar=/usr/share/java/eclipse-ecj.jar --disable-libjava-multilib --with-ppl --with-cloog --with-tune=generic --with-arch_32=i686 --build=x86_64-redhat-linux
Thread model: posix
gcc version 4.4.4 20100630 (Red Hat 4.4.4-10) (GCC) 

/home/linville
[linville-8530p.local]:> cat /etc/redhat-release 
Fedora release 13 (Goddard)

> > +	bool finish = false;
> >  
> >  	/*
> >  	 * We are only canceling software scan, or deferred scan that was not
> > @@ -818,7 +819,7 @@ void ieee80211_scan_cancel(struct ieee80211_local *local)
> >  	if (abortscan) {
> >  		/* The scan is canceled, but stop work from being pending */
> >  		cancel_delayed_work_sync(&local->scan_work);
> > -		if (finish)
> > -			__ieee80211_scan_completed_finish(&local->hw, false);
> >  	}
> > +	if (finish)
> > +		__ieee80211_scan_completed_finish(&local->hw, false);
> >  }
> 
> I have nothing against the patch, but this seems to be compiler problem,
> not our code.

I'd rather just avoid the warning spam. :-)

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
