Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.180
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793476512;
	b=40hc1YBG47qTn3iMz9M1za3NEnhaMMgAFjk1lRGleWWOboUGc/2AFJa4Xt/MCraPe+eG
	 hA1lx+rFxxkefdHCK5vBPUSwwzPadEiRakOc8qp4j3w1ZenqmYZAYwtoU7bw2/i9qc1QC
	 B9csIAnHUSxItH5z2GLYNKwQ3wuQWffpKv+0y4fYNVBcOmxBO6EdUcqFE6nhohqnjiXni
	 WkKNDtuECLUapt0jx9s7NelkZSd5sOOCcjD/C63R2sRFh2X9CHOT/UMFT6zFgAdBhbC7+
	 u41THsD5N20ggXiNXysu4TzHhfpKY30IfIS2tN1n4C5ggfL/sFXURGd9iu/Q/LboxVA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793476512;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=5O5IADadRA7OjjYl6cdAuBGkPA4cHFlxrAeTL7mxKBk=;
	b=mr+UX0pAQ1nlnb05r9pkydAxzcwBlKd4rsuAduDwu1aUGbnGt5ubcMN/vZUF7KTr9sAU
	 Yrm5kiJZt49gG4CUP7VS5FfuN9gUUbd4ugXs7zOCITiI6OdVyfuw9KgYzVIKS5UAfubBe
	 8M++KfProXHUiiqyJI39tV5nIgfNIBTxoZlLp/9O4ZQe5WlSk+O+2uIUHY6yCp3ervkX7
	 ALG+KkbZXRkJqkxsa1rmdink6sMJdEmiyavgsnNp/phpds3Pdg0Vua517z4vTMflItGiu
	 DPlpQ7qgSUk916H4nHIKJ9t9vCy5j9bNTtXQ+7DAQU+sgu7zsX4PlnV3IvG9ULn0i3Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bairaktaris.de;
	spf=pass smtp.mailfrom=bairaktaris.de;
	dkim=pass header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b="STiIltO/";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.180
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2FC606A31C
	for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 19:55:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0A2FC606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=STiIltO/
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-8b0d91601bdso22832517b3.1
        for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 12:55:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793476511; cv=none;
        d=google.com; s=arc-20260327;
        b=eZgdoYXIxGup8QwzWURBxpDPYn2vRMJpHAUUzM0h84MQI6vdkL/eioyX+cGFEmYeXW
         +62P7T3WUHWf7z77nvzRCdu0zQxqlhTC0jJ09Z2sZzw/rxHmIVa7hmAnbZbVYleivEHA
         4dyROFZhtKVK0KPphBUM+gNQotjvKkRDZ0wSWl+zGUm2zMxQ1r2kuPdyHUYWEQH5OoZN
         TrZnXd4otG/t16jqHCG3WBII8voKAxTERON8OprT5cRFlgr4lStXyFmzDnfQK680tI1F
         eAPNAVAb8xv1oh4kb1DcMw8X+/sDTTlpxp3Vdv2F5WLCrFueAvcDgmN3/lOPUMcB4KSr
         5IAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=5O5IADadRA7OjjYl6cdAuBGkPA4cHFlxrAeTL7mxKBk=;
        fh=aBj4LCg/Axcumx+CaF+Kl5PsZv2xO8Vf2BamhIwISrY=;
        b=CrjrLUderhaCTNLV8A7j0csclZrVE4YjY1C34cotuDbBA/x1dv7gLhjxRRfBX+vu29
         q8KlLbGhKqz4p0t/q3avu7J5XrnIg4qISKXqzZEzUQ3rIfWVHOT3cN+0INmYW1Ig1ptb
         WsDCz+xNsbugo1XX4zZjxbtGEQB9JJt5EhdEvznQ4qjQd/jeP7gpfsR6a5X+u4B3jBFq
         5a+QGIiAEgx5Ky0KnT2Rc5qabeN9h17sCXWkLuUf+cpPIVAc0tjOBsIBor0vJLKd5etA
         AoP4WQv+Bg2bASmmleRPhyIPYhTpEXIlVaMLq9XmrRhrbf5Qrwaxd+J1aOR6U5dvTi7t
         vu8Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1793476511; x=1794081311; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5O5IADadRA7OjjYl6cdAuBGkPA4cHFlxrAeTL7mxKBk=;
        b=STiIltO/aqKmnKiUqXHcjXT6P/2qN7QUM0q+/n4EgGThq8OvAxvoQ80ETa9YMtYGjO
         VX2c8EEV7d8VCgCeuPgqP3pbjamibnVJQTW1fOst0t2iouJACwrAHGTKavgV8n1ZK7Lu
         iTte4wR+EAOE0Nh1dOrnv8ZEsXgKYQFvEtWqJHeqbOFOIEFQ4I47jRwdWoTHn+Cb7RWT
         eKgj9UDHraGLjIy/F/ihfoA86jyx7bK6URZkBM/2O7X7mgq/IbwaNx1Wx+Hyj4/aZ27w
         vo+NjOBzJtAdRBAySh7FM6PRRlaltQWSPh10UxMdqDRaH04TyoJVhfV4CKGgv/Zs6yzE
         /Sxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793476511; x=1794081311;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=5O5IADadRA7OjjYl6cdAuBGkPA4cHFlxrAeTL7mxKBk=;
        b=Nau7hl3FHEIvsppD+z8Jk9kUB2hVhjO3Ws3ZI3jSdzT3JKFzfx++xmC13VTVA65X2s
         fP4EANpqioWLNNNuFdw1h4J30JyFlQ1pIy4RPamnXnwKti1UKiHdWJofGlt5/WINLII2
         R3q26iWGkopIbxFQBNxorOEo2m2A3vs9yhHJQV8tQ72xYBqJG+nj3qMRZxJv27+3V8eT
         x+rdhVYP7xeCG/y72dGiBrbJ9O5I8s/8GAPZdQc4Fxghn/YfWX+Uo9FKH7j5GTgRB8wQ
         MfWNEU8I0mHbGBb9xQmlp+0XZ28WemUDNXlx7cA6NvxqnlGkpYk05V1qgC77yzw3zxNt
         Kvbw==
