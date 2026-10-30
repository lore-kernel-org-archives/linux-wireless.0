Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.207
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793384184;
	b=XxCfISgzVbK5/7gbu2pTB2AkDpf9Tph0zZ/r/q/aIlOL1qbv2DJwAFEEirem5G8cxYJM
	 YIkiy6rxdBTADEnFUvBq2QRYL3WvvJh4c1g2Dty7AsWA+f7qwWzmNz5GrRwWadls3ujAs
	 31cVgRffOJ6pnw4el9qUUD9q7S6qTBzOstfY/OLHmEj75lHHM8iNWYWQvJEja1izONEyt
	 XT7sTeyXqMWT2wwHgYRFJI30iJkr6mxMrmIKMJzeETXtTVlDfIIdnBdgPKUCU+o+kz4PO
	 7Uf/QESEQz/kDgraV9CFXDASLJEMPtF8lZ1RO/ipNiXkSxUG23S+2AFvbz6Swo4HnBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793384184;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:MIME-Version:Date:Content-Type:
	 Content-Transfer-Encoding:From:Message-ID:TLS-Required:Subject:To:Cc:
	 In-Reply-To:References;
	bh=uRUrH7xb1dUfTLeJp9gZP/lJQlZ4lgtPhAWQiPHp3uU=;
	b=z24kMC4L1ifdJAN48OD3HkXg+am0KFCmPc1Uk8NhC0P/o+T0ukLOC9YAIn54zUzy6JS2
	 JU1edFPpHDbNl5gPoyMSiprU5XHmXHBSHGGBmzuqg3zsSCXOZpulPNCmryUQ/Ubb4/pqr
	 QpATeKGe6HiVOia76ThjRzJchzeyWduFKSWoofQtUwmOAkgN+Q45j2u5JGPonkRch4/jX
	 bSb9s4VjeWQOmLQSRidY9dMhWY9VKDHU/bxPUgGBDNsrinDszUXidY/GC/6HVr+Ehvyoo
	 wFMjop0GPkt+ZB7X8mZm1QoBgmM6OF2ZrTCxTjdQf8Y49K/im4r7y1XFNy8wez4PRPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=eaMsNL43;
	arc=none smtp.remote-ip=91.218.175.207
Received: from mta0.migadu.com (out-207.mta0.migadu.com [91.218.175.207])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EE74606A31C
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 18:16:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9EE74606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=eaMsNL43
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=62U1Kl5SrpQSnq6H/7WvaSOR2VDKaZhhumC9ay/FrSI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793384181; v=1; x=1793988981;
 b=eaMsNL43E+isvIi+Wj/QSYuCFygDIP4/U+omcB1spijkHULj9M2OY8PygX7m9m5732VqdUQ/
 s9NMoWKVMRxxzB523MqwzcG+U+yNIKyY3ncMro3Fbw/1Cn+IP4zg8duxQ72Bbehh2GFyWOEIkim
 6A/wF2uQeQCCaAEl06VufsD4=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 89e73c8b3a5f57c0;
	Fri, 30 Oct 2026 18:16:21 +0000
X-Mizu-Trace-ID: 89e73c8b3a5f57c0
X-Migadu-Flow: FLOW_OUT
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Fri, 30 Oct 2026 18:16:21 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <b54683e9ddd81ae2a4f08ed4a8dedcfdb0209a28@linux.dev>
TLS-Required: No
Subject: Re: [PATCH 5/6] wifi: rtw88: 88xxa: adapt channel sensing to
 receiver gain
To: "Bitterblue Smith" <rtl8821cerfe2@gmail.com>, "Ho Jie Feng"
 <hjf3108@gmail.com>
Cc: "Ping-Ke Shih" <pkshih@realtek.com>, linux-wireless@vger.kernel.org
In-Reply-To: <15240b8b-31f0-4587-a7a6-28cd4d36775b@gmail.com>
References: <20261029055212.84711-1-hjf3108@gmail.com>
 <20261029055212.84711-6-hjf3108@gmail.com>
 <15240b8b-31f0-4587-a7a6-28cd4d36775b@gmail.com>

Hi Bitterblue, Jie Feng,

Thanks for testing this Bitterblue. I had a look at why the scan gets so
slow and I think I found the cause.

October 30, 2026 at 3:57 PM, "Bitterblue Smith" <rtl8821cerfe2@gmail.com>=
 wrote:

>=20
>=20On 29/10/2026 07:52, Ho Jie Feng wrote:
>=20
>=20During the scans I see a lot of "timed out to flush queue 1" (and 3)
> in dmesg. You need debug_mask=3D0x80000000 to see these.

[ ... ]

>> +void rtw88xxa_adaptivity(struct rtw_dev *rtwdev)
>> +{
>> +    struct rtw_dm_info *dm_info =3D &rtwdev->dm_info;
>> +    int igi_diff =3D EDCCA_IGI_BASE - dm_info->igi_history[0];

As far as I can see, igi_history[0] is not always the IGI in the hardware=
.
Since 3f90942473d2 ("wifi: rtw88: Increase the RX gain before scanning")
a sw scan writes IGI 0x1c without updating igi_history:

        rtw_core_scan_start()
          rtw_phy_dig_set_max_coverage()
            rtw_phy_dig_write(rtwdev, DIG_CVRG_MIN)

rtw_watch_dog_work() skips rtw_phy_dynamic_mechanism() while scanning, so
if I read it right 0x8a4 keeps the value computed for the associated IGI
for the whole scan.

In the 8812au vendor driver these chips are in ODM_IC_PWDB_EDCCA, and
phydm_adaptivity() computes the threshold from the current IGI
(cur_ig_value) with the same formula as here. So with the gain raised and
0x8a4 unchanged, EDCCA seems to get more sensitive by the difference
between the associated IGI and 0x1c. Since rtw88xxa_adaptivity_init()
clears BIT_DIS_EDCCA, the MAC would then hold the frames.

I think this matches the flush timeouts quoted above. Queue 1 and 3 are
the LOW and HIGH priority queues, and mac80211 flushes the queues every
time it leaves the home channel. Most of the delayed pings also came back
together at about the time the scan finished, which is when
rtw_core_scan_complete() writes the old IGI back.

The 8812A beacon loss branch in rtw_phy_dig() switches to DIG_CVRG_MIN
after rtw_phy_dig_recorder() has stored the other value, so the same
mismatch seems possible outside of scans too.

Jie Feng, maybe something like what rtw89 does in 280c444745aa
("wifi: rtw89: config EDCCA threshold during scan to prevent TX failed")
would work here, setting 0x8a4 to 0x7f/0x7f at scan start and restoring
it at scan complete. Or rtw88xxa_adaptivity() could use the IGI that is
actually in the hardware and run again when the core writes the IGI,
which would also cover the beacon loss case. I think this belongs in
this patch for v2.

And one more thing Bitterblue, is there a reason for your email only
being addressed to the mailing list. I am pretty certain that the
author hasn't subscribed to the mailing list so your test results
might now reach them.

Best regards,
Luka Gejak
