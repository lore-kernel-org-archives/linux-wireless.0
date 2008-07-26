Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:51868 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbYGZN0t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jul 2008 09:26:49 -0400
Received: by wf-out-1314.google.com with SMTP id 27so4702649wfd.4
        for <linux-wireless@vger.kernel.org>; Sat, 26 Jul 2008 06:26:48 -0700 (PDT)
Message-ID: <3ace41890807260626x925b6b8h90f85dd91b24b4d5@mail.gmail.com> (sfid-20080726_152652_825435_8429FCA3)
Date: Sat, 26 Jul 2008 14:26:48 +0100
From: "Hin-Tak Leung" <hintak.leung@gmail.com>
To: "Herton Ronaldo Krzesinski" <herton@mandriva.com.br>
Subject: mac80211 power management breakage?(was Re: Commit 741b4fbc44 (mac80211: fix TX sequence numbers) breaks rtl8187)
Cc: "Larry Finger" <Larry.Finger@lwfinger.net>,
	"Pavel Roskin" <proski@gnu.org>,
	wireless <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 25, 2008 at 5:36 PM, Herton Ronaldo Krzesinski
<herton@mandriva.com.br> wrote:
<snipped>
> The patch didn't help, but I reached a set of commands where I'm always able
> to reproduce the problem, I found out that is the order of commands that
> makes the issue happen here:
>
> [1] /sbin/ip link set dev wlan0 down
> [2] /sbin/ip link set dev wlan0 up
> [3] /sbin/iwconfig wlan0 power on
> [4] /sbin/iwconfig wlan0 essid any
> [5] /sbin/iwconfig wlan0 power on
> [6] /sbin/iwconfig wlan0 essid <my AP>
> [7] /sbin/iwconfig wlan0 key open <my key>
>
> With these commands the interface doesn't associate with AP.
> If I remove only command 3, I still can't associate.
> If I remove only command 4, no problems.
> If I remove only command 5, no problems.
>
> So it seems there is a bug when trying to do a "power on" after "essid <key>"
> command, are you able to reproduce this too?

- I have added linux-wireless back to CC:, since I have reproduced the
problem you saw,
exactly as you described. (you mean "power on after essid <any>" is
problematic, I think)

I have also had a look at the code and while I don't understand most
of it, I thought maybe
I have a guess of how adding power management wext hooks can break association.
What the power management hooks + enabling power management does, is
to buffer for up to
STA_MAX_TX_BUFFER frames of certain types; also, if a iwconfig essid
<any> is issued before
iwconfig essid <some_ap>, the <any> result is cached for look-up, I
think. so the 3 situations you out-lined are this:

-use a lot of frames to find any APs, (power saving on, start
buffering)  send a small number of frames to
associate with one among the known APs but these frames are buffered,
so no association

- (power saving on, start buffering), use a lot of frames to find any
APs, a few more to associate to one.

- (power saving on, start buffering), doesn't know any APs, so use a
lot of frames to find a particular one.

Does this make sense, or am I talking nonsense? In any case, there is
a MAC80211_VERBOSE_PS_DEBUG
in net/mac80211/tx.c,  which should be relevant.

Hin-Tak