X-Forwarded-Encrypted: i=1; AKwUvBzVxykvkLmyNXuZW7N3mJK1W/xUnAIoc8nPCI8aaxXxm4X6FwOpOID9cY7AigzXX2fDdaBOgcFVHZs+bRKI6g==@vger.kernel.org
X-Gm-Message-State: APuU4Z/ynl/WbcjaGl/JCESivfuNWtnE6ys6m3B4Tc9ed2b/7vAj9KDw
	Z8okTiq7jQjuBKYh+B5HO7gKtE7v2ZHVluxNytNxRm+ejRPUeABRhQXyTxqEJld5eaLRiuqI1NU
	JgI7OjExzX4vPHgyiZpedK5WMf084mBML9iZRP3mD
X-Gm-Gg: AYBFou2i12CGwT2TjjIlzUhABZu48xfbIMOPE+IVtDN1SeJzO4qyMzEsUFfejDng1XF
	Ens8FQUjW7VEi4lSmy6XaQRFhZg3/W5LD3cDW7jeLlIhr0YNr2w6TPBXhl5UTaRJwzDnoGhBKhf
	QBXnkM92lW42dcnxxCzLu5LK8/T4HuZjCoKbB+/unxXFaUStpG0cGnRE5BsfDoDtl+1cEBbriom
	Cg641hrYy6vB6dKAgz06jYtlDrWmPMBP3fJJYWTXr6h5y7sAyugJdFpuAqpkcutGVloy4BW3JBD
	a+AoXhnyAuPnKiI3vy5IkzavF/m7+xhXQeE6VG+wJw6cwCXTxairpk2v3KxXKOzwTFlYGPdwH3V
	scD3Br/zcoFFkNL+P0bSlq81K7ZKEVfl7k/2O7Ta015c66Q7sei+zg4kcbv7AK8Rrk3NbkEhF2b
	RyhF6lYLjyH5VaSukNSWoaov1buzU4xRiJCFjX/NGzX+oAmgYKAoEHPxncOrPqWTBzD2NalgTbJ
	zIHn5vl8CIzz6tEFioUt3OgTlKAemMelR5veHRxkbDIKg9pPaYei2txyOr5KCSJ8c0zETuuyLXd
	L8UIoA/MyBmuG7QcEf844rFXUZWonxZSI81oXIJZw6P0o9pPmcfU0h6xeASNWdtQdaoeGZnc3zk
	nq6yS4QIF5bgbPKajhQg7Fhda+raO2w==
