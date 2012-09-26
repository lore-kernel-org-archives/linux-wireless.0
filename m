Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:61786 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039Ab2IZMrj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2012 08:47:39 -0400
Received: by qadc26 with SMTP id c26so2762695qad.19
        for <linux-wireless@vger.kernel.org>; Wed, 26 Sep 2012 05:47:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJZjf_xVOKjVYYXxsWf6Z+KaTDi_3ZDqvBMyzMETfbkpWUgWFQ@mail.gmail.com>
References: <CAJZjf_wv=+HKLwnH-=rvx9h=0jEGzoCrd-a8GOW-QnXfOVgc_g@mail.gmail.com>
 <20120807102208.GA12589@redhat.com> <CAJZjf_xVOKjVYYXxsWf6Z+KaTDi_3ZDqvBMyzMETfbkpWUgWFQ@mail.gmail.com>
From: Pedro Francisco <pedrogfrancisco@gmail.com>
Date: Wed, 26 Sep 2012 13:47:18 +0100
Message-ID: <CAJZjf_xVzQmpLHd=KQ0qc77QxdpE0a7xjGTNo2Sw6BM8miwe7A@mail.gmail.com> (sfid-20120926_144744_080342_D107F710)
Subject: Re: unloading WiFi modules is usually triggering kernel crash
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: ML linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 30, 2012 at 4:58 PM, Pedro Francisco
<pedrogfrancisco@gmail.com> wrote:
> On Tue, Aug 7, 2012 at 11:22 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>> On Tue, Jul 31, 2012 at 01:54:52PM +0100, Pedro Francisco wrote:
>>> I've noticed in the past few days a pattern: sometimes nm-applet
>>> starts showing empty bars for the signal strength.
>>
>> RSSI reporting problem or maybe NM issue. When you change kernel to
>> older or newer does this problem go away ?
>>
>>> Running the script:
>>> sudo ifconfig wlan0 down; sleep 1
>>> sudo rmmod hp_wmi; sudo rmmod iwl3945; sudo rmmod iwlegacy; sudo rmmod
>>> mac80211; sudo rmmod cfg80211
>>> sleep 2; sudo rmmod rfkill; sync
>>> sudo modprobe rfkill; sudo modprobe cfg80211; sudo modprobe mac80211;
>>> sudo modprobe iwlegacy
>>> sudo modprobe iwl3945; sudo modprobe hp_wmi; sleep 1; sudo ifconfig wlan0 up
>>
>> I run a bit modified script (I do not have hp_wmi.ko and rfkill.ko) for few
>> hours, and did not get any WARNING/crash. I used 3.5, can you check if that
>> problem is also fixed on your system on 3.5 or newer.
>
> On 3.5.2-3.fc17.i686.PAE everything seems stable. The problem I had
> described hasn't happened recently.
> I guess it got fixed in the meantime.

I was wrong, got it again.

So, to recap: once the network applet shows no signal, but only then,
removing the wireless modules triggers an unrecoverable kernel panic.
I still haven't compiled a relocatable x86 kernel to get a proper
backtrace using kexec/kdump, sorry.

I found something else as well. Notice this output of "iwconfig" when
everything is _normal_:
$ iwconfig wlan0
wlan0     IEEE 802.11abg  ESSID:"eduroam"
          Mode:Managed  Frequency:2.437 GHz  Access Point: B8:62:1F:XX:XX:XX
          Bit Rate=54 Mb/s   Tx-Power=15 dBm
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Power Management:off
          Link Quality=58/70  Signal level=-52 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

When I have the "empty signal bars" issue:
$ iwconfig wlan0
wlan0     IEEE 802.11abg  ESSID:off/any
          Mode:Managed  Access Point: Not-Associated   Tx-Power=15 dBm
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Power Management:off

In case you're wondering, it is connected and streaming stuff :)

I can sometimes trigger it on purpose: I just have to roam to a 5GHz
AP of the same ESS, cycle around 2GHz and back to 5GHz (using wpa_cli
roam XX:XX:XX:XX:XX ). If I get "SME: Authentication request to the
driver failed", then disabling NetworkManager (not wireless) and
reenabling will _probably_ get the "empty signal bars" (I was just
able to trigger the "empty signal bars" now after a clean boot).
So I'm guessing something gets corrupted, which is why reloading the
modules will crash.

I'm aware due to a patch to _iwlwifi_ (not iwl3945/iwlegacy) [1] that
2->5GHz roaming is not working very well on newer Intel wireless cards
so it is worth considering it is happening here as well.

Also, note some info, collected two days ago, relative to "Invalid
misc:" is getting 10 "invalid misc" packets in 10 seconds normal?
Several 'VAL=`date`; VAL="$VAL $(iwconfig wlan0 |grep "Invalid
misc")"; echo $VAL' follow:
Seg Set 24 15:06:36 WEST 2012 Tx excessive retries:5 Invalid misc:133
Missed beacon:0
Seg Set 24 15:06:46 WEST 2012 Tx excessive retries:5 Invalid misc:143
Missed beacon:0
Seg Set 24 15:07:00 WEST 2012 Tx excessive retries:5 Invalid misc:148
Missed beacon:0
Seg Set 24 15:21:46 WEST 2012 Tx excessive retries:22 Invalid misc:495
Missed beacon:0
Seg Set 24 15:24:41 WEST 2012 Tx excessive retries:24 Invalid misc:593
Missed beacon:0


So, something is getting corrupted here. Do you want the full logs?

[1] http://thread.gmane.org/gmane.linux.kernel.wireless.general/89361/focus=89445

-- 
Pedro
