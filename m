Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.3eti.com ([65.220.88.139]:51948 "EHLO 3eSpam.3eti.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751422Ab1FUQRG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 12:17:06 -0400
From: Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>
To: 'Ben Greear' <greearb@candelatech.com>
CC: "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: Help on AMPDU stuck in transmit queue
Date: Tue, 21 Jun 2011 16:16:58 +0000
Message-ID: <BD54DDEB2546894FAB0731EA7B0EDF8D05833EC1@RockMX01.rock.corp> (sfid-20110621_181711_524245_D1D5B815)
References: <BD54DDEB2546894FAB0731EA7B0EDF8D05822A57@RockMX01.rock.corp>
 <4DFA2989.10503@candelatech.com>
In-Reply-To: <4DFA2989.10503@candelatech.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Anybody,any ideas/comments?

Here is my update.

I tried 2.6.39.1. The situation gets better, but not fixed completely. The ping packets still lose (about 62 seconds) once a while.
I say "gets better" because it recovers.

The ping session recovers after about 62 seconds which matches to 2 NULL data packet interval. I sniffed the air, it looks like every 31 seconds, a NULL data packet is sent out from client. 


Again, the symptom does not happen when 802.11n is disabled on AP.

Can anyone explain or help?

Below is my ping session info (message on console)

----------------------------------------------
64 bytes from 192.168.5.1: seq=117 ttl=64 time=2.327 ms
64 bytes from 192.168.5.1: seq=118 ttl=64 time=2.297 ms
64 bytes from 192.168.5.1: seq=119 ttl=64 time=2.316 ms
64 bytes from 192.168.5.1: seq=120 ttl=64 time=2.295 ms
ath: txq: de26d87c axq_qnum: 2, mac80211_qnum: 2 axq_link:   (null) pending frames: 1 axq_acq empty: 0 stopped: 0 axq_depth: 0 .
64 bytes from 192.168.5.1: seq=182 ttl=64 time=1014.549 ms
64 bytes from 192.168.5.1: seq=183 ttl=64 time=4.507 ms
64 bytes from 192.168.5.1: seq=184 ttl=64 time=2.353 ms
64 bytes from 192.168.5.1: seq=185 ttl=64 time=2.307 ms
64 bytes from 192.168.5.1: seq=186 ttl=64 time=1.975 ms
.....
64 bytes from 192.168.5.1: seq=245 ttl=64 time=2.287 ms
64 bytes from 192.168.5.1: seq=246 ttl=64 time=2.315 ms
64 bytes from 192.168.5.1: seq=247 ttl=64 time=2.286 ms
ath: txq: de26d87c axq_qnum: 2, mac80211_qnum: 2 axq_link:   (null) pending frames: 1 axq_acq empty: 0 stopped: 0 axq_depth: 0 .
64 bytes from 192.168.5.1: seq=310 ttl=64 time=14.979 ms
64 bytes from 192.168.5.1: seq=311 ttl=64 time=2.314 ms
64 bytes from 192.168.5.1: seq=312 ttl=64 time=2.296 ms
64 bytes from 192.168.5.1: seq=313 ttl=64 time=2.329 ms
64 bytes from 192.168.5.1: seq=314 ttl=64 time=1012.550 ms
64 bytes from 192.168.5.1: seq=315 ttl=64 time=4.143 ms
.....
64 bytes from 192.168.5.1: seq=368 ttl=64 time=2.291 ms
64 bytes from 192.168.5.1: seq=369 ttl=64 time=2.325 ms
64 bytes from 192.168.5.1: seq=370 ttl=64 time=2.301 ms
64 bytes from 192.168.5.1: seq=371 ttl=64 time=2.308 ms
ath: txq: de26d87c axq_qnum: 2, mac80211_qnum: 2 axq_link:   (null) pending frames: 1 axq_acq empty: 0 stopped: 0 axq_depth: 0 .
64 bytes from 192.168.5.1: seq=430 ttl=64 time=1014.381 ms
64 bytes from 192.168.5.1: seq=431 ttl=64 time=4.337 ms
64 bytes from 192.168.5.1: seq=432 ttl=64 time=4.033 ms
64 bytes from 192.168.5.1: seq=433 ttl=64 time=2.313 ms
.....
64 bytes from 192.168.5.1: seq=2839 ttl=64 time=2.330 ms
64 bytes from 192.168.5.1: seq=2840 ttl=64 time=2.312 ms
64 bytes from 192.168.5.1: seq=2841 ttl=64 time=2.327 ms
64 bytes from 192.168.5.1: seq=2842 ttl=64 time=2.318 ms
ath: txq: df04d87c axq_qnum: 2, mac80211_qnum: 2 axq_link:   (null) pending frames: 1 axq_acq empty: 0 stopped: 0 axq_depth: 0 .
64 bytes from 192.168.5.1: seq=2905 ttl=64 time=13.931 ms
64 bytes from 192.168.5.1: seq=2906 ttl=64 time=2.332 ms
64 bytes from 192.168.5.1: seq=2907 ttl=64 time=2.316 ms
.....
64 bytes from 192.168.5.1: seq=2964 ttl=64 time=2.327 ms
64 bytes from 192.168.5.1: seq=2965 ttl=64 time=2.748 ms
64 bytes from 192.168.5.1: seq=2966 ttl=64 time=2.334 ms
64 bytes from 192.168.5.1: seq=2967 ttl=64 time=2.298 ms
ath: txq: df04d87c axq_qnum: 2, mac80211_qnum: 2 axq_link:   (null) pending frames: 1 axq_acq empty: 0 stopped: 0 axq_depth: 0 .
64 bytes from 192.168.5.1: seq=3030 ttl=64 time=13.919 ms
64 bytes from 192.168.5.1: seq=3031 ttl=64 time=2.310 ms
64 bytes from 192.168.5.1: seq=3032 ttl=64 time=2.288 ms
.....
64 bytes from 192.168.5.1: seq=3088 ttl=64 time=2.294 ms
64 bytes from 192.168.5.1: seq=3089 ttl=64 time=2.305 ms
64 bytes from 192.168.5.1: seq=3090 ttl=64 time=2.348 ms
64 bytes from 192.168.5.1: seq=3091 ttl=64 time=2.305 ms
ath: txq: df04d87c axq_qnum: 2, mac80211_qnum: 2 axq_link:   (null) pending frames: 1 axq_acq empty: 0 stopped: 0 axq_depth: 0 .
64 bytes from 192.168.5.1: seq=3152 ttl=64 time=2014.331 ms
64 bytes from 192.168.5.1: seq=3153 ttl=64 time=1004.289 ms
64 bytes from 192.168.5.1: seq=3154 ttl=64 time=1.762 ms
.....
64 bytes from 192.168.5.1: seq=3335 ttl=64 time=2.293 ms
64 bytes from 192.168.5.1: seq=3336 ttl=64 time=4.247 ms
64 bytes from 192.168.5.1: seq=3337 ttl=64 time=2.290 ms
ath: txq: df04d87c axq_qnum: 2, mac80211_qnum: 2 axq_link:   (null) pending frames: 1 axq_acq empty: 0 stopped: 0 axq_depth: 0 .
64 bytes from 192.168.5.1: seq=3399 ttl=64 time=1014.480 ms
64 bytes from 192.168.5.1: seq=3400 ttl=64 time=4.438 ms
64 bytes from 192.168.5.1: seq=3401 ttl=64 time=3.247 ms
.....
64 bytes from 192.168.5.1: seq=3458 ttl=64 time=2.304 ms
64 bytes from 192.168.5.1: seq=3459 ttl=64 time=3.927 ms
64 bytes from 192.168.5.1: seq=3460 ttl=64 time=2.312 ms
64 bytes from 192.168.5.1: seq=3461 ttl=64 time=2.351 ms
ath: txq: df04d87c axq_qnum: 2, mac80211_qnum: 2 axq_link:   (null) pending frames: 1 axq_acq empty: 0 stopped: 0 axq_depth: 0 .
64 bytes from 192.168.5.1: seq=3523 ttl=64 time=1014.407 ms
64 bytes from 192.168.5.1: seq=3524 ttl=64 time=4.366 ms
64 bytes from 192.168.5.1: seq=3525 ttl=64 time=2.294 ms
.....

-----Original Message-----
From: Ben Greear [mailto:greearb@candelatech.com] 
Sent: Thursday, June 16, 2011 12:04 PM
To: Chaoxing Lin
Cc: ath9k-devel@lists.ath9k.org; linux-wireless@vger.kernel.org
Subject: Re: Help on AMPDU stuck in transmit queue

On 06/16/2011 07:32 AM, Chaoxing Lin wrote:
> Hi Linux wireles experts,
>
> Here is my problem. If anyone can throw some ideas, I would appreciate it.
>
> I have a customized router board which has one wireless card (ath9160) and one Ethernet port. The ath9160 is (and must be) put in client mode. My customization is to translate packet strictly between Ethernet port and wireless port so that the board can be used for old PC to access wireless network.
>
> I am running kernel 2.6.38.5. I made a mini module which always forwards data packets between wireless port and Ethernet port.
> In addition, I made two small changes as follows.
> 1. On wireless Tx path (in ieee80211_subif_start_xmit() defined in mac80211). The change is to replace source address (the MAC of old PC) with wireless radio MAC (ath9160).
> 2. On wireless Rx path (in ieee80211_deliver_skb() defined in mac80211). The change is to replace destination address (ath9160 MAC) with MAC of my old PC.
>
> My customization works very well when 802.11n is disabled on AP which is hostapd based on nl80211 driver.
> When 802.11n is enabled on AP, my customization works only for the first few minutes. (Ping packets from old PC to AP go through well). After a few minutes, wireless radio (ath9160) on my customized router board won't transmit any ping packet. I see AMPDU stuck in transmit queue based on the info from /debugfs/ieee80211/phy0/ath9k/xmit as follows
>
>                              BE         BK        VI        VO
>
> MPDUs Queued:              126          0         0      4261
> MPDUs Completed:           126          0         0      4261
> Aggregates:                  0          0         0         0
> AMPDUs Queued:            4002          0         0         0
> AMPDUs Completed:         3877          0         0         0
> AMPDUs Retried:              0          0         0         0
> AMPDUs XRetried:             1          0         0         0
> FIFO Underrun:               0          0         0         0
> TXOP Exceeded:               0          0         0         0
> TXTIMER Expiry:              0          0         0         0
> DESC CFG Error:              0          0         0         0
> DATA Underrun:               0          0         0         0
> DELIM Underrun:              0          0         0         0
> TX-Pkts-All:              4004          0         0      4261
> TX-Bytes-All:           462852          0         0    105128
>
>
> I noticed that when 11n is disable, MPDUs are sent and the "MPDUs queued" == "MPDUs completed".
> When 11n is enabled, AMPDUs are sent and the "AMPDUs queued"=="AMPDUs Complete" only for the first few minutes. After that, "AMPDUs Complete" stop incrementing.
>
> I also sniffed the air, the "NULL data packet" is still sent out as usual (it's also reflected in the number "MPDUs Queued and Completed" in VO queue). But no ping packets at all.
>
> Without my customization, the wireless client (standalone) on router board works very well with the AP with 11n enabled. This eliminates the AP or client issue.
>
> I also tried another radio (ar9380). The symptom is exactly the same.
>
> Any help on the following is highly appreciated.
> 1. Point out the issue, or
> 2. Throw some idea on how to investigate, or
> 3. Tell me how that AMPDU works in ath9k (mac80211).
> 4. Anywhere in ath9k or mac80211 that is sensitive to the address change.

You might try a later kernel.  I saw problems of this type too a while back,
but not lately.  (I'm using 2.6.39-wl+ for most testing, though the
latest linus 3.0.0-rc3 kernel seems to work fine too in limited testing.)

Thanks,
Ben

>
>
> Thanks
>
> Chaoxing
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

