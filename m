Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52634 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755731Ab2AJMXB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jan 2012 07:23:01 -0500
Received: by dajs34 with SMTP id s34so2780040daj.19
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jan 2012 04:23:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201201101156.q0ABuS87004643@mail.maya.org>
References: <4EFF12D9.3010602@01019freenet.de>
	<2766356.70ylY68Gqi@helmutmobil.site>
	<4F040FEA.3080703@01019freenet.de>
	<1408490.qSFZVkU7fA@helmutmobil.site>
	<4F0562DF.3000200@dualc.maya.org>
	<CAGXE3d8b5qtbhesPjRy3EXvkiwshUg0eZqcDBzb1OhKK3j6z6A@mail.gmail.com>
	<4F0AEBAB.9020104@01019freenet.de>
	<CAGXE3d-cOeTEHugbgWMoz8-Dymw0=JHxykdK4ZkBmCJZ9tSPmg@mail.gmail.com>
	<201201100803.q0A83nsQ003757@mail.maya.org>
	<CAGXE3d_jW7NFnekMfwn6JPXX0xB4UWM3ttbRVLv-ZbsoMOoWEw@mail.gmail.com>
	<201201101156.q0ABuS87004643@mail.maya.org>
Date: Tue, 10 Jan 2012 13:23:00 +0100
Message-ID: <CAGXE3d9usjQB+9jkBPgtvL6fT8L84ZzDQQ3UqHyMdb+PRfhrKA@mail.gmail.com> (sfid-20120110_132306_388800_E5C29571)
Subject: Re: Compat-wireless-3.2-rc6-3 is broken for rt2860 device
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Andreas Hartmann <andihartmann@01019freenet.de>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 10, 2012 at 12:56 PM, Andreas Hartmann
<andihartmann@01019freenet.de> wrote:
> I think, that there is a problem with the tx status, as if I can see the
> BAR in the trace and even the response of the STA (so the BAR was
> probably ok), there really seems to be a problem with the tx status.
>
>> 2) If the same BAR fails consecutively we should maybe really tear down
>>    the BA session as it was done before
>>
>> 2 is done in the below untested patch and will also work around 1.
>> Mind to give it a try?
>
> Yes :-)
>
> The workaround patch works fine for me (at a first glance - I didn't
> check for any side effects yet). The stall doesn't happen any more. But
> I'm not really sure, why it works:
>
> At the beginning, you just can see 9 tx failures.

This is most likely a complete AMPDU that failed.

> After a few tx
> failures, you can see 7 BAR's, which are pending, but never passed to
> ieee80211_send_bar().

The BAR for each failed AMPDU subframe is sent by mac80211.

> - Why are they suddenly ok (are they really ok)? Or is it a logging
>  problem (too much input at the same time)?
>
>
> At session 38176, you can see your patch at work :-).
>
>
> [27229.720767] rt2800_txdone_entry - tx failed
> [27229.720791] rt2800_txdone_entry - tx failed
> [27229.720800] rt2800_txdone_entry - tx failed
> [27229.720807] rt2800_txdone_entry - tx failed
> [27229.720814] rt2800_txdone_entry - tx failed
> [27229.720821] rt2800_txdone_entry - tx failed
> [27229.720828] rt2800_txdone_entry - tx failed
> [27229.720835] rt2800_txdone_entry - tx failed
> [27229.727130] rt2800_txdone_entry - tx failed
> [27229.727133] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4> ssn: <38064>
> [27229.734419] rt2800_txdone_entry - tx failed
> [27229.734431] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4> ssn: <38080>
> [27229.741731] rt2800_txdone_entry - tx failed
> [27229.741741] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4> ssn: <38096>
> [27229.749097] rt2800_txdone_entry - tx failed
> [27229.749107] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4> ssn: <38112>
> [27229.758136] rt2800_txdone_entry - tx failed
> [27229.758143] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4> ssn: <38128>
> [27229.765453] rt2800_txdone_entry - tx failed
> [27229.765461] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4> ssn: <38144>
> [27229.771836] rt2800_txdone_entry - tx failed
> [27229.771843] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4> ssn: <38160>
> [27229.779281] rt2800_txdone_entry - tx failed
> [27229.779290] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4> ssn: <38176>
>
> [27229.779315] ieee80211_check_pending_bar -> ieee80211_send_bar() retry cnt: 2 tid: 0 failed_bar_ssn: 38176
> [27229.786705] rt2800_txdone_entry - tx failed
> [27229.786714] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4> ssn: <38176>
> [27229.793439] ieee80211_check_pending_bar -> ieee80211_send_bar() retry cnt: 1 tid: 0 failed_bar_ssn: 38176
>
> [27229.793452] ieee80211_check_pending_bar -> ieee80211_stop_tx_ba_session() retry cnt: 0 tid: 0 failed_bar_ssn: 38176
>
> [27229.793476] Tx BA session stop requested for 00:25:9c:11:22:33 tid 0
> [27229.802082] Stopping Tx BA session for 00:25:9c:11:22:33 tid 0
>
> [27229.807455] rt2800_txdone_entry - tx failed
> [27229.807465] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4> ssn: <38176>
>
> [27229.816023] Open BA session requested for 00:25:9c:11:22:33 tid 0
> [27229.834077] activated addBA response timer on tid 0
> [27229.835517] switched off addBA timer for tid 0
> [27229.835522] Aggregation is on for tid 0
>
>
>
> The following test is done with reduced debugging (without the tx
> failed entries). But I can see the set_bar_pending calls without a
> send_bar, too. This block is typical and comes up about 6 times a
> minute (not regularly).
>
> [29007.375460] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4> ssn: <4000>
> [29007.384394] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4> ssn: <4016>
> [29007.391329] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4> ssn: <4032>
> [29007.398646] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4> ssn: <4048>
> [29007.409470] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4> ssn: <4064>
> [29007.415295] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4> ssn: <4080>
> [29007.425943] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4> ssn: <4096>
> [29007.439950] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4> ssn: <4112>
> [29007.440041] ieee80211_check_pending_bar -> ieee80211_send_bar() retry cnt: 2 tid: 0 failed_bar_ssn: 4112
> [29007.440061] ieee80211_check_pending_bar -> ieee80211_send_bar() retry cnt: 1 tid: 0 failed_bar_ssn: 4112
> [29007.440071] ieee80211_check_pending_bar -> ieee80211_stop_tx_ba_session() retry cnt: 0 tid: 0 failed_bar_ssn: 4112
> [29007.440100] Tx BA session stop requested for 00:25:9c:11:22:33 tid 0
> [29007.447797] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4> ssn: <4112>
> [29007.449024] Stopping Tx BA session for 00:25:9c:11:22:33 tid 0
> [29007.461327] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4> ssn: <4112>
> [29007.490023] Open BA session requested for 00:25:9c:11:22:33 tid 0
> [29007.499048] activated addBA response timer on tid 0
> [29007.504198] switched off addBA timer for tid 0
> [29007.504203] Aggregation is on for tid 0

The BAR will only be resent after the next successful AMPDU transmission. And if
this BAR transmission fails 3 times the session will be shut down (and restarted
later).

So this looks good to me although the broken tx status for BAR frames
is for sure
a rt2800pci problem (or even a hw issue).

Helmut
