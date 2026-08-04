Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E808842AFB9
	for <linux-wireless@vger.kernel.org>; Tue,  4 Aug 2026 07:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785827955; cv=pass; b=fC/3jMlOIIN5RWsd0UmUosLG58pphox00cg+AIRJjdrqA4a13jZxM1moOfs6NyNmB6APg86D/MabG/WxlBFhADvfp7AC/zTWOXLIJmztN5GxnYA3UWM2qeWuzbqAnnW0oRxmcigxtuOJRxTty0HYjCwl8BcY5QwwbN5WPud7Z4E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785827955; c=relaxed/simple;
	bh=kGv8yM/L4BL7yuGUlXwYjgPB45f2zbPoZqK35vTyQks=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E4Cnw4dVCg2MVY7oZG3BSaUF1cM1dXT233Nms4RKR5BktaMFSXSXmLqzbtExdmtv3GPpXQ631vwdoS6heUaBH2kBGYgTD886CduxKXBusfKeXD6o3CPLL+0NmNUvSInYZi4VYU4utPjiGiQUrlPxy9+xp4f27XDPz4BCw61xDQA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UWFMLSyz; arc=pass smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UWFMLSyz"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-527e352a167so27130341cf.1
        for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2026 00:19:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785827952; cv=none;
        d=google.com; s=arc-20260327;
        b=XWG08XeB9m1odUrSrqSC02pOj+/wEdX5pZb3M7RaSwWa+q4FHeR2xfZGIDALNOsiBY
         GmVFWuJqcnoQFcZm7l667v88d/UvgJQ4vlxqDUWNOLpXoHYlugFnEi4FmMAxOXEVGhCS
         HaoUt5ol8GzpiiAvESWAtcgjxz0iANdqVJop4WFPqH2lQVr6WGJvidjwIv8r79JtSPGo
         5y6Kh+EVxyr8x4BKjlNxgKyIgATNytDrYlpGEZ6g2Z8wzKQbEFvPea7WZyT/gxeihDgy
         4FLBy4n3azaFv5NxRxFCFiU25LOVbsbCotpolAD/7xjyPkuPyUJepBAAK8jOa9x1Py5c
         40ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=iwbyHSDGC8YPw/8kargj/smRm2DAbzxndqNGQdk4YPU=;
        fh=PIR3nG35/MN29V1ftQmjr48ix/NojA/0bkCy9k7uWa4=;
        b=hy5z35RIZAl6Qveho6xqyip78SLHjSuBVSbUko8Rvb/fxxddleeEbY/2lqOP2ygcIH
         bfUW7Vm7FTuzPBHzbojepPRRD9b7qqowV9MgVXl876RUs1/PVnPEDxVsoqQtV9SJ8LYp
         0BN7x70irChzaxBPWjDHz+pgXuulk7pfKYq0Mai7Pi2EtsI6utCp4CQnbEezbqfaIWw/
         yPHQoS4+fI3tbYzoFrJoK1r+uG/tloV0dxgjWmbgpL7GsBo1SmHpc4ITEkBTK1I5AIz3
         R13BmwdLLtdjBhkRjMsorEDZC5XXrAjuj+TwZXr0gudywZ1Ft5dJEkQKbsnkUyZxws1i
         Qd8w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785827952; x=1786432752; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iwbyHSDGC8YPw/8kargj/smRm2DAbzxndqNGQdk4YPU=;
        b=UWFMLSyzLlhy5DO2i4Cg3D8Hn+QQhbuh5H5IVYwhG4uyiXshRLv2og2bIJYNpAwbDC
         dXiCd5kJPFU+UFr01EwbcQQ91nyxK3nB3knJdZMNIPJf4e6QDMSr9Rmu/kzGmUq09et1
         csE3u7qva88ulRc3XA2mBdhvCDd9UWX5o6dYLSeQdNOSiKzCQ+DqP+azitY/d3WyRt0b
         wms2O2imOu3NAL7HjON+7AOJSlHKJwqZlYUOi46XCEimAcaINCzLMVmZx3XxRt7L/WlG
         gyXd0f0KPWgHjTRh9HqUecx6go/Li63SiF9aPhb2qN74ZIUwiTc/CLGHbHSiF12WCcAF
         tgbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785827952; x=1786432752;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=iwbyHSDGC8YPw/8kargj/smRm2DAbzxndqNGQdk4YPU=;
        b=WoeQLggvthDSw0VBjE1bpKCHPcynGfK3A9tpEMaEwzOlY53VDnzFPZ9Rky0VNQv6bm
         VpqTVVd08u6mEM1gumyzozExokbpRdhnCXXRkMkc+QbyxjjXyBdLWg+4JnyO4I/e9EeX
         QGXbnVJB8TTs8VYz6PbAL9mwXglJsAc+ZUO3n5AWPIh+dDM3dE7Vh//ykljJjJ7CVj54
         5/MsIDjj7iTv4e6DSve0n1oNBQwAC+7hJVZ7rrKdlkB0AHMI1uFeCV0WXST3+h1LXxyn
         6hKdTOLEtbyqaKH4XCWiIsdbOwtO3fPzFLHXQBMk3RkkuU8JN2/547z9jDmwn/GqfTbH
         aFvA==
