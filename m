Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout0.freenet.de ([195.4.92.90]:39695 "EHLO mout0.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753918Ab2AJL70 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jan 2012 06:59:26 -0500
Received: from [195.4.92.140] (helo=mjail0.freenet.de)
	by mout0.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.76 #1)
	id 1RkaMN-0006cF-AW
	for linux-wireless@vger.kernel.org; Tue, 10 Jan 2012 12:59:23 +0100
Received: from localhost ([::1]:42271 helo=mjail0.freenet.de)
	by mjail0.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1RkaMN-0008Sc-6i
	for linux-wireless@vger.kernel.org; Tue, 10 Jan 2012 12:59:23 +0100
Received: from [195.4.92.20] (port=40218 helo=10.mx.freenet.de)
	by mjail0.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1RkaJl-0007d1-4r
	for linux-wireless@vger.kernel.org; Tue, 10 Jan 2012 12:56:41 +0100
Received: from p4fde00e1.dip0.t-ipconnect.de ([79.222.0.225]:34115 helo=mail.maya.org)
	by 10.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.76 #1)
	id 1RkaJk-0005cT-QT
	for linux-wireless@vger.kernel.org; Tue, 10 Jan 2012 12:56:41 +0100
Message-Id: <201201101156.q0ABuS87004643@mail.maya.org> (sfid-20120110_125929_994261_77142A57)
Date: Tue, 10 Jan 2012 12:56:28 +0100
From: Andreas Hartmann <andihartmann@01019freenet.de>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
Subject: Re: Compat-wireless-3.2-rc6-3 is broken for rt2860 device
In-Reply-To: <CAGXE3d_jW7NFnekMfwn6JPXX0xB4UWM3ttbRVLv-ZbsoMOoWEw@mail.gmail.com>
References: <4EFF12D9.3010602@01019freenet.de> <2766356.70ylY68Gqi@helmutmobil.site> <4F040FEA.3080703@01019freenet.de> <1408490.qSFZVkU7fA@helmutmobil.site> <4F0562DF.3000200@dualc.maya.org> <CAGXE3d8b5qtbhesPjRy3EXvkiwshUg0eZqcDBzb1OhKK3j6z6A@mail.gmail.com> <4F0AEBAB.9020104@01019freenet.de> <CAGXE3d-cOeTEHugbgWMoz8-Dymw0=JHxykdK4ZkBmCJZ9tSPmg@mail.gmail.com> <201201100803.q0A83nsQ003757@mail.maya.org> <CAGXE3d_jW7NFnekMfwn6JPXX0xB4UWM3ttbRVLv-ZbsoMOoWEw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Helmut Schaa schrieb:
> On Tue, Jan 10, 2012 at 9:03 AM, Andreas Hartmann
> <andihartmann@01019freenet.de> wrote:
>> Meanwhile, I took a look at the tx_path with Felix patch applied. I'm
>> getting this output:
>>
>>
>> -> netperf start
>>
>> [38139.839028] Open BA session requested for 00:25:9c:de:4e:30 tid 0
>> [38139.848151] IEEE80211_AMPDU_TX_START
>> [38139.848157] activated addBA response timer on tid 0
>> [38139.849723] switched off addBA timer for tid 0
>> [38139.849728] Aggregation is on for tid 0
>>
>> -> stall
>>
>> [38161.686305] rt2x00lib_txdone - no success - low_level_stats.dot11ACKFailureCount: 1
>> [38161.698957] rt2x00lib_txdone - no success - low_level_stats.dot11ACKFailureCount: 2
>>
>> [38161.698963] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4>
>> [38161.699116] ieee80211_check_pending_bar() -> ieee80211_send_bar() true tid: 0 failed_bar_ssn: 65040
>> [38161.710238] rt2x00lib_txdone - no success - low_level_stats.dot11ACKFailureCount: 3
>> [38161.710240] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4>
>> [38161.710394] ieee80211_check_pending_bar() -> ieee80211_send_bar() true tid: 0 failed_bar_ssn: 65040
>> [38161.724512] rt2x00lib_txdone - no success - low_level_stats.dot11ACKFailureCount: 4
>> [38161.724519] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4>
>> [38161.724659] ieee80211_check_pending_bar() -> ieee80211_send_bar() true tid: 0 failed_bar_ssn: 65040
>> [38161.735416] rt2x00lib_txdone - no success - low_level_stats.dot11ACKFailureCount: 5
>> [38161.735423] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4>
>> [38161.735486] ieee80211_check_pending_bar() -> ieee80211_send_bar() true tid: 0 failed_bar_ssn: 65040
>> [38161.747815] rt2x00lib_txdone - no success - low_level_stats.dot11ACKFailureCount: 6
>> [38161.747822] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4>
>> [38161.747888] ieee80211_check_pending_bar() -> ieee80211_send_bar() true tid: 0 failed_bar_ssn: 65040
>> [38161.755268] rt2x00lib_txdone - no success - low_level_stats.dot11ACKFailureCount: 7
>> [38161.755271] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4>
>> [38161.758823] ieee80211_check_pending_bar() -> ieee80211_send_bar() true tid: 0 failed_bar_ssn: 65040
>> [38161.772898] rt2x00lib_txdone - no success - low_level_stats.dot11ACKFailureCount: 8
>> [38161.772901] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4>
>> [38161.773049] ieee80211_check_pending_bar() -> ieee80211_send_bar() true tid: 0 failed_bar_ssn: 65040
>> [38161.789222] rt2x00lib_txdone - no success - low_level_stats.dot11ACKFailureCount: 9
>> ...
>>
>> Looks as if sending of any package is reported as broken at some
>> point of time and this circle cannot be left anymore.
> 
> Not necessarily since mac80211 will only retry the BAR if a data frame
> transmission was successful. 

Ok - this can't be seen in the trace as I just traced channel 1 - there
could be some data transfer outside of channel 1.

But if I look at the debug output, I fear, that at some point the tx is
broken completely as I can see at the beginning of each stall solely
tx failures.

> Hence, it seems as if only the BARs TX
> status is reported incorrectly ...

Seems so. Because each BAR can be seen in the trace and is responded by
the STA.

> I see two issues here:
> 1) rt2800pci seems to have problems delivering the BAR _or_ doesn't
>    report the tx status correctly

