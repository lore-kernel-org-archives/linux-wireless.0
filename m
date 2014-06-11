Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:47849 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633AbaFKALI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jun 2014 20:11:08 -0400
Received: from [192.168.100.236] (firewall.candelatech.com [70.89.124.249])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by mail2.candelatech.com (Postfix) with ESMTPSA id 04F3C40A9E6
	for <linux-wireless@vger.kernel.org>; Tue, 10 Jun 2014 17:11:06 -0700 (PDT)
Message-ID: <53979E9A.5010308@candelatech.com> (sfid-20140611_021112_924498_3EDA6F62)
Date: Tue, 10 Jun 2014 17:11:06 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: More confusion with regulatory issues.
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


I have a Fedora 19 system with two ath10k NICs in them.  I'm not sure
they have any regulatory info in them at all, based on logs
and some poking at what firmware reports.

I have /etc/sysconfig/regdomain set to:

COUNTRY=US

I am configuring the country-code as US in the hostapd.

I installed the latest regulatory.bin, downloaded and built today.

And still, it shows up as 'country 98' and DFS-UNSET,
which keeps DFS from working, evidently.

[root@ath10k-2220 lanforge]# iw reg get
country 98: DFS-UNSET
	(2402 - 2472 @ 70), (N/A, 20)
	(2457 - 2472 @ 70), (N/A, 20), PASSIVE-SCAN
	(5170 - 5250 @ 80), (N/A, 17), PASSIVE-SCAN
	(5250 - 5330 @ 80), (N/A, 20), DFS, PASSIVE-SCAN
	(5735 - 5835 @ 80), (N/A, 20), PASSIVE-SCAN
	(57240 - 63720 @ 2160), (N/A, 0)

Another Fedora 17 system, with ath10k and ath9k (hacked to use regdomain 0)
NIC shows up as more what I expected, using slightly older regulatory.bin:

[root@ct523-9292 ~]# iw reg get
country US:
	(2402 - 2472 @ 40), (N/A, 30)
	(5170 - 5250 @ 80), (N/A, 17)
	(5250 - 5330 @ 80), (N/A, 23), DFS
	(5735 - 5835 @ 80), (N/A, 30)
	(57240 - 63720 @ 2160), (N/A, 40)
[root@ct523-9292 ~]#


I just want to start hostapd on a DFS channel for some testing...any
idea what is making the regulatory domain weird?  Could it actually
be coming from ath10k somehow?


