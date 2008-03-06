Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from embla.aitel.hist.no ([158.38.50.22]:34952 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764384AbYCFOE0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Mar 2008 09:04:26 -0500
Message-ID: <47CFF955.4010501@mail.aitel.hist.no> (sfid-20080306_140500_224709_817F81E4)
Date: Thu, 06 Mar 2008 15:01:57 +0100
From: Helge Hafting <helgehaf@mail.aitel.hist.no>
MIME-Version: 1.0
To: Tomas Winkler <tomasw@gmail.com>
CC: Helge Hafting <helge.hafting@aitel.hist.no>,
	Joonwoo Park <joonwpark81@gmail.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: fix races between siwessid and siwencode
References: <1204710009-10040-1-git-send-email-joonwpark81@gmail.com>	 <20080305094859.GA10077@ehus.geninetworks.com>	 <47CEA5CB.6040001@aitel.hist.no> <1ba2fa240803050701y57913de2s635eaf8b5e3b4f96@mail.gmail.com>
In-Reply-To: <1ba2fa240803050701y57913de2s635eaf8b5e3b4f96@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tomas Winkler wrote:
> On Wed, Mar 5, 2008 at 3:53 PM, Helge Hafting
> <helge.hafting@aitel.hist.no> wrote:
>   
>> Joonwoo Park wrote:
>>  > On Wed, Mar 05, 2008 at 06:40:09PM +0900, Joonwoo Park wrote:
>>  >
>>  >> resolve: http://bughost.org/bugzilla/show_bug.cgi?id=1522
>>  >>
>>  >> The function ieee80211_ioctl_siwencode shouldn't be called if
>>  >> authentication process is not completed.
>>  >> This patch makes the ieee80211_ioctl_siwessid to wait for authentication
>>  >> is completed.
>>  >>
>>  >> Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
>>  >>
>>  >
>>  > Helge,
>>  >
>>  > Can you please try this patch?
>>  > I believe this patch helps your problem.
>>  >
>>  I tried it, and still have problems. The messages may be slightly different:
>>
>>  I first bring up the interface with "ifconfig wlan0 up"
>>  and then try "iwconfig wlan0 essid my_essid key s:password"
>>  over and over till it works. This gave me:
>>
>>  Initial auth_alg=0
>>  wlan0: authenticate with AP 00:14:1b:5e:13:40
>>  wlan0: authenticate with AP 00:14:1b:5e:13:40
>>  wlan0: authenticate with AP 00:14:1b:5e:13:40
>>  wlan0: authentication with AP 00:14:1b:5e:13:40 timed out
>>
>>  A total of 5 tries went wrong. The sixth time it worked, with
>>  different messages and a different access point.
>>  (There are several access points at work.)
>>  Initial auth_alg=0
>>  wlan0: authenticate with AP 00:12:7f:ce:9c:e0
>>  wlan0: RX authentication from 00:12:7f:ce:9c:e0 (alg=0 transaction=2
>>  status=0)
>>  wlan0: authenticated
>>  wlan0: associate with AP 00:12:7f:ce:9c:e0 (capab=0x431 status=0 aid=242)
>>  wlan0: associated
>>  wlan0: CTS protection enabled (BSSID=00:12:7f:ce:9c:e0)
>>  wlan0: switched to long barker preamble (BSSID=BSSID=00:12:7f:ce:9c:e0)
>>  wlan0: WMM queue=2 aci=0 acm=0 aifs=3 cWmin=15 cWmax=1023 burst=0
>>  wlan0: WMM queue=3 aci=1 acm=0 aifs=7 cWmin=15 cWmax=1023 burst=0
>>  wlan0: WMM queue=1 aci=2 acm=0 aifs=2 cWmin=7 cWmax=15 burst=30
>>  wlan0: WMM queue=0 aci=3 acm=0 aifs=2 cWmin=3 cWmax=7 burst=15
>>  wlan0: link becomes ready
>>
>>
>>  Only 6 attempts is an improvement, if it stays that way.  Still, the
>>  old ipw3945 succeeded on first try. :-/
>>  I hope the testing can be of help.
>>
>>  Helge Hafting
>>
>>
>>
>>     
> Is this shared or open authentication?
> Do you happend to have a sniff capture of the association ?
I am not sure what you mean by the question.
This network uses WEP encryption (some users have older wireless equipment)
there is one essid and a single shared password that everybody uses.
Security is not that important, this is mostly to keep out outside bandwith
wasters/pirates.

I do not have a sniff of this association, but I can try to sniff the 
next time.
will wireshark be useful, or is some kind of wireless specific sniffer 
needed?


Helge Hafting
