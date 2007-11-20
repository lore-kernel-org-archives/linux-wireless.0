Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.180]:23241 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762080AbXKTWs5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2007 17:48:57 -0500
Received: by py-out-1112.google.com with SMTP id u77so6809657pyb
        for <linux-wireless@vger.kernel.org>; Tue, 20 Nov 2007 14:48:56 -0800 (PST)
Message-ID: <43e72e890711201448k54bd4d64kaf9887de83f07def@mail.gmail.com> (sfid-20071120_224916_523594_48777700)
Date: Tue, 20 Nov 2007 17:48:55 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Francesco Gringoli" <francesco.gringoli@ing.unibs.it>
Subject: Re: ath5k driver on MIPS and low level control over the hw
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <E7E9AC02-E136-48B7-8E39-3419B36B6575@ing.unibs.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <E7E9AC02-E136-48B7-8E39-3419B36B6575@ing.unibs.it>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Nov 20, 2007 8:17 AM, Francesco Gringoli
<francesco.gringoli@ing.unibs.it> wrote:
> Hello everybody,
>
> I have been following the ath5k project for a while hoping that the
> new driver could sort out the speed issue that afflicts the MIPS
> platform I am using: I'm involved in a performance evaluation task
> and I need to hack the kernel in such a way that frames are created
> from a task running in kernel space and sent directly to the device
> without passing through the traditional network stack. Clearly I
> cannot deal with a closed binary.
>
> After a small effort to have 2.6.24-rc2 booting up and running
> without problems on my MIPS boards (Mikrotik RB133), I finally added
> the ath5k driver and everything went fine: the driver is usable also
> on these MIPS boards, wlan0 network is up and everything work, I can
> join a test network without using encryption, still have not tested
> with WEP.

Francesco, WEP doesn't work yet. I had issues with it at least when I
tested that code path. I've seen a few people reporting already issues
with it as if it did work. I shall patch this to let users know it
doesn't work -- we should let it through only if it works.

> I did some tests and I see that setting up filters properly I can
> also see ACKs, RTSs and all other stuff.

Thanks for reporting this. Glad to know its working.

> I have now a few questions
>
> - is it possible to (e.g. does anybody ever succeeded to) ask the hw
> to transmit a skb-encoded frame with arbitrary content? I mean, is it
> possible to disable CSMA/CA mechanism, call ath5k_txbuf_setup() and
> let the hw to not check if a frame is actually received by someone?

Should be possible, yes. I'd poke with this:

>From ath5k.h:

/* Register for RSSI threshold has a mask of 0xff, so 255 seems to
 * be the max value. */
#define AR5K_TUNE_RSSI_THRES                   129
/* This must be set when setting the RSSI threshold otherwise it can
 * prevent a reset. If AR5K_RSSI_THR is read after writing to it
 * the BMISS_THRES will be seen as 0, seems harware doesn't keep
 * track of it. Max value depends on harware. For AR5210 this is just 7.
 * For AR5211+ this seems to be up to 255. */
#define AR5K_TUNE_BMISS_THRES                  7

>From reg.h:

/*
 * RSSI threshold register
 */
#define AR5K_RSSI_THR                   0x8018          /* Register Address */
#define AR5K_RSSI_THR_M                 0x000000ff      /* Mask for
RSSI threshold [5211+] */
#define AR5K_RSSI_THR_BMISS_5210        0x00000700      /* Mask for
Beacon Missed threshold [5210] */
#define AR5K_RSSI_THR_BMISS_5210_S      8
#define AR5K_RSSI_THR_BMISS_5211        0x0000ff00      /* Mask for
Beacon Missed threshold [5211+] */
#define AR5K_RSSI_THR_BMISS_5211_S      8
#define AR5K_RSSI_THR_BMISS             (ah->ah_version == AR5K_AR5210 ? \
                                        AR5K_RSSI_THR_BMISS_5210 :
AR5K_RSSI_THR_BMISS_5211)
#define AR5K_RSSI_THR_BMISS_S           8

But I haven't tested it myself yet. If I test or find something more
useful I'll let you know.

> - how is it implemented the rate control in the ath5k driver?

mac80211 drivers follow the rate control algorithms designed for
mac80211. So the right question is how is rate control implemented on
mac80211. For that please see net/mac80211/rc80211_simple.c. Its our
only algorithm so far. I'd be nice to get minstrel ported to mac80211.
I believe a few people have said they were going to try.

> I see
> that if a force 54M rate and the channel does not allow (e.g. noise
> due to other BSs in the same channel) this rate the driver takes a
> long time to switch to a lower rate (and usually it switches to 1Mb/s)

rc80211_simple.c starts off at the lowest rate on
rate_control_simple_rate_init() as a workaround for it not yet using
the RSSI from previous packets as 802.1x auth is required immediately
after association. Until that is not fixed we start off at 1Mbps.
Please note that as Nick pointed out we are still having issues with
higher rates. I'd only rely up to 11Mbps for now.

> - I'm not using the wireless git branch but the standard development
> 2.6.24-rc2 code with ath5k added in driver/net/wireless: I suppose
> that this is ok because I have no problems with the net/mac80211 part
> coming with the standard kernel but if someone is aware of changes in
> this part, please let me now.

With ath5k I'd try to stick to the latest as the driver is getting
patched heavily. I understand this is a pain specially if your machine
is slow. A possible workaround is to use the compatibility package
with your local git clone to pull updates from:

http://linuxwireless.org/en/users/Download

Although this intended for older kernels this also lets you keep
updating the sources from your local git tree so you can *just*
compile mac80211 and necessary mac80211 drivers out-of-kernel. You can
change the git tree directory it expects in scripts/admin-update.sh,
on the GIT_TREE variable. By default it assumes you'll use:

/home/$USER/devel/wireless-2.6

This is what I do for slow machines right now instead of cross-compiling.

  Luis