[root@ath10k-2220 lanforge]# dmesg|grep cfg80211
[    6.059919] cfg80211: Calling CRDA to update world regulatory domain
[    6.259155] cfg80211: World regulatory domain updated:
[    6.259156] cfg80211:  DFS Master region: unset
[    6.259158] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
[    6.259160] cfg80211:   (2402000 KHz - 2472000 KHz @ 0 KHz), (N/A, 2000 mBm), (N/A)
[    6.259162] cfg80211:   (2457000 KHz - 2482000 KHz @ 0 KHz), (N/A, 2000 mBm), (N/A)
[    6.259163] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
[    6.259165] cfg80211:   (5170000 KHz - 5250000 KHz @ 160000 KHz), (N/A, 2000 mBm), (N/A)
[    6.259166] cfg80211:   (5250000 KHz - 5330000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
[    6.259168] cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
[    6.259169] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
[    6.259171] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
[    7.925339] cfg80211: Updating information on frequency 5180 MHz with regulatory rule:
[    7.925342] cfg80211: 5140000 KHz - 5360000 KHz @ 80000 KHz), (N/A mBi, 3000 mBm)
[    7.925345] cfg80211: Updating information on frequency 5200 MHz with regulatory rule:
[    7.925348] cfg80211: 5140000 KHz - 5360000 KHz @ 80000 KHz), (N/A mBi, 3000 mBm)
[    7.925350] cfg80211: Updating information on frequency 5220 MHz with regulatory rule:
[    7.925353] cfg80211: 5140000 KHz - 5360000 KHz @ 80000 KHz), (N/A mBi, 3000 mBm)
[    7.925355] cfg80211: Updating information on frequency 5240 MHz with regulatory rule:
[    7.925358] cfg80211: 5140000 KHz - 5360000 KHz @ 80000 KHz), (N/A mBi, 3000 mBm)
[    7.925360] cfg80211: Updating information on frequency 5260 MHz with regulatory rule:
[    7.925363] cfg80211: 5140000 KHz - 5360000 KHz @ 80000 KHz), (N/A mBi, 3000 mBm)
[    7.925365] cfg80211: Updating information on frequency 5280 MHz with regulatory rule:
[    7.925368] cfg80211: 5140000 KHz - 5360000 KHz @ 80000 KHz), (N/A mBi, 3000 mBm)
[    7.925370] cfg80211: Updating information on frequency 5300 MHz with regulatory rule:
[    7.925373] cfg80211: 5140000 KHz - 5360000 KHz @ 80000 KHz), (N/A mBi, 3000 mBm)
[    7.925375] cfg80211: Updating information on frequency 5320 MHz with regulatory rule:
[    7.925378] cfg80211: 5140000 KHz - 5360000 KHz @ 80000 KHz), (N/A mBi, 3000 mBm)
[    7.925380] cfg80211: Disabling freq 5500 MHz as custom regd has no rule that fits it
[    7.925382] cfg80211: Disabling freq 5520 MHz as custom regd has no rule that fits it
[    7.925384] cfg80211: Disabling freq 5540 MHz as custom regd has no rule that fits it
[    7.925386] cfg80211: Disabling freq 5560 MHz as custom regd has no rule that fits it
[    7.925388] cfg80211: Disabling freq 5580 MHz as custom regd has no rule that fits it
[    7.925390] cfg80211: Disabling freq 5600 MHz as custom regd has no rule that fits it
[    7.925392] cfg80211: Disabling freq 5620 MHz as custom regd has no rule that fits it
[    7.925394] cfg80211: Disabling freq 5640 MHz as custom regd has no rule that fits it
[    7.925396] cfg80211: Disabling freq 5660 MHz as custom regd has no rule that fits it
[    7.925398] cfg80211: Disabling freq 5680 MHz as custom regd has no rule that fits it
[    7.925399] cfg80211: Disabling freq 5700 MHz as custom regd has no rule that fits it
[    7.925402] cfg80211: Updating information on frequency 5745 MHz with regulatory rule:
[    7.925405] cfg80211: 5715000 KHz - 5860000 KHz @ 80000 KHz), (N/A mBi, 3000 mBm)
[    7.925407] cfg80211: Updating information on frequency 5765 MHz with regulatory rule:
[    7.925410] cfg80211: 5715000 KHz - 5860000 KHz @ 80000 KHz), (N/A mBi, 3000 mBm)
[    7.925412] cfg80211: Updating information on frequency 5785 MHz with regulatory rule:
[    7.925415] cfg80211: 5715000 KHz - 5860000 KHz @ 80000 KHz), (N/A mBi, 3000 mBm)
[    7.925417] cfg80211: Updating information on frequency 5805 MHz with regulatory rule:
[    7.925420] cfg80211: 5715000 KHz - 5860000 KHz @ 80000 KHz), (N/A mBi, 3000 mBm)
[    7.925422] cfg80211: Updating information on frequency 5825 MHz with regulatory rule:
[    7.925425] cfg80211: 5715000 KHz - 5860000 KHz @ 80000 KHz), (N/A mBi, 3000 mBm)
[    7.925490] cfg80211: Ignoring regulatory request set by core since the driver uses its own custom regulatory domain
[    7.925964] cfg80211: Calling CRDA for country: US
[    7.926309] cfg80211: Updating information on frequency 2412 MHz with regulatory rule:
[    7.926313] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[    7.926316] cfg80211: Updating information on frequency 2417 MHz with regulatory rule:
[    7.926320] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[    7.926323] cfg80211: Updating information on frequency 2422 MHz with regulatory rule:
[    7.926327] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[    7.926329] cfg80211: Updating information on frequency 2427 MHz with regulatory rule:
[    7.926330] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[    7.926332] cfg80211: Updating information on frequency 2432 MHz with regulatory rule:
[    7.926333] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[    7.926335] cfg80211: Updating information on frequency 2437 MHz with regulatory rule:
[    7.926336] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[    7.926338] cfg80211: Updating information on frequency 2442 MHz with regulatory rule:
[    7.926339] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[    7.926341] cfg80211: Updating information on frequency 2447 MHz with regulatory rule:
[    7.926342] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[    7.926343] cfg80211: Updating information on frequency 2452 MHz with regulatory rule:
[    7.926345] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[    7.926346] cfg80211: Updating information on frequency 2457 MHz with regulatory rule:
[    7.926348] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[    7.926349] cfg80211: Updating information on frequency 2462 MHz with regulatory rule:
[    7.926351] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[    7.926352] cfg80211: Updating information on frequency 2467 MHz with regulatory rule:
[    7.926353] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[    7.926355] cfg80211: Disabling freq 2472 MHz as custom regd has no rule that fits it
[    7.926356] cfg80211: Disabling freq 2484 MHz as custom regd has no rule that fits it
[    7.926358] cfg80211: Updating information on frequency 5180 MHz with regulatory rule:
[    7.926360] cfg80211: 5140000 KHz - 5360000 KHz @ 80000 KHz), (N/A mBi, 3000 mBm)
[    7.926362] cfg80211: Updating information on frequency 5200 MHz with regulatory rule:
[    7.926364] cfg80211: 5140000 KHz - 5360000 KHz @ 80000 KHz), (N/A mBi, 3000 mBm)
[    7.926365] cfg80211: Updating information on frequency 5220 MHz with regulatory rule:
[    7.926367] cfg80211: 5140000 KHz - 5360000 KHz @ 80000 KHz), (N/A mBi, 3000 mBm)
[    7.926368] cfg80211: Updating information on frequency 5240 MHz with regulatory rule:
[    7.926370] cfg80211: 5140000 KHz - 5360000 KHz @ 80000 KHz), (N/A mBi, 3000 mBm)
[    7.926372] cfg80211: Updating information on frequency 5260 MHz with regulatory rule:
[    7.926374] cfg80211: 5140000 KHz - 5360000 KHz @ 80000 KHz), (N/A mBi, 3000 mBm)
[    7.926375] cfg80211: Updating information on frequency 5280 MHz with regulatory rule:
[    7.926377] cfg80211: 5140000 KHz - 5360000 KHz @ 80000 KHz), (N/A mBi, 3000 mBm)
[    7.926379] cfg80211: Updating information on frequency 5300 MHz with regulatory rule:
[    7.926381] cfg80211: 5140000 KHz - 5360000 KHz @ 80000 KHz), (N/A mBi, 3000 mBm)
[    7.926383] cfg80211: Updating information on frequency 5320 MHz with regulatory rule:
[    7.926384] cfg80211: 5140000 KHz - 5360000 KHz @ 80000 KHz), (N/A mBi, 3000 mBm)
[    7.926385] cfg80211: Disabling freq 5500 MHz as custom regd has no rule that fits it
[    7.926387] cfg80211: Disabling freq 5520 MHz as custom regd has no rule that fits it
[    7.926388] cfg80211: Disabling freq 5540 MHz as custom regd has no rule that fits it
[    7.926389] cfg80211: Disabling freq 5560 MHz as custom regd has no rule that fits it
[    7.926390] cfg80211: Disabling freq 5580 MHz as custom regd has no rule that fits it
[    7.926391] cfg80211: Disabling freq 5600 MHz as custom regd has no rule that fits it
[    7.926392] cfg80211: Disabling freq 5620 MHz as custom regd has no rule that fits it
[    7.926393] cfg80211: Disabling freq 5640 MHz as custom regd has no rule that fits it
[    7.926395] cfg80211: Disabling freq 5660 MHz as custom regd has no rule that fits it
[    7.926396] cfg80211: Disabling freq 5680 MHz as custom regd has no rule that fits it
[    7.926397] cfg80211: Disabling freq 5700 MHz as custom regd has no rule that fits it
[    7.926398] cfg80211: Updating information on frequency 5745 MHz with regulatory rule:
[    7.926400] cfg80211: 5715000 KHz - 5860000 KHz @ 80000 KHz), (N/A mBi, 3000 mBm)
[    7.926401] cfg80211: Updating information on frequency 5765 MHz with regulatory rule:
[    7.926403] cfg80211: 5715000 KHz - 5860000 KHz @ 80000 KHz), (N/A mBi, 3000 mBm)
[    7.926404] cfg80211: Updating information on frequency 5785 MHz with regulatory rule:
[    7.926406] cfg80211: 5715000 KHz - 5860000 KHz @ 80000 KHz), (N/A mBi, 3000 mBm)
[    7.926408] cfg80211: Updating information on frequency 5805 MHz with regulatory rule:
[    7.926409] cfg80211: 5715000 KHz - 5860000 KHz @ 80000 KHz), (N/A mBi, 3000 mBm)
[    7.926411] cfg80211: Updating information on frequency 5825 MHz with regulatory rule:
[    7.926412] cfg80211: 5715000 KHz - 5860000 KHz @ 80000 KHz), (N/A mBi, 3000 mBm)
[    7.926456] cfg80211: Updating information on frequency 2412 MHz with regulatory rule:
[    7.926460] cfg80211: 2402000 KHz - 2472000 KHz @ 0 KHz), (N/A mBi, 2000 mBm)
[    7.926464] cfg80211: Updating information on frequency 2417 MHz with regulatory rule:
[    7.926469] cfg80211: 2402000 KHz - 2472000 KHz @ 0 KHz), (N/A mBi, 2000 mBm)
[    7.926473] cfg80211: Updating information on frequency 2422 MHz with regulatory rule:
[    7.926477] cfg80211: 2402000 KHz - 2472000 KHz @ 0 KHz), (N/A mBi, 2000 mBm)
[    7.926478] cfg80211: Updating information on frequency 2427 MHz with regulatory rule:
[    7.926480] cfg80211: 2402000 KHz - 2472000 KHz @ 0 KHz), (N/A mBi, 2000 mBm)
[    7.926482] cfg80211: Updating information on frequency 2432 MHz with regulatory rule:
[    7.926483] cfg80211: 2402000 KHz - 2472000 KHz @ 0 KHz), (N/A mBi, 2000 mBm)
[    7.926486] cfg80211: Updating information on frequency 2437 MHz with regulatory rule:
[    7.926487] cfg80211: 2402000 KHz - 2472000 KHz @ 0 KHz), (N/A mBi, 2000 mBm)
[    7.926489] cfg80211: Updating information on frequency 2442 MHz with regulatory rule:
[    7.926491] cfg80211: 2402000 KHz - 2472000 KHz @ 0 KHz), (N/A mBi, 2000 mBm)
[    7.926492] cfg80211: Updating information on frequency 2447 MHz with regulatory rule:
[    7.926494] cfg80211: 2402000 KHz - 2472000 KHz @ 0 KHz), (N/A mBi, 2000 mBm)
[    7.926496] cfg80211: Updating information on frequency 2452 MHz with regulatory rule:
[    7.926497] cfg80211: 2402000 KHz - 2472000 KHz @ 0 KHz), (N/A mBi, 2000 mBm)
[    7.926499] cfg80211: Updating information on frequency 2457 MHz with regulatory rule:
[    7.926501] cfg80211: 2402000 KHz - 2472000 KHz @ 0 KHz), (N/A mBi, 2000 mBm)
[    7.926502] cfg80211: Updating information on frequency 2462 MHz with regulatory rule:
[    7.926505] cfg80211: 2402000 KHz - 2472000 KHz @ 0 KHz), (N/A mBi, 2000 mBm)
[    7.926506] cfg80211: Updating information on frequency 2467 MHz with regulatory rule:
[    7.926508] cfg80211: 2402000 KHz - 2472000 KHz @ 0 KHz), (N/A mBi, 2000 mBm)
[    7.926510] cfg80211: Updating information on frequency 2472 MHz with regulatory rule:
[    7.926512] cfg80211: 2457000 KHz - 2482000 KHz @ 0 KHz), (N/A mBi, 2000 mBm)
[    7.926513] cfg80211: Updating information on frequency 2484 MHz with regulatory rule:
[    7.926515] cfg80211: 2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A mBi, 2000 mBm)
[    7.926517] cfg80211: Updating information on frequency 5180 MHz with regulatory rule:
[    7.926519] cfg80211: 5170000 KHz - 5250000 KHz @ 160000 KHz), (N/A mBi, 2000 mBm)
[    7.926521] cfg80211: Updating information on frequency 5200 MHz with regulatory rule:
[    7.926523] cfg80211: 5170000 KHz - 5250000 KHz @ 160000 KHz), (N/A mBi, 2000 mBm)
[    7.926525] cfg80211: Updating information on frequency 5220 MHz with regulatory rule:
[    7.926527] cfg80211: 5170000 KHz - 5250000 KHz @ 160000 KHz), (N/A mBi, 2000 mBm)
[    7.926528] cfg80211: Updating information on frequency 5240 MHz with regulatory rule:
[    7.926530] cfg80211: 5170000 KHz - 5250000 KHz @ 160000 KHz), (N/A mBi, 2000 mBm)
[    7.926532] cfg80211: Updating information on frequency 5260 MHz with regulatory rule:
[    7.926533] cfg80211: 5250000 KHz - 5330000 KHz @ 160000 KHz), (N/A mBi, 2000 mBm)
[    7.926535] cfg80211: Updating information on frequency 5280 MHz with regulatory rule:
[    7.926537] cfg80211: 5250000 KHz - 5330000 KHz @ 160000 KHz), (N/A mBi, 2000 mBm)
[    7.926539] cfg80211: Updating information on frequency 5300 MHz with regulatory rule:
[    7.926541] cfg80211: 5250000 KHz - 5330000 KHz @ 160000 KHz), (N/A mBi, 2000 mBm)
[    7.926543] cfg80211: Updating information on frequency 5320 MHz with regulatory rule:
[    7.926545] cfg80211: 5250000 KHz - 5330000 KHz @ 160000 KHz), (N/A mBi, 2000 mBm)
[    7.926547] cfg80211: Updating information on frequency 5500 MHz with regulatory rule:
[    7.926548] cfg80211: 5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A mBi, 2000 mBm)
[    7.926550] cfg80211: Updating information on frequency 5520 MHz with regulatory rule:
[    7.926552] cfg80211: 5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A mBi, 2000 mBm)
[    7.926554] cfg80211: Updating information on frequency 5540 MHz with regulatory rule:
[    7.926555] cfg80211: 5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A mBi, 2000 mBm)
[    7.926557] cfg80211: Updating information on frequency 5560 MHz with regulatory rule:
[    7.926559] cfg80211: 5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A mBi, 2000 mBm)
[    7.926561] cfg80211: Updating information on frequency 5580 MHz with regulatory rule:
[    7.926563] cfg80211: 5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A mBi, 2000 mBm)
[    7.926564] cfg80211: Updating information on frequency 5600 MHz with regulatory rule:
[    7.926566] cfg80211: 5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A mBi, 2000 mBm)
[    7.926568] cfg80211: Updating information on frequency 5620 MHz with regulatory rule:
[    7.926570] cfg80211: 5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A mBi, 2000 mBm)
[    7.926571] cfg80211: Updating information on frequency 5640 MHz with regulatory rule:
[    7.926573] cfg80211: 5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A mBi, 2000 mBm)
[    7.926575] cfg80211: Updating information on frequency 5660 MHz with regulatory rule:
[    7.926577] cfg80211: 5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A mBi, 2000 mBm)
[    7.926579] cfg80211: Updating information on frequency 5680 MHz with regulatory rule:
[    7.926581] cfg80211: 5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A mBi, 2000 mBm)
[    7.926582] cfg80211: Updating information on frequency 5700 MHz with regulatory rule:
[    7.926584] cfg80211: 5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A mBi, 2000 mBm)
[    7.926586] cfg80211: Updating information on frequency 5745 MHz with regulatory rule:
[    7.926587] cfg80211: 5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A mBi, 2000 mBm)
[    7.926589] cfg80211: Updating information on frequency 5765 MHz with regulatory rule:
[    7.926591] cfg80211: 5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A mBi, 2000 mBm)
[    7.926592] cfg80211: Updating information on frequency 5785 MHz with regulatory rule:
[    7.926594] cfg80211: 5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A mBi, 2000 mBm)
[    7.926595] cfg80211: Updating information on frequency 5805 MHz with regulatory rule:
[    7.926597] cfg80211: 5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A mBi, 2000 mBm)
[    7.926598] cfg80211: Updating information on frequency 5825 MHz with regulatory rule:
[    7.926600] cfg80211: 5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A mBi, 2000 mBm)
[    7.927057] cfg80211: Calling CRDA for country: US
[    7.930942] cfg80211: Ignoring regulatory request set by driver since the driver requires its own regulatory domain to be set first
[    7.930946] cfg80211: Updating information on frequency 5180 MHz with regulatory rule:
[    7.930947] cfg80211: 5170000 KHz - 5250000 KHz @ 80000 KHz), (N/A mBi, 1700 mBm)
[    7.930948] cfg80211: Updating information on frequency 5200 MHz with regulatory rule:
[    7.930950] cfg80211: 5170000 KHz - 5250000 KHz @ 80000 KHz), (N/A mBi, 1700 mBm)
[    7.930951] cfg80211: Updating information on frequency 5220 MHz with regulatory rule:
[    7.930952] cfg80211: 5170000 KHz - 5250000 KHz @ 80000 KHz), (N/A mBi, 1700 mBm)
[    7.930953] cfg80211: Updating information on frequency 5240 MHz with regulatory rule:
[    7.930955] cfg80211: 5170000 KHz - 5250000 KHz @ 80000 KHz), (N/A mBi, 1700 mBm)
[    7.930957] cfg80211: Updating information on frequency 5260 MHz with regulatory rule:
[    7.930959] cfg80211: 5250000 KHz - 5330000 KHz @ 80000 KHz), (N/A mBi, 2300 mBm)
[    7.930961] cfg80211: Updating information on frequency 5280 MHz with regulatory rule:
[    7.930962] cfg80211: 5250000 KHz - 5330000 KHz @ 80000 KHz), (N/A mBi, 2300 mBm)
[    7.930964] cfg80211: Updating information on frequency 5300 MHz with regulatory rule:
[    7.930966] cfg80211: 5250000 KHz - 5330000 KHz @ 80000 KHz), (N/A mBi, 2300 mBm)
[    7.930967] cfg80211: Updating information on frequency 5320 MHz with regulatory rule:
[    7.930969] cfg80211: 5250000 KHz - 5330000 KHz @ 80000 KHz), (N/A mBi, 2300 mBm)
[    7.930970] cfg80211: Disabling freq 5500 MHz for good
[    7.930971] cfg80211: Disabling freq 5520 MHz for good
[    7.930972] cfg80211: Disabling freq 5540 MHz for good
[    7.930974] cfg80211: Disabling freq 5560 MHz for good
[    7.930975] cfg80211: Disabling freq 5580 MHz for good
[    7.930977] cfg80211: Disabling freq 5600 MHz for good
[    7.930979] cfg80211: Disabling freq 5620 MHz for good
[    7.930980] cfg80211: Disabling freq 5640 MHz for good
[    7.930981] cfg80211: Disabling freq 5660 MHz for good
[    7.930982] cfg80211: Disabling freq 5680 MHz for good
[    7.930983] cfg80211: Disabling freq 5700 MHz for good
[    7.930985] cfg80211: Updating information on frequency 5745 MHz with regulatory rule:
[    7.930986] cfg80211: 5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A mBi, 3000 mBm)
[    7.930988] cfg80211: Updating information on frequency 5765 MHz with regulatory rule:
[    7.930990] cfg80211: 5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A mBi, 3000 mBm)
[    7.930992] cfg80211: Updating information on frequency 5785 MHz with regulatory rule:
[    7.930993] cfg80211: 5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A mBi, 3000 mBm)
[    7.930995] cfg80211: Updating information on frequency 5805 MHz with regulatory rule:
[    7.930998] cfg80211: 5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A mBi, 3000 mBm)
[    7.930999] cfg80211: Updating information on frequency 5825 MHz with regulatory rule:
[    7.931001] cfg80211: 5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A mBi, 3000 mBm)
[    7.931007] cfg80211: Current regulatory domain intersected:
[    7.931008] cfg80211:  DFS Master region: unset
[    7.931009] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
[    7.931012] cfg80211:   (2402000 KHz - 2472000 KHz @ 0 KHz), (N/A, 2000 mBm), (N/A)
[    7.931014] cfg80211:   (2457000 KHz - 2472000 KHz @ 0 KHz), (N/A, 2000 mBm), (N/A)
[    7.931018] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz), (N/A, 1700 mBm), (N/A)
[    7.931020] cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz), (N/A, 2000 mBm), (0 s)
[    7.931022] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
[    7.931024] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
[    7.931041] cfg80211: Calling CRDA for country: US
[    7.934863] cfg80211: Updating information on frequency 2412 MHz with regulatory rule:
[    7.934866] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 3000 mBm)
[    7.934868] cfg80211: Updating information on frequency 2417 MHz with regulatory rule:
[    7.934869] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 3000 mBm)
[    7.934870] cfg80211: Updating information on frequency 2422 MHz with regulatory rule:
[    7.934872] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 3000 mBm)
[    7.934873] cfg80211: Updating information on frequency 2427 MHz with regulatory rule:
[    7.934874] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 3000 mBm)
[    7.934875] cfg80211: Updating information on frequency 2432 MHz with regulatory rule:
[    7.934876] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 3000 mBm)
[    7.934878] cfg80211: Updating information on frequency 2437 MHz with regulatory rule:
[    7.934880] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 3000 mBm)
[    7.934881] cfg80211: Updating information on frequency 2442 MHz with regulatory rule:
[    7.934883] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 3000 mBm)
[    7.934885] cfg80211: Updating information on frequency 2447 MHz with regulatory rule:
[    7.934886] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 3000 mBm)
[    7.934888] cfg80211: Updating information on frequency 2452 MHz with regulatory rule:
[    7.934890] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 3000 mBm)
[    7.934891] cfg80211: Updating information on frequency 2457 MHz with regulatory rule:
[    7.934893] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 3000 mBm)
[    7.934895] cfg80211: Updating information on frequency 2462 MHz with regulatory rule:
[    7.934896] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 3000 mBm)
[    7.934898] cfg80211: Updating information on frequency 2467 MHz with regulatory rule:
[    7.934899] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 3000 mBm)
[    7.934900] cfg80211: Disabling freq 2472 MHz for good
[    7.934901] cfg80211: Disabling freq 2484 MHz for good
[    7.934903] cfg80211: Updating information on frequency 5180 MHz with regulatory rule:
[    7.934904] cfg80211: 5170000 KHz - 5250000 KHz @ 80000 KHz), (N/A mBi, 1700 mBm)
[    7.934905] cfg80211: Updating information on frequency 5200 MHz with regulatory rule:
[    7.934906] cfg80211: 5170000 KHz - 5250000 KHz @ 80000 KHz), (N/A mBi, 1700 mBm)
[    7.934907] cfg80211: Updating information on frequency 5220 MHz with regulatory rule:
[    7.934909] cfg80211: 5170000 KHz - 5250000 KHz @ 80000 KHz), (N/A mBi, 1700 mBm)
[    7.934910] cfg80211: Updating information on frequency 5240 MHz with regulatory rule:
[    7.934911] cfg80211: 5170000 KHz - 5250000 KHz @ 80000 KHz), (N/A mBi, 1700 mBm)
[    7.934912] cfg80211: Updating information on frequency 5260 MHz with regulatory rule:
[    7.934913] cfg80211: 5250000 KHz - 5330000 KHz @ 80000 KHz), (N/A mBi, 2300 mBm)
[    7.934915] cfg80211: Updating information on frequency 5280 MHz with regulatory rule:
[    7.934916] cfg80211: 5250000 KHz - 5330000 KHz @ 80000 KHz), (N/A mBi, 2300 mBm)
[    7.934917] cfg80211: Updating information on frequency 5300 MHz with regulatory rule:
[    7.934918] cfg80211: 5250000 KHz - 5330000 KHz @ 80000 KHz), (N/A mBi, 2300 mBm)
[    7.934920] cfg80211: Updating information on frequency 5320 MHz with regulatory rule:
[    7.934922] cfg80211: 5250000 KHz - 5330000 KHz @ 80000 KHz), (N/A mBi, 2300 mBm)
[    7.934923] cfg80211: Disabling freq 5500 MHz for good
[    7.934924] cfg80211: Disabling freq 5520 MHz for good
[    7.934926] cfg80211: Disabling freq 5540 MHz for good
[    7.934927] cfg80211: Disabling freq 5560 MHz for good
[    7.934928] cfg80211: Disabling freq 5580 MHz for good
[    7.934929] cfg80211: Disabling freq 5600 MHz for good
[    7.934931] cfg80211: Disabling freq 5620 MHz for good
[    7.934932] cfg80211: Disabling freq 5640 MHz for good
[    7.934933] cfg80211: Disabling freq 5660 MHz for good
[    7.934934] cfg80211: Disabling freq 5680 MHz for good
[    7.934935] cfg80211: Disabling freq 5700 MHz for good
[    7.934937] cfg80211: Updating information on frequency 5745 MHz with regulatory rule:
[    7.934939] cfg80211: 5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A mBi, 3000 mBm)
[    7.934940] cfg80211: Updating information on frequency 5765 MHz with regulatory rule:
[    7.934941] cfg80211: 5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A mBi, 3000 mBm)
[    7.934942] cfg80211: Updating information on frequency 5785 MHz with regulatory rule:
[    7.934943] cfg80211: 5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A mBi, 3000 mBm)
[    7.934945] cfg80211: Updating information on frequency 5805 MHz with regulatory rule:
[    7.934946] cfg80211: 5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A mBi, 3000 mBm)
[    7.934947] cfg80211: Updating information on frequency 5825 MHz with regulatory rule:
[    7.934948] cfg80211: 5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A mBi, 3000 mBm)
[    7.934954] cfg80211: Updating information on frequency 5180 MHz with regulatory rule:
[    7.934955] cfg80211: 5170000 KHz - 5250000 KHz @ 80000 KHz), (N/A mBi, 1700 mBm)
[    7.934956] cfg80211: Updating information on frequency 5200 MHz with regulatory rule:
[    7.934958] cfg80211: 5170000 KHz - 5250000 KHz @ 80000 KHz), (N/A mBi, 1700 mBm)
[    7.934959] cfg80211: Updating information on frequency 5220 MHz with regulatory rule:
[    7.934960] cfg80211: 5170000 KHz - 5250000 KHz @ 80000 KHz), (N/A mBi, 1700 mBm)
[    7.934962] cfg80211: Updating information on frequency 5240 MHz with regulatory rule:
[    7.934963] cfg80211: 5170000 KHz - 5250000 KHz @ 80000 KHz), (N/A mBi, 1700 mBm)
[    7.934964] cfg80211: Updating information on frequency 5260 MHz with regulatory rule:
[    7.934965] cfg80211: 5250000 KHz - 5330000 KHz @ 80000 KHz), (N/A mBi, 2300 mBm)
[    7.934966] cfg80211: Updating information on frequency 5280 MHz with regulatory rule:
[    7.934968] cfg80211: 5250000 KHz - 5330000 KHz @ 80000 KHz), (N/A mBi, 2300 mBm)
[    7.934969] cfg80211: Updating information on frequency 5300 MHz with regulatory rule:
[    7.934970] cfg80211: 5250000 KHz - 5330000 KHz @ 80000 KHz), (N/A mBi, 2300 mBm)
[    7.934971] cfg80211: Updating information on frequency 5320 MHz with regulatory rule:
[    7.934973] cfg80211: 5250000 KHz - 5330000 KHz @ 80000 KHz), (N/A mBi, 2300 mBm)
[    7.934973] cfg80211: Disabling freq 5500 MHz
[    7.934974] cfg80211: Disabling freq 5520 MHz
[    7.934975] cfg80211: Disabling freq 5540 MHz
[    7.934976] cfg80211: Disabling freq 5560 MHz
[    7.934977] cfg80211: Disabling freq 5580 MHz
[    7.934977] cfg80211: Disabling freq 5600 MHz
[    7.934978] cfg80211: Disabling freq 5620 MHz
[    7.934979] cfg80211: Disabling freq 5640 MHz
[    7.934980] cfg80211: Disabling freq 5660 MHz
[    7.934980] cfg80211: Disabling freq 5680 MHz
[    7.934981] cfg80211: Disabling freq 5700 MHz
[    7.934982] cfg80211: Updating information on frequency 5745 MHz with regulatory rule:
[    7.934983] cfg80211: 5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A mBi, 3000 mBm)
[    7.934984] cfg80211: Updating information on frequency 5765 MHz with regulatory rule:
[    7.934986] cfg80211: 5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A mBi, 3000 mBm)
[    7.934987] cfg80211: Updating information on frequency 5785 MHz with regulatory rule:
[    7.934988] cfg80211: 5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A mBi, 3000 mBm)
[    7.934989] cfg80211: Updating information on frequency 5805 MHz with regulatory rule:
[    7.934990] cfg80211: 5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A mBi, 3000 mBm)
[    7.934991] cfg80211: Updating information on frequency 5825 MHz with regulatory rule:
[    7.934993] cfg80211: 5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A mBi, 3000 mBm)
[    7.934995] cfg80211: Current regulatory domain intersected:
[    7.934996] cfg80211:  DFS Master region: unset
[    7.934997] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
[    7.934999] cfg80211:   (2402000 KHz - 2472000 KHz @ 0 KHz), (N/A, 2000 mBm), (N/A)
[    7.935000] cfg80211:   (2457000 KHz - 2472000 KHz @ 0 KHz), (N/A, 2000 mBm), (N/A)
[    7.935002] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz), (N/A, 1700 mBm), (N/A)
[    7.935003] cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz), (N/A, 2000 mBm), (0 s)
[    7.935005] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
[    7.935006] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
[   63.664229] cfg80211: Found new beacon on frequency: 5180 MHz (Ch 36) on wiphy0


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

