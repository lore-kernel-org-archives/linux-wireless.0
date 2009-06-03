Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web55303.mail.re4.yahoo.com ([206.190.58.182]:42290 "HELO
	web55303.mail.re4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752315AbZFCD2R convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2009 23:28:17 -0400
Message-ID: <380442.8741.qm@web55303.mail.re4.yahoo.com>
Date: Tue, 2 Jun 2009 20:28:18 -0700 (PDT)
From: austinxxh-ath9k@yahoo.com
Reply-To: austinxxh-ath9k@yahoo.com
Subject: Re: [ath9k-devel] ath9k/ath5k + 80211s crash
To: devel@lists.open80211s.org, ath9k-devel@lists.ath9k.org,
	linux-wireless@vger.kernel.org,
	=?utf-8?B?6rO9cmVvbQ==?= <acidreom@hotmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


the new wireless-testing(6/2/09) did not cause reset anymore. however "iw dev mesh station dump" showed nothing, even after I did "ifconfig mesh up" and "ifconfig mesh down" a few times. How did you know if it's sending beacons or not? are you using the monitor interface or something?

this is what i did:
-------------------
iw dev wlan0 interface add mesh type mp mesh_id mesh
ifconfig mesh up
ifconfig mesh 192.168.3.80 
iw dev mesh station dump
--------------------
do the same on a second node, with a different mesh IP address.

nothing showed up, with olsr I can see two nodes are "merged"

wish i know more to debug this, learning...

xxiao

--- On Tue, 6/2/09, 곽reom <acidreom@hotmail.com> wrote:

> From: 곽reom <acidreom@hotmail.com>
> Subject: Re: [ath9k-devel] ath9k/ath5k + 80211s crash
> To: devel@lists.open80211s.org, ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
> Date: Tuesday, June 2, 2009, 8:26 PM
> 
> 
> 
> #yiv1908813577 .hmmessage P
> {
> margin:0px;padding:0px;}
> #yiv1908813577 {
> font-size:9pt;font-family:굴림;}
> 
> 
>  
> 802.11s works fine on my system with latest
> wireless-testing ath5k.
> 
> There's only one problem. 
> 
> mesh0 doesn't send beacon automatically when i up mesh0
> first time.
> 
> Only after doing down and up again mesh0, beacon was send
> and mesh works.
> 
> I don't think crashing and rebooting with mesh setting
> is a related problem with ath5k or ath9k.
>  
> > Date: Tue, 2 Jun 2009 17:55:20 -0700
> > From: austinxxh-ath9k@yahoo.com
> > To: andrey@cozybit.com; lrodriguez@atheros.com
> > CC: devel@lists.open80211s.org;
> ath9k-devel@lists.ath9k.org; linux-wireless@vger.kernel.org
> > Subject: Re: [ath9k-devel] ath9k/ath5k + 80211s crash
> > 
> > 
> > Not good, I definitely like to use 80211s with ath9k,
> though I'm not familiar enough to fix anything related
> to them yet. Say, I don't know what's the
> relationship between 80211s and ath9k/ath5k at this point.
> Trying 0602 release now and see if it improves anything. 
> > 
> > I was told b43 runs well with 80211s, hope ath5k/ath9k
> will do the same someday.
> > 
> > X Xiao
> > 
> > --- On Tue, 6/2/09, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
> > 
> > > From: Luis R. Rodriguez
> <lrodriguez@atheros.com>
> > > Subject: Re: [ath9k-devel] ath9k/ath5k + 80211s
> crash
> > > To: "Andrey Yurovsky"
> <andrey@cozybit.com>
> > > Cc: "austinxxh-ath9k@yahoo.com"
> <austinxxh-ath9k@yahoo.com>,
> "devel@lists.open80211s.org"
> <devel@lists.open80211s.org>,
> "ath9k-devel@lists.ath9k.org"
> <ath9k-devel@lists.ath9k.org>,
> "linux-wireless@vger.kernel.org"
> <linux-wireless@vger.kernel.org>
> > > Date: Tuesday, June 2, 2009, 5:30 PM
> > > On Tue, Jun 02, 2009 at 09:58:59AM
> > > -0700, Andrey Yurovsky wrote:
> > > > With wireless-testing from a couple of days
> ago, an
> > > X86 system, and this patch:
> > > >
> http://osdir.com/ml/linux-wireless/2009-05/msg01241.html
> > > > ath9k can bring up a mesh point interface
> and doesn't
> > > crash for me,
> > > > but there are no mesh beacons, so mesh
> isn't
> > > working.  On ath5k, there
> > > > are also no beacons and mesh doesn't
> work, but there's
> > > no crash.
> > > 
> > > If no one is really interested in fixing we
> should just
> > > disable mesh
> > > for both ath5k and ath9k.
> > > 
> > >   Luis
> > > 
> > _______________________________________________
> > ath9k-devel mailing list
> > ath9k-devel@lists.ath9k.org
> > https://lists.ath9k.org/mailman/listinfo/ath9k-devel
>  
> 
> -----Inline Attachment Follows-----
> 
> _______________________________________________
> ath9k-devel mailing list
> ath9k-devel@lists.ath9k.org
> https://lists.ath9k.org/mailman/listinfo/ath9k-devel
> 