X-Forwarded-Encrypted: i=1; AHgh+RpbHSAeHu2AKg00Xp2ELs6ZbGKyC1tvPU7ZSZYbwQp9TtjgVI7k3lbpep25PLRgtoe3DzbRHO4XnOx8/ukTCw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyio7E83R49SlAl6RUnPrWKPNL6pjOVzeV0rJ0n9vqv89kejgXy
	nXVan7XuS+gDdspuWew2OlSdVbY4Fv5YECxtr9VzQyLEVKGooRbam15dsRWY8MikYCi4hTkBnSY
	ApOxgb/gSqdD8tQY821lnprCFJgRgalE=
X-Gm-Gg: AR+sD13n+Z7s3mnHlYXj7EX3rUSPOySaPW5f8xH2j8JBic6iNzT4Jk0E6Dsyvq5CB2G
	HeizI6chHFZzBJ5q+jDxYoCqodInTgCli8qnl8dEXB3J0bCDWwlP3T9ijwm/FUGY1uc8JSFeA46
	I58ee4mMOHc7dM7Op7A0Rtff+cDCiiIKRyFtnzkdbZgjMqGutvXkWEiG1JgPfhL0T1KNwJ3sfwc
	JIVGcUnZgXrWneWttHXYUhHrrPifEcT9vYV3GmakB3J40P6NjTzhMegX2DFEcj8GLrb5XeVo5BI
	tIqa8uSjTzgV+5XQ0aCDPz6d6mVMdPBm1epctPD24YcKTPGmioiCao5rSsc6ibugiG2boVkZdxF
	DMbkO+20WxtYxWymbjIQbe/5m0v5Z1bTBq239Q1x7m4mCjk0J0GiNplrdtsaddTKM1CfmDjvhpQ
	s4bwDXWTN3IchAn8c/JSPj9QLseSLt5He3FW7XY7tR/Ydmz/0qPQ==
X-Received: by 2002:ac8:5705:0:b0:51a:89c1:1eef with SMTP id
 d75a77b69052e-52b5673773fmr242693011cf.14.1785827951482; Tue, 04 Aug 2026
 00:19:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260804065425.17364-1-luka.gejak@linux.dev>
In-Reply-To: <20260804065425.17364-1-luka.gejak@linux.dev>
From: Peter Robinson <pbrobinson@gmail.com>
Date: Tue, 4 Aug 2026 08:18:59 +0100
X-Gm-Features: AUfX_mzXAvuxZmcXFMnf-6iEkQ6vJrC0AikucamK_Q9QndGDJ7_AKTp1aUIz9fA
Message-ID: <CALeDE9MjtFthMsA6w5=6vhMT+C959Wi0zh5knwLoQfy6_A0TmQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] wifi: rtw88: preparations for RTL8723B/RTL8723BS
To: luka.gejak@linux.dev
Cc: Ping-Ke Shih <pkshih@realtek.com>, linux-wireless@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Michael Straube <straube.linux@gmail.com>, 
	Bitterblue Smith <rtl8821cerfe2@gmail.com>, Hans de Goede <johannes.goede@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"

