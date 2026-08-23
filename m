Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E79D9381E9B
	for <linux-wireless@vger.kernel.org>; Sun, 23 Aug 2026 04:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787457623; cv=pass; b=lUJLk8eEY/aEmetInLCa18fh4FO+IsQ2wvAJreWRQcuilrfO/g2tBKHejCl2jiPPVyGtw+T1+1Q5K23czk9kN8YuJvboFhXPVtdYnIaZYXSIMn03tAO/kRX77dlEqJ9wI3eXLYTGqstHn81BZu7G2Ktm3ZBEE2dw1B/tJzc6ZBI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787457623; c=relaxed/simple;
	bh=CNu+9EVfUBKnP4uW7HfUeHqrbB97I+6qysh1mVTXZlw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nHJQvS9y+3/65D9sfkTELppQJc3TAj+CcLa/6llmSJRgxG/GCa7Z6x8DuojD5S90fn1oQ783AR98qkwSRUCIMC2LuUPEMy4EZjpr11OKpBTvjtojerCIH7bWYYa35wz03DXirtK7ykRzv9oMuyBCUmQX/i+RsDb3oq2nvF1fYCI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pucp.edu.pe; spf=pass smtp.mailfrom=pucp.edu.pe; dkim=pass (2048-bit key) header.d=pucp.edu.pe header.i=@pucp.edu.pe header.b=o9qjbWXS; arc=pass smtp.client-ip=209.85.167.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pucp.edu.pe
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pucp.edu.pe
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pucp.edu.pe header.i=@pucp.edu.pe header.b="o9qjbWXS"
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-495c49f8eccso1991616b6e.3
        for <linux-wireless@vger.kernel.org>; Sat, 22 Aug 2026 21:00:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787457617; cv=none;
        d=google.com; s=arc-20260327;
        b=cMqtNz3W+0w0IgXyxcrbU+ygfrKsSCAea+Am7+bFyokRj28cc8Kd3Oy/N2KA6O0hJ5
         jynXE+J3OmkEgbwA0ZoMYbGPSKCoZcEpKdqWgwDhDM8kkEULdPfJo8XMC8VGW7dE95cH
         B+R0Di7qlVsw7PC3fabjJhBm5wDjL1Q3ye7hagIr/TI2Np0h56sM9mNzyXqspDYbcSwz
         d/PN4LWNb64eOh7AMCycvf+54krNIq2Vu/VUuzjUQhnNAda+k8F2tnsUCEnXJYZtQ4ne
         QWJcYaMR8j3LxELtvm3aLqAIckDN62DR50AAbqxpCi8wMvyNh8GOTk4gmaubaythIqeV
         8xFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=c7v0zdFb+tH9oH/bA20dGm2YYptriPCQxJapEHHeh4o=;
        fh=XaRn086w+sPpVULNVkYHuF0HSTsM+yhxiQd/AOJNWJI=;
        b=byfLuYrbLrm795/l0DtmJ6TaSXV0H13AMIfTSryVbg6w8pHhZOeDVQ+gT/rqJCcAHf
         wAo/axJ849sn4NkNf3kOuM0v3c9go/qBKIj+5EkIzqozQbBNq1ApayoRhmTEM2WA4Ptr
         so+0BMEk1MGfgiijETc1osgewKl5BRUpocQWkBbqD9Y6+IeI0pyQ9cNCy5QEuWBfKrcl
         CWsCju5SgLl3hR34pd425K0hwwLlucneAfFtYbYZJNDL77SamBJHQC+XvmpeCFzz3kJy
         12A3/UcaER7Aml67PbP/9QDJHC6tcHnPyQmqBFTLhlAoO4gqPteyrbiHAwmCBGxSNhzb
         rA2A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pucp.edu.pe; s=google; t=1787457617; x=1788062417; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=c7v0zdFb+tH9oH/bA20dGm2YYptriPCQxJapEHHeh4o=;
        b=o9qjbWXSr1yFTuXQcxufii2FDOPqi3vVlHf6hk36+6wZHlrEY9hVDA695bNOQvL+MQ
         bhW+8Iahhr2Y4cI5HZhvRIToCPdW9vHLk89/GmsQ/xXnakv8LLqg5wYAfzl7k5/1gH3c
         DdS675g5kw8YKBbZ9TaissgJcRD+973gMZZ4MjqvE2Ug+jYyX8NnEE126eXBESPsFZ4+
         MtTjpOaCCGS7lfouTqeSqH54a5tnt23glwEOikwS12cP4BxMRj6GlXQ0on9Ke58InzzT
         59DrwxSr+iShPFoAF/DrBvxKedHSwZMoRuZlxKj4XO5q6QjACdNZF5eRLDo9XHc7zMLa
         YHtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787457617; x=1788062417;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=c7v0zdFb+tH9oH/bA20dGm2YYptriPCQxJapEHHeh4o=;
        b=AkjOfr9h0p2qnxMjcRJcINnvcONgxX4O2nT8e0fpohIad2LAF5MiaZERdfyIy/hCSW
         ovy7oguBmNyTjsqNtfJjB1wQP8txqwcvWUiARuuvTI+m+otp3aDwjqi2+cKYiT+gTg9M
         nwTbULCRIA40VQyi+UGkC65biQGm3PZI6SJrkhX4sbbAURdiGeuv3S7stjJM0kTsx+V4
         2GeXHIBKSRYNVXjwkr6TgH1t68wNCoupOf3gsRkslBb5Ixn2EfgiojaeFus2+2OY4gMG
         ToYeCCDynUixvM2MYMiOtbYAzxJ5ffLSdaotN7Fxq/K/25V6OKaiuLxb27NptKxVX72n
         kL0Q==
