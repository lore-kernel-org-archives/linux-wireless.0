Received: from mail-yx2-f10.google.com (mail-yx2-f10.google.com [74.125.224.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65CF847B41F
	for <linux-wireless@vger.kernel.org>; Tue,  1 Sep 2026 15:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788277473; cv=pass; b=bpvwT72EsNl8VSNmUNjVl1HkPvXDdaGO6dO9tsvClVCnDxGINZOavPEr3zhW2kKXohAnKDu8as3JGEBLZ5hWeGP8lAsdSHRZ/3+wJJ/DcJvHzcgVIsTMwhUd1yEKTpfApBPAv/I1VzrkQM6FV4if+kSvICZPj3og95hJ40REcV4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788277473; c=relaxed/simple;
	bh=zov6Py3zltqAVv+NOMkKfsCD46ZHMW9+axwfVt48bpE=;
	h=From:MIME-Version:Date:Message-ID:Subject:To:Cc:Content-Type; b=Z/rG3jRXlrWvdFUCrzzQ1Nljzx+sC0aE/2Ikb9SxKWBqtSRahq6DBeb/sfFahtrrmja1Heu9Ca+k7GL8rVDIau2kKw15cIR+QPWUQQ5ul5yayzZfvxStGGKDR3ufUulz8AIZ/b9WLwMW58PrWxMxuFPsz7yep2/vPklhwQf1SrI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X0Z721EU; arc=pass smtp.client-ip=74.125.224.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X0Z721EU"
Received: by mail-yx2-f10.google.com with SMTP id 00721157ae682-85e68bdf10fso114377b3.1
        for <linux-wireless@vger.kernel.org>; Tue, 01 Sep 2026 08:44:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788277471; cv=none;
        d=google.com; s=arc-20260327;
        b=UHFj98ZuGsgCpT9MlR93wSAHU5sFHT5TfbfYk0F16XUxL2Qm+7p7vC9OMYzvxVXRre
         mlNem5khdrT1L1/nuvW5Iu6YQc/01rlB2wpmv4Baqf/LE0gyc2lSP6BQpGeK5ReR0GOP
         2mLj9ixZGj4kK+NiDWNOJVGW1nShXj79ru76knd31ke144IMFi0d1cnATuix9DOcrt/b
         cVSpi4Nv65DUs6slB8ShYr17bORQVc8XkA6r8b+7vr8N4wNL7SvCiwIAQgQYhVnupalZ
         iZ+0u+RxltztZBPGxbWwD/BzUqRPfG35LOiscTsE2l++8w2WF/8d4MgkJ/7dogd59aYg
         YznQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:from:dkim-signature;
        bh=w1OB1cgXW9mHXAWQyGbfd9pPmTDojnYoo1rlvFUrlvU=;
        fh=okC+ffmPnwP9v8VGQE1L9pF5jMl5wfp1spON8Ne0s+k=;
        b=Udi5F9hR3izty2K8USwBFtT/LjW/LjeR2S2lENIB+q8j/LN7K2neg39RSfszqbTCwR
         50pwt0PDcwQA7X2zkzhtfDS/7H+I3UjJYfNfqS77yoqKxTBgx/2H+0wcEZTR2hlxGP5I
         jWQfY1Q1B/ajQ39/Mi3QrtQqMtYBB4JXDbt7Rb+zActaMcyHZgq6N4r2KsrR0ejIPv9n
         nN7PRmb8elCsMjoxiGEPz5FX41ZMlsaqjn9rR1oINOTKWQhuM1JzwJ2G6JOe8MSOx71k
         T+L89idmg9hlm6oYiCtsoYwESVcf9hsf4QTB9RsXvOyAI9poiqTBblTqIFUO9XPOZeBX
         FTsg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788277471; x=1788882271; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:from:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=w1OB1cgXW9mHXAWQyGbfd9pPmTDojnYoo1rlvFUrlvU=;
        b=X0Z721EUmuhz63VTGJ5u7pPfYJweIlzW8xnbyub43asPTsCX+7p3hvxSTcvYXyIq3U
         6oWFHTSVWPSREF+2l9egp+LAK/8b9wX7vbcQtpX4Qv992oAs9aH0IgkSUDgCgkngeiR4
         1bwRqkJSFW/IVbFIa0dRJdFDo03T/8NTG0SsCMA2+/dNmdFSyhDYJvcFIW62nKEjr3mR
         BZUF/0C/0RMOqGmdi3VH+vCuP4lzFsC06rtXjbxf4Ek3q4rLbVQbK2vk/1bCYGAqZX4U
         UdIFdQ2146WDu6QWE9v2CQ8ImPFvYbem+80BDEV/Ot5Ik6qF5cvND+vgRSSs3ifDPye1
         wlrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788277471; x=1788882271;
        h=content-type:cc:to:subject:message-id:date:mime-version:from
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=w1OB1cgXW9mHXAWQyGbfd9pPmTDojnYoo1rlvFUrlvU=;
        b=pbdl6JKa3X/HtqwHNbvVH7OcpuN/abGFcw8EBOUXmAY28MbiRfHavr0S39JTMktfz6
         s87gYnLt7skiGinPD4Lf58jqmjdJ9QX27MgD0Uc+mME1Gdpzsaf1SBLypbmoA1SSIZEb
         KuZTRdKABAwgMcSH73FkfHhpic1F4MtodFUrPtfuj9DREGAwZJ+v+/JIt8eqTfe8WD9+
         aNGT4iTx3tCJiNGxc8NlX+01Chk/Klj1+M4bNIx41FxcgmKruSkmS1yqxT23uN2fUGzu
         6Ye6jnjcpoZSTJeUje/v/1KoPyqB2FoieTmgCwTy1FxHa6vhJj+f3UzrfT6+7v+HDA6e
         a94A==
X-Gm-Message-State: AFuF++l9th5QeKToJatec/gsmWHriTYr0CB9XVct8yu23jaNAjfruGUC
	B7NwemrW0urenOyvyL9UC2of3/GHcmoo7sfIfVGSEEIL+Xuj83mWfk+iiEB2TYXsApTl2ZDBVvm
	KOhlOGi3QoWtrSJdiQoFFg0o95NfH1RjVGHhfz/tppB9D
X-Gm-Gg: AYBFou35nCT9ag+yZR5zguvWV6i3a7zuQSoQf0yi67ilwtDAA7r+zbNOBUBdSnfT2zX
	0Ev3y9SU1jud4lMfRiUBY3H+JQHeZOsW24i9opZo8YQlVZXWYvDXern2WDSg3ZsMOSjstoylCf1
	bV8N8Mi3miX+T4CNTUERpWwRcH5ZkAOi1ZN9u+wUDEYDTu+1mbxPXZLDEspLhUNADC9NZ4s7E6v
	OYK+bjYoWQdEZozbUtXM0Se41Asi4Yrua3aorDEiyU35RV9joeq3xRXIMPmIm47VVtgR4TsQ/BS
	dIgSamIBf6wVZyqCWa18n7hgGgyu9WCFlkH7fXq514r+
X-Received: by 2002:a05:690c:a584:b0:833:f9bd:b289 with SMTP id
 00721157ae682-85d6c9ea406mr122198947b3.31.1788277471223; Tue, 01 Sep 2026
 08:44:31 -0700 (PDT)
Received: from 479852211826 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 1 Sep 2026 08:44:30 -0700
Received: from 479852211826 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 1 Sep 2026 08:44:30 -0700
From: Andrei Rusu de Castro <arc.au197@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 1 Sep 2026 08:44:30 -0700
X-Gm-Features: AcwNN1VZtLYI02yNKP1hkBxAEsv9HGRSQetMnnKpKSyOsvE3ZAluO2YMPhDL2VM
Message-ID: <CAE1+iCRfzzPpkjWKTtGe6Apeo-EBT-iZjwgwhB9jSVsz0fzokA@mail.gmail.com>
Subject: wifi: mt76: mt7925: scheduled scan accepted but no NLO event
To: linux-wireless@vger.kernel.org
Cc: Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>, Ryder Lee <ryder.lee@mediatek.com>, 
	Shayne Chen <shayne.chen@mediatek.com>, Sean Wang <sean.wang@mediatek.com>
Content-Type: text/plain; charset="UTF-8"

Hi,

I am reporting an MT7925 scheduled-scan failure where the firmware
accepts the request and then produces no result event, stop event, or
error.

Environment:

  Hardware: ASUS ROG Flow Z13 GZ302EAC, MT7925e over PCIe
  Firmware: 20260605184805
  Kernel: Linux 7.1.8 with local MLO fixes; the scheduled-scan path was
          unchanged
  Userspace: NetworkManager 1.58.0, wpa_supplicant 2.11
  Known-good kernel or firmware: unknown

Observed on 25 August 2026, CEST:

  06:00:17  AP disappears; driver reports DISASSOC_DUE_TO_INACTIVITY
             Three ordinary scans complete in 0.31 to 3.22 seconds.
  06:00:35  No suitable network found.
  06:00:35  Starting sched scan after 0 seconds (no timeout).
  06:00:35  nl80211: Passive scan requested.
  06:00:35  Sched scan requested (ret=0).
  06:00:35  nl80211: Sched scan started.
             No NLO result or stop event for 16 minutes 45 seconds.
  06:17:20  Opening the network UI requests an ordinary scan.
  06:17:20  wpa_supplicant cancels the scheduled scan.
  06:17:23  The ordinary scan finds the AP.
  06:17:24  Association completes.

Elapsed silence alone is not the issue. Scheduled scans are open-ended,
and neither cfg80211 nor mac80211 arms a timeout. The discriminator is
that an ordinary scan on the same interface found the AP in three
seconds immediately after cancellation.

The AP was a configured network and wpa_supplicant associated with it
automatically after the ordinary scan. I did not retain the exact
NL80211_CMD_START_SCHED_SCAN match-set attributes from the failing
request, so the existing capture does not prove that this AP was in the
firmware match set. I can reproduce with nl80211 tracing and a minimal
single-match request if that is the useful next measurement.

I checked current mainline as well as the running version:

* mt7925_start_sched_scan(), mt7925_stop_sched_scan(),
  mt7925_mcu_sched_scan_req(), and mt7925_mcu_sched_scan_enable() arm no
  timer and have no state readback or recovery path.
* MT76_HW_SCHED_SCANNING is set when the enable command is acknowledged.
  It records command acceptance, not a later result.
* The only result path is UNI_EVENT_SCAN_DONE_NLO to
  ieee80211_sched_scan_results(). If the event never arrives, the driver
  has no other observation.
* The shared mt792x initialization advertises one scheduled-scan request
  unconditionally. There is no firmware-version, device, or feature-bit
  gate.

I found no obvious request-construction defect. cfg80211 bounds
n_scan_plans to the driver's one-plan limit, so the request does not
overflow the plan array.

Which repair shape do you prefer?

1. Gate scheduled scan for affected devices or firmware builds. This
   preserves it where firmware implements it, but I currently have
   evidence for only one firmware build.
2. Add timeout, abort, and recovery around the first NLO result. This
   gives userspace scanning ownership back, but scheduled scan is
   intentionally open-ended and the right bound is not obvious.
3. Stop advertising scheduled scan on the affected MT7925 path. This is
   simple and made reconnect reliable locally, but should not remove
   working support from other mt792x devices.

I can provide the exact nl80211 request, run a minimal request without an
RSSI threshold, test another firmware build, or enable additional MCU
tracing based on what would distinguish the firmware states.

An LLM assisted with inspecting the current driver path and structuring
this report. The timeline and versions above come from captured logs and
installed-generation metadata.

Thanks,
Andrei
