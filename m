Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3CE1446BFE
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 09:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784627390; cv=pass; b=WzZ3HrtScJt71TJ2ogfmDZLnHM4QEXcXdbZcN6UNdZz7l501xYRaVd1EtigphwXXlrd1Fd0DNU+hYwyr1gq1Y4CSAgEqCifD8f3DDt+4RU8bXZe99HqdWbAJ9eV+K/kunS0bmZn1QaKICXqAOnlBSnwY3BsgYFUd4qJMkZyi3g0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784627390; c=relaxed/simple;
	bh=VNnNdBprPcSczbm0Piff++O0r3ENcSnYe4FY0HJlLZY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Awo46G+YTzfryUC8TaGkZiZbtfqmfLsoY1vuKNtADd3gifQ6LKHuHvfFmlHKOuEWMqiuxVdQbPNBF+klNcaBe8p2V3PKS4kqM6FVfkYlsZ1H+4TfgY9Sf1N5llrscA117TPQL7XmCjBoHKvNpwg/R4tIliVZFgN9JCqzI0ZpGH8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Za1Lbo/p; arc=pass smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Za1Lbo/p"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-902fc790cd5so104092416d6.1
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 02:49:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784627387; cv=none;
        d=google.com; s=arc-20260327;
        b=lMe+D5XRxl/sgWJEJ8ugpVrB5l4vi9s1LvTqMwsWxfbhZYyqb5OSOi3QXUz4DyYvV8
         4a/+xrHPr1CUR2/itJMwsPja2k5Q+i4dWECHWLmDJXwo7cDptA1xKX6tA3Y/xoBYM6DM
         W7faBa4WkYFn/fDt44EtabDmle3jLz9jjveITCuKKNMJvwennb1adZMlxH8C5NG/7EYX
         sPpdfmWAjtaKYqF1HH2dPX0kdR4voHmFsLPyWw5u7D3m7/q6VEqXcmmztfoFzFKLwI/c
         J82Q6Thy37owKW1STbYH/+EZfjfrTFfTo3gHb4fhHF+R6cMwDltB1NUbNXtGQqW4kFA2
         O3DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=6cp2npo80JG9BPFenL/JZI11syMdvz2JbvUKll+8ZCc=;
        fh=PRzMr4Be9Om7NEOl5GhiHG8+mXh/TEt2PSxMBJU9WqM=;
        b=NuV+q1msroe2SJji53vzQiKxpdjuBa7DRaQzVw8wFfdMQaoK1SK0e21VcRyknShHwh
         kZjzva61gchWJdVLphrmwP5n6NpUo2L96GZMNzuPg9kcNoYSiw4TCBzSJD4GtReI8Gzw
         mQqDryV4WePWHnrGj5KSPgHnG3LK9plQ5+qxWhitEKhhXEvM80Jf7zfFsHjtusFNf1rP
         8PK0aixhALxYy1DjgUC/fuFxjKdFcnpySiCSMihfz0oASNiPSttNHgRJypqOh7KrIqFs
         +16IRqoBHh6OsVK5uC8VRKkDq/gYS4psB0uRMww1QttjoAgZSMB4Z3WseupyaHhQL8UK
         9jaw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784627387; x=1785232187; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6cp2npo80JG9BPFenL/JZI11syMdvz2JbvUKll+8ZCc=;
        b=Za1Lbo/p2FgdjIa6/w0HDyXdNa618Ly+V6CX2wkhtbh/9y84MrBOKh6TL4UJCFoEvF
         wFYLRozQJbleKGW2VDS0zH+N5ghDICw3B/CH8UbVfPp14b55znWhK5wxxbVYCXc7qCk1
         QoRzQdqwYgXDzcUMClGeLaRYpGjLlNfF45XM3ohD7AbGBVyLDxnWbqKb405DQRAf6pIM
         NtkuumsjcqYNM3Q9B2P81/YkYPko8h7C/ksvusXPb+gxHtmgIYWZigdOL0PsUrNrOx7i
         L+ZmP1IRDHzduhBd0+E8GOuO62KpNKT9jefpYv1f6WmYQ2xmwnVMP3RbD1eNBwF6NlN6
         2Q6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784627387; x=1785232187;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=6cp2npo80JG9BPFenL/JZI11syMdvz2JbvUKll+8ZCc=;
        b=c3jgxmtuCJa/Sdn6yZLyLwOkdiCCF2QXoFLxVxFlcA/mAuco6YcAJOBHt4XNVMWEzJ
         9uTMtkulPM1SN9SSqs2NTiBB/iQjUR8SqO4BOeu12Lyoz5deXevVoUkxZUIcnfiS3Swp
         fRY4IEJh/8ocEKl+uyUrw4uvGwsZOi4+nMkthnwR+Z4vCbAH6sKjbE1cBVKYB58WsS2g
         vMJOUnpZ1AwONAQHjs35ZP4iH+08hdz9/3Z17uHNmegu41hVNc0/RC0bS4vilbKPaTMk
         gVb8x3/Aj6FPVS/X+r/owJPd7euhgvuls8PhPLKp0OSEuqwtllVKeirhuLIp5qtbfP4Z
         8BRg==
