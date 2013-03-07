Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:59468 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805Ab3CGBGp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Mar 2013 20:06:45 -0500
Received: from [192.168.100.226] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id r2716ika019332
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Wed, 6 Mar 2013 17:06:44 -0800
Message-ID: <5137E824.9020009@candelatech.com> (sfid-20130307_020649_606397_6209B171)
Date: Wed, 06 Mar 2013 17:06:44 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: ath9k-rate-ctrl v/s minstrel_ht on AR8380 results.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ok, finally got my test rig all set up.

Kernel is Johanne's mac80211-testing (3.9-rc1+) from today.

This test uses two systems cabled up to an attenuator.  Attenuation starts
at 30db, adds 10 each time up to 95 (it adds 5 on the last step).

Each step runs for 30 seconds and then goes to the next.  I have it
set to zero pause between steps, so a few stats like dropped pkts
will be off slightly.  I'm mostly interested in tx/rx bandwidth at this point.

Traffic flow is UDP payload, 24000 byte PDU, tx socket buffer is 2M,
rx socket buffer on peer is 1M.

At least in this test, it appears the ath9k is better in almost all
cases.  In particular, it is better at dropping tx rate at very low
signal levels so that at least something gets through.

It should now be easy for me to run these tests over and over, and its
easy to vary the attenuation, etc.  I can also run open-air tests.

So, let me know if you have suggestions for different scenarios or patches.


LANforge Machine Stats:
   Hostname:             lec2010-ath9k-1
   OS Version:           Linux/x86-32
   CPU:                  Genuine Intel(R) CPU N270   @ 1
   Mhz:                  0
   Memory:               2012 MB
   Free Memory:          1643 MB
   CPU Cores (incl. HT): 2
   LANforge SW Version:  5.2.8  32bit
   Starting System Load: 0.23
  Interface Information
   Interface/Port:       vap0
   Driver:
   Driver Version:
   Firmware Version:
   Bus Info:
Peer LANforge Machine Stats:
   Hostname:             ct520-6157
   OS Version:           Linux/x86-32
   CPU:                  Genuine Intel(R) CPU N270   @ 1
   Mhz:                  0
   Memory:               2012 MB
   Free Memory:          1693 MB
   CPU Cores (incl. HT): 2
   LANforge SW Version:  5.2.8  32bit
   Starting System Load: 0.15
  Peer Interface Information
   Interface/Port:       wlan0
   Driver:
   Driver Version:
   Firmware Version:
   Bus Info:
Started test at: Wed Mar  6 16:36:43 2013
Iteration Duration: 30000ms   Pause Duration: 0ms
Number of running endpoints at end of first iteration: 4
System Load at end of first iteration: 0.28
Endpoint Information:
   Endpoint ID: udp-es-as-A     Type: LANFORGE_UDP     Peer Endpoint ID: udp-es-as-B

ath9k-rate-control:

Summary data for each iteration:
  ## pld-size    cfg-rate       tx-bps       rx-bps    rx-bps-LL   tx-pps   rx-pps      tx-pkts      rx-pkts     cx-drops    drop% rx-lat(ms)  atten   link-speed
  rx-signal
   - (bytes)        (bps)            -         peer         peer        -     peer            -         peer         peer     peer       peer (ddBm)         peer
       peer
   0*  24000    350000000    340253975    338602940            0     1772     1764        53170        52912          258    0.485         34      0    450000000
        -35
   1*  24000    350000000    340654245    339169494            0     1774     1767        53229        52997          232    0.436         34      0    450000000
        -44
   2*  24000    350000000    339670155    338371042            0     1769     1762        53077        52874          203    0.382         35      0    450000000
        -54
   3   24000    350000000    267130991    266529431            0     1391     1388        41742        41648           94    0.225         46      0    364500000
        -66
   4   24000    350000000    121890337    121557548            0      635      633        19046        18994           52    0.273         95      0    108000000
        -74
   5   24000    350000000     54566400     54649600            0      284      285         8526         8539          -13   -0.152        211      0     27000000
        -81
   6   24000    350000000      1088000       947200            0        6        5          170          148           22   12.941       9272      0     13500000
        -84
   7   24000    350000000       255991       236792            0        1        1           40           37            3    7.500      10447      0            0
          0
One-way latency distribution for sampled packets received by the peer endpoint, units: (ms)
  ##      min      avg      max      RTT     <= 1      2-2      3-4      5-8     9-16    17-32    33-64   65-128  129-256  257-512 513-1024
   0      -43       34      163       34      195        6       18       84      549     3916    48113        0       31        0        0
   1      -31       34      129       34      197       12        9       36      387     2680    49640       28        3        0        0
   2      -34       35      129       34      205        6       14       66      543     2216    49738       30        1        0        0
   3        5       46      129       46        0        0        0        7       24      130    41381       54        2        0        0
   4        8       95     1575      129        0        0        0        1        4        0        0    18388      495        8        5
   5       70      211      468      232        0        0        0        0        0        0        0        6     8417       65        0
   6      205     9272    13013     9429        0        0        0        0        0        0        0        0        1        0        2
   7     9695    10447    12759    10682        0        0        0        0        0        0        0        0        0        0        0


minstel_ht rate control


Summary data for each iteration:

  ## pld-size    cfg-rate       tx-bps       rx-bps    rx-bps-LL   tx-pps   rx-pps      tx-pkts      rx-pkts     cx-drops    drop% rx-lat(ms)  atten 
link-speed  rx-signal
   - (bytes)        (bps)            -         peer         peer        -     peer            -         peer         peer     peer       peer (ddBm) 
peer       peer
   0*  24000    350000000    325685144    324366788            0     1696     1689        50890        50684          206    0.405         35      0 
81000000        -35
   1*  24000    350000000    326549115    325608346            0     1701     1696        51025        50878          147    0.288         35      0 
81000000        -44
   2*  24000    350000000    325864338    325275557            0     1697     1694        50918        50826           92    0.181         35      0 
81000000        -55
   3   24000    350000000    257117829    257418619            0     1339     1341        40176        40223          -47   -0.117         45      0 
81000000        -66
   4   24000    350000000    126391574    126065196            0      658      657        19750        19699           51    0.258         89      0 
81000000        -74
   5   24000    350000000     52289171     51310069            0      272      267         8171         8018          153    1.872        203      0 
30000000        -81
   6   24000    350000000     25670400        19200            0      134        0         4011            3         4008   99.925        294      0 
6500000        -84
   7   24000    350000000     85882275            0            0      447        0        13420            0        13420  100.000          0      0 
6500000        -85

One-way latency distribution for sampled packets received by the peer endpoint, units: (ms)
  ##      min      avg      max      RTT     <= 1      2-2      3-4      5-8     9-16    17-32    33-64   65-128  129-256  257-512 513-1024
   0        3       35      146       36        0        0        3       15       71     2214    48277       73       31        0        0
   1        4       35      155       35        0        0        2        7       23     2186    48589       12       42        0        0
   2        4       35      120       35        0        0        2       17       30     2267    48445       54        0        0        0
   3        5       45      115       45        0        0        0        8       10       89    40025       76        0        0        0
   4        5       89      940       90        0        0        0        3        0        0        0    19495       45       11      145
   5      101      203     4169      212        0        0        0        0        0        0        0        4     7851       56       58
   6      294      294      294     1013        0        0        0        0        0        0        0        0        0        2        0
   7       -1        0       -1        0        0        0        0        0        0        0        0        0        0        0        0

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

