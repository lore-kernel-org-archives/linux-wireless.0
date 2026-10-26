Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793016953;
	b=D63vSthglQsRjm++IjIGvpAOIpXNIAcrVM+6oZCtJPE3jeMcyQ0M/BMLlk0spJkQEUHL
	 evP3yxzuctti7l4kRc2uaSPk0JghacBS9YpiZ26vSPsBvVY5BNRj83mn8e6EPP4W2EmJd
	 dQb+3SX0CMVM4/jSJOjyyWU6BGn9t0YJVEPYJDcVgdkh47qWYcilFeQrsCb8CslDGTvi+
	 0v4iXtASZwe7Y2256ATcgDT3W4HbJvIFdI4BxfC6LE8zp4jvFqHZjQShqmvpZ13cDwKpz
	 /ExLdCOlv1qKlKfCV/QRLg+lXIw1xKvztBY9yCaLEsFAbNDoEb/I4u1FdSXJylkA1Og==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793016953;
	h=DMARC-Filter:Received:DKIM-Signature:Message-ID:Date:MIME-Version:
	 User-Agent:Content-Language:From:Subject:To:Cc:Content-Type:
	 Content-Transfer-Encoding;
	bh=mfpu+zMRsi5EfPfwVXRPbt8uVtLZDvJ7dJxVwtl2Is8=;
	b=kaoZTvlxuJ1InpDf2EEtRUDpDf//YHWzbbGnwnUBDSCNW9XID/xg8kczzPKGafktKTq1
	 DVQhDAsqWQvUKs4V/pcltKbq0R6p5hcCXmFbZG0fMVxK5gyqP9K5NjHAwAG0tzQeQJ2Vd
	 t/5v3KzDc+f5YPl4khtTUOJNMvq9WDGucSbXO6XUL0ENs2wAoae7HD6whuwihR0i0Dl5w
	 3Xv1pn9gzqIeHdwcQWzIO5NWAJCqYd3GoY2ePA+4Ls5HBuBTnZYT+TUUVApwlUjAE+3KT
	 eFw7lufWYc1Npw9f4ZSK2Ue5/zy4USCfeA5QqvO4r/obyjUySd1/JeVIYXORKPJLXBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=Ini0zTlz;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4DEB606A335
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 12:15:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B4DEB606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=Ini0zTlz
Received: from [192.168.9.110] (198-27-206-187.fiber.dynamic.sonic.net [198.27.206.187])
	(authenticated bits=0)
        (User authenticated as andersk@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 69QCFTk2026926
	(version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 26 Oct 2026 08:15:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1793016938; bh=mfpu+zMRsi5EfPfwVXRPbt8uVtLZDvJ7dJxVwtl2Is8=;
	h=Message-ID:Date:MIME-Version:From:Subject:Content-Type;
	b=Ini0zTlz0Mg1G3oPdtq9smWAtqsaYbbn0Mja8HcRCpsV7lGax94DLY9svuRt2EhRx
	 iwja0B1tMH/HfrslH5XkeHCNtv9zT0Tl5IwZoKbG22+mKlTHeHMaCDcBGxEdL5dB4q
	 Uwvu6i9zE3lqgqTafQH0ohKIdV05NSsVcNZwxhRWKD+YoQW89BkbqfzxqPIf57rCiP
	 OjdDYDgjMYBbFpd2geOVyyIrBmZjY+UGGHKbLE7jzfOPOHG/PCXCLAmU5DoAlWKK0Y
	 OudbUM1AzkP18RZOGuwZx83sC4/V+v6ZMiC6OlHwZtCeDzR2jou5ikEj+eVAr4u8cn
	 7XftIpue+h1Jg==
Message-ID: <3d6796cc-6f45-4bc0-80a3-ceb7af8a3767@mit.edu>
Date: Mon, 26 Oct 2026 05:15:29 -0700
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
From: "Anders Kaseorg" <andersk@mit.edu>
Subject: [BUG] wifi: mt76: mt7925: ADDBA SSN lags the hardware sequence number
To: Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>,
        Ryder Lee <ryder.lee@mediatek.com>
Cc: Shayne Chen <shayne.chen@mediatek.com>,
        Sean Wang
 <sean.wang@mediatek.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

For about 30 s after associating with my AP, every SSH session from my 
laptop (Framework Laptop 13 with MT7925, kernel 7.3.0) is sluggish, with 
echoed keystrokes and command output arriving in bursts, delayed by half 
a second or more.  Specifically, because OpenSSH defaults to IPQoS=ef 
for interactive sessions, its packets get a TID distinct from most 
traffic; every TID stalls like this until it has carried 64 frames.

The cause is on both sides.  The MT7925 sends ADDBA requests whose 
Starting Sequence Number lags behind the sequence number the hardware 
actually uses for that TID, and the AP’s reorder buffer keeps waiting 
for the missing SN.

What I see, with a Linksys WRT3200ACM (Marvell 88W8964) as AP:

- By patching the AP’s mwlwifi driver to log the ADDBA SSN of every RX 
BA session from the MT7925, I find that after association, it’s 
consistently 0 for each TID.
- The client sends one QoS data frame on a TID before the session exists 
(mt7925_tx_check_aggr() starts the session from the TX completion of the 
first QoS data frame).  That frame uses SN 0.
- So the AP’s reorder window starts at SN 0, which never arrives within 
the session.  The 88W8964 firmware buffers every following frame of the 
TID until its ~500 ms timeout, which releases the buffered frames but 
doesn’t move the window start; only a frame beyond the window end (64 
frames later) does.

Reproduction recipe: right after association,

   ping -Q 0xb8 -i 0.02 -c 150 <AP>

(0xb8 = EF maps to TID 6, a TID nothing else uses).  Ping 1 is answered 
in ~1 ms (sent before the session).  Pings 2-26 are answered together 
~520 ms later, 27-50 together ~500 ms after that, and ping 65 (64 frames 
after ping 1) goes through immediately and releases 51-64.  Everything 
after that is fast.  Captures on both ends show the uplink frames 
reaching the AP’s network stack ~502 ms late; the downlink is fine.

The AP’s firmware is arguably at fault for not advancing the window on 
timeout (a mac80211 recipient would stall once, for at most its 100 ms 
reorder timeout).  But the originator should announce the SN of the next 
frame it will send under the agreement, here 1.

Cause, as far as I can tell: with SUPPORTS_TX_ENCAP_OFFLOAD the hardware 
assigns the sequence numbers of 802.3 frames, and mac80211’s 
sta->tid_seq[tid] never advances, so the SSN mac80211 puts in 
params->ssn for IEEE80211_AMPDU_TX_START stays 0.  mt7925 doesn’t 
override it.  mt7615 does, reading the TID’s SN from the WTBL 
(mt7615_mac_get_sta_tid_sn()).  mt7915, mt7921 and mt7996 use encap 
offload and don’t override it either, so they might have the same 
problem (not tested).

I’m happy to test any proposed patches.  I wasn’t able to fix it myself 
because I don't know where connac3 keeps the per-TID TX SN.

Anders

(Disclosure: I worked on this with help from an AI coding assistant. 
All measurements are from real hardware.)