Hi Luka,

Is there a branch somewhere that has the remaining patches to be able
to test the full stack?

Might be useful to reference that in the cover letter in future
versions as well so people can find it if they wish to test the whole
driver end game.

Peter

On Tue, 4 Aug 2026 at 07:55, <luka.gejak@linux.dev> wrote:
>
> From: Luka Gejak <luka.gejak@linux.dev>
>
> This is the first of two series adding support for the Realtek RTL8723B
> 802.11n chipset and its RTL8723BS SDIO variant to rtw88. It contains
> only the changes to the shared rtw88 core that the chip driver depends
> on. The chip itself, the build glue and the MAINTAINERS entry are a
> second series.
>
> v1 had 19 patches, v2 had 11, this has 5.
>
> There is no rtw88-style firmware for this chip and no documentation for
> the vendor blob it does use, so while bringing it up I deliberately kept
> the driver as close to the vendor driver's behaviour as I could. With
> that many unknowns at once, matching the vendor exactly was the only way
> to tell which difference actually mattered when something did not work,
> rather than guessing. A number of the v1 patches came from that: they
> reproduced vendor behaviour that was useful to hold fixed during bring
> up, not behaviour the chip turns out to require.
>
> Bitterblue Smith's review of v1 prompted me to go back and remove each
> of those on hardware to find which were actually load bearing; eight
> were not. Ping-Ke Shih's review of v2 did the same for a further six,
> and the changelog below gives the measurement for each. In three of
> those cases I had told the list, or claimed in a commit message, that
> the chip needed something it does not, on the strength of bring-up
> notes I had not re-measured. All three corrections are in the
> changelog.
>
> What is left is there because removing it made something measurably
> worse, not because the vendor driver does it.
>
> What is left falls into two groups:
>
>   - SDIO (patches 3, 4, 5): software free-page and output-queue
>     accounting, RX aggregation and interrupt setup, and TX back-pressure
>     with a retry on page starvation;
>   - patches 1 and 2: the chip type and helper plus a one-line receive
>     fix.
>
> This series no longer touches fw.c, coex.c or mac80211.c at all.
>
> Scope
> =====
>
> Everything is gated on rtw_is_8723bs(), which is false for every chip
> currently supported, so behaviour for existing devices is unchanged.
> There is one exception, deliberate: patch 2 extends an existing RTL8703B
> zero-length-packet check and is gated on the SDIO interface rather than
> the chip id, since that is the only place the behaviour has been
> observed. Ping-Ke has suggested that check may not need a chip test at
> all; I would rather measure that on RTL8703B hardware than assume it,
> and I do not have that part, so it is unchanged here.
>
> Patch 4 changes how the SDIO interrupt status is acknowledged. In v1
> that applied to all SDIO parts; it is scoped to this chip only, and the
> others keep writing the status word back unchanged.
>
> Chip specific code in the common path
> =====================================
>
> Ping-Ke asked whether this needs a set of ops rather than a chip test
> sprinkled through the core. Working through that question is what
> removed most of this series: once the association and coexistence
> patches turned out not to be needed, the chip tests they carried went
> with them.
>
> What remains is one test in rx.c and eleven in sdio.c. There are none
> in fw.c, mac80211.c or coex.c. The SDIO ones are in the bus driver
> rather than the chip driver, and rtw_sdio has no per-chip ops table
> today; Ping-Ke confirmed an inline chip id check there is fine.
>
> Fixed in the second series
> ==========================
>
> Two of Bitterblue's review points are addressed in the chip driver
> rather than here, because that is the right place for both:
>
>   - the hardware capability is filled in from a chip-specific
>     read_efuse, instead of special casing rtw_dump_hw_feature() in the
>     core;
>   - the receive FCS handling is a chip configuration fix. v1 stopped the
>     core advertising RX_INCLUDES_FCS for this chip. The real cause was
>     that the chip cleared BIT_APP_FCS by assigning WLAN_RCR_CFG over
>     hal.rcr wholesale, where the 8723x siblings only write the register
>     and leave hal.rcr alone. Setting that bit in the chip's WLAN_RCR_CFG
>     makes the descriptor carry the FCS like every other rtw88 chip, so
>     the core needs no special case and both hunks are gone from this
>     series.
>
> Neither change is visible here. I planned to send that series once this
> one is applied to rtw-next, but I can send it now alongside if you would
> rather review them together, or fold the two into one series if that is
> easier.
>
> Testing
> =======
>
> Tested on RTL8723BS hardware together with the second series: repeated
> scan, authentication, association, WPA2-PSK/CCMP handshake, DHCP,
> bidirectional traffic, reconnects and module reloads.
>
> Throughput is measured against an iperf3 server one hop behind the AP,
> with the wlan0 byte counters as ground truth because the test machine's
> wired interface shares the same subnet. On one AP at strong signal
> (-35 dBm), 2.4 GHz HT40: TCP 19.1 Mbit/s up and 37.8 Mbit/s down, UDP
> 25.0 Mbit/s up and 40.0 Mbit/s down, both at 0% loss.
>
> Uplink on this band drifts by several Mbit/s from day to day, enough to
> swamp the differences I was trying to measure, so where the changelog
> below compares two builds the comparison is a paired test: the two
> builds alternate within one session, rebuilt and reinstalled each time,
> rather than being measured on different days.
>
> Suspend and resume are not covered: this machine only offers s2idle and
> does not reliably come back from it.
>
> A five minute soak: 1495/1495 pings at 0% loss, 15/15 reconnects, 5/5
> link up/down cycles, 3/3 module reloads, 5/5 scans under traffic, 24
> group rekeys, no deauthentication, no SDIO errors, no warnings in the
> log. Scanning saw the target AP in 18 of 18 attempts across 6 cold
> module reloads, with 6/6 associations.
>
> The soak and scan figures were taken on a build that also carried the
> reserved page patch dropped below; the throughput figures above are from
> the tree posted here.
>
> Every patch builds with W=1 with no warnings on its own, sparse is clean
> at the tip, and smatch reports nothing in any file this series touches.
> checkpatch --strict is clean across this series. The other rtw88 bus and
> chip modules continue to build.
>
> Changes in v3:
>   - Dropped "fw: fix the reserved page upload on RTL8723BS". Its commit
>     message said the BIT_BCN_VALID handshake fails on 8723BS SDIO
>     without it. That does not reproduce. The failure path is an explicit
>     rtw_err("error beacon valid") returning -EBUSY, reached from
>     BSS_CHANGED_ASSOC on every association; over three associations on
>     each of five builds with the patch reverted it never fired,
>     associations were 3/3, and there was no packet loss after 30 s idle
>     in power save, which is the path the reserved page's null data and
>     PS-poll frames serve. As a control, rtw_info messages appear in the
>     same captures and rtw_err outranks them, so a failure would have
>     been logged. AP mode and WoWLAN also download the reserved page and
>     are not tested here, so if it turns out to matter there it can come
>     back with evidence behind it.
>   - Kept "sdio: add TX back-pressure and retry on page starvation", now
>     with a measurement rather than an assertion, since you asked whether
>     the remaining chip tests are necessary. Counting
>     rtw_sdio_tx_handler invocations under an identical 60 Mbit/s UDP
>     flood, because the retry re-arms that same work item: 1798 and 3095
>     on two baseline runs against 69 with the patch reverted. Achievable
>     transmit rate falls by about a third without it, 25.5 Mbit/s against
>     38.3 and 40.2. tx_dropped and tx_errors stay at zero throughout, so
>     the failure is not dropping frames, it is failing to push them.
>   - Kept "sdio: set up RX aggregation and interrupts". The aggregation
>     half makes no measurable difference to throughput here, and on that
>     evidence alone I would have dropped it. The rest of the patch does
>     not show up in a throughput test at all: the chip keeps raising the
>     interrupt after resume if undefined status bits are written back
>     when acknowledging.
>
>     I have not been able to validate the suspend and resume path: the
>     test machine only offers s2idle and does not reliably resume from
>     it, so I cannot exercise the interrupt acknowledgement change. It is
>     kept because the failure it addresses was observed during bring up,
>     not because it has been re-measured. If someone with hardware that
>     suspends cleanly finds it unnecessary, it should go.
>   - Dropped "run the RTL8723BS association register sequence", 440
>     lines, which was the vendor join sequence, six sites in
>     rtw_ops_bss_info_changed() and both sites in rtw_ops_set_key().
>
>     Ping-Ke asked for this to run from rtw_chip_prepare_tx() rather than
>     a chip test in mgd_prepare_tx(), and I had done that with a new
>     chip_ops::prepare_tx. Since the whole patch is gone, so is the
>     callback; the core is left as it was rather than gaining an op with
>     no user.
>
>     I had told the list that association fails without these registers.
>     That was wrong, and it was bring-up-era data I repeated without
>     re-measuring. With the whole patch reverted: 18/18 scans saw the AP,
>     6/6 associations, and the five minute soak above, whose 15 reconnects
>     and 24 rekeys exercise the exact path the sequence ran on, since it
>     ran from mgd_prepare_tx() on every authentication. Uplink measured
>     paired against the full series, 19.0 against 19.2 Mbit/s over ten
>     runs each.
>
>     The default key search handling in that patch was also simply wrong:
>     rtw_sec_enable_sec_engine() sets sec->default_key_search itself and
>     programs all four USE_DK bits on that basis, so the enable path was
>     a no-op and the disable path was clearing bits the core had
>     deliberately set.
>   - Dropped "coex: add the RTL8723BS scan antenna workaround" and "coex:
>     reassert the antenna path when associating", and with them "fw: add
>     the GNT_BT firmware command", whose only caller they were.
>
>     The commit message on the first claimed the site survey does not
>     hear the AP reliably without it. That is also wrong: 18/18 scans
>     without it. Both were gated on the chip and on coex bt_disabled, so
>     that gate is their entire scope rather than a subset of it, and the
>     measurements above cover it.
>   - Dropped "record beacons from the target BSSID before
>     authenticating". Ping-Ke doubted the beacon wait affected the
>     connection and he was right: with the wait removed, association
>     succeeded 12/12 from a cold module reload and 12/12 from a warm
>     reconnect, against 10/10 and 10/10 with it, at the same latency.
>     The pre-auth deauth already sleeps 100 ms with the recording window
>     open, so on a 100 ms beacon interval the wait was almost always
>     already satisfied when it was reached. struct rtw_auth_sync and the
>     RX-path hook go with it.
>   - Dropped the BT_MP version queries and the BT_INFO query at scan
>     start, and the BT_INFO query plus two of three repeated PS-TDMA
>     H2Cs in the pre-auth replay. Measured over cold module reloads with
>     three scans each, 8 reloads with the queries and 10 without: 29/30
>     scans saw the target AP and 10/10 associations succeeded without
>     them, against 24/24 and 8/8 with them.
>   - The cached SDIO page counters are clamped at zero. A lost update
>     between the free page check and the accounting could previously
>     drive the public counter negative, and the sum was assigned to an
>     unsigned, which made the check pass unconditionally from then on and
>     suppressed the resync that was supposed to recover it.
>   - REG_SDIO_FREE_TXPG now has field masks and is decoded with
>     u32_get_bits(); the RX DMA burst count uses BIT_DMA_BURST_CNT;
>     open-coded BIT(0)|BIT(1) on REG_SYS_FUNC_EN uses the existing names.
>   - The RTL8723BS-specific SDIO helpers are named _8723bs_ and the chip
>     test moved to their callers.
>   - rtw_sdio_process_tx_queue() returns 1/0/-errno instead of taking a
>     "processed" out-parameter, which makes the retry and back-pressure
>     logic in the TX handler readable.
>   - mod_delayed_work() in rtw_sdio_tx_kick_off() carries a comment
>     saying why it is not queue_delayed_work(): a page-starvation retry
>     may already be armed with a delay, and the newly queued frame should
>     not wait for it.
>   - An argument that had a single value at every call site is gone,
>     along with its dead branch.
>   - Block comments use the general kernel style, per commit 82b8000c28b5
>     ("net: drop special comment style").
>
> Changes in v2:
>   - Dropped "tx: extend the TX report purge timeout". Instrumenting the
>     report path shows payload[6] & 0xfc equals the enqueued sequence
>     number, 32 out of 32 times, with rtw88's existing decode, and no
>     report is missed. The longer timeout was covering for the next
>     patch, not for the hardware.
>   - Dropped "fw: handle the RTL8723BS management TX reports". 0x12 and
>     0x32 are the first payload byte of C2H_CCX_TX_RPT, not C2H IDs;
>     every C2H event this chip sends carries a known id, so the existing
>     handler already covers them.
>   - Dropped "fw: send rate adaptation and RSSI info in the vendor
>     layout". The vendor byte layout is equivalent to what the existing
>     macros produce; uplink and the negotiated rate are unchanged without
>     it (16.4/16.5/17.0 against 15.4/16.7/16.6 Mbit/s, MCS7 both ways).
>   - Dropped "fw: send the media status report in the vendor layout". The
>     role field the vendor sets makes no difference here, as with the
>     other chips.
>   - Dropped "sdio: handle the RTL8723BS management TX path". Sequence
>     numbers do work for management frames on this chip, so reporting
>     completion at DMA completion is unnecessary.
>   - Dropped "calibrate and tune the PHY" entirely. All three parts were
>     vendor-matching scaffolding and none survived measurement: the
>     scan-time initial gain override is worse than
>     rtw_phy_dig_set_max_coverage() (five scans found 41 BSSes without it
>     against 34 with it); the IQ calibration works from the normal
>     phy_calibration path; and the hardcoded per-rate TX AGC table
>     overrode the efuse calibration by up to 22 index units and bypassed
>     the regulatory limit the by-rate path applies, which is not
>     something a driver should do.
>   - Dropped "match the RTL8723BS firmware connect and power save
>     behaviour". Deferring the connect report changes nothing, and the
>     LPS gating cannot be justified from measurement: with RTW_DBG_PS
>     enabled, LPS never engages on this setup at all, so the gating never
>     takes effect here.
>   - Dropped "advertise the correct receive capabilities". Both halves
>     move into the chip driver, as described above.
>   - "fw: add the vendor firmware commands" now adds only GNT_BT. rtw88
>     already implements MACID_CFG and the WL channel info report, and the
>     coexistence antenna select reserve became unused once the PHY patch
>     went.
>   - The zero-length packet check is gated on SDIO rather than the chip
>     id.
>   - The SDIO interrupt acknowledgment change is scoped to this chip.
>   - The association sequence no longer re-applies the BSS capability at
>     association time; BSS_CHANGED_ERP_PREAMBLE and BSS_CHANGED_ERP_SLOT
>     are handled later in the same callback.
>   - Register accesses that had raw addresses now use the existing
>     REG_GNT_BT and REG_BT_COEX_ENH_INTR_CTRL, plus a named define for
>     the BB antenna select register.
>
> The implementation is based on the initial RTL8723B work by Michael
> Straube <straube.linux@gmail.com>:
>
>   https://github.com/mistraube/rtw88/tree/rtl8723bs
>
> Based on the rtw-next branch from pkshih/rtw.
>
> Luka Gejak (5):
>   wifi: rtw88: add the RTL8723B chip type and SDIO helper
>   wifi: rtw88: rx: mark zero length packets on RTL8723BS
>   wifi: rtw88: sdio: track free TX pages and OQT credits for RTL8723BS
>   wifi: rtw88: sdio: set up RX aggregation and interrupts for RTL8723BS
>   wifi: rtw88: sdio: add TX back-pressure and retry on page starvation
>
>  drivers/net/wireless/realtek/rtw88/main.h |   7 +
>  drivers/net/wireless/realtek/rtw88/rx.c   |   8 +-
>  drivers/net/wireless/realtek/rtw88/sdio.c | 373 ++++++++++++++++++++--
>  drivers/net/wireless/realtek/rtw88/sdio.h |  22 +-
>  4 files changed, 383 insertions(+), 27 deletions(-)
>
> --
> 2.53.0
>
