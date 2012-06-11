Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58561 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933Ab2FKDPu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Jun 2012 23:15:50 -0400
Received: by yenm10 with SMTP id m10so2203406yen.19
        for <linux-wireless@vger.kernel.org>; Sun, 10 Jun 2012 20:15:49 -0700 (PDT)
Date: Sun, 10 Jun 2012 22:15:45 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
	=?utf-8?B?Q2FtYWxlw7Nu?= <noelamac@gmail.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Seth Forshee <seth.forshee@canonical.com>,
	Roland Vossen <rvossen@broadcom.com>
Subject: [3.2.y] Re: Brcmsmac driver woes, possible regression?
Message-ID: <20120611031544.GB3092@burratino> (sfid-20120611_051554_498866_19BFA400)
References: <CAKprTDFHmBuOorCo4evrYrNEi2-gJov0mQXQpEjoRJicfhWg=A@mail.gmail.com>
 <20120530172713.GH3908@burratino>
 <CAKprTDGtvUFSBb_XK01bi6bJa3dynu73Lq-jTs=E78E3QwSqpA@mail.gmail.com>
 <20120601174237.GA31781@burratino>
 <CAKprTDHepfbCKquvnG8CQ2=-tSNbgOSkT6R0GQmEx9UyuiZyMQ@mail.gmail.com>
 <CAKprTDHQT8Oodh_YD5CWffSGJXAg-HgFMjR0STVgEZRxH4FaSQ@mail.gmail.com>
 <20120604084200.GA30645@tiikeri.vuoristo.local>
 <20120604173121.GA9238@stt008.linux.site>
 <20120605050620.GC3118@burratino>
 <CAKprTDHGqDpdZY4ErZmPEc7Ur81GeQoH8tiAL5hrfhAE0RtbvQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAKprTDHGqDpdZY4ErZmPEc7Ur81GeQoH8tiAL5hrfhAE0RtbvQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend et al,

Quick puzzle for you.  You like puzzles, right? ;-)

As discussed at [1], Camaleón has been experiencing unwanted random
wireless reconnects with various 3.2.y kernels up to and including
3.2.19:

Camaleón wrote[3]:

>      What I get is the Network Manager window requesting for the
> password confirm, randomly. If I delay the password confirmation, the
> wireless connection drops.

Newer kernels seemed to work better than old, so I asked her to apply
the following patches agains the 3.2.y tree (the exact patches used
are at [2]):

  6b1a89afbf97 brcm80211: smac: drop "40MHz intolerant" flag from HT
               capability info
  c261bdf8acad brcm80211: smac: indicate severe problems to Mac80211
  0bf1f883fd0a brcm80211: smac: removed MPC related code
  4412953061de brcm80211: smac: removed MPC related variables
  28237002e726 brcm80211: smac: removed down-on-watchdog MPC functionality
  43ac09722f8e brcm80211: smac: removed down-on-rf-kill functionality
  a8bc4917ed6b brcm80211: smac: bugfix for tx mute in brcms_b_init()
  c6c44893c864 brcm80211: smac: fixed inconsistency in transmit mute
  2646c46d5679 brcm80211: smac: modified Mac80211 callback interface
  dc460127898c brcm80211: smac: mute transmit on ops_start
  1525662ac280 brcm80211: smac: changed check to confirm STA only support
  b7eec4233c34 brcm80211: smac: replace own access category definitions with
               mac80211 enum
  e9ca530a7b18 brcm80211: smac: don't modify sta parameters when adding sta
  8906c43cb160 brcm80211: smac: fix channel frequency
  02a588a2e3b9 brcm80211: smac: combine promiscuous mode functionality
  be667669ec01 brcm80211: smac: added support for mac80211 filter flags
 [d3f311349add brcm80211: fix usage of set tx power] --- unrelated, my mistake
  aa1f2f0a3218 brcm80211: smac: precendence bug in wlc_phy_attach()
  1570e53c14ff brcm80211: smac: fix unintended fallthru in
               wlc_phy_radio_init_2057()
  137dabed34a1 brcm80211: smac: remove smatch warnings from brcmsmac code
  2b0a53d51b5f brcm80211: smac: only print block-ack timeout message at
               trace level
  6b8da423315b brcm80211: smac: do not use US as fallback regulatory hint
  94a2ca311cf4 brcm80211: smac: only provide valid regulatory hint

The result was very nice --- the random reconnects went away.

Here comes the puzzle --- which of those patches are responsible for
the improvement?

If it is not too invasive, we would like to test the responsible patch
separately and submit it for inclusion in stable trees, hence the
question.  Incidentally, if any unrelated patches also seem like good
stable candidates, that would be interesting to hear, too.  (In other
words, a brief description of the symptoms addressed by _any_ of the
listed patches would be welcome.)

Example log of a reconnect at [3].

Thanks,
Jonathan

[1] http://thread.gmane.org/gmane.linux.kernel.wireless.general/87873
[2] http://bugs.debian.org/664767#99
[3] http://bugs.debian.org/664767#196
