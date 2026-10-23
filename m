Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.255.225.202
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792778200;
	b=loyiVxJ5AoZJlqZGg+pU3JW0gjbUS/y/KHlsl7H65Cta4jFo9ZjyJPmZBSw5ichG0Aob
	 4+ekT4bhroRCtxICDEF7LMvE1NWLOXNFnYv4CT7q/d0XHfYUJ4H0HuFxmNiduWY2qAaB0
	 Wzi0CvpE6YhPItKMIeJVnBjpfIvSuE1+DNBoz7GN5BiP1Yn00xOCYiB2ic673WjHeBjpW
	 YREt1M6OGcM3QXQEZ6gesigQoMYKx9rlupLs2aceEsz18T4jBuxb9TeoBNN78J0M9T3I/
	 QdH9X95GwsbkebgJvUoi6c2WzWLTGyUTs1wbzQG/8Z91afU6hDxl2fucy/iRYIgaJEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792778200;
	h=DMARC-Filter:Received:DKIM-Signature:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ThreatScanner-Verdict:X-IPAS-Result:IronPort-PHdr:
	 IronPort-Data:IronPort-HdrOrdr:X-Talos-CUID:X-Talos-MUID:
	 X-IronPort-Anti-Spam-Filtered:X-IronPort-AV:Received:Received:Date:
	 From:To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:Content-Transfer-Encoding:In-Reply-To;
	bh=cVor6heXm2oce1250ghrSSnDDcUiPjp6nRn5tapiiZw=;
	b=5OBMR8cQT04pljLCPskbGXDXq/Ix13Xukd6QJdXgiAIUwYZ//4nvHLs0dMK2HV0UZPzM
	 VCu66Yqk1wmbNgjGGocZGZOAZsFH+asKQau12iCARnEtStgwe0Vbm+Kat1P8Z2QW6FwbW
	 VUF4qR74dldb3+Pkv7iIQbcvrihu7i3byCbhpqzPPkmjk0YskLHLPkDXJDZBJd10hTn1m
	 bYc9JJ5FH9DKh9f0vzljNEKQ+3IRVOVbIARFq6QDNYAlAyQKVa+SP/CXgJXcVjVQuMPsZ
	 djaJX8glxaaJtNja8hQXeK6dGhKPzYmjLesrtIne2RKAtKzUXCrMTKG5pzyR4sc9N5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=pobox.sk;
	spf=pass smtp.mailfrom=pobox.sk;
	dkim=pass header.d=pobox.sk header.i=@pobox.sk header.a=rsa-sha256 header.s=mail header.b=UWfY794i;
	arc=none smtp.remote-ip=46.255.225.202
