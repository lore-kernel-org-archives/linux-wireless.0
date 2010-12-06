Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:49802 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751516Ab0LFIOY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Dec 2010 03:14:24 -0500
Received: from vs3012.wh2.ocn.ne.jp (125.206.180.183)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 3-0160013261
	for <linux-wireless@vger.kernel.org>; Mon,  6 Dec 2010 17:14:23 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Jonathan Guerin <jonathan@guerin.id.au>
Subject: Re: ath5k: Weird Retransmission Behaviour
Date: Mon, 6 Dec 2010 17:14:15 +0900
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	"ath5k-devel" <ath5k-devel@lists.ath5k.org>, nbd@openwrt.org
References: <AANLkTimDF3kofO=kiuOsz+WrTGROdOL8-3eNvKd5NrD3@mail.gmail.com>
In-Reply-To: <AANLkTimDF3kofO=kiuOsz+WrTGROdOL8-3eNvKd5NrD3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201012061714.15863.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon December 6 2010 15:30:00 Jonathan Guerin wrote:
> Hi,
> 
> 
> I've been doing some investigation into the behaviour of contention
> windows and retransmissions.
> 
> Firstly, I'll just describe the test scenario and setup that I have. I
> have 3 Via x86 nodes with Atheros AR5001X+ cards. They are tethered to
> each other via coaxial cables, into splitters. They have 20dB of fixed
> attenuation applied to each antenna output, plus a programmable
> variable attenuator on each link. One node acts as a sender, one as a
> receiver, and one simply runs a monitor-mode interface to capture
> packet traces. All 3 are running kernel version 2.6.37-rc2. The sender
> and receiver are configured as IBSS stations and are tuned to 5.18
> GHz.
> 
> Here's a really dodgy ASCII diagram of the setup:
> 
> S-----[variable attenuator]-----R
> 
> 
> 
> +------------M-------------------------+
> 
> where S is the Sender node, R is the Receiver node and M is the
> Monitoring capture node.
> 
> 
> Secondly, I have written a program which will parse a captured pcap
> file from the Monitoring station. It looks for 'chains' of frames with
> the same sequence number, and where the first frame has the Retry bit
> set to false in the header and all following have it set to true. Any
> deviation from this, and the program drops the current chain without
> including it in its stats, and looks for the next chain matching these
> requirements. It averages the amount of time per transmission number
> (i.e. the average of all transmissions which were the first, second,
> third etc. for a unique sequence number). The transmission time of a
> frame is the amount of time between the end of the frame and the end
> of the previous. It tracks these 'chains' of frames with the same
> sequence number. It considers the last transmission number in each
> chain as the 'final' transmission.
> 
> Finally, the link is loaded using a saturated UDP flow, and the data
> rate is fixed to 54M and 36M. This is specified in the output. The
> output is attached below.
> 
> The output describes the fixed link data rate, the variable
> attenuator's value, the delivery ratio, and the number of transmitted
> packets/s. I've added a discussion per result set. Each line outputs
> the transmission number, the average transmission time for this
> number, the total number of transmissions, the number of frames which
> ended their transmissions at this number (i.e. where the chain ended
> its final transmission - this is equivalent to the retransmission
> value from the Radiotap header + 1), and the average expected
> transmission time for all that particular transmission number in all
> chains. This is calculated using the airtime calculations from the
> 802.11a standard, with the receipt of an ACK frame, as well as a SIFS
> (16us), which is 28us. If the transmission did not receive an ACK, a
> normal ACK timeout is 50 us, but ath5k appears to have this set to 25
> us, so the value shouldn't be too far out what to expect.
> 
> The header to each result refers to the rate it was fixed at, as well
> as the variable attenuation being added to it. The link also has a
> fixed 40dB of attenuation both to protect the cards, as well as give
> the necessary range for the variable attenuator to control link
> quality.
> 
> ==> iperf_33M_rate_36M_att_1dB.pcap.txt <== (good link, 100% delivery)
> Average time per TX No:
> TXNo	Avg			No		Final    	ExpectedAvg
> 1		477.604980	10463	10462   	509
> Overall average: 477.604980
> 
> [Discussion:] Nothing, appears normal.
> 
> 
> ==> iperf_33M_rate_36M_att_18dB.pcap.txt <== (lossy link, but still
> 100% delivery)
> Average time per TX No:
> TXNo	Avg			No		Final   	ExpectedAvg
> 1		476.966766	9808		8138   	509
> 2		550.320496	1663		1403   	581
> 3		697.552917	255		218   	725
> 4		1028.756714	37		30		1013
> 5		1603.428589	7		7   		1589
> Overall average: 494.514618
> 
> [Discussion:] Nothing, appears normal. Contention window appears to
> double normally.
> 
> ==> iperf_33M_rate_36M_att_19dB.pcap.txt <== (lossy link, but still
> 100% delivery)
> Average time per TX No:
> TXNo	Avg			No		Final   	ExpectedAvg
> 1		477.510437	14893	8653   	509
> 2		546.149048	6205		3624   	581
> 3		692.270203	2561		1552   	725
> 4		980.565857	1002		596   	1013
> 5		1542.079956	400		252   	1589
> 6		2758.693848	147		89		2741
> 7		4971.500000	56		32   		5045
> 8	 	4689.043457	23		15   		5045
> 9		4487.856934	7		3   		5045
> 10		442.250000	4		3   		5045
> 11		488.000000	1		1   		5045
> Overall average: 580.976807
> 
> [Discussion:] Contention window appears to double until a plateau from
> 7 through 9. Weirdly, the contention window appears to be drop again
> from 10, but
> there are too few frames to draw a conclusion.
> 
> ==> iperf_33M_rate_36M_att_21dB.pcap.txt <== (lossy link, < 1% delivery)
> TXNo	Avg			No	     	Final   ExpectedAvg
> 1		485.390198	1940		3	   509
> 2		479.113434	1922		2	   581
> 3		479.681824	1914		0   	   725
> 4		485.083038	1903		1   	   1013
> 5		492.088135	1895		4   	   1589
> 6		508.322510	1876		1   	   2741
> 7		524.697876	1870		1   	   5045
> 8		543.054382	1857		0   	   5045
> 9		522.970703	1842		0   	   5045
> 10		478.204132	1837		0   	   5045
> 11		476.520782	1828		0   	   5045
> 12		477.531342	1818		0   	   5045
> 13		476.743652	1810		0   	   5045
> 14		478.936554	1797		0   	   5045
> 15		480.699097	1788		0   	   5045
> 16		482.734314	1784		0   	   5045
> 17		491.608459	1775		0   	   5045
> 18		497.458984	1767		1   	   5045
> 19		495.067932	1752		7   	   5045
> 20		478.102417	1738		295     5045
> 21		475.128845	1436		1402   5045
> 22		492.692322	26		0	   5045
> 23		471.576935	26		0   	   5045
> 24		466.884613	26		0   	   5045
> 25		476.269226	26		0   	   5045
> 26		462.192322	26		0   	   5045
> 27		480.961548	26		1   	   5045
> 28		463.600006	25		24   	   5045
> Overall average: 491.068359
> 
> [Discussion:] Contention does not appear to increase, and the number
> of transmission per frame is very large. This behaviour is replicated
> with the 54M scenario when a link is extremely lossy.
> 
> ==> iperf_33M_rate_54M_att_1dB.pcap.txt <== (good link, 2400 packets/s)
> Average time per TX No:
> TXNo	Avg			No		Final   	ExpectedAverage
> 1		365.551849	23957	23935   	393
> 2		409.571442	21		21   		465
> Overall average: 365.590424
> 
> [Discussion: ] Appears relatively normal.
> 
> ==> iperf_33M_rate_54M_att_10dB.pcap.txt <== (lossy link, but still
> 100% delivery, 1500 packets/s)
> Average time per TX No:
> TXNo	Avg			No		Final   	ExpectedAverage
> 1		364.501190	10134	5915   	393
> 2		434.138000	4196		2461   	465
> 3		579.482300	1721		1036   	609
> 4		837.005859	682		397   	897
> 5		1365.279175	283		155   	1473
> 6		2572.007812	128		81 	  	2625
> 7		4905.195801	46		27   		4929
> 8		4985.947266	19		12   		4929
> 9		4627.285645	7		4   		4929
> 10		366.000000	3		1   		4929
> 11		335.500000	2		2   		4929
> Overall average: 473.477020
> 
> [Discussion: ] Appears fine, until transmission 10, which appears to
> drop the contention window back to an equivalent first transmission
> value, but not enough frames at this point to draw a conclusion.
> 
> ==> iperf_33M_rate_54M_att_11dB.pcap.txt <== (lossy link, but still
> 100% delivery, 680 packets/s)
> Average time per TX No:
> TXNo	Avg			No		Final   	ExpectedAverage
> 1		362.082825	2149		539   	393
> 2		434.672485	1606		368   	465
> 3		582.795288	1231		307   	609
> 4		820.347107	919		237   	897
> 5		1424.753296	673		194   	1473
> 6		2626.403320	466		143   	2625
> 7		4734.233887	308		83   		4929
> 8		4830.244141	217		65   		4929
> 9		4449.702637	148		33   		4929
> 10		360.114044	114		36   		4929
> 11		366.000000	78		20   		4929
> 12		460.655182	58		20   		4929
> 13		544.184204	38		9   		4929
> 14		893.965515	29		7   		4929
> 15		1361.409058	22		8   		4929
> 16		2675.285645	14		2   		4929
> 17		4239.500000	12		5   		4929
> 18		3198.142822	7		2   		4929
> 19		5111.799805	5		3   		4929
> 20		1403.000000	2		1   		4929
> Overall average: 1063.129883
> 
> [Discussion: ] Everything appears fine until, once again, transmission
> 10, when the contention windows appears to 'restart' - it climbs
> steadily until 17. After this point, there are not enough frames to
> draw any conclusions.
> 
> ==> iperf_33M_rate_54M_att_12dB.pcap.txt <== (lossy link, 6% delivery,
> 400 packets/s)
> Average time per TX No:
> TXNo	Avg			No		Final   	ExpectedAvg
> 1		360.460724	4482		14   		393
> 2		366.068481	4453		16   		465
> 3		360.871735	4413		13   		609
> 4		361.535553	4386		18   		897
> 5		367.526062	4357		60   		1473
> 6		360.003967	4283		3839   	2625
> 7		361.778046	419		416   	4929
> Overall average: 362.732910
> 
> [Discussion:] This exhibits the same problem as the extremely lossy
> 36M link - the contention window does not appear to rise. Even with
> enough frames to draw a good conclusion at transmission 6, the
> transmission time average (360) is way below the expected average
> (2625).
> ==> END OF OUTPUT <==
> 
> The question here is: why does ath5k/mac80211 send out so many
> transmissions, and why does it vary so much based on link quality?
> Additionally, why does it appear to 'reset' the contention window
> after 9 retransmissions of a frame?
> 
> Cheers,
> 
> Jonathan

