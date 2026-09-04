Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F2251A74D
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 18:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788545402; cv=pass; b=UPN5AAtYyQOnISIL5ctrf0bxQSfVmvekpZK8CTJ7T3WseFDS0VyzykYpLiHf1NZH+stHFQmEG/PIiORS4lKTpzJCh9MU4fz2VtUG5Pha1uEUo5AnjaZCt7OKL3EnMOgH01kA74A+jknPXHK+QL4FMkm3gtdlwvKs1mttWw7IElI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788545402; c=relaxed/simple;
	bh=I1YuFFVoBNYOzCKgmqMHspPTsr5tXvroejD7b2pkVxA=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=rvXwMtBDjT/xhoryievIh9OpJqug9+Dg6phyUIiPaAtDt/aqG0nmD1IOnkm+rFp6vS0YuhY4uK6XQMs7fb56nQVzB32Sd9ipR5aM6zpflRbTmw3HQI8euM30j4ZpTyzbQ/+crxhfJwknbtia5hC7eIjVP9eNzVax9o7XNn2k9bs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=od6lAUSw; arc=pass smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="od6lAUSw"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c2529b3139fso162452066b.3
        for <linux-wireless@vger.kernel.org>; Fri, 04 Sep 2026 11:09:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788545395; cv=none;
        d=google.com; s=arc-20260327;
        b=DIMOEUUJzE7bMTmdhRiSwn8qWasbD7TceRcHuNpxG3fd1JR5P9WeLr43DbzM59wr9G
         jOsJEGMgKGbZ/SQYy2c4JlK1ywp3xEOhvCf4NMFVdOpB91czZbQbCF2jdOLpSpkN4HEW
         6cyelHptepgkEs4IJqbNOF2flmWS8BPOXo/iu8b0jEMh2Smm4UqHOCuk0G0SIDOjQ03r
         fL2uFcWAa1hiIfKUK6CrA1nnc1LTzd/tZp14mkk6dEMJHpMWgUqbqrq6ARlwrzJFfYGx
         AsLHBVXIclINHmQF4JlnWGysOSu77Ue6gR6CKaH+5qW0STDkYV8P5Jl4Fpyum3b6il3M
         KvwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=e59T5f6DjuSD0sM5+7ad5x1p262o0W4iAoz/V04rVIw=;
        fh=BzVcj3AOSjt+4oCebDOU6fO0kGZQwBEUFf03l6Edbvw=;
        b=Ri4kTu/3Z2BYeFFrqQWy5/jBovu7Yl6zs1NYl3zQEMffQm0fmB3iS1HOMDfFweSRLj
         C43C1v+zI+Sjpol8KJK5H3bHRx2a2NnMXg08U1smg9j/9BFOmvE2qtdtA57b2xeuacz/
         b7pceIvlfRHY3g7MvqJz6446MBQ3n8twm7aQsSGOSIsmXnD4nNPzxa1tpqoblu8/unVA
         L9zMZIGS6p4XCwaPLSTB6scsZD9DawjBrTZ2oAMwbdIyHSzugsvFV9TAWUZsIzEtmIRZ
         cDbEuvHXBoJmQsZJph8yIJ6aHLj7hc1dAGiqwH+GxuXbfq3TCH4QFmuaCdy/NSIvAzaa
         ulvg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788545395; x=1789150195; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=e59T5f6DjuSD0sM5+7ad5x1p262o0W4iAoz/V04rVIw=;
        b=od6lAUSwqZiVIc4dygvH9wb5KNxtbZcGv9VGKukHcCEjFiNMFjPH1/Et/PUQHU14fh
         bA4Vy0vMx6amtMN0h0lYQyNe5uvSUEHSU1lXOkKsFy4dAJL7Y7SHaww4xzp8+wtgAZ6D
         kEHJYfuVFBhDSdRKU6overetVrTrA1IMSfJ8bcTwpMBLRdr7KNhObxSa4ua7IU0fiii1
         tP2L6NHz+8gtVCXTRc9hPPDfowShwf240kVklk2ePr/lZZAY8NHte/4oyYiqbNMjUDgY
         VpN/mfL8QdJl4q+ZHK57k7/EEhqQNrMb40IIxhY50C24I6F9loIqHKtChR2IGboBm9xu
         SD+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788545395; x=1789150195;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=e59T5f6DjuSD0sM5+7ad5x1p262o0W4iAoz/V04rVIw=;
        b=qkmhJX5woFreDFAKfc2whTa5wVx5LpeEY2d/lrGjTfU6/0+GW4kiTlVQPAaiTPmrNV
         eESiCXsNFiaXMFto/FPZ9FVAAkl19uZ6WBr3jZcOwPc1HKCf0Xd0pPpuFhpFNEWP1WjS
         iNOgzWMUEr4PKjf83unARqgf6JXtBnEmeV7g0oRPNIXY2Yg5ljKFtqTOohhyeDBFtRHo
         SmFqbAUuRpekt1FNXhIyfAQWfFoiIZWdGyh6cwv3Xrpc3SFa2MItbQ8UJlJCxrzRP7mB
         lcLuYznF+ZaLYS+lF2hn4Hx4e4nu9G5NRI4zigq5x8gt0th9qCcp7PiJrwUcfrR0BHLp
         I85w==
X-Gm-Message-State: AFuF++l4eOUNXJx4vG7FGvDYZeWt5KvqjH4rLXQEMpAeXptuV+3u0igG
	pstRwSAl29CiQdlZ/RpjELAXIT68AiE3ik2lp+8uDCZzhLy7VfpT8tm9418VaTcCIAu830PHpF4
	aOohjSzOh8aKTfNqmU/R0HY1GFA9wwNwyvXt3
