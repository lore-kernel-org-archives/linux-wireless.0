Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC1F3D9DC9
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 18:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788548316; cv=pass; b=LvFCpDMUK3u32Vc1FcgYCwsFdzOyOAqEXqOt8m3B/KaCZ0F3DJEqhtaWC8rC5hBaB5KUM+dQ4uSZvs/7l+HX8+Ln1++XIGIusdlC8OyDQUtD360jEP9Gj8+KH4GJroyzBj5P14MJNSwwQpGBcusOfC0nn2cuTcgHFcgxrsFT35Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788548316; c=relaxed/simple;
	bh=YZVQXpiD+ibDPGgRr8mN6UjSS07APrjGwuBzY1Ndd+w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Y7VlTz3WpMycxE/XSup1nGdXTUEIqHSKmN3oMNvNSbJE5vXcICMVLRvPRVEASuEDRjxjTM9QjB9njcyO98+e5Hj522P9VZyfGzm3ddQCLGKMX9CSO1t3EcnKWfO4BMe71TJAOfoq4nQHKNKGOlb8MduKvi0YEt3ekDLAMDtunYE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pucp.edu.pe; spf=pass smtp.mailfrom=pucp.edu.pe; dkim=pass (2048-bit key) header.d=pucp.edu.pe header.i=@pucp.edu.pe header.b=WAEA5IPb; arc=pass smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pucp.edu.pe
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pucp.edu.pe
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pucp.edu.pe header.i=@pucp.edu.pe header.b="WAEA5IPb"
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-7eb5bdb50fcso1298935a34.1
        for <linux-wireless@vger.kernel.org>; Fri, 04 Sep 2026 11:58:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788548307; cv=none;
        d=google.com; s=arc-20260327;
        b=pyRxYZCw7D206stgTGIzxu4UO0+z+xzTq+Xs5+ttSB6Fuf5qgO2JPOT4+/N7RZ/HR9
         1gtYt5b9W/Y4vWGHw+WzroslpjGz0Ug2nNGUiDG2d+mvPm3/PXcijhlTE3v1USq21Gcf
         TeTr6RIiSxcCq+Dhy6yQ6h9Cv4lQBw4Da29pn2Gb2O/04LTlZxDIP0hWpTUHojmmS5hd
         5mVR64oYwXomAt7Mr+hR4GfpZpQUmZGNNQuImFtrlXBY4EmOckT9mECURmfEAiPS3jXh
         DY1vIxCZh9wDFHe+zSMKWC1Z/su1rZM3FCWY4uruiY9qYwkmiOVJpbEs9ii/iEeH1j1u
         O8tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7+nnDlrcgaGm2vkzi2CVJQOHo0uA6hsoXRc8hBbF+54=;
        fh=ivSUBYEQDXxV8KMg5kCrR5FDsLAvzqIqN141EbHRWc8=;
        b=OJU8Uuu0HM2Ulj9M0ahhS9zsvxCJFq0sjGnmSfxVt58YuFW1ICX9lvvoCHPO7vHEws
         Qa0LH2g2ysudaKGN+JTlOV3cLKM517hvwxycaX2OgbQcnfKn41Mdnht8Q3jcbdiiv2JI
         EMfFGh/A+5fKeH9spX3tvdoW/DJrk1d34m90HP25Jrmd68A0eQFrsMhlxpD3ybeSMDYz
         D2GycQ12Aq9AG66BtvtbmAQo13Auggk8/f+qY8A9MR4ZFiZqUzImgvuArkGLBKAJGMTp
         PBk9Gmk97TKnm7tN/mIuFrqE8TNEVHMqBJko08dkeZeH8MmXbZR+VAtadrohmr9UOSNm
         DK7A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pucp.edu.pe; s=google; t=1788548307; x=1789153107; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7+nnDlrcgaGm2vkzi2CVJQOHo0uA6hsoXRc8hBbF+54=;
        b=WAEA5IPbn1KYI0+3OOOFnplIkkZx0U0jkCTiNIcGykA3KWqtEo4BAflX0N4ACWzojZ
         12uSKHk77Ay8qDsTqPvQX7CJsH5IKGqBq1+AaQ2dwCUwm2j5TzDeXJLGEf26k/bOs/cH
         fbOdGQkjGszUX1Q0i2E9E/m7cPQppcus2LC+FFUz1hEzodTnZ7Ybn7s6IWVeEBnKEqve
         gbHOjp0sQTo6iE9ciBrPYG8hDMx0Q3DZ7hXCCG3jepehNHJcpELtQHD5akdBt2N77L2A
         zAIZRVwsw9p0Bimm7JRKQWeTZRdItTjRrfGpL6MjxK+bLAlqbq6BNsmTIE3Q8PW4SfLD
         1stw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788548307; x=1789153107;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7+nnDlrcgaGm2vkzi2CVJQOHo0uA6hsoXRc8hBbF+54=;
        b=S4zDsSZyVUm3FvDGremEol3UQ8r2YUrp400rxVvVZAZeJh8RmUiF1uik9fP5VZ1g7q
         uLOTwkVzGwCuhR92G3n8Jk0y7OoTNTZN/8wB7BRORXt7qfXL8CsDbztLOxj4690ByLgT
         ApR/flORB9OArqpxaPZzE5Fy9k7GpYhY4X2ZZtTmRSr1oRMu9h8zCwdcQ8eeCtPA17X4
         1CUKMeNfO0nPHM3njUR1dLdVB/cUm3JjC2qm2nGrrVSflNZ9nr0NYl+cv/V1ytKqJV7z
         LxY0JAwVuFXGub7GbS7w7EOG3znXacJo+NMs/3M48ehX4DP1zK9gdxrFihP3C41H5w8p
         YIDA==
