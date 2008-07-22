Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:35944 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbYGVTNS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2008 15:13:18 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [RFC/RFT] rtl8187: Improve wireless statistics for RTL8187B
Date: Tue, 22 Jul 2008 16:13:34 -0300
Cc: "Hin-Tak Leung" <hintak.leung@gmail.com>,
	Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org
References: <487f5f20.2lT57D3i0q99wrfY%Larry.Finger@lwfinger.net> <3ace41890807191739t5969f38au170e4b73a3d0b7de@mail.gmail.com> <4882A910.4040408@lwfinger.net>
In-Reply-To: <4882A910.4040408@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200807221613.34434.herton@mandriva.com.br> (sfid-20080722_211322_347157_DC30CDCB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Em Saturday 19 July 2008 23:55:12 Larry Finger escreveu:
> Hin-Tak Leung wrote:
> > I am on x86_64 and I am on a similar situation - I am using the
> > rawhide kernels from:
> > http://koji.fedoraproject.org/koji/packageinfo?packageID=8
> > and the last one that worked for me is kernel-2.6.25.11-92.fc9 -
> > something in kernel-2.6.25.11-93.fc9 broke connectivity. Apparently the
> > difference is this set of changes:
> > http://marc.info/?l=linux-wireless&m=121606436000705&w=2
> >
> > I just don't feel like mentioning it earlier because I had mistakenly
> > complained about Herton's
> > last patch and I don't want to make the same mistake - and I did test
> > it. Beside Herton's
> >  ANAPARAM*_OFF patch (which I don't think is the source of the
> > problem), there is
> > only one other "rtl8187: Fixed section mismatch in rtl8187_dev.c"
> > change - but that's is also
> > obviously right, and besides, its nature shouldn't affect association
> > anyway; but there is
> > a lot of mac80211 changes elsewhere, and I wonder.
> >
> > My symptom is that I can authenticate and associate (apparently,
> > according to dmesg)
> > but cannot get an ip address via dhcp. I have tried and just alternate
> > between the two kernels,
> > identical steps, etc and one works and the other doesn't.
>
> Curious. According to the git log, my copy of the wireless-testing tree has
> all those patches installed. There must be some really obscure
> configuration difference, or the rawhide kernel has some unexpected
> difference with the wl kernels.

I got some time to take at a look at it again, I did the bisect and found 
commit 8f87dd7e540d455f8e7f11478133b85edc969c67 ("mac80211: power management 
wext hooks") to cause the issue here (non working interface). But with it, 
making "iwconfig wlan* power off" and making interface go up again, it starts 
to work. May be something related to the power management needs to be 
implemented in driver now? or keep it disabled with rtl8187...

>
> Larry
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
> in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
[]'s
Herton