X-Forwarded-Encrypted: i=1; AHgh+Rpp3coCViSx2GJfJm9jfmhFSv4swPpGX/rHCqmhv4zXNBGTjX2VIRU1AZ/PiR9s5Kl1d6K/vaTGpoFOWTLRdA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8QxNnSs/mXmkH5N/0QIeEyS/5/LyZkjEv4eYvkAKegRhZ143F
	JeNF26fyc2EGO58ujjWf3G16+xLCrJH8FJSpGtPHbVIXFiMrn7VwlRwo1IVSK5K+Ud7gH4V5Ybc
	yJcChb2pExmlbDHX77DN1B5ncm6Oo/ks=
X-Gm-Gg: AR+sD10xzJvLWZx+s8BuFWtrQHkR2iTHR2nJiDufctuVDyCc8WI/h/wfi31fvppQu/L
	s3TFc1g0NA6ZLyWZHg655JcE0POGUFWlsRhts0LasWWfp/h3OX9wSIcBsIeekfrVKuXEsFu9v7N
	HJyFd2X/c1nIuDhaRD1t3OdXF91iEc8JugqrfDkEJUz6Th9WboMnc0rDp/0z6E+XLrBeDKXe85M
	w8RX1jwTLWIQXxfk2OO2vPnxthGocZyHjjaPfIKTvFvftaNtvrqaHhbQbeKLctr+gZJ4YTufJk2
	zxcYiASH4lQNCf3A7N/TaiMYLSKVqmbyCDCBTegWtt6fRdnITOjGeVAWr/wQwf+hTqZ7pXaRw7+
	brN87P0rvRWW62FOJ5piPV4F1E8EpumMUqDLSodIDjfngevzzzbNuaCZm
X-Received: by 2002:a05:6214:f05:b0:8fd:6e12:970e with SMTP id
 6a1803df08f44-90778503149mr188069886d6.60.1784627386522; Tue, 21 Jul 2026
 02:49:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1784047561.git.luka.gejak@linux.dev> <1800080a275f4421b16bd3a028131e8a@realtek.com>
 <3EA0A653-D15F-4DD4-8DA6-C9CFFFF38205@linux.dev>
In-Reply-To: <3EA0A653-D15F-4DD4-8DA6-C9CFFFF38205@linux.dev>
From: Peter Robinson <pbrobinson@gmail.com>
Date: Tue, 21 Jul 2026 10:49:33 +0100
X-Gm-Features: AUfX_mzpnCivOJ9lddYT_ixKq_N6773LEBVtkfovLccvVSkYNRUu6hVYmmkRkqE
Message-ID: <CALeDE9O5aT7iYLt7dDNceEVGrq=mFXrjGmKVvedrsTbBoBg6PA@mail.gmail.com>
Subject: Re: [RFC PATCH v1 0/9] wifi: rtw88: add RTL8723B/RTL8723BS support
To: Luka Gejak <luka.gejak@linux.dev>
Cc: Ping-Ke Shih <pkshih@realtek.com>, 
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>, 
	"straube.linux@gmail.com" <straube.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Hi Luka,


