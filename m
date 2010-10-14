Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:19311 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754807Ab0JNHtW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 03:49:22 -0400
Received: from vs3016.wh2.ocn.ne.jp (125.206.180.189)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 1-0522722559
	for <linux-wireless@vger.kernel.org>; Thu, 14 Oct 2010 16:49:20 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Qasim Javed <qasimj@gmail.com>
Subject: Re: [ath5k-devel] How to profile this strange effect under high load?
Date: Thu, 14 Oct 2010 16:49:30 +0900
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	ath5k-devel@lists.ath5k.org, Bob Copeland <me@bobcopeland.com>,
	Nick Kossifidis <mickflemm@gmail.com>
References: <201010121933.59209.br1@einfach.org> <AANLkTin3eFFnVS5e1uK=-jmA3iC4qqfBLWkt0KFexYDg@mail.gmail.com>
In-Reply-To: <AANLkTin3eFFnVS5e1uK=-jmA3iC4qqfBLWkt0KFexYDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201010141649.30818.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed October 13 2010 02:14:19 Qasim Javed wrote:
> How about using trace-cmd and kernelshark with function graph tracer
> to see what is getting called so often?
> 
> -Qasim
> 
> On Tue, Oct 12, 2010 at 5:33 AM, Bruno Randolf <br1@einfach.org> wrote:
> > Hello!
> > 
> > I am trying to debug a strange effect, I am seeing on soekris net48xx
> > boards with two ath5k interfaces:
> > 
> >  * wlan0 [phy0] configured in ad-hoc mode, A band, and it is getting a
> > lot of traffic routed thru it
> >  * wlan1 [phy1] also configured in ad-hoc mode, G band, but not actively
> > sending (no IP address).
> > 
> > I run iperf between two PCs attached by ethernet, UDP 25Mbps and I am
> > sure all traffic is routed thru wlan0 (phy0). The load on the SENDING
> > box gets very high:
> > 
> > Mem: 27304K used, 99040K free, 0K shrd, 616K buff, 14128K cached
> > CPU:   0% usr   0% sys   0% nic   0% idle   0% io   5% irq  93% sirq
> > Load average: 1.73 1.01 2.23 2/38 3128
> >  PID  PPID USER     STAT   VSZ %MEM %CPU COMMAND
> >  2772     2 root     RW       0   0%  71% [phy1]
> >  2757     2 root     SW       0   0%  11% [phy0]
> >  3128   436 root     R      988   1%   8% top
> >    3     2 root     SW       0   0%   5% [ksoftirqd/0]
> >    5     2 root     SW       0   0%   3% [events/0]
> >   56     2 root     SW       0   0%   1% [bdi-default]
> >  1383     1 root     S     1824   1%   0% /usr/bin/oprofiled
> > --session-dir=/r
> > 
> > ...and the interesting thing is that [phy1] - the INACTIVE interface -
> > consumes much more CPU time than [phy0] which is actually transmitting.
> > 
> > I have disabled ANI on wlan1, to avoid getting many MIB interrupts, but
> > it does not change much.
> > 
> > I have dumped frames on phy1, and all it sees are a few beacon frames.
> > 
> > I have tried wlan1 in managed mode - same effect. The effect is slightly
> > less in AP mode, though...
> > 
> > I tried oprofile, but it shows mostly tx related things.
> > 
> > So my question is: How can I find out, what [phy1] is so busy doing? Any
> > ideas how to profile this?

Thanks for your suggestions.

I think, I was able to get a hold of this using the Ftrace function tracer. 
What is happening, is that received beacons get queued up by mac80211 
(ieee80211_queue_work) and then the work queue (ieee80211_rx_mgmt_beacon) has 
many beacons to process. If we are running late, the funny thing is that most 
of these beacons in the queue will be irrelevant because they are too old. 
Obviously there is room for optimization here.

Also another effect which I think adds to the high CPU utilization of the 
[phy1] process is that functions running in interrupt context are run "at the 
expense" of the process which has been interrupted. So if [phy1] work has been 
interrupted by a TX completed interrupt of phy0 it will be accounted to 
[phy1].