X-Gm-Message-State: AFuF++mqhGok9faTbViDZzPk55ijlisMBFe4hy8sYg97TmOE/E8w65u3
	cfTC+FkQAhnZ8uLvlOzr1vzWOH3rrO0GKQUW3BWgkLFVjCIDCZ9xcKf5w57UNhhMcAEb7GQhuhF
	A682bdWnXxzIkbSqEnmWO80DMD4pWZxa4/6ZcnRV1JfkJ6UoLPI7QjQj0uwxb
X-Gm-Gg: AYBFou3PMI+EN41PUn+wULfiuhuxvzgKO2+/9SfuTRVmJAlhJnz+NxRd+4oPrF80Xjz
	Jlu6/imi1TYJU5o6gw4AzDLALKAnfPaPJGvzk3F5Y0aJLVoM+cUFzty0osAM7/aoStJc7SMR4n1
	TTMfeBgdShIfpYX/kEtW9vw4obokgXL8Rf1nytua4izqZNWUqdxD6Us6x7WVUi7VNWIztCfsxnT
	T9jASXtqw0Kn5YTsggV4Df9M8DKgcTUiw0YKllFccP5IK/ue4tfSekBgfr6grUS6P4zR3+nEgt0
	RpTOjrbNOpIec8/BIOZeFg2rHllA2CujFToa82BYrPmESGrSeDBhXaYfLYPtwrb1p3WBpuM+zhP
	zGFysXdvJGO96
X-Received: by 2002:a05:6820:c0d4:10b0:6b7:83d6:293f with SMTP id
 006d021491bc7-6b783d6301dmr2588331eaf.66.1788548307095; Fri, 04 Sep 2026
 11:58:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+Hv-VqAQ38g9hGf+-nBcpRNZrcowicSejRQKgBswPOR-o+adQ@mail.gmail.com>
 <CA+Hv-VrxZV6yg5eBBRsUrNFOzCx9upS735RDO-pfPatUEdWz4w@mail.gmail.com> <20260823180814.4081175-1-lucid_duck@justthetip.ca>
In-Reply-To: <20260823180814.4081175-1-lucid_duck@justthetip.ca>
From: Pablo Diaz <pablo.diazv@pucp.edu.pe>
Date: Fri, 4 Sep 2026 13:58:14 -0500
X-Gm-Features: AcwNN1U3PF9hq0TPMfGUtHXajneDCy0EZJB6vAUkN_Yn6k28kAlhNAawLz74zaI
Message-ID: <CA+Hv-VqrxKWETcegx09-=v7udVO0Rk1CY9nPjw8sDK3mzgw-JQ@mail.gmail.com>
Subject: Re: [BUG] mt7921e/MT7902: firmware programs near-zero Tx power for
 all 20/40 MHz rates -> assoc fails except at close range