> Before I send v2 I want to report what changed, because the result of
> your comments is that the series gets noticeably smaller. I would
> rather tell you now than have you spend review time on patches I am
> about to delete.
>
> Answers to your questions from the cover letter first.
>
> 1. The link. Michael Straube's original work is now referenced in the
>    chip patch:
>
>      https://github.com/mistraube/rtw88/tree/rtl8723bs
>
>    The current state of my series is here, if it is easier to read than
>    mail:
>
>      https://github.com/MocLG/rtw/tree/8723bs-upstream
>
> 2. sparse and smatch. Both re-run on the new series, clean, no findings
>    in the 8723b/8723bs files.
>
> 3. Bluetooth coexistence. Tested as you asked: WiFi download while an
>    A2DP sink plays music, shared antenna, 2.4 GHz HT40.
>
>    The audio side is good. Music played for the whole run with no
>    underruns reported by the audio stack. The WiFi side is not good:
>    download throughput went from 42.0 Mbit/s with Bluetooth idle to
>    0.21 Mbit/s with A2DP active, a 99.5% drop. So BT wins the air
>    almost completely rather than sharing it.
>
>    While looking into that I found two chip config values of mine were
>    wrong, both now fixed:
>
>      - scbd_support was true. The vendor driver has no scoreboard
>        implementation for 8723b at all (it exists only for 8703b,
>        8723d and 8821c), so this is now false. With it false the TDMA
>        case moves off case-0, which it never did before.
>
>      - bt_desired_ver was 0x6f, which is glcoex_ver_8723b_1ant, the
>        driver's own coex version rather than the desired BT version.
>        It is now 0x6d (glcoex_ver_btdesired_8723b_1ant, shared
>        antenna).
>
>    With those two fixed the coex mechanism itself is clearly running.
>    During the A2DP run it sits on TDMA case-3 (61 30 03 11 11), coex
>    table 10, and the run reason is BTINFO, so it is reacting to BT
>    status rather than sitting idle.
>
>    What it is reacting to looks wrong, and this is the part I cannot
>    answer from outside. With music actively streaming, coex_info shows:
>
>      Coex Ver/ BT Dez/ BT Rpt   = 0133ece9/ 0x6d/ 0x00000069 (Mismatch)
>      BT status/ rssi/ retry/pop = conn-idle/ -54dBm/ 0/ 9
>      Profiles                   =  (multi-link 0)
>      BT_RSP                     = 01 01 40 12 00 00 00
>      Hi-Pri TX/RX, Lo-Pri TX/RX = 0/3, 440/440
>
>    So the BT side reports conn-idle with an empty profile list while it
>    is demonstrably moving traffic (440 low priority packets each way),
>    and the profile byte stays 0x01 (CONNECTION) with A2DP (BIT 6) and
>    ACL_BUSY (BIT 3) never set. Coex is therefore arbitrating for an
>    idle link that is not idle, which would explain why WiFi gets
>    almost nothing.
>
>    The reported BT coex version is 0x69, below the 0x6d the 1ant
>    parameters expect. Is the rtl8723bs BT firmware currently shipped in
>    linux-firmware older than the coex protocol these parameters were
>    written for, and should I be using a different blob? If this is a
>    known gap I am happy to document the limitation rather than chase it
>    in the WiFi driver.
>
> Now the larger change.
>
> Several of your comments were variants of "does the existing logic not
> work, why do you need this". Rather than argue from the vendor driver I
> tested it. For each of those special cases I reverted it to the generic
> rtw88 path, rebuilt, reloaded and measured association, WPA2 handshake
> and throughput in both directions.
>
> Every one of them turned out to be unnecessary. I have dropped these
> five patches:
>
>   - apply the firmware-reported TX rate
>   - program the management TX descriptor contract
>   - add first-segment and retry-limit TX descriptor bits
>   - select the management and EAPOL TX rate
>   - keep the chip powered between scan and connect (soft IPS)
>
> Specifically, to your questions:
>
>   - "Why does it need report?" and the mac_id question. It does not.
>     With SPE_RPT not set and mac_id taken from si/vif as you suggested,
>     association still completes normally through the generic management
>     path. My claim that the firmware will not schedule a management
>     frame without SPE_RPT was wrong.
>
>   - First/last segment and the four-way handshake. You were right that
>     these are unrelated. With the first-segment bit removed the WPA2
>     four-way completes and data flows unchanged.
>
>   - The two rate patches. Not needed. The generic rtw_get_mgmt_rate
>     path carries auth, assoc and EAPOL fine, and without forcing the
>     firmware-reported rate the TX rate still climbs to MCS7. The CCK
>     floor behaviour I described does not reproduce.
>
>   - IPS. You were right to question this too, though not for the reason
>     I expected. IPS is entered here. With the soft-IPS special case
>     removed the chip does a real power off and on, which I confirmed by
>     tracing the power state across the transition, and it still
>     reconnects every time and passes full throughput. So the power
>     cycle does not corrupt the management TX path the way I claimed.
>
> Result, measured on the reduced series: association fine, WPA2
> reconnect 3/3, 20 Mbit/s up and about 32 Mbit/s down, no warnings and
> no TX report failures. That matches the full series, so nothing was
> lost by removing them. The series goes from 15 patches to 10.
>
> Two caveats I want to state plainly rather than have you find them.
>
> First, this was measured on one AP at strong signal (-32 dBm), 2.4 GHz
> HT40, on a single board. If any of those five patches guards a case I
> cannot reach here, a weaker link, a different AP, another firmware, you
> will know it and I will not. Please say so and I will put it back.
>
> Second, I kept one you asked about: the auth_sync mechanism in the SDIO
> association sequence. It also tested removable here, association and
> repeated rejoins all succeeded without it, but its whole purpose is to
> wait for a beacon or probe response before authenticating, which is
> exactly the thing a strong-signal AP will hide. I did not want to drop
> it on the strength of a test that cannot show the problem it solves. If
> you think the driver has no business doing that and mac80211 should
> handle the timing, I will drop it too.
>
> The remaining changes since v1, in short. Details will be in the v2
> per-patch changelogs:
>
>   - rtw_is_8723bs_sdio() renamed to rtw_is_8723bs().
>   - Kconfig and Makefile moved to the end of the series, before
>     MAINTAINERS, so the driver only becomes buildable once the
>     supporting patches are in.
>   - Struct fields, flags and function declarations moved out of the
>     chip patch into the patch that first uses them.
>   - The vendor-reference comments removed throughout. You were right
>     that they were notes to myself.
>   - Local register defines moved to reg.h, and RF_RCK_OS / RF_TXPA_G1 /
>     RF_TXPA_G2 replaced with the existing RF_MODE_TABLE_* definitions.
>   - Copyright headers corrected to include Realtek, includes reordered,
>     comment style switched to the current form, forward declarations
>     removed, reverse christmas tree and the alignment and mdelay
>     issues fixed.
>   - The old patch 2 split into smaller patches as you asked. What is
>     left of it after the removals above is the TX report purge timeout
>     change.
>   - Peter Robinson tested the RFC and reported two warnings. The
>     "failed to get tx report" one is what the purge timeout patch
>     addresses: the 500 ms default is too short for this firmware, the
>     same reasoning as the 8723D USB case already in tree. The
>     "firmware failed to leave lps state" one I could not reproduce
>     here, including with forced LPS enter and leave cycles, so I have
>     not added a workaround for something I cannot demonstrate. Peter is
>     on CC and I have asked him about it at the end of this mail.
>   - checkpatch --strict is clean apart from one TRANS_SEQ_END macro
>     warning, which is byte for byte the same as the existing one in
>     rtw8703b.c.
>   - Every commit builds with W=1 with no warnings.
>
> I will hold v2 until you have had a chance to react to the removals, in
> case any of them should stay, and to pick up whatever else you find in
> the patches that remain.
>
>
> Peter, the rest of this is for you, hence the CC.
>
> Since your Tested-by the series has lost the five patches listed above,
> so what you tested is not quite what v2 will be. I would rather not
> carry the tag forward without asking. Say so if you would prefer I drop
> it until you have had a look at v2.

