Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:43936 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035Ab1DSGhh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2011 02:37:37 -0400
Received: by pwi15 with SMTP id 15so2602308pwi.19
        for <linux-wireless@vger.kernel.org>; Mon, 18 Apr 2011 23:37:36 -0700 (PDT)
Message-ID: <4DAD2E36.5000105@gmail.com>
Date: Tue, 19 Apr 2011 16:39:50 +1000
From: Peizhao Hu <peizhao.research@gmail.com>
Reply-To: peizhao.research@gmail.com
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Question on ieee80211_frame_duration in util.c
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I am trying to understand why this function is implemented as such 
currently.

within the util.c in mac80211, if the coding is OFDM:

         /*
	 * OFDM:
	 *
	 * N_DBPS = DATARATE x 4	
	 * N_SYM = Ceiling((16+8xLENGTH+6) / N_DBPS)
	 *    (16 = SIGNAL time, 6 = tail bits)
	 * TXTIME = T_PREAMBLE + T_SIGNAL + T_SYM x N_SYM + Signal Ext
	 *
	 * T_SYM = 4 usec
	 * 802.11a - 17.5.2: aSIFSTime = 16 usec
	 * 802.11g - 19.8.4: aSIFSTime = 10 usec +
	 *    signal ext = 6 usec
	 */
	dur = 16; /* SIFS + signal ext */
	dur += 16; /* 17.3.2.3: T_PREAMBLE = 16 usec */
	dur += 4; /* 17.3.2.3: T_SIGNAL = 4 usec */
	dur += 4 * DIV_ROUND_UP((16 + 8 * (len + 4) + 6) * 10,
	            4 * rate); /* T_SYM x N_SYM */

so the Tx time for a frame is calculated as

SIFS + T_PREAMBLE + T_SIGNAL + T_SYM * N_SYM

What is this Tx time calculation for? Data or the ack? I looks like it 
is for the ack, since it has an SIFS in front. Because the my 
understanding of the standard IEEE std 802.11 2007 Section 9. a full 
transmission consists of

DIFS + Data + SIFS + Ack

 From the rc80211_minstrel.c implementation,

calc_rate_durations(struct minstrel_sta_info *mi, struct ieee80211_local *local,
struct minstrel_rate *d, struct ieee80211_rate *rate)
{
     int erp = !!(rate->flags&  IEEE80211_RATE_ERP_G);
     d->perfect_tx_time = ieee80211_frame_duration(local, 1200, rate->bitrate, erp, 1);
     d->ack_time = ieee80211_frame_duration(local, 10, rate->bitrate, erp, 1);
}

It looks like minstrel treating the Tx time calculation for data frame 
and ack to be the same (as shown above).

If this is right, then we have

SIFS + Data + SIFS + Ack

Anyone has an idea on this?

-- 
regards;

Peizhao Hu