X-Gm-Gg: AYBFou0L+NvJOoQnkScl9tp8dx+dkhJ/mUAXEW+7kVD8MjmJX1wzCmSIXijfhVxUmna
	mmVQI5VEbnE4mG4hbVf6Lp8/yd1kGkzTh3oB07WX+YdNol5X0ai72VA2hR2ELeVtkpLIJSgtg/r
	wx4HgGkQQccTR+wN1cwmR3tbwpnkGiwY3g1rjlyIBKTcwNPWO4qI3EiyLLEpMPFDYYarrF6VIVD
	v6qEuEuZ/59BWmCk38d/TCU+rvpzTfR92uxnUbFd2TRZSk9Q5XNNK+UdPBQorkh12b9IwDLH5z+
	oLiA9IWojMQcQuEBHhOnBpDrIT9s6xsgEveCu5SZUuwaAlUsEHFY67d0E3yOwGIr9R+lnJMA3TJ
	qicMgJHDylhw8QyQZeLw3jF5lF1mhkNa8s4AF3kbKfWAaMBB+DJj+hGIt+Gd5mk9SPrGoARBkt8
	Bt4w==
X-Received: by 2002:a17:907:3f98:b0:c26:19e3:e988 with SMTP id
 a640c23a62f3a-c2619e3ef32mr190660966b.40.1788545394779; Fri, 04 Sep 2026
 11:09:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Ankit Dange <ankitdange37@gmail.com>
Date: Fri, 4 Sep 2026 23:39:42 +0530
X-Gm-Features: AcwNN1XpRrOS7DkTO7IJPrREexmDOLcloLYcUmK-ZhlOdXvM-UE8dIh9FZ1wa_g
Message-ID: <CAJ+EMqqfT5-Wm+YY9XUUoqVTe01VHN7U++GbYosYTHS1jxH4rg@mail.gmail.com>
Subject: wireless-regdb: IN DFS ranges result in DFS_UNSET and prevent mt76 CAC
To: linux-wireless@vger.kernel.org
Cc: wireless-regdb@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

Hi,

I am seeing an immediate DFS/CAC failure on an OpenWrt 24.10.0 based
system using MT7915E/mt76 with country code IN.

Environment:

  Device: YunCore AX820
  SoC: MediaTek MT7621
  Wi-Fi: MediaTek MT7915E
  OpenWrt: 24.10.0 r28427-6df0e3d02a
  Kernel: 6.6.73
  mt76: 2025.01.14~8e4f72b6
  wireless-regdb: 2024.10.07

The India entry in db.txt is:

  country IN:
      (2402 - 2482 @ 40), (30)
      (5150 - 5250 @ 80), (30)
      (5250 - 5350 @ 80), (24), DFS
      (5470 - 5725 @ 160), (24), DFS
      (5725 - 5875 @ 80), (30)

The DFS frequency ranges are marked with DFS, but the country entry does
not specify DFS-FCC, DFS-ETSI, or DFS-JP.

On the device:

  iw reg get

reports:

  country IN: DFS-UNSET

When I configure channel 100, hostapd reports:

  phy1-ap0: DFS-CAC-START freq=5500 chan=100 sec_chan=0,
             width=0, seg0=0, seg1=0, cac_time=60s
  DFS start_dfs_cac() failed, -1
  phy1-ap0: interface state DFS->DISABLED
  phy1-ap0: AP-DISABLED

The failure is immediate; CAC does not run for 60 seconds.

I instrumented mt76 and during the channel change I see:

  DFSDBG: region=0 dfs_state=1 prev_state=0

The mt76 enum is:

  enum mt76_dfs_state {
      MT_DFS_STATE_UNKNOWN,
      MT_DFS_STATE_DISABLED,
      MT_DFS_STATE_CAC,
      MT_DFS_STATE_ACTIVE,
  };

So the runtime values correspond to:

  prev_state = MT_DFS_STATE_UNKNOWN
  dfs_state  = MT_DFS_STATE_DISABLED

The relevant mt76 code is:

  if (dev->region == NL80211_DFS_UNSET ||
      test_bit(MT76_SCANNING, &phy->state))
      return MT_DFS_STATE_DISABLED;

Therefore the observed path is:

  country IN
    -> DFS_UNSET
    -> mt76 returns MT_DFS_STATE_DISABLED
    -> radar detector/CAC is not started
    -> hostapd start_dfs_cac() fails

I also instrumented the later MT7915 radar initialization functions, but
they are not reached during the failing CAC attempt.

I reproduced this with:

  channel 100 / HT20
  channel 100 / HE80
  channel 52 / HT20

Non-DFS channel 157 works normally.

There is also an existing OpenWrt report with the same symptom:

  openwrt/openwrt#20699

My questions are:

1. Is it intentional that India has DFS-required ranges but no
   DFS-FCC/DFS-ETSI/DFS-JP region?

2. If DFS_UNSET is intentional, how are drivers such as mt76 expected to
   perform DFS CAC?

3. Is mt76 expected to disable DFS when the regulatory region is
   NL80211_DFS_UNSET?

I have not forced DFS-FCC, DFS-ETSI, or DFS-JP locally because I do not
want to select a radar profile without regulatory justification.

I can provide complete iw reg output, iw phy output, hostapd logs, and
the temporary mt76 instrumentation patch if useful.

Thanks,
Ankit Dange
