Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:46643 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497AbYCFOZu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Mar 2008 09:25:50 -0500
Received: by wa-out-1112.google.com with SMTP id v27so2258464wah.23
        for <linux-wireless@vger.kernel.org>; Thu, 06 Mar 2008 06:25:49 -0800 (PST)
Message-ID: <1ba2fa240803060625m75a98890m936dfc7e0c413540@mail.gmail.com> (sfid-20080306_142554_272089_7917D9A9)
Date: Thu, 6 Mar 2008 16:25:48 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Helge Hafting" <helgehaf@mail.aitel.hist.no>
Subject: Re: [PATCH] mac80211: fix races between siwessid and siwencode
Cc: "Helge Hafting" <helge.hafting@aitel.hist.no>,
	"Joonwoo Park" <joonwpark81@gmail.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <47CFF955.4010501@mail.aitel.hist.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1204710009-10040-1-git-send-email-joonwpark81@gmail.com>
	 <20080305094859.GA10077@ehus.geninetworks.com>
	 <47CEA5CB.6040001@aitel.hist.no>
	 <1ba2fa240803050701y57913de2s635eaf8b5e3b4f96@mail.gmail.com>
	 <47CFF955.4010501@mail.aitel.hist.no>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 6, 2008 at 4:01 PM, Helge Hafting
<helgehaf@mail.aitel.hist.no> wrote:
>
> Tomas Winkler wrote:
>  > On Wed, Mar 5, 2008 at 3:53 PM, Helge Hafting
>  > <helge.hafting@aitel.hist.no> wrote:
>  >
>  >> Joonwoo Park wrote:
>  >>  > On Wed, Mar 05, 2008 at 06:40:09PM +0900, Joonwoo Park wrote:
>  >>  >
>  >>  >> resolve: http://bughost.org/bugzilla/show_bug.cgi?id=1522
>  >>  >>
>  >>  >> The function ieee80211_ioctl_siwencode shouldn't be called if
>  >>  >> authentication process is not completed.
>  >>  >> This patch makes the ieee80211_ioctl_siwessid to wait for authentication
>  >>  >> is completed.
>  >>  >>
>  >>  >> Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
>  >>  >>
>  >>  >
>  >>  > Helge,
>  >>  >
>  >>  > Can you please try this patch?
>  >>  > I believe this patch helps your problem.
>  >>  >
>  >>  I tried it, and still have problems. The messages may be slightly different:
>  >>
>  >>  I first bring up the interface with "ifconfig wlan0 up"
>  >>  and then try "iwconfig wlan0 essid my_essid key s:password"
>  >>  over and over till it works. This gave me:
>  >>
>  >>  Initial auth_alg=0
>  >>  wlan0: authenticate with AP 00:14:1b:5e:13:40
>  >>  wlan0: authenticate with AP 00:14:1b:5e:13:40
>  >>  wlan0: authenticate with AP 00:14:1b:5e:13:40
>  >>  wlan0: authentication with AP 00:14:1b:5e:13:40 timed out
>  >>
>  >>  A total of 5 tries went wrong. The sixth time it worked, with
>  >>  different messages and a different access point.
>  >>  (There are several access points at work.)
>  >>  Initial auth_alg=0
>  >>  wlan0: authenticate with AP 00:12:7f:ce:9c:e0
>  >>  wlan0: RX authentication from 00:12:7f:ce:9c:e0 (alg=0 transaction=2
>  >>  status=0)
>  >>  wlan0: authenticated
>  >>  wlan0: associate with AP 00:12:7f:ce:9c:e0 (capab=0x431 status=0 aid=242)
>  >>  wlan0: associated
>  >>  wlan0: CTS protection enabled (BSSID=00:12:7f:ce:9c:e0)
>  >>  wlan0: switched to long barker preamble (BSSID=BSSID=00:12:7f:ce:9c:e0)
>  >>  wlan0: WMM queue=2 aci=0 acm=0 aifs=3 cWmin=15 cWmax=1023 burst=0
>  >>  wlan0: WMM queue=3 aci=1 acm=0 aifs=7 cWmin=15 cWmax=1023 burst=0
>  >>  wlan0: WMM queue=1 aci=2 acm=0 aifs=2 cWmin=7 cWmax=15 burst=30
>  >>  wlan0: WMM queue=0 aci=3 acm=0 aifs=2 cWmin=3 cWmax=7 burst=15
>  >>  wlan0: link becomes ready
>  >>
>  >>
>  >>  Only 6 attempts is an improvement, if it stays that way.  Still, the
>  >>  old ipw3945 succeeded on first try. :-/
>  >>  I hope the testing can be of help.
>  >>
>  >>  Helge Hafting
>  >>
>  >>
>  >>
>  >>
>  > Is this shared or open authentication?
>  > Do you happend to have a sniff capture of the association ?
>  I am not sure what you mean by the question.


>  This network uses WEP encryption (some users have older wireless equipment)
>  there is one essid and a single shared password that everybody uses.
>  Security is not that important, this is mostly to keep out outside bandwith
>  wasters/pirates.
>
If also authentication uses WEP key (4 way handshake) or not (2 way
handshake) only data is encrypted.
You can know this from your AP configureation

>  I do not have a sniff of this association, but I can try to sniff the
>  next time.
>  will wireshark be useful, or is some kind of wireless specific sniffer
>  needed?

That would be enough if you can give us the capture of failed
association process.

Currently mac80211 has wrong implementation of static WEP key handling
but it shows up only in certain scenarios


>
>  Helge Hafting
>
