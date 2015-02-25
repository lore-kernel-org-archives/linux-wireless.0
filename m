Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hetz2.bluebottle.com ([176.9.57.138]:36444 "EHLO
	fe1.bluebottle.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753335AbbBYVLb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2015 16:11:31 -0500
Received: from localhost (p57AB252B.dip0.t-ipconnect.de [87.171.37.43])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: bittorf@bluebottle.com)
	by fe1.bluebottle.com (Postfix) with ESMTPSA id 0F24919EBC
	for <linux-wireless@vger.kernel.org>; Wed, 25 Feb 2015 21:04:04 +0000 (UTC)
Date: Wed, 25 Feb 2015 22:00:40 +0100
From: Bastian Bittorf <bittorf@bluebottle.com>
To: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Subject: Re: [PATCH v2 0/10] Improve Minstrels & Minstrel-HTs common code
 base & statistics
Message-ID: <20150225210040.GA8189@medion.lan> (sfid-20150225_221136_712041_B8177545)
References: <1423839472-15625-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1423839472-15625-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Job <thomas@net.t-labs.tu-berlin.de> [13.02.2015 16:32]:
> This patch series adds several improvements to the readability, the
> output format of rc_stats and the calculated statistics of Minstrel
> and Minstrel-HT. Variable names got more consistent and functions
> got unified between both rate control algorithms.

i did intensive testing in our small testnet (~50 routers) with all
kinds of platforms (ar71xx, x86, mpc85xx/ppc) and have no objections
for this patch-series but a big "thumbs up" for very nice, readable
and machine-parseable minstrel/rate-selector-output:

root@KuechenJukebox:~ cat /sys/kernel/debug/ieee80211/phy0/netdev:wlan0/stations/f4:ec:38:9d:81:f0/rc_stats

              best   ____________rate__________    ___________statistics__________    ________last_______    ______sum-of________
mode guard #  rate  [name   idx airtime  max_tp]  [ ø(tp) ø-2σ(tp) ø(prob) σ(prob)]  [prob.|retry|suc|att]  [#success | #attempts]
CCK    LP  1          1.0M  120   10548     0.9      0.0      0.0     6.4     1.6       5.2   2     0 0            74   585      
CCK    LP  1          2.0M  121    5476     1.8      0.0      0.0     0.0     0.0       0.0   0     0 0             0   2        
CCK    LP  1          5.5M  122    2411     4.1      0.0      0.0     0.0     0.0       0.0   0     0 0             0   2        
CCK    LP  1         11.0M  123    1535     6.5      1.2      1.1    18.7     0.7       0.0   0     0 0             1   3        
HT20  LGI  1    CD   MCS0     0    1480     6.5      3.3      3.2    52.7     1.2      33.3   2     0 0           320   657      
HT20  LGI  1  A   P  MCS1     1     740    12.5      9.9      9.7    79.8     0.9     100.0   3     2 2           645   1234     
HT20  LGI  1         MCS2     2     496    18.1      0.0      0.0     0.0     0.0       0.0   0     0 0             0   3        
HT20  LGI  1         MCS3     3     372    23.4      1.9      1.3     8.8     1.5       0.0   5     0 0            69   281      
HT20  LGI  1         MCS4     4     248    33.1      0.0      0.0     0.0     0.0       0.0   0     0 0             0   2        
HT20  LGI  1         MCS5     5     188    41.3      0.0      0.0     0.0     0.0       0.0   0     0 0             0   3        
HT20  LGI  1         MCS6     6     168    45.0      0.0      0.0     0.0     0.0       0.0   0     0 0             0   3        
HT20  LGI  1         MCS7     7     148    49.5      0.0      0.0     0.0     0.0       0.0   0     0 0             0   3        
HT20  LGI  2         MCS8    10     740    12.5      0.0      0.0     0.0     0.0       0.0   0     0 0             0   2        
HT20  LGI  2   B     MCS9    11     372    23.4      7.4      6.8    32.4     1.6       0.0   4     0 8            10   27       
HT20  LGI  2         MCS10   12     248    33.1      0.0      0.0     0.0     0.0       0.0   0     0 0             0   2        
HT20  LGI  2         MCS11   13     188    41.3      0.0      0.0     0.0     0.0       0.0   0     0 0             0   3        
HT20  LGI  2         MCS12   14     124    56.1      0.0      0.0     0.0     0.0       0.0   0     0 0             0   3        
HT20  LGI  2         MCS13   15      96    66.6      0.0      0.0     0.0     0.0       0.0   0     0 0             0   3        
HT20  LGI  2         MCS14   16      84    72.4      0.0      0.0     0.0     0.0       0.0   0     0 0             0   3        
HT20  LGI  2         MCS15   17      76    76.9      0.0      0.0     0.0     0.0       0.0   0     0 0             0   3        