Received: from gmmr-1.centrum.cz (gmmr-1.centrum.cz [46.255.225.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F80960A6F70;
	Fri, 23 Oct 2026 17:56:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8F80960A6F70
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pobox.sk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.sk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=pobox.sk header.i=@pobox.sk header.a=rsa-sha256 header.s=mail header.b=UWfY794i
Received: from gmmr-1.centrum.cz (localhost [127.0.0.1])
	by gmmr-1.centrum.cz (Postfix) with ESMTP id 4F5E63E7C9;
	Fri, 23 Oct 2026 19:56:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.sk; s=mail;
	t=1792778192; bh=cVor6heXm2oce1250ghrSSnDDcUiPjp6nRn5tapiiZw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UWfY794ihKHO3s1+N9gRJFpW2R5okI9QEmlpD42pDup0G1gZZE3yybRQtGT+OhVE4
	 OWarih0eYfJ2MZSsPgezgMw4zHTfMZg4tVLG9rut7/bX+s5HBtsHIiVBfDY7e2KFcB
	 00vcrqebrp08M4kVxecH+xYFTFKBkRjQAseAJlBo=
Received: from antispam62.centrum.cz (antispam62.cent [10.30.208.62])
	by gmmr-1.centrum.cz (Postfix) with ESMTP id 4D7473BB49;
	Fri, 23 Oct 2026 19:56:32 +0200 (CEST)
X-CSE-ConnectionGUID: FNq+xlWlTcKfnkgPk77fjg==
X-CSE-MsgGUID: SFJrXFnEQN6qpkDo4qVuPg==
X-ThreatScanner-Verdict: Negative
X-IPAS-Result: =?us-ascii?q?A2F3BQDtnttq/03h/y5agRKBSYU2li8dA4EThGeFfoZzi?=
 =?us-ascii?q?0WBag8BAQEBAQEBAQEJUQQBAYISgnMCjhgnOBMBAgQDAgMBAQEBAQEBAQEBA?=
 =?us-ascii?q?QsBAQYBAQEBAQEGBgECgR2GCVNJAYlIAYIHAYN/AQEBAQIBJwsBRhALDQsuE?=
 =?us-ascii?q?EYGE4U8AQMQJ7ZeeIEBMxoCZdx/FjUZZoF0FYE4iF8BhXkbg0KBH4ILRIEVg?=
 =?us-ascii?q?TuBODg+hCmGXwSCIoEMiE2NV1J4HANZLAFLCjUMM3JDA4EpSwU3ZRI/IR0oH?=
 =?us-ascii?q?jkCOAYFEiARGUFDW0QxKmuBB11wOylgAQIfJx8tFYF2AoJRgSMHVgIBSUEOB?=
 =?us-ascii?q?0VTCSVDEkckIggSCQETGi4LgRo1RSZBFRhYCxoFGkgIAgsCDHsoERAUgQI9N?=
 =?us-ascii?q?xUZBJJsgwdbUDAwBzpNVAg9kmOTfZ9aB4QhhHOVY4dmgTeDB5MtA4soh0aZC?=
 =?us-ascii?q?KN9A4VDgX+Bf02DWlMZjj0W0hx3PwcCBw8ChyqKfYFMAQE?=
IronPort-PHdr: A9a23:SA8Z5hEFwdr4d552Otwx5Z1Gf4xLhN3EVzX9CrIZgr5DOp6u447ld
 BSGo6k20hmRB86Ct6wY0KL/iOPJZy8p2d65qncMcZhBBVcuqP49uEgNJvDAImDAaMDQUiohA
 c5ZX0Vk9XzoeWJcGcL5ekGA6ibqtW1aFRrwLxd6KfroEYDOkcu3y/qy+5rOaAlUmTaxe7x/I
 Ru3oAnLqsUan4RuJrs+xxbIrXZFdfldyH91K16Ugxvz6cC88YJ5/S9Nofwh7clAUav7f6Q8U
 7NVCSktPn426sP2qxTNVBOD6HQEXGoZixZFHQfL4gziUpj+riX1uOx92DKHPcLtVrA7RS6i7
 6ZwRxD2jioMKiM0/3vWisx0i6JbvQ6hqhliyIPafI2ZKPxzdb7GcNgEWWROQNpeVy1ZAoO9c
 YQPCfYBPf1FpIX5vlcCsAeyCRWpCO7p1zRGhGL53bci3uovEQ/IwhItEc8NvnTao9r6KLodX
 ++3w6TT0TXObOlb1Svh5ITUbxwsp+yHU7JqccrWzEkiDx3LjlKVqYP/JDOey/oDs2+d7+pgT
 +2vlnUnpB9rojOywcoslpPFhp4SylDC9SV22ps1JcamR05hetOkCJxQuDqdN4p5WM8iWGJot
 T88x7YbtpG1YDIEx447xx7DdfOHaY6I7wrgWeufIzp1mXBodbK/ihuy8Uauxe7xW9S23VtLr
 idIndbCuH4Q2xHS6saKRPRz80Wu1DiB1Q3d5O5KLE8omaTULZMq370+loILvEnMHyL6glv6g
 a+We0k+5OSk9eTqbq/kq5KeL4N4lwLzP6c0lsCiAOk1MBICU3WV9Om+zrHv4E30TbFMg/Yri
 KfWqoraKt4epqOhBg9V1Zss5AinAje91dQYgWEHLFVYeBKbl4TpO0/BIPT/DfqnjFSslS5nx
 +vDPr39GpXBM2TPnK39crlj7U5c1BAzzc1a555OFr4AIer/Wk73tNPGEh80KwO5zuf9BNlj1
 o4TWXiDDrGHPK7Sq1OF5OAiL/GJZIAPuTb9L/Yl5+TpjX88gVIdYbOl3YcQaHC+HvRpOViZY
 WHyjdcbCmoKpg0+Q/ftiFyNSzJTfHWyU7om5j4nEIKmEZvDRoe1jbyHxyi0A4ZbZmZdBV+RC
 3vocZ+LW/ISZy6KOM9ujiQEVaS9S48mzRyuqAj6y7l5IefP5i0YspHj28Zv6+LOlhE+7SZ0A
 NiF02GRU2F0mXsFRzs33KB5vEx8xU6P0atmjPxCE9xc+fdJXxwkNZ7T0eN6Ecr+WgHfcdeTT
 lapXNGmDSs2TtIrzN8Ce1x9FMm6jhDfwyqqBKcYl7iKBJwy76Ld0GH9Jsh8y3bcyqYhi0cpQ
 tBUNWC9mK5/+BbcB5TTn0Waiamqb6Ic0zDJ9GuZymqOpk5YXBZ2UareRX8ffFfZrczl5kPeS
 L+jEbsqPhNcxs6BK6tKb8Xkg01JSvjtJtrQf368lWGoCRmVw7ODdpDqdHkF0SvFEUYKiw8d8
 W6dNQgmCCesu3rQAiV2G1zgMAvQ9rxCr3C2Bm+fHwCOZkttkpgeKgQaiPqHRvVbiq4DuyoJt
 zJ3ERCx3ISFJcCHol9de6BVepsB51FH3H/CuhY1aoDmM6dkhlcDaAltl1vp3RJnTJ5Dx5t55
 Eg2xRZ/fPrLmGhKcCmViNWpYuW/Fw==
IronPort-Data: A9a23:AQai66izlcM4+VBVQlKcqKxUX161ZxEKZh0ujC45NGQN5FlHY01je
 htvUTuEa/eIYGqmKY10PYS1oEIF65SBndAxTQE+rH01RCJjpJueD7x1DKtR0wB+jCHnZBg6h
 ynLQoCYdKjYdleF+FH1dOSn9SAivU2xbuKUIPbePSxsThNTRi4kiBZy88Y0mYcAbeKRWmthg
 vus5ZeAULOZ82QsaDxNs/jY8E8HUMna4Vv0gHRvOJing3eBzxH5PLpHTYmtIn3xRJVjH+LSb
 47r0LGj82rFyAwmA9Wjn6yTWhVirmn6YGBiIlIPM0STqkAqSh4ai87XB9JAAatjsAhlqvgqo
 Dl7ncfpFVp2ZP2kdNM1CHG0GwkmVUFPFSSuzXKX6aR/xGWeG5fgLmkH4Ojb8uT0984uaVyi+
 8D0JxgjSAnAl+aJxI6waedqhcsbL5a0MoEQ7yQIITHxVZ7KQLjMRuDR4MNAhW92jc1IAezDY
 owSe1KDbjycPVsVZwpRUshj2rj37pX8W2QwRFa9uewr5G7TxRFq3aLFKN3ffczMXsY9ckOw/
 z+YoDmmW0hFXDCZ4QGr0GicqOnipAWlQZoROLrk78B3uFLGkwT/DzVTDzNXu8KRjESyc9RVJ
 woS8y8jxYAu80+mZsX6XBD+rH3slhodXcdAVu438geAzoLK7AuDQGsJVDhMbJohrsBebTgr0
 EKZ2szoHzFrvaaOYWyS+63Srj6oPyURa2gYakc5oRAtv4el+txuyEiVE5A8T8ZZk+HIJN05+
 BjSxABWulnZpZdjO3mTlbwfvw+Rmw==
IronPort-HdrOrdr: A9a23:HBIUDaM3SO4+1cBcTsyjsMiBIKoaSvp037Dk7S9MoDhuA6mlfq
 eV7ZAmPH7P+VQssR4b8+xoVJPsfZqYz+8T3WBzB8bAYOCFggqVxehZhOOI/9SjIU3DH4Vmu5
 uIHZITNOHN
X-Talos-CUID: 9a23:vDyXiWGQvnwhDdQxqmJJ0ldXCsQadkHW73nWIECACjk2Rr+aHAo=
X-Talos-MUID: 9a23:5i/d2wkznYCCEalP/lR5dnpZGuVy04qoJXkrz4weuOWDaTVOJg+S2WE=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.27,174,1787004000"; 
   d="scan'208";a="156757117"
Received: from unknown (HELO gm-smtp10.centrum.cz) ([46.255.225.77])
  by antispam62.centrum.cz with ESMTP; 23 Oct 2026 19:56:32 +0200
Received: from blackbox (188-167-137-159.dynamic.chello.sk [188.167.137.159])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gm-smtp10.centrum.cz (Postfix) with ESMTPSA id CB8DA80911AD;
	Fri, 23 Oct 2026 19:56:31 +0200 (CEST)
Date: Fri, 23 Oct 2026 19:56:16 +0200
From: Tomas Tonhauser <t.tonhauser@pobox.sk>
To: Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] wifi: ath9k: clear destination mask for
 non-aggregate frames
Message-ID: <atufwCYLtoF3UaMk@blackbox>
References: <20261003192957.761090-1-t.tonhauser@pobox.sk>
 <87mrs9v3aa.fsf@toke.dk>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87mrs9v3aa.fsf@toke.dk>

On Mon, Oct 19, 2026 at 10:33:33PM +0200, Toke Høiland-Jørgensen wrote:
> Tomas Tonhauser <t.tonhauser@pobox.sk> writes:
> 
> > Frames to stations without an A-MPDU session (e.g. non-WMM/non-HT
> > clients) use the non-aggregate path. If the hardware returns such a
> > frame with ATH9K_TXERR_FILT, ath_tx_complete_buf() reports it to
> > mac80211 as IEEE80211_TX_STAT_TX_FILTERED. For a station that is not
> > in powersave, ieee80211_handle_filtered_frame() retries it once and
> > drops it if it is filtered again.
> >
> > The aggregate path re-queues filtered subframes on tid->retry_q and
> > sets tid->clear_ps_filter, so they are retransmitted until they get
> > through.
> >
> > The result is downlink loss to awake non-WMM stations, while WMM/HT
> > stations on the same radio are unaffected. On a QCA9563 AP with
> > ESP8266 clients this caused 20-45% ping loss, with two TXERR_FILT
> > completions per lost frame and no XRETRY failures.
> >
> > Set CLRDMASK on every non-aggregate frame. This restores the
> > behaviour from before commit 5519541d5a5f ("ath9k: fix powersave
> > frame filtering/buffering in AP mode") for the non-aggregate path
> > only. The trade-off is that non-aggregate frames already queued in
> > hardware when a station enters powersave may be sent to the sleeping
> > station instead of being filtered.
> >
> > Assisted-by: LLM
> > Signed-off-by: Tomas Tonhauser <t.tonhauser@pobox.sk>
> > ---
> > RFC: is this direction acceptable, or is one of the alternatives
> > below preferred?
> 
> Hmm, no, I don't think unconditionally clearing the filter is the right
> thing to do. See below.

Understood, thanks for looking at it.

> 
> > Setup: TP-Link EAP225 v3 (QCA9563, 2.4 GHz), OpenWrt 25.12.5,
> > backports 6.18.26. Clients: ESP8266 running Tasmota, modem sleep
> > disabled, associated without WMM (legacy rates).
> >
> > Ping from the AP to one client, 30 packets, 14 lost:
> >
> >   station "tx failed":             +14
> >   station "tx retries":            +2
> >   ath9k/xmit BE "TXERR Filtered":  +27
> >   ath9k/xmit BE "MPDUs XRetried":  +0
> >
> > A second run: 12 lost, Filtered +28, XRetried +0.
> >
> > Ruled out:
> >  - Client powersave: PS_STA never set in debugfs station flags, and a
> >    monitor capture showed no client frames with the PM bit set.
> >  - airtime_flags=0, aql_enable=0, nohwcrypt=1: no change.
> >  - RF: signal -50..-64 dBm; a WMM/HT client on the same radio has
> >    0 tx failed out of ~10k frames; the same ESP8266 hardware behind
> >    an ath10k AP has no loss.
> >
> > With the patch: 500 pings to each of five ESP8266 clients, 0 lost.
> >
> > Open question: what sets the destination mask for stations that are
> > awake and never hit XRETRY? 5519541d5a5f removed an unconditional
> > CLRDMASK commented "needed for crypto errors", so the hardware may
> > set it in other cases too.
> 
> This is a good question. Maybe Felix knows?
> 
> Regardless, of your alternatives:
> 
> > Alternatives:
> >  1. Set CLRDMASK only when the station is not sleeping.
> >  2. Re-queue filtered non-aggregate frames in ath9k for awake
> >     stations, like the aggregate path does.
> >  3. Allow more than one software retry in
> >     ieee80211_handle_filtered_frame() for awake stations.
> 
> I think 2. makes the most sense. In fact, AFAICT, there is currently
> *no* software retry logic for non-aggregated frames in ath9k? So you hit
> it due to this weird filtering issue, but presumably random interference
> can also just lead to losses if they exhaust the hardware retry chain.
> But maybe this is not something that's noticeable because the hardware
> retry chain is usually enough? Do you notice any errors/retries in your
> AP stats after applying the fix (in normal usage, not just with a ping
> test)?

AP uptime with the patch is ~20 days, normal usage (mostly MQTT,
plus OTA firmware updates of all ESP devices early on).
Apart from ESP's and the camera (which are fixed), there are mobile
devices which come and go.

Per station (counters since association, ~19 days):
  10 x ESP8266 (non-WMM): tx failed 21..84 each,
                          0.018-0.057% of tx packets,
                          signal -50..-83 dBm, many hw retries
  ESP32 (WMM/HT):         1 failed / 1.8M tx packets
  IP camera (WMM/HT):     0 failed / 268k tx packets

ath9k xmit, BE queue, 20 days:
  MPDUs Completed:   3776047   MPDUs XRetried:   6130 (0.16%)
  AMPDUs Completed:  111572010 AMPDUs XRetried:  4605
  TXERR Filtered:    343

So the filtering losses are gone, but non-aggregated frames still
fail after the hardware retry chain far more often than aggregated
ones, which matches your point about missing software retries for
them.

> 
> Anyway, I don't think it's unreasonable to add the same retry logic to
> non-aggregated frames that we have for aggregated ones, and the retry_q
> seems like the simplest way to do that.

I'll work on re-queueing failed/filtered non-aggregate frames on
tid->retry_q for awake stations and send a v2.

> 
> -Toke

Thanks,
Tomas
