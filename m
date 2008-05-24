Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:38402 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754676AbYEXLEF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 May 2008 07:04:05 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1JzrXb-0008Dv-GC
	for linux-wireless@vger.kernel.org; Sat, 24 May 2008 11:04:01 +0000
Received: from c-67-190-34-252.hsd1.co.comcast.net ([67.190.34.252])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 24 May 2008 11:03:59 +0000
Received: from dann.church by c-67-190-34-252.hsd1.co.comcast.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 24 May 2008 11:03:59 +0000
To: linux-wireless@vger.kernel.org
From: Dann Church <dann.church@cassatt.com>
Subject: Re: iwl4965 - =?utf-8?b?d3BhX3N1cHBsaWNhbnQ=?= can't see 5Ghz frequencies - 2.6.26-rc1 kernel
Date: Sat, 24 May 2008 11:03:46 +0000 (UTC)
Message-ID: <loom.20080524T105644-837@post.gmane.org> (sfid-20080524_130410_482752_2A1861EB)
References: <1210352234.3763.23.camel@X61.NetworkingUnlimited.com>  <1210434402.3787.7.camel@X61.NetworkingUnlimited.com>  <1ba2fa240805101156q4dc52c2bt47d2f6e51b611eea@mail.gmail.com>  <1210456110.3787.26.camel@X61.NetworkingUnlimited.com>  <1ba2fa240805101506p78c3eeb6q6e980ac4200fd56f@mail.gmail.com>  <1210474179.3787.31.camel@X61.NetworkingUnlimited.com>  <1ba2fa240805120950mf983e97qac4cdfa2c84b6662@mail.gmail.com>  <1210617467.3792.4.camel@X61.DFGI.com>  <1ba2fa240805220953u746d3429q50faa1885104cadb@mail.gmail.com>  <loom.20080522T173929-232@post.gmane.org> <1ba2fa240805221054h7873d5c8k6fb44bf38ef2778@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tomas Winkler <tomasw@...> writes:

> 
> On Thu, May 22, 2008 at 8:42 PM, Dann Church <dann.church@...> wrote:
> > Tomas Winkler <tomasw@...> writes:
> >
> >>
> >> On Mon, May 12, 2008 at 9:37 PM, Vincent C Jones
> >> <v.jones@...> wrote:
> >> >
> >> > On Mon, 2008-05-12 at 19:50 +0300, Tomas Winkler wrote:
> >> >
> >> >> Meanwhile we've reproduced the wpa_supplicant issue...
> >> >>
> >> >
> >> > That is great news. Let me know when it is time to test again...
> >>
> >> Please try this one. I've just pasted that in so it's might be
> >> white-space-wise broken
> >
> > I have this same issue running fedora core 9 with a kernel version
> > 2.6.25.3-18.fc9.i686.PAE.  Any chance this patch would work on such a kernel
> > (assuming I recompiled it from source)?
> >
> >
> Yes it will please try it out
> Thanks
> Tomas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@...
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
I'm happy to report that I have made the equivalent changes to ieee80211_sta.c
in the 2.6.25 kernel on my FC9 box and it works as expected.  I didn't do the
wpa_supplicant fix mentioned later in this thread as it didn't seem necessary in
my case.

Here's the patch I generated (which isn't conceptually different from the
previous one posted) in case anyone needs it for such a kernel:

diff -uNrp linux-2.6.25.noarch/net/mac80211/ieee80211_sta.c
kernel-2.6.25.new/linux-2.6.25.i686/net/mac80211/ieee80211_sta.c
--- linux-2.6.25.noarch/net/mac80211/ieee80211_sta.c	2008-05-23
10:23:15.000000000 -0600
+++ linux-2.6.25.noarch/net/mac80211/ieee80211_sta.c	2008-05-23
10:28:44.000000000 -0600
@@ -4035,15 +4035,15 @@ ieee80211_sta_scan_result(struct net_dev
 
 	memset(&iwe, 0, sizeof(iwe));
 	iwe.cmd = SIOCGIWFREQ;
-	iwe.u.freq.m = bss->freq;
-	iwe.u.freq.e = 6;
+	iwe.u.freq.m = ieee80211_frequency_to_channel(bss->freq);
+	iwe.u.freq.e = 0;
 	current_ev = iwe_stream_add_event(current_ev, end_buf, &iwe,
 					  IW_EV_FREQ_LEN);
 
 	memset(&iwe, 0, sizeof(iwe));
 	iwe.cmd = SIOCGIWFREQ;
-	iwe.u.freq.m = ieee80211_frequency_to_channel(bss->freq);
-	iwe.u.freq.e = 0;
+	iwe.u.freq.m = bss->freq;
+	iwe.u.freq.e = 6;
 	current_ev = iwe_stream_add_event(current_ev, end_buf, &iwe,
 					  IW_EV_FREQ_LEN);
 

Thanks for tracking this issue down!

--Dann






