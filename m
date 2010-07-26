Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62390 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754768Ab0GZUhK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jul 2010 16:37:10 -0400
Received: by eya25 with SMTP id 25so562798eya.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Jul 2010 13:37:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C4DE4F5.3010907@openwrt.org>
References: <AANLkTimWoSTAtb0m9V=0CNowhy=KtpiKj-O3vdmV8qxB@mail.gmail.com>
	<4C4DC98E.6090002@openwrt.org>
	<AANLkTinZ=KDo4aJU6Z93p1DXghF_MzE9CeBN6OuC_LnD@mail.gmail.com>
	<4C4DE4F5.3010907@openwrt.org>
Date: Mon, 26 Jul 2010 22:37:08 +0200
Message-ID: <AANLkTikcW5Gx6P2-6w_Vmeh7kEDGuEHcY=U_jbH3tYhT@mail.gmail.com>
Subject: Re: [ath9k-devel] [RFC] ath9k: improve aggregation throughput by
	using only first rate
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: Felix Fietkau <nbd@openwrt.org>
Cc: ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/7/26 Felix Fietkau <nbd@openwrt.org>:
> On 2010-07-26 9:23 PM, Björn Smedman wrote:
>> 2010/7/26 Felix Fietkau <nbd@openwrt.org>:
>> * When tx is aggregated most rate control probe frames end up inside
>> aggregates and are never used for probing (effective probe frequency
>> is divided by average aggregate length).
> Nope, a probing frame never ends up inside an aggregate. It's always
> sent out as a single frame, which is why I had to make the decision
> about sending a probing frame more complex in minstrel_ht, compared to
> minstrel - the previous 10% stuff was limiting aggregation size.

Ok, I must have jumped to conclusions. I looked quickly at the code
and had the impression that it only cared about the RATE_PROBE flag if
it was on the first subframe of the aggregate, and then I compared
debug output from rc and xmit like this:

root@OpenWrt:/sys/kernel/debug# cat
ieee80211/phy0/stations/00\:1e\:52\:c7\:cf\:63/rc_stats ; ca
t ath9k/phy0/xmit
type      rate     throughput  ewma prob   this prob  this
succ/attempt   success    attempts
HT20/LGI    MCS0        5.8       87.3       50.0          0(  0)
   48          54
HT20/LGI    MCS1       12.6       94.6      100.0          0(  0)
   46          48
HT20/LGI    MCS2       18.9       95.8      100.0          0(  0)
   52          73
HT20/LGI    MCS3       24.8       94.8      100.0          0(  0)
   53          62
HT20/LGI    MCS4       38.4       99.2      100.0          0(  0)
   45          55
HT20/LGI    MCS5       47.4       94.0      100.0          0(  0)
   56          72
HT20/LGI    MCS6       55.4       98.7      100.0          0(  0)
   60          78
HT20/LGI   PMCS7       56.2       88.8       66.6          0(  0)
  112         143
HT20/LGI    MCS8       10.8       81.4       50.0          0(  0)
   50          62
HT20/LGI    MCS9       23.6       90.4      100.0          0(  0)
   66          81
HT20/LGI    MCS10      30.6       79.0       50.0          0(  0)
   51          64
HT20/LGI    MCS11      50.1       99.2      100.0          0(  0)
   56          63
HT20/LGI    MCS12      60.1       80.6      100.0          0(  0)
  217         382
HT20/LGI    MCS13      66.6       70.6       50.0          0(  0)
 2440        3042
HT20/LGI  t MCS14      82.9       77.9       65.9          0(  0)
70446       86949
HT20/LGI T  MCS15      85.5       73.5       77.1        264(342)
31170       43240

Total packet count::    ideal 117093      lookaround 1322
Average A-MPDU length: 10.6
                            BE         BK        VI        VO

MPDUs Queued:              120          0         0       224
MPDUs Completed:           120          0         0       224
Aggregates:               7555          0         0         0
AMPDUs Queued:          118358          0         0        50
AMPDUs Completed:       118247          0         0        20
AMPDUs Retried:          15406          0         0       300
AMPDUs XRetried:            21          0         0        30
FIFO Underrun:               0          0         0         0
TXOP Exceeded:               0          0         0         0
TXTIMER Expiry:              0          0         0         0
DESC CFG Error:              0          0         0         0
DATA Underrun:               0          0         0         0
DELIM Underrun:              0          0         0         0

Rate control says 1322 lookaround (=probe frames?) but ath9k xmit says
only 120 + 224 MPDUs.

/Björn