Here is some output of ftrace, which shows my first point:

       phy1-1089  [000]   594.942525: ieee80211_rx_mgmt_beacon <-
ieee80211_ibss_work
       phy1-1089  [000]   594.986019: ieee80211_queue_work <-
ieee80211_ibss_rx_mgmt
       phy1-1089  [000]   595.030190: ieee80211_queue_work <-
ieee80211_ibss_rx_mgmt
       phy1-1089  [000]   595.088663: ieee80211_queue_work <-
ieee80211_ibss_rx_mgmt
       phy1-1089  [000]   595.131842: ieee80211_queue_work <-
ieee80211_ibss_rx_mgmt
        top-1284  [000]   595.195661: ieee80211_queue_work <-
ieee80211_ibss_rx_mgmt
        top-1284  [000]   595.195812: ieee80211_queue_work <-
ieee80211_ibss_rx_mgmt
        top-1284  [000]   595.241381: ieee80211_queue_work <-
ieee80211_ibss_rx_mgmt
        top-1284  [000]   595.307445: ieee80211_queue_work <-
ieee80211_ibss_rx_mgmt
        top-1284  [000]   595.328727: ieee80211_queue_work <-
ieee80211_ibss_rx_mgmt
       phy0-1075  [000]   595.328935: ieee80211_rx_mgmt_beacon <-
ieee80211_ibss_work
       phy0-1075  [000]   595.329223: ieee80211_queue_work <-
ieee80211_ibss_timer
       phy0-1075  [000]   595.395654: ieee80211_queue_work <-
ieee80211_ibss_rx_mgmt
       phy0-1075  [000]   595.395784: ieee80211_queue_work <-
ieee80211_ibss_rx_mgmt
       phy0-1075  [000]   595.440385: ieee80211_queue_work <-
ieee80211_ibss_rx_mgmt
ksoftirqd/0-3     [000]   595.544013: ieee80211_queue_work <-
ieee80211_ibss_rx_mgmt
ksoftirqd/0-3     [000]   595.614735: ieee80211_queue_work <-
ieee80211_ibss_rx_mgmt
ksoftirqd/0-3     [000]   595.633631: ieee80211_queue_work <-
ieee80211_ibss_rx_mgmt
       phy1-1089  [000]   595.642036: ieee80211_rx_mgmt_beacon <-
ieee80211_ibss_work
       phy1-1089  [000]   595.642122: ieee80211_rx_mgmt_beacon <-
ieee80211_ibss_work
       phy1-1089  [000]   595.642173: ieee80211_rx_mgmt_beacon <-
ieee80211_ibss_work
       phy1-1089  [000]   595.642280: ieee80211_rx_mgmt_beacon <-
ieee80211_ibss_work
       phy1-1089  [000]   595.642334: ieee80211_rx_mgmt_beacon <-
ieee80211_ibss_work
       phy1-1089  [000]   595.642385: ieee80211_rx_mgmt_beacon <-
ieee80211_ibss_work
       phy1-1089  [000]   595.642437: ieee80211_rx_mgmt_beacon <-
ieee80211_ibss_work
       phy1-1089  [000]   595.642491: ieee80211_rx_mgmt_beacon <-
ieee80211_ibss_work
       phy1-1089  [000]   595.642553: ieee80211_rx_mgmt_beacon <-
ieee80211_ibss_work
       phy1-1089  [000]   595.642608: ieee80211_rx_mgmt_beacon <-
ieee80211_ibss_work
       phy1-1089  [000]   595.642660: ieee80211_rx_mgmt_beacon <-
ieee80211_ibss_work
       phy1-1089  [000]   595.642738: ieee80211_rx_mgmt_beacon <-
ieee80211_ibss_work
       phy1-1089  [000]   595.642805: ieee80211_rx_mgmt_beacon <-
ieee80211_ibss_work

Thanks for listening... ;)

Bruno