Hi Jonathan!

This is a very interesting setup and test. I guess nobody has looked so 
closely yet... I think this is not necessarily ath5k related, but may be a bug 
of mac80211 or minstrel, but not sure yet, of course...

It's normal, that the CW is reset after the retry limits are reached, this is 
what the standard says:

"The CW shall be reset to aCWmin after every successful attempt to transmit an 
MPDU or MMPDU, when SLRC reaches dot11LongRetryLimit, or when SSRC reaches 
dot11ShortRetryLimit." (802.11-2007 p261)

But it seems weird that there are so many retransmissions. The default maximum 
numbers of retransmissions should be 7 for short frames and 4 for long frames 
(dot11[Short|Long]RetryLimit), and this is what is set as defaults in mac80211 
(local->hw.conf.short_frame_max_tx_count). Seems we are getting many 
retransmissions from minstel, i added some debug prints:

*** txdesc tries 3
*** mrr 0 tries 3 rate 11
*** mrr 1 tries 3 rate 11
*** mrr 2 tries 3 rate 11

This seems to be the normal case and that would already result in 12 
transmissions.

Another thing that strikes me here is: why use multi rate retries if the rate 
is all the same? (Ignore the actual value of the rate, this is the HW rate 
code).

Other examples: 

*** txdesc tries 2
*** mrr 0 tries 9 rate 12
*** mrr 1 tries 2 rate 13
*** mrr 2 tries 3 rate 11

= 16 transmissions in sum.

*** txdesc tries 9
*** mrr 0 tries 3 rate 11
*** mrr 1 tries 9 rate 8
*** mrr 2 tries 3 rate 11

= 24 transmissions in sum. Again, rate[1] and rate[3] are the same, so why 
bother setting it up twice?

bruno