To: Devin Wittmayer <lucid_duck@justthetip.ca>
Cc: linux-wireless@vger.kernel.org, nbd@nbd.name, lorenzo@kernel.org, 
	ryder.lee@mediatek.com, shayne.chen@mediatek.com, sean.wang@mediatek.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

  Hi Devin,

  Thanks =E2=80=94 that lines up with what I have. Short version up front: =
I cannot
  give you a byte dump comparable to issue #62, because on this machine the
  tables are not static. Details below, along with two corrections to my ow=
n
  second mail that matter more than they sound.

  ## The clamp needs no AP

  txpower_sku with the interface not associated to anything, kernel 7.1.12,
  mt7921_common.disable_clc=3D1:

    Tx power table (channel 3)
                          6m     9m    12m    18m    24m    36m    48m    5=
4m
    OFDM (user)     :     -1     -1     -1     -1     -1     -1     -1     =
-1
    OFDM (eeprom)   :     38     38     38     38     36     36     35     =
34
    OFDM (tmac)     :      4      4      4      4      4      4      4     =
 4
    HT40 (tmac)     :      4      4      4      4      4      4      4     =
 4
    VHT80 (tmac)    :      4      4      4      4      4      4      4     =
 4
    VHT160 (tmac)   :     38     38     38     38     38     38     38     =
38
    HE996 (tmac)    :      4      4      4      4      4      4      4     =
 4
    HE996x2 (tmac)  :     38     38     38     38     38     38     38     =
38

  (user) is -1 on every row; full dump on request.

  So the reproducer is "boot, cat txpower_sku". No AP, no association. That
  replaces the airport reproducer from my first mail, and confirms
  disable_clc=3D1 changes nothing =E2=80=94 I had only compared it byte-for=
-byte before.

  Just as well, because I am no longer at that site and cannot re-test ther=
e.
  I expect to be back in a few months, so if anything from those APs is sti=
ll
  worth having by then =E2=80=94 TPC reports, the Country IE, association c=
aptures =E2=80=94 I
  can collect it and send it on. Nothing in the current picture seems to ne=
ed
  it, but the offer stands.

  Two corrections to my second mail:

   - The groups that escape the clamp are VHT160 and HE996x2, not VHT80/HE9=
96.
     VHT80 and HE996 sit at 4 like the rest. So "my home AP runs 80 MHz, th=
at
     is why it looked healthy" was wrong. What decides whether a link survi=
ves
     is path loss, not width: a phone hotspot a metre away on 5 GHz/80 MHz
     links at 292 Mbit/s under this same clamp, while a Tenda RX2Pro across
     the room fails to associate on 5 GHz and drops 28% of frames on 2.4 GH=
z.
     Plain consumer gear, second AP, same failure.

   - I said the 40 MHz groups read 43 while idle and collapse to 4 on
     association. On 7.1.12 they read 4 while idle already. I do not know i=
f
     that is the delta from 7.1.8 or a mistake in how I measured it then.

  ## Why I have no bytes for you

    ASUS Vivobook X1605VA, BIOS X1605VA.302 (2023-04-17)
    MT7902 [14c3:7902], AzureWave [1a3b:5520], mt7921e
    kernel 7.1.12, linux-firmware 20260810, WM fw build 20251212032127
    regdomain PE (DFS-FCC)

  #62 reports MTDS static limits decoding to 8-14.5 dBm. Here there is noth=
ing
  to decode: all three methods return a Package template whose entries are =
0xFF
  placeholders, filled at runtime with Store(<NVS field>, Index(pkg, n)). A
  static dump would just be rows of ff.

  What is fixed at build time is the element count, and that is what your
  length checks act on. MTCL has one Package of 19 elements =E2=80=94 exact=
ly
  sizeof(struct mt792x_asar_cl), so read_mtcl takes the v1 branch and
  asar->ver =3D MCSV. MTDS and MTGS have two Packages each, behind
  If (MD6G =3D=3D 1):

    MDSP (31)  idx 4 <- MDSE, idx 5 unwritten, idx 6 <- MDSN
    MDSB (18)  idx 4 <- One (under If MDSE=3D=3D1), idx 5 <- MDSN
    MGSP (42)  idx 4 <- MGSV, idx 5 unwritten, idx 6 <- MGSN
    MGSB (21)  idx 4 static One, idx 5 <- MGSN

  The nr_tbl offset gives the layout away: MDSP/MGSP put it at index 6, the=
 v2
  header (names[4], enable/version, rsvd, nr_tbl); MDSB/MGSB at index 5, wh=