X-Gm-Message-State: AFuF++kmdtO5SBgl3PHB40Ef0uGuSuxiVBGuNsr3aW2BOlWj32XA+iKL
	iAhbNPcvsvI+ixD4sltHfBea8rf6DBHmh6agH9XuSAA8mLs5Yq9w4Db/N9gwokZfE59gpJHvaWH
	tg0kUeO8ujugS824qruCcle0vdNQrPdbTnvyqYsSEHE/pV+RFJl41hUN861Tk
X-Gm-Gg: AR+sD10CoGm7BRMuBL9qxc3yNXvgVhwa2WZvjuDrRJazO0Oqehi8k48Yrufta5mWc/P
	F9XxLeCh8VDBMZwGY85XS+TWyvZR4NUcCVg6YDnPK1/LM8KmxW+lQkrefEwXjcGUFyODZHjJvNK
	CFmm69ONPeY7iLjGpRHdJJwYi3us20SUXqaeHGFBCO3Vad/hdQGDyy/Qyn+okGRhCCyM8BHmpxm
	8g6qY8Mi8ZBjy+6Jmm1pA4XzhX168W1RChzM01sU6uwe4SxaGhnfVMthU2QduMxNTBN3cCF0VqJ
	SVJqYBLtYPACcgwlxEl5DNeRDmsFtDpmtB1H411qCnRekSTua6d/iWhcitQI1I6gSQO0gGfw4Oo
	=
X-Received: by 2002:a05:6808:1785:b0:496:a01:458b with SMTP id
 5614622812f47-4b2ef17635emr18588214b6e.2.1787457616535; Sat, 22 Aug 2026
 21:00:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+Hv-VqAQ38g9hGf+-nBcpRNZrcowicSejRQKgBswPOR-o+adQ@mail.gmail.com>
In-Reply-To: <CA+Hv-VqAQ38g9hGf+-nBcpRNZrcowicSejRQKgBswPOR-o+adQ@mail.gmail.com>
From: Pablo Diaz <pablo.diazv@pucp.edu.pe>
Date: Sat, 22 Aug 2026 23:00:04 -0500
X-Gm-Features: AcwNN1XKn_Bds3eZu_xD8QK7GvVZygUfH9_12tjarqS5EkCJvL-fOe7yKwCAq50
Message-ID: <CA+Hv-VrxZV6yg5eBBRsUrNFOzCx9upS735RDO-pfPatUEdWz4w@mail.gmail.com>
Subject: Re: [BUG] mt7921e/MT7902: firmware programs near-zero Tx power for
 all 20/40 MHz rates -> assoc fails except at close range
To: linux-wireless@vger.kernel.org
Cc: nbd@nbd.name, lorenzo@kernel.org, ryder.lee@mediatek.com, 
	shayne.chen@mediatek.com, sean.wang@mediatek.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Self-correction to my original report: the root cause is not in the MT7902
firmware. It is in mt76, in the ACPI SAR path, and it looks trivially
fixable. Apologies for the misdirection in the first mail.

## What actually happens

I instrumented the tx power path with kprobes on 7.1.8, while associated to
the same APs as in the original report:

  mt76_connac_get_ch_power()  in=3D40 -> 40 / 34 / 24  (correct, 0.5 dBm)
  mt76_get_sar_power()        in=3D40 -> -1            (684 of 684 calls)

mt76_get_rate_power_limits() then does

        memset(dest, target_power, sizeof(*dest) - sizeof(dest->path));

so the entire limits struct becomes -1, mt76_connac_mcu_build_sku() sends -=
1
for every rate group, and the firmware programs tmac =3D 4 (2 dBm) against
eeprom values of 38-40 (19-20 dBm).

So the firmware is not inventing the near-zero power. It is being told to
use it.

