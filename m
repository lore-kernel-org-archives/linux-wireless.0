Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cp-out10.libero.it ([212.52.84.110]:40012 "EHLO
	cp-out10.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957AbZC2VIx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Mar 2009 17:08:53 -0400
From: Fabio Rossi <rossi.f@inwind.it>
To: Nick Kossifidis <mickflemm@gmail.com>
Subject: Re: [PATCH 3/3] ath5k: Add tx power calibration support
Date: Sun, 29 Mar 2009 22:04:42 +0200
Cc: Nick Kossifidis <mick@madwifi-project.org>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com,
	me@bobcopeland.com, nbd@openwrt.org
References: <20090315202035.GC5246@makis> <200903292109.55033.rossi.f@inwind.it> <40f31dec0903291335j2befd3b4r1b4f4619ae634113@mail.gmail.com>
In-Reply-To: <40f31dec0903291335j2befd3b4r1b4f4619ae634113@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <200903292204.44260.rossi.f@inwind.it> (sfid-20090329_230912_806148_03050065)
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 29 March 2009, Nick Kossifidis wrote:

> I can understand how this patch may have resulted a noise floor
> calibration timeout but i can't understand how it broke everything
> else. I've tested it with a very similar card (same MAC and PHY chips
> but from a different vendor) and it worked just fine. Also i know
> there is still something more to fix for RF5112 while setting rf
> buffer settings and we have 2 curves but i don't think that's related=
=2E

I was using wireless-testing when I have experienced the problem. Then =
after=20
the bisectioning procedure I removed the entire patch solving the probl=
em with=20
the authentication-association process.

Does also your board support 802.11abg? I don't understand why the nois=
e=20
calibration process remains stuck @ 5.18GHz.

Is it possible to split your patch in shorter pieces to isolate the pro=
blem?

> > and with "modprobe -r ath5k"
> >
> > Mar 29 11:23:59 kernel: ath0: deauthenticating by local choice (rea=
son=3D3)
> > Mar 29 11:24:05 kernel: ath5k phy0: noise floor calibration timeout
> > (5180MHz) Mar 29 11:24:38 last message repeated 3 times
> > Mar 29 11:24:49 kernel: ath5k phy0: noise floor calibration timeout
> > (5180MHz)
> >
> > (I can't understand the deauthenticating line when before I don't s=
ee an
> > authenticate line). At this point it's impossible to remove the mod=
ule
> > and the execution of a top session identifies a "phy0" program whic=
h runs
> > forever with high CPU usage (I need to reboot the system)
> >
> > =C2=A0PID USER =C2=A0 =C2=A0 =C2=A0PR =C2=A0NI =C2=A0VIRT =C2=A0RES=
 =C2=A0SHR S %CPU %MEM =C2=A0 =C2=A0TIME+ =C2=A0COMMAND
> > 21548 root =C2=A0 =C2=A0 =C2=A015 =C2=A0-5 =C2=A0 =C2=A0 0 =C2=A0 =C2=
=A00 =C2=A0 =C2=A00 R 68.5 =C2=A00.0 =C2=A0 2:25.68 phy0
>
> This is even more weird, do you have an SMP system ? That warning you
> get is from the periodic calibration function, it seems you run this
> function too often...

Unfortunately I don't have a SMP system but a very old processor, an At=
hlon=20
Thunderbird 900MHz :-( I have to manually reboot the system (hardware b=
utton,=20
the software procedure doesn't work).

Tell me if you need other information, I'll test possible patches to so=
lve the=20
problem.

=46abio
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
