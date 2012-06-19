Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:33325 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802Ab2FSSP2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jun 2012 14:15:28 -0400
Received: by gglu4 with SMTP id u4so4923784ggl.19
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jun 2012 11:15:27 -0700 (PDT)
Date: Tue, 19 Jun 2012 13:15:22 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	=?utf-8?B?Q2FtYWxlw7Nu?= <noelamac@gmail.com>,
	Arend van Spriel <arend@broadcom.com>,
	Seth Forshee <seth.forshee@canonical.com>,
	Roland Vossen <rvossen@broadcom.com>
Subject: Re: [3.2.y] Re: Brcmsmac driver woes, possible regression?
Message-ID: <20120619181522.GB19354@burratino> (sfid-20120619_201532_244545_4FB1D3CD)
References: <20120530172713.GH3908@burratino>
 <CAKprTDGtvUFSBb_XK01bi6bJa3dynu73Lq-jTs=E78E3QwSqpA@mail.gmail.com>
 <20120601174237.GA31781@burratino>
 <CAKprTDHepfbCKquvnG8CQ2=-tSNbgOSkT6R0GQmEx9UyuiZyMQ@mail.gmail.com>
 <CAKprTDHQT8Oodh_YD5CWffSGJXAg-HgFMjR0STVgEZRxH4FaSQ@mail.gmail.com>
 <20120604084200.GA30645@tiikeri.vuoristo.local>
 <20120604173121.GA9238@stt008.linux.site>
 <20120605050620.GC3118@burratino>
 <CAKprTDHGqDpdZY4ErZmPEc7Ur81GeQoH8tiAL5hrfhAE0RtbvQ@mail.gmail.com>
 <20120611031544.GB3092@burratino>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20120611031544.GB3092@burratino>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi again,

Jonathan Nieder wrote:

> As discussed at [1], Camaleón has been experiencing unwanted random
> wireless reconnects with various 3.2.y kernels up to and including
> 3.2.19:

This was first reproduced on a kernel closely based on 3.2.9.  It
would typically happen pretty reliably once a day or so.  Four days of
testing a kernel close to 3.2.2 haven't triggered it again[1].

The only brcm80211 change in that range is

  f96b08a7e6f6 brcmsmac: fix tx queue flush infinite loop

So maybe the timeout is too short and this safety is tripping when it
shouldn't.  I've asked Camaleón to try a recent 3.2.y kernel with and
without that commit reverted to test this guess.

That leaves another mystery: which of the 22 changes listed at [2] was
providing relief in earlier tests?  E.g., does

>   c261bdf8acad brcm80211: smac: indicate severe problems to Mac80211

make it easier to recover from this kind of error?  Are there commands
we should run or diagnostics to try to get a better sense of what is
going on?

Grasping at straws,
Jonathan

[1] http://bugs.debian.org/cgi-bin/bugreport.cgi?msg=220;bug=664767
[2] http://thread.gmane.org/gmane.linux.kernel.wireless.general/92452