I will retest with v2 so feel free to leave/drop as you think
appropriate. With v2 I'll get others I know to use this HW on Fedora
to test too to assist in widening the testing.

> There is a better reason to ask you than tag hygiene though. Both
> warnings you hit are timing races I cannot reproduce here, and the
> difference looks like host speed: your Pine64 SDIO hosts are slower than
> the board I test on. That also makes them the right place to check the
> five removals, because I validated those on a single fast host against a
> strong signal AP, which is the least likely setup to expose a timing
> regression. If any of those patches was quietly covering for a slow
> host, your boards will show it and mine will not.
>
> The tx report warning should be gone with the longer purge timeout.
>
> For the LPS one, the driver gives the firmware 100 ms to send its null
> packet, get the ACK back from the AP and restore REG_TCR. If that
> warning still fires on v2, could you say roughly how often it happens,
> and if it is easy to tell, how far past 100 ms it goes? I would rather
> extend that poll by a measured amount than guess a number, and I do not
> want to just silence the message.

The testing I did on v1 was very basic as I had very little time due
to travel, I should be able to do wider testing once you have v2 out.

PS on the FW side of things, both the old firmware in rtlwifi/ and the
rtw8703b, plus your repo, have a wow firmware, does it make sense to
send that upstream at the same time as the other FW even if it's not
currently used so the two are there together like a bunch of the other
variants?

Peter