Total packet count::    ideal 1023      lookaround 48
Average # of aggregated frames per A-MPDU: 2.7


root@KuechenJukebox:~ cat /sys/kernel/debug/ieee80211/phy0/netdev:wlan0/stations/f4:ec:38:9d:81:f0/rc_stats_csv 
1424897596.239275,CCK,LP,1,,,,,, 1.0M,120,10548,0.9,0.0,0.0,0.0,0.0,0.0,0,0,0,0,0,0,0,1.0
1424897596.239275,CCK,LP,1,,,,,, 2.0M,121,5476,1.8,0.0,0.0,0.0,0.0,0.0,0,0,0,0,0,0,0,1.0
1424897596.239275,CCK,LP,1,,,,,, 5.5M,122,2411,4.1,0.0,0.0,0.0,0.0,0.0,0,0,0,0,0,0,0,1.0
1424897596.239275,CCK,LP,1,,,,,,11.0M,123,1535,6.5,0.0,0.0,0.0,0.0,0.0,0,0,0,0,0,0,0,1.0
1424897596.239275,HT20,LGI,1,A,B,C,D,P,MCS0 ,0,1480,6.2,0.0,0.0,0.0,0.0,0.0,1,0,0,0,0,0,0,1.0
1424897596.239275,HT20,LGI,1,,,,,,MCS1 ,1,740,11.7,0.0,0.0,0.0,0.0,0.0,0,0,0,0,0,0,0,1.0
1424897596.239275,HT20,LGI,1,,,,,,MCS2 ,2,496,16.5,0.0,0.0,0.0,0.0,0.0,0,0,0,0,0,0,0,1.0
1424897596.239275,HT20,LGI,1,,,,,,MCS3 ,3,372,20.8,0.0,0.0,0.0,0.0,0.0,0,0,0,0,0,0,0,1.0
1424897596.239275,HT20,LGI,1,,,,,,MCS4 ,4,248,28.0,0.0,0.0,0.0,0.0,0.0,0,0,0,0,0,0,0,1.0
1424897596.239275,HT20,LGI,1,,,,,,MCS5 ,5,188,33.7,0.0,0.0,0.0,0.0,0.0,0,0,0,0,0,0,0,1.0
1424897596.239275,HT20,LGI,1,,,,,,MCS6 ,6,168,36.2,0.0,0.0,0.0,0.0,0.0,0,0,0,0,0,0,0,1.0
1424897596.239275,HT20,LGI,1,,,,,,MCS7 ,7,148,39.0,0.0,0.0,0.0,0.0,0.0,0,0,0,0,0,0,0,1.0
1424897596.239275,HT20,LGI,2,,,,,,MCS8 ,10,740,11.7,0.0,0.0,0.0,0.0,0.0,0,0,0,0,0,0,0,1.0
1424897596.239275,HT20,LGI,2,,,,,,MCS9 ,11,372,20.8,0.0,0.0,0.0,0.0,0.0,0,0,0,0,0,0,0,1.0
1424897596.239275,HT20,LGI,2,,,,,,MCS10,12,248,28.0,0.0,0.0,0.0,0.0,0.0,0,0,0,0,0,0,0,1.0
1424897596.239275,HT20,LGI,2,,,,,,MCS11,13,188,33.7,0.0,0.0,0.0,0.0,0.0,0,0,0,0,0,0,0,1.0
1424897596.239275,HT20,LGI,2,,,,,,MCS12,14,124,43.1,0.0,0.0,0.0,0.0,0.0,0,0,0,0,0,0,0,1.0
1424897596.239275,HT20,LGI,2,,,,,,MCS13,15,96,49.0,0.0,0.0,0.0,0.0,0.0,0,0,0,0,0,0,0,1.0
1424897596.239275,HT20,LGI,2,,,,,,MCS14,16,84,52.0,0.0,0.0,0.0,0.0,0.0,0,0,0,0,0,0,0,1.0
1424897596.239275,HT20,LGI,2,,,,,,MCS15,17,76,54.3,0.0,0.0,0.0,0.0,0.0,0,0,0,0,0,0,0,1.0



so a just want to say:

Tested-by: Bastian Bittorf