ich
  is v1. So the 6G branch is written as v2 and the non-6G branch as v1, eac=
h
  internally consistent. Running your arithmetic over those four sizes:

    table       len   as v1                     as v2
    MTDS 6G     31    (31-6)/6 =3D 4  rem 1  ACC  (31-7)/12 =3D 2  exact  A=
CC
    MTDS non6G  18    (18-6)/6 =3D 2  exact  ACC  (18-7)/12 =3D 0         R=
EJ
    MTGS 6G     42    (42-6)/5 =3D 7  rem 1  ACC  (42-7)/7  =3D 5  exact  A=
CC
    MTGS non6G  21    (21-6)/5 =3D 3  exact  ACC  (21-7)/7  =3D 2         R=
EJ

  And nothing in the AML ties MCSV to MD6G =E2=80=94 two independent 8-bit =
fields of
  the same region:

    OperationRegion (AUMO, SystemMemory, AWMB, 0x56)
    Field (AUMO, AnyAcc, NoLock, Preserve) { AWMS, 32, MD6G, 8, MDSE, 8, ..=
. }

  So the mismatch you describe is structurally possible here, but I cannot
  tell you whether it is happening. Three runtime values decide it and I ha=
ve
  none of them: MCSV, MD6G, and nr_tbl (MDSN/MGSN) =E2=80=94 that last one =
being the
  input to your new check. /dev/mem is locked down here
  (CONFIG_STRICT_DEVMEM=3Dy, CONFIG_IO_STRICT_DEVMEM=3Dy) and acpi_call is =
not
  packaged for this distro, so static analysis is as far as I got.

  For what it is worth, my guess is MCSV=3D1 with MD6G=3D1, i.e. a v2-shape=
d MTDS
  of 31 read as v1 =E2=80=94 of the four combinations it is the only one th=
at both
  accepts the table and misparses it, and the -1 does reach
  mt76_get_sar_power(), so asar->dyn was non-NULL and MTDS was accepted. Bu=
t
  that is a guess, and I would not want you to act on it.

  ## Next

  I will build your patch with a print_hex_dump added to mt792x_acpi_read()
  before it returns, which gives the actual bytes and lengths the driver se=
es
  for all three methods, and the patch result, from the same build. I will
  follow up with both.

  If those come back well formed, then you are right that something else is
  driving it negative here and the clamp is the wrong place to look.

  Pablo

El dom, 23 ago 2026 a las 13:08, Devin Wittmayer
(<lucid_duck@justthetip.ca>) escribi=C3=B3:
>
> Hi Pablo,
>
> On Sat, 2026-08-22 at 23:00 -0500, Pablo Diaz wrote:
> > Whether the BIOS tables are bogus or we mis-parse them, mt76 applies th=
e
> > value with no sanity check.
>
> Only just came across this. Nice bit of digging, so here's the other half=
 of
> it.
>
> Your -1 is the tell. Those tables are in half dB steps, so it's claiming =
minus
> half a dBm, and that isn't a cap anyone writes. Real entries in there are=
 small
> positive numbers. What you're looking at is the driver reading bytes that
> aren't limits.
>
> Same flat 4 showed up on an ASUS laptop back in July, an MT7922 rather th=
an
> your part. Turned out the country list on that thing said one table layou=
t and
> the power tables were written in the other. Driver takes its version from=
 the
> country list and reads everything with it, so both tables came out a byte=
 off.
> There it landed on a zero. Yours coming out negative would be the same fa=
ult
> reading different rubbish.
>
> I sent a patch for it a couple of weeks ago. It throws out a table whose =
size
> doesn't match what the table says it holds, so a mismatched pair gets dro=
pped
> and no limit gets applied at all. That machine's bytes and the walk throu=
gh
> them are on the issue behind it, if you want something to compare yours t=
o.
>
> https://lore.kernel.org/linux-wireless/20260811232839.515463-1-lucid_duck=
@justthetip.ca/
> https://github.com/morrownr/mt76/issues/62
>
> Whether it covers you comes down to whether your tables fail those checks=
.
> Your MTCL, MTGS and MTDS bytes would settle it either way. And if they co=
me
> back well formed, then something else is driving it negative and I'd soon=
er go
> find that than clamp it. A bad parse lands on a plausible number as easil=
y as
> an implausible one. Which, imo, is the version nobody ever notices.
>
> Devin
