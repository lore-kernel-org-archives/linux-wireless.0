Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server.heaven-czfree.net ([78.108.102.201]:57893 "EHLO
	smtp.heaven-czfree.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab0E3WRv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 May 2010 18:17:51 -0400
Received: from [10.23.202.43] (unknown [10.23.202.43])
	by smtp.heaven-czfree.net (Postfix) with ESMTP id F3FFB147664
	for <linux-wireless@vger.kernel.org>; Mon, 31 May 2010 00:17:48 +0200 (CEST)
From: "Jaroslav Fojtik" <jafojtik@seznam.cz>
To: linux-wireless@vger.kernel.org
Date: Mon, 31 May 2010 00:08:10 +0200
MIME-Version: 1.0
Subject: Association problems - again
Message-ID: <4C02E1CA.10757.239262@jafojtik.seznam.cz>
Content-type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dears,

I have found that ATH5k has severe problems during association to AP.

Sometimes it needs more than 100 attempts to association, before it connects
to AP.

ATH0="wlan1"
n=1
while (( $n <= 200 ))
do
  ASOC=`iwconfig wlan1 | grep "Access Point: 00:15"`
  if [[ $ASOC == "" ]]
  then
    echo Asoc failed $n!
    ifconfig $ATH0 down
    iwconfig $ATH0 txpower 12 channel 36 essid "dvrmn.heaven-czfree.net"
    ifconfig $ATH0 up
    sleep 2
  else
    echo Asociated - $ASOC.
    break
  fi
  n=$(( n+1 ))
done


It consumes more than 200 seconds to finish association:

[  149.690938] ath5k phy1: failed to put device on hold
[  149.735596] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  149.926717] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 1)
[  150.013353] eth3: no IPv6 routers present
[  150.126699] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 2)
[  150.326707] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 3)
[  150.526696] wlan1: direct probe to 00:15:6d:d6:2a:9d timed out
[  160.292015] eth3: link up, 100Mbps, full-duplex, lpa 0x41E1
[  160.514233] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  160.706709] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 1)
[  160.906713] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 2)
[  161.106715] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 3)
[  161.306696] wlan1: direct probe to 00:15:6d:d6:2a:9d timed out
[  162.566424] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  162.756713] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 1)
[  162.956705] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 2)
[  163.156702] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 3)
[  163.356701] wlan1: direct probe to 00:15:6d:d6:2a:9d timed out
[  164.616070] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  164.806727] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 1)
[  165.006713] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 2)
[  165.206705] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 3)
[  165.406713] wlan1: direct probe to 00:15:6d:d6:2a:9d timed out
[  166.664287] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  166.856483] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 1)
[  167.053379] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 2)
[  167.253367] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 3)
[  167.453376] wlan1: direct probe to 00:15:6d:d6:2a:9d timed out
[  168.714132] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  168.906485] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 1)
[  169.103365] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 2)
[  169.303364] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 3)
[  169.503375] wlan1: direct probe to 00:15:6d:d6:2a:9d timed out
[  170.560019] eth3: no IPv6 routers present
[  170.762425] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  170.953462] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 1)
[  171.153379] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 2)
[  171.353371] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 3)
[  171.553366] wlan1: direct probe to 00:15:6d:d6:2a:9d timed out
[  181.333624] eth3: link up, 100Mbps, full-duplex, lpa 0x41E1
[  181.581997] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  181.773383] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 1)
[  181.973363] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 2)
[  182.173362] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 3)
[  182.373367] wlan1: direct probe to 00:15:6d:d6:2a:9d timed out
[  183.643261] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  183.833377] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 1)
[  184.033370] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 2)
[  184.233371] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 3)
[  184.433365] wlan1: direct probe to 00:15:6d:d6:2a:9d timed out
[  185.692285] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  185.883687] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 1)
[  186.083378] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 2)
[  186.283371] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 3)
[  186.483368] wlan1: direct probe to 00:15:6d:d6:2a:9d timed out
[  187.741481] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  187.933379] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 1)
[  188.133362] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 2)
[  188.333370] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 3)
[  188.533366] wlan1: direct probe to 00:15:6d:d6:2a:9d timed out
[  189.791035] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  189.983882] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 1)
[  190.183371] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 2)
[  190.383364] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 3)
[  190.583359] wlan1: direct probe to 00:15:6d:d6:2a:9d timed out
[  191.840237] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  191.996686] eth3: no IPv6 routers present
[  192.033413] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 1)
[  192.233377] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 2)
[  192.433370] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 3)
[  192.633359] wlan1: direct probe to 00:15:6d:d6:2a:9d timed out
[  202.423994] eth3: link up, 100Mbps, full-duplex, lpa 0x41E1
[  202.650309] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  202.846714] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 1)
[  203.046695] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 2)
[  203.246704] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 3)
[  203.446706] wlan1: direct probe to 00:15:6d:d6:2a:9d timed out
[  204.711466] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  204.903883] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 1)
[  205.103360] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 2)
[  205.303366] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 3)
[  205.503368] wlan1: direct probe to 00:15:6d:d6:2a:9d timed out
[  206.760057] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  206.949867] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 1)
[  207.146703] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 2)
[  207.347163] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 3)
[  207.546704] wlan1: direct probe to 00:15:6d:d6:2a:9d timed out
[  208.809326] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  208.999864] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 1)
[  209.196698] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 2)
[  209.396701] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 3)
[  209.596696] wlan1: direct probe to 00:15:6d:d6:2a:9d timed out
[  210.857783] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  211.049811] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 1)
[  211.246704] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 2)
[  211.446701] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 3)
[  211.646705] wlan1: direct probe to 00:15:6d:d6:2a:9d timed out
[  212.426682] eth3: no IPv6 routers present
[  212.907265] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  213.099820] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 1)
[  213.296710] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 2)
[  213.496706] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 3)
[  213.696695] wlan1: direct probe to 00:15:6d:d6:2a:9d timed out
[  223.477970] eth3: link up, 100Mbps, full-duplex, lpa 0x41E1
[  223.718622] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  223.910122] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 1)
[  224.110035] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 2)
[  224.310027] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 3)
[  224.510024] wlan1: direct probe to 00:15:6d:d6:2a:9d timed out
[  225.787482] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  225.979812] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 1)
[  226.176693] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 2)
[  226.376697] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 3)
[  226.576691] wlan1: direct probe to 00:15:6d:d6:2a:9d timed out
[  227.836521] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  228.026489] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 1)
[  228.223418] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 2)
[  228.423372] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 3)
[  228.623358] wlan1: direct probe to 00:15:6d:d6:2a:9d timed out
[  229.885582] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  230.080558] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 1)
[  230.280545] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 2)
[  230.480546] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 3)
[  230.680541] wlan1: direct probe to 00:15:6d:d6:2a:9d timed out
[  231.935080] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  232.126716] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 1)
[  232.326702] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 2)
[  232.526693] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 3)
[  232.726688] wlan1: direct probe to 00:15:6d:d6:2a:9d timed out
[  233.984012] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  234.053347] eth3: no IPv6 routers present
[  234.176479] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 1)
[  234.373386] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 2)
[  234.573374] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 3)
[  234.773359] wlan1: direct probe to 00:15:6d:d6:2a:9d timed out
[  244.558830] eth3: link up, 100Mbps, full-duplex, lpa 0x41E1
[  244.785451] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  244.976492] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 1)
[  245.173365] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 2)
[  245.373362] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 3)
[  245.573360] wlan1: direct probe to 00:15:6d:d6:2a:9d timed out
[  246.846439] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  247.036701] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 1)
[  247.236695] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 2)
[  247.436699] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 3)
[  247.636688] wlan1: direct probe to 00:15:6d:d6:2a:9d timed out
[  248.895403] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  250.944729] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  251.136496] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 1)
[  251.333367] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 2)
[  251.533368] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 3)
[  251.733360] wlan1: direct probe to 00:15:6d:d6:2a:9d timed out
[  252.993801] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  253.186478] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 1)
[  253.383361] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 2)
[  253.583362] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 3)
[  253.783357] wlan1: direct probe to 00:15:6d:d6:2a:9d timed out
[  255.042771] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  255.233146] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 1)
[  255.430034] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 2)
[  255.436682] eth3: no IPv6 routers present
[  255.630037] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 3)
[  255.830023] wlan1: direct probe to 00:15:6d:d6:2a:9d timed out
[  273.252513] eth3: link up, 100Mbps, full-duplex, lpa 0x41E1
[  273.478721] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  273.673211] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 1)
[  273.870025] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 2)
[  274.070021] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 3)
[  274.270024] wlan1: direct probe to 00:15:6d:d6:2a:9d timed out
[  275.548287] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  275.739808] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 1)
[  275.936697] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 2)
[  276.136686] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 3)
[  276.336687] wlan1: direct probe to 00:15:6d:d6:2a:9d timed out
[  277.597522] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  277.789806] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 1)
[  277.986694] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 2)
[  278.186686] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 3)
[  278.386695] wlan1: direct probe to 00:15:6d:d6:2a:9d timed out
[  279.646296] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  279.836487] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 1)
[  280.033361] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 2)
[  280.233355] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 3)
[  280.433355] wlan1: direct probe to 00:15:6d:d6:2a:9d timed out
[  281.695678] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  281.886472] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 1)
[  282.083360] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 2)
[  282.283359] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 3)
[  282.483355] wlan1: direct probe to 00:15:6d:d6:2a:9d timed out
[  283.306676] eth3: no IPv6 routers present
[  283.744406] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  283.936709] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 1)
[  284.136700] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 2)
[  284.336690] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 3)
[  284.536689] wlan1: direct probe to 00:15:6d:d6:2a:9d timed out
[  294.320546] eth3: link up, 100Mbps, full-duplex, lpa 0x41E1
[  294.563434] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  294.756472] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 1)
[  294.953366] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 2)
[  295.153354] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 3)
[  295.353357] wlan1: direct probe to 00:15:6d:d6:2a:9d timed out
[  296.616435] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  296.806715] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 1)
[  297.006686] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 2)
[  297.206682] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 3)
[  297.406693] wlan1: direct probe to 00:15:6d:d6:2a:9d timed out
[  298.664775] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  298.856699] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 1)
[  299.056694] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 2)
[  299.256684] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 3)
[  299.456695] wlan1: direct probe to 00:15:6d:d6:2a:9d timed out
[  300.714297] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  300.906535] wlan1: authenticate with 00:15:6d:d6:2a:9d (try 1)
[  300.907495] wlan1: authenticated
[  300.907586] wlan1: associate with 00:15:6d:d6:2a:9d (try 1)
[  300.908710] wlan1: RX AssocResp from 00:15:6d:d6:2a:9d (capab=0x401 status=0 aid=1)
[  300.908732] wlan1: associated
[  300.913565] ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready
[  304.836660] eth3: no IPv6 routers present
[  311.373341] wlan1: no IPv6 routers present
[  314.990007] wlan0: no IPv6 routers present

regards
   Jara