## Where the -1 comes from

mt76_get_sar_power() takes min() with phy->frp[i].power, which
mt792x_init_acpi_sar_power() fills from the machine's ACPI SAR tables:

        frp->power =3D min_t(s8, set_default ? 127 : frp->power,
                           mt792x_asar_range_pwr(phy, frp->range, i));

mt792x_asar_range_pwr() -> mt792x_asar_get_geo_pwr() returns
min(geo_power, dyn_power + offset) straight out of MTDS/MTGS. This laptop's
DSDT exports MTDS, MTGS and MTCL, and that path yields -1 for every
frequency range.

Whether the BIOS tables are bogus or we mis-parse them, mt76 applies the
value with no sanity check. A limit of -0.5 dBm is not a plausible SAR limi=
t
and arguably should never reach the firmware.

## Confirmation

A kretprobe module forcing mt76_get_sar_power() to return its input
argument, nothing else changed:

  group     stock             with override
  OFDM      4 4 4 4 ...       39 39 39 39 ...
  HT40      4 4 4 4 ...       39 39 39 39 ...
  HE484     4 4 4 4 ...       39 39 39 38 ...

On air, same BSSID, tx rate control went from HE-MCS 3 (68.8 Mbit/s) to
HE-MCS 9 (229.4 Mbit/s) with 3 dB worse RSSI.

## What this invalidates from my first mail

- Not 802.11h / TPC / Country IE. The regulatory domain never changes:
  iw reg get stays at the user regdomain before and after associating to
  the APs advertising Country: CO.

- Not CLC. mt7921_common.disable_clc=3D1 gives a byte-identical txpower_sku
  on the same channel while associated.

- Not specific to those APs at all. The -1 is applied unconditionally on
  this machine. The airport deployment only exposes it, because 2 dBm is
  not enough at -72 dBm with heavy co-channel contention, while it is
  plenty at close range to a home AP. That also explains why 80 MHz looked
  healthy: the firmware appears to ignore the bogus limit for the
  VHT80/HE996 groups, and my home AP runs 80 MHz.

A much better reproducer than "association times out": the 40 MHz groups
read the correct 43 while idle and collapse to 4 on association, i.e. as
soon as SET_RATE_TX_POWER is pushed.

## Suggested fix

Reject non-positive ACPI SAR limits instead of applying them, e.g. in
mt792x_init_acpi_sar_power():

        s8 lim =3D mt792x_asar_range_pwr(phy, frp->range, i);

        if (lim <=3D 0)
                continue;

or a sanity floor in mt76_get_sar_power(). I did not want to guess which
one you prefer, nor whether it is worth warning once when the ACPI tables
are clearly out of range.

Happy to send a proper patch and to test anything on this hardware:

  MT7902 [14c3:7902], subsystem [1a3b:5520] (AzureWave), ASIC rev 79020000,
  mt7921e, kernel 7.1.8-200.fc44.x86_64, firmware WIFI_RAM_CODE_MT7902_1.bi=
n
  build 20251212032127 (linux-firmware, unchanged since the first report).

Full kprobe traces, txpower_sku dumps before/after and the override module
are available on request.

Thanks,
Pablo Diaz