X-Received: by 2002:a05:690c:6612:b0:8b1:6c4d:6b83 with SMTP id
 00721157ae682-8b1c6762363mr64199007b3.24.1793476510987; Sat, 31 Oct 2026
 12:55:10 -0700 (PDT)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261027075544.19144-1-julius@bairaktaris.de> <20261027075544.19144-4-julius@bairaktaris.de>
 <7ecbb748-85fd-4a5b-b673-3f29b683e8af@oss.qualcomm.com>
In-Reply-To: <7ecbb748-85fd-4a5b-b673-3f29b683e8af@oss.qualcomm.com>
From: Julius Bairaktaris <julius@bairaktaris.de>
Date: Sat, 31 Oct 2026 19:54:35 +0000
X-Gm-Features: AclHuK-y6ZcuKV4f5uzsmB8CJRCLAxncnpWnV8eG7gDPJlWCxU7zg7ukuzbMPBc
Message-ID: <CAC1t37K+SCBFbt03xWrdgreaWctwx5G7uEYfyjRHghztKaWR5w@mail.gmail.com>
Subject: Re: [PATCH ath-next 3/3] wifi: ath11k: add a module parameter to
 select the hardware mode
To: jeff.johnson@oss.qualcomm.com
Cc: jjohnson@kernel.org, ath11k@lists.infradead.org, 
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
	baochen.qiang@oss.qualcomm.com, strst.gs@gmail.com
Content-Type: text/plain; charset="UTF-8"

On 10/28/2026 12:03 PM, Jeff Johnson wrote:
> Is there a different way?
> Adding new module params is frowned upon.
> https://www.google.com/url?q=https://msgid.link/6d553cffcb0ae84e141006ae1430f6f37909ad2b.camel@sipsolutions.net&source=gmail&ust=1793562736182000&sa=E

Yes. Which mode the NBG7815 should run is a property of the board: Zyxel
specifies it with one 8x8 5 GHz radio and 160 MHz [1], and its board
data makes the firmware advertise DBS for that. ath11k can then pick the
mode from the machine compatible, the way
ath11k_core_usecase_firmware_table[] picks the firmware for WCN6855
boards since commit c386a2b10689 ("wifi: ath11k: add usecase firmware
handling based on device compatible").

For v2 I would replace 3/3 with a table of hw_rev, compatible and hw
mode, with one entry:

{ ATH11K_HW_IPQ8074, "zyxel,nbg7815", WMI_HOST_HW_MODE_DBS },

ath11k_wmi_tlv_hw_mode_caps() takes that mode if the firmware advertises
it and otherwise keeps today's choice. No parameter and no new binding.
1/3 and 2/3 stay as they are.

A property on the wifi node would describe configuration rather than
hardware, and the series above deprecated firmware-name in favour of
the table. A runtime switch does not fit either: the mode goes to the
firmware in WMI_INIT_CMDID and fixes the number of radios ath11k
registers, one ieee80211_hw each, so changing it means a firmware
restart and a new set of wiphys.

Does that work for you?

[1] https://download.zyxel.com/Armor_G5_(NBG7815)/datasheet/Armor%20G5%20(NBG7815)_4.pdf