I think, that there is a problem with the tx status, as if I can see the
BAR in the trace and even the response of the STA (so the BAR was
probably ok), there really seems to be a problem with the tx status.

> 2) If the same BAR fails consecutively we should maybe really tear down
>    the BA session as it was done before
> 
> 2 is done in the below untested patch and will also work around 1.
> Mind to give it a try?

Yes :-)

The workaround patch works fine for me (at a first glance - I didn't
check for any side effects yet). The stall doesn't happen any more. But
I'm not really sure, why it works:

At the beginning, you just can see 9 tx failures. After a few tx
failures, you can see 7 BAR's, which are pending, but never passed to
ieee80211_send_bar().

- Why are they suddenly ok (are they really ok)? Or is it a logging
  problem (too much input at the same time)?


At session 38176, you can see your patch at work :-).


[27229.720767] rt2800_txdone_entry - tx failed
[27229.720791] rt2800_txdone_entry - tx failed
[27229.720800] rt2800_txdone_entry - tx failed
[27229.720807] rt2800_txdone_entry - tx failed
[27229.720814] rt2800_txdone_entry - tx failed
[27229.720821] rt2800_txdone_entry - tx failed
[27229.720828] rt2800_txdone_entry - tx failed
[27229.720835] rt2800_txdone_entry - tx failed
[27229.727130] rt2800_txdone_entry - tx failed
[27229.727133] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4> ssn: <38064>
[27229.734419] rt2800_txdone_entry - tx failed
[27229.734431] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4> ssn: <38080>
[27229.741731] rt2800_txdone_entry - tx failed
[27229.741741] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4> ssn: <38096>
[27229.749097] rt2800_txdone_entry - tx failed
[27229.749107] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4> ssn: <38112>
[27229.758136] rt2800_txdone_entry - tx failed
[27229.758143] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4> ssn: <38128>
[27229.765453] rt2800_txdone_entry - tx failed
[27229.765461] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4> ssn: <38144>
[27229.771836] rt2800_txdone_entry - tx failed
[27229.771843] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4> ssn: <38160>
[27229.779281] rt2800_txdone_entry - tx failed
[27229.779290] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4> ssn: <38176>

[27229.779315] ieee80211_check_pending_bar -> ieee80211_send_bar() retry cnt: 2 tid: 0 failed_bar_ssn: 38176
[27229.786705] rt2800_txdone_entry - tx failed
[27229.786714] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4> ssn: <38176>
[27229.793439] ieee80211_check_pending_bar -> ieee80211_send_bar() retry cnt: 1 tid: 0 failed_bar_ssn: 38176

[27229.793452] ieee80211_check_pending_bar -> ieee80211_stop_tx_ba_session() retry cnt: 0 tid: 0 failed_bar_ssn: 38176

[27229.793476] Tx BA session stop requested for 00:25:9c:11:22:33 tid 0
[27229.802082] Stopping Tx BA session for 00:25:9c:11:22:33 tid 0

[27229.807455] rt2800_txdone_entry - tx failed
[27229.807465] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4> ssn: <38176>

[27229.816023] Open BA session requested for 00:25:9c:11:22:33 tid 0
[27229.834077] activated addBA response timer on tid 0
[27229.835517] switched off addBA timer for tid 0
[27229.835522] Aggregation is on for tid 0



The following test is done with reduced debugging (without the tx
failed entries). But I can see the set_bar_pending calls without a
send_bar, too. This block is typical and comes up about 6 times a
minute (not regularly).

[29007.375460] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4> ssn: <4000>
[29007.384394] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4> ssn: <4016>
[29007.391329] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4> ssn: <4032>
[29007.398646] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4> ssn: <4048>
[29007.409470] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4> ssn: <4064>
[29007.415295] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4> ssn: <4080>
[29007.425943] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4> ssn: <4096>
[29007.439950] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4> ssn: <4112>
[29007.440041] ieee80211_check_pending_bar -> ieee80211_send_bar() retry cnt: 2 tid: 0 failed_bar_ssn: 4112
[29007.440061] ieee80211_check_pending_bar -> ieee80211_send_bar() retry cnt: 1 tid: 0 failed_bar_ssn: 4112
[29007.440071] ieee80211_check_pending_bar -> ieee80211_stop_tx_ba_session() retry cnt: 0 tid: 0 failed_bar_ssn: 4112
[29007.440100] Tx BA session stop requested for 00:25:9c:11:22:33 tid 0
[29007.447797] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4> ssn: <4112>
[29007.449024] Stopping Tx BA session for 00:25:9c:11:22:33 tid 0
[29007.461327] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4> ssn: <4112>
[29007.490023] Open BA session requested for 00:25:9c:11:22:33 tid 0
[29007.499048] activated addBA response timer on tid 0
[29007.504198] switched off addBA timer for tid 0
[29007.504203] Aggregation is on for tid 0



Thank you for your time - I really appreciate your work!
Kind regards,
Andreas