El mi=C3=A9, 15 jul 2026 a las 23:13, Pablo Diaz
(<pablo.diazv@pucp.edu.pe>) escribi=C3=B3:
>
> Hi,
>
> Reporting a connectivity bug on MT7902 (mt7921e). Following
> Documentation/admin-guide/reporting-issues.rst.
>
> ## The one-line problem
>
> mt7921e/MT7902 cannot authenticate/associate with a specific class of
> enterprise AP (Huawei, 802.11h + TPC + Country IE + MBSSID + HE), while i=
t
> works at 100% with every other AP I use, including my home AP. Frames are
> transmitted (HW Tx counters increment) but the AP never replies:
>
>     wlo1: send auth to <bssid> (try 1/3..3/3)
>     wlo1: authentication with <bssid> timed out
>     (occasionally: authenticated, then association timed out)
>
> ## Scope / trigger (important)
>
> - FAILS only with the airport (Jorge Chavez, Lima) Huawei enterprise APs.
> - WORKS 100% with my home AP and all normal/consumer APs.
> - So the trigger is something these APs advertise, not general breakage.
>
> AP characteristics (from `iw scan`):
>   - Vendor: Huawei (BSSID OUIs 48:4c:29, 10:a4:da, 60:9b:b4, 3c:ff:d8)
>   - MBSSID: several SSIDs per radio (.FreeWifiJorgeChavez open, plus
>     WMIG_AIJCH/PACHACUTEC/T2_LAP incl. WPA3-SAE)
>   - 802.11ax / HE (HE Operation, BSS Color)
>   - 802.11h: SpectrumMgmt, Power constraint 0 dB, TPC report (9-16 dBm)
>   - Country IE =3D CO (Colombia) although the site is in Peru; my regdoma=
in is PE
>   - fails on both 2.4 GHz (ch6) and 5 GHz (ch44)
>
> ## Observed correlate: 20/40 MHz Tx power programmed near-zero
>
> debugfs .../mt76/txpower_sku while in range of these APs
> (tmac =3D value the firmware programmed, eeprom =3D calibration):
>
>     group (bandwidth)          eeprom   tmac
>     CCK (2.4 legacy)           29-34     34    OK
>     OFDM (20 MHz)              31-36      4    near-zero
>     HT20 / HT40                29-34      4    near-zero
>     VHT20 / VHT40              27-34      4    near-zero
>     VHT80                      27-34     39    OK
>     VHT160                     23-30     35    OK
>     HE26/52/106/242/484        23-34      4    near-zero
>     HE996                      23-34     39    OK
>     HE996x2                    18-30     35    OK
>
> Every 20/40 MHz rate is programmed to ~4; only 80/160 MHz is correct.
> Auth/mgmt frames go out at OFDM 6 Mbps / 20 MHz, i.e. at ~near-zero power=
,
> which matches "frames sent, AP never answers, works only at very close ra=
nge".
>
> Hypothesis: the MT7902 firmware mis-handles the 802.11h TPC / power-const=
raint
> / Country IE advertised by these APs and collapses the low-bandwidth Tx p=
ower.
> Consumer APs that do not advertise 802.11h do not trigger it. I could not=
 fully
> prove causation in the field; maintainer insight is welcome.
>
> ## Environment
>
> - Adapter: [14c3:7902] MT7902 802.11ax PCIe [Filogic 310],
>   subsystem [1a3b:5520] (AzureWave), ASIC rev 79020000
> - Driver: mt7921e (in-tree mt76)
> - Kernel: 7.1.3-201.fc44.x86_64 (Fedora distro kernel)
> - Firmware (linux-firmware commit edc18bd, the only MT7902 WiFi fw publis=
hed,
>   already the latest): WIFI_RAM_CODE_MT7902_1.bin 20251212032127 +
>   WIFI_MT7902_patch_mcu_1_1_hdr.bin 20251212032046a
> - Not a regression: MT7902 support is new; there is no known-good prior k=
ernel.
>
> ## Steps to reproduce
>
> 1. Be in range of a Huawei enterprise AP advertising 802.11h TPC + Countr=
y IE.
> 2. Try to connect (open network). Auth/assoc time out repeatedly.
> 3. Same adapter connects fine to a home/consumer AP.
>
> ## What I already tried (ruled out)
>
> - Rebuilt in-tree mt76 (v7.1) with SUPPORTS_MULTI_BSSID /
>   SUPPORTS_ONLY_HE_MULTI_BSSID disabled in mt792x_core.c: no fix (failure=
 only
>   moved from auth to assoc). So MBSSID handling is not the cause.
> - mt7921e disable_aspm=3D1 and Wi-Fi power-save off: marginal only.
> - Regdomain PE (correct for the site) vs forcing the AP-advertised CO:
> no change.
> - iw dev wlo1 set txpower fixed|auto: no effect (reports 0.00 dBm).
>
> ## Code trace (why this looks firmware-side, v7.1 mt76)
>
> - txpower_sku is read from the firmware via MCU_CE_CMD(GET_TXPWR)
>   (mt7921/mcu.c mt7921_get_txpwr_info): the fw reports correct eeprom (36=
) but
>   programs tmac =3D 4 for 20/40 MHz.
> - The only driver Tx-power input is a per-rate limit table
>   (mt76_connac_mcu_build_sku), which is bandwidth-agnostic (VHT20 and VHT=
80
>   share limits->mcs); yet the fw applies 4 vs 39, so the per-bandwidth
>   reduction is a firmware decision.
> - The driver writes no RF power registers (only MT_TMAC ODTR/CDTR/ICR0 ti=
ming);
>   mt7921 exposes no writable txpower override and no per-BW power MCU com=
mand.
> - is_mt7902 special-casing covers only MCU_WA ring/TXQ/DMA/runtime-PM, no=
thing
>   RF/Tx-power related.
>
> ## Request
>
> Can the MT7902 firmware be corrected to program the calibrated 20/40 MHz =
Tx
> power (the eeprom values already present) when these APs' 802.11h/Country=
 IE is
> present, or is a driver-side workaround feasible? Happy to test patches o=
r new
> firmware and to provide full dmesg, complete txpower_sku, and iw scan dum=
ps.
>
> Thanks,
> Pablo Diaz
