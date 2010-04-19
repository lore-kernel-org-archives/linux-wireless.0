Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:48439 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753275Ab0DSAYY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Apr 2010 20:24:24 -0400
Received: from vs3001.wh2.ocn.ne.jp (125.206.180.229)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 3-0846096661
	for <linux-wireless@vger.kernel.org>; Mon, 19 Apr 2010 09:24:22 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: [PATCH 1/2] ath5k: Use high bitrates for ACK/CTS
Date: Mon, 19 Apr 2010 09:24:25 +0900
Cc: linville@tuxdriver.com, ath5k-devel@venema.h4ckr.net,
	linux-wireless@vger.kernel.org
References: <20100412073847.28215.87571.stgit@tt-desk> <20100416155907.6e33c722@dhcp-lab-109.englab.brq.redhat.com>
In-Reply-To: <20100416155907.6e33c722@dhcp-lab-109.englab.brq.redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201004190924.25709.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 16 April 2010 22:59:07 Stanislaw Gruszka wrote:
> On Mon, 12 Apr 2010 16:38:47 +0900
> 
> Bruno Randolf <br1@einfach.org> wrote:
> > There was a confusion in the usage of the bits AR5K_STA_ID1_ACKCTS_6MB
> > and AR5K_STA_ID1_BASE_RATE_11B. If they are set (1), we will get lower
> > bitrates for ACK and CTS. Therefore ath5k_hw_set_ack_bitrate_high(ah,
> > false) actually resulted in high bitrates, which i think is what we want
> > anyways. Cleared the confusion and added some documentation.
> 
> I thought ACK and other control frames have to be modulated at slow/robust
> bitrates, but can't remember where I read that ...

this has been discussed on ath5k-devel before. i'm copying it here. please let 
me know if i missed something...

(https://lists.ath5k.org/pipermail/ath5k-devel/2010-March/003391.html)

control frames have to be sent at one of the lower bitrates - one of the 
"basic rates". in G mode these are 1, 2, 5.5, 11, 6, 12, 24Mbps. 

this is from the 802.11g spec:
"a STA responding to a received frame shall transmit its Control Response
(either CTS or ACK) frames at the highest rate in the BSSBasicRateSet that is 
less than or equal to the rate of the immediately previous frame in the frame 
exchange sequence (as defined in 9.7)"

basically we have to make a tradeoff here: using lower rates for ACK/CTS will 
improve reliability, but lower performance. for example i could get only 
10Mbps truput with ACK/CTS at the lowest bitrates and RTS/CTS enabled 
(iwconfig wlan0 rts 250) and i can get more than 20Mbps with higher bitrates. 
so i think it's worth to use high bitrates. actually also this should be 
tuneable for the user, too...

bruno
