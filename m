Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.171
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792778941;
	b=Y8dod30MD0GC/VACrjO4ms8NYYDJ6WyqU7dWOoFFFPUwFvsV/GeXNQ7Gx6kEp6gtIPLW
	 747wJWyNwzCheGiI2jnWnGZPq6gulPjLI6afsZWuPgOJRa+Q/RR3n97Ik3Q/rMBkkuHOt
	 HQwx9O9PZ/z8q3NreiyDMrvsq4/kS/21qaClE+cwv0Aefn5dgVVeZak4ffjFAWK8kv5bz
	 5uJxV7juJjyrc2N7aJQQYS0dZmkx+48MERcD0ZzIYNCtMXpSjXy+OzMlSAxlydM7HNKor
	 nETrJrLGiSaRtODiYgKDLXa7iMcveZ/Z+tRsSdNBuzmAFAuHMdZCmk5J/aLyMy9ox2Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792778941;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=nKpQdPCfN7vtbw7obZJvLCHSgtoYzv6z5biXGbDum1g=;
	b=L8Vyi2yh2aWWlqqthhvgmGjYWx8mv1rCIlk8B1FwwGm+f+CjMrldcE8+PN1MIjir4Kr2
	 nS0fOp9PiY/J1O0L+xEHTXwAxrezk4DZvNFoDt7EBq1wW49wYgBeY3sX9CX7EvaY3NZWx
	 UMbuNzlNjX1Uhc5p/3hKelNwBDOT+3m3ezq765dp+VXaL4bmBc6bvOryMcuNYA3IM8+Em
	 t35loqLJo4ps0vhH3HKkqgtUeddoeSZ7tEFRuyscXuoGBOui9fcMycxajy7791DEBlA3O
	 Tbe1ub1SGkUKd9pi5nLQdVxN7qmmJFNMkXfMfOmQF6KFMA2Fj6NH/3LiEX0qOMo3wDg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b="V2T6l/7a";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.171
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F2FE606A31B
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 18:09:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9F2FE606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=V2T6l/7a
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-3ab3b29a210so10980571fa.0
        for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 11:09:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792778939; cv=none;
        d=google.com; s=arc-20260327;
        b=XRT4gdw2TeD8yEqTRecin5f76nKAyyxVAyAo2Ukry0E93aHpqWu/+EBn/CLKLyaRqJ
         MS0hwcKr1HEPH541Lh3rAsPFqdmuiNq5S0A0JoXiCdJ1MtU1m6vAxfvuNy3XPPLHZLqi
         LGd4GAWpDLDWOs6z3Tsd2lO2ZZ/W8LE552OhA8EpxG3RCgNIZAsw/tT08+5E+KeKwxcE
         o95ERPyMZMf5nJohLYhzTRgW6ua/fg2naY5v8aXQYw7JxbzrG3zyloahH0iV6E94Eir6
         1Su37rJ7hJadUjcoalrDwzaas7yuOwZ7hl00zibqyy+zz/eQ9jBW+lKwY3gWthfqeX8x
         Qc8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nKpQdPCfN7vtbw7obZJvLCHSgtoYzv6z5biXGbDum1g=;
        fh=SenwZFA6gsPXeNarhFNnDrrvycDF3Y7WgSbli3sUy0E=;
        b=RgC1mZ6ARLYNc5hVibdXwLpyKqtaPO/lXkRNRLOfhWtNSJBiZnc8lDj7Q4JIeuWuoc
         M94yqVvOK9tlwyZuBrO94mkY51vcvXrvZwZj2lrJnmJ8aQn+39i9x8PcbkyXV9fV6iof
         S1ZTeubhGlMlGZ4Ody7AE/oq3ebDU5NPYJDtzN8i0ddAHfHAcyDCIfztcyDhS49p/WhR
         t4BzDuxAA537t2TIbRNRiIzX3A2q+wvAxlyOlUDLH3m8Ro/ClbH0WgbNQEPlT38kAphs
         DXUdz2zliTyA2rhklvHQeuC9Nmt5nXKieIw0QWtUC7O+SXGNqRpaWUhah9syDCKbpfL4
         rnkQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792778939; x=1793383739; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nKpQdPCfN7vtbw7obZJvLCHSgtoYzv6z5biXGbDum1g=;
        b=V2T6l/7ameed6sVkeAzi5rrA0oehedbrCJVrRWC9j0OKhx2Zc0FICRciba4BDpIPQo
         DaoImqskD9qR6gvN9ulG9cWDahYaCipbWKqi+StdjBKSgi/XEe8DFKAaWwn66eCKp9X3
         vfIS0E+7Tjpodd69QWhWun3l0H8L4b3P/4EHAZXQMpq3jEJ2axEI8dFOAPCbcBKnmK6j
         /ZO+Iknhs6cnujPkJELBC6nC/odMJ0gQXq4m9zGG8dPAQT/A9DMD5oAcXwbvzjdGhmSQ
         BRMjaYDEuh/N7eC0xYZlDssRAsNMV5DA4IN1Q6D0kr1+Ug/PNtnwg3obm+1YGSudx7/e
         PHlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792778939; x=1793383739;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nKpQdPCfN7vtbw7obZJvLCHSgtoYzv6z5biXGbDum1g=;
        b=O+g+lDj7OITAs7upnp5ckLvjuczX2WSeYPHwF9FQ92rRVcGCaLrENg9zXCNw3au02f
         ks5qJ5uVs/KtrSXO2kmp6H4VM/kkx+pibycgLdEoOMhNj8jKnzt1iw2H5dby3GiwgHs/
         TpnicRgG8Swuo0C4C8Rjk99KAvG/fUHoCdgxgtilTuTtuPCGQC4yoi64BobhDwyGXT0d
         vopiqTSWNsw/xQBG0LpIfA38KmfB4rAOszqix8+BXBi8YdhgGKn1k9OXZKlSbZwMKPPW
         0ogJRjy4LKoQ9nPmSeIi4++lkawVYQO4xf/ROqXBvkw7kOuATb3Y6DF+Ja5p95jaETHK
         HBZA==
X-Forwarded-Encrypted: i=1; AKwUvByi0i1n5FIEpj9P3Bfhp3aBCp3jVL2wpIVN60O0aDpE5W5cnPm6Xk0dyIVax2GrnybPJSDA1humAulea9AryQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYLYPidnowklWoGKHw2GZtRBhsZImesYcjjakb98n+16jd7IRYRR
	Xhd+YmASo8Zs6zwia89Y+z6qOo/j5qA4sCdC52w4lAPk6POI90nekyZt1otw5ZWz3JrGXI0RHKx
	BCvh60zVgkcAv7g7GhEk1/uRyezemC7k=
X-Gm-Gg: AYBFou1RYq38XxXUexy/LD9pjlSve0B7/lOrg91SfM5O7CSUoXb7+uguDamzF68HdpF
	rC6BoFA5wmeOn72nkr45KA9ZwTMImFjq6nrv87UCXFa8/1n/URdTHgwcov+LfHnpjib1hAGMDub
	VfzXQmX76qtHOOtkvloutILJrGJWtraaei2F9Yi126ywbkSMPaz9Zz1VcJzC8vuXZ8b/XKJlfWd
	gk29mqK7LA4ltvAAFPbpqVhRCDWDGqnJlcdNPEweuB8N79qNvwEeqMdaJKIQWQc1niRLhCpP/CG
	8/HKHOXeqZ8WH44w3Ay5+TDQdy701igCu6oHxnH0aPqoTlPvjnq1xG2UwVKwqsc1I7sT5fsvJXL
	wGhbvk0Nf1wrbXFxotWMh4xlNkHKRNUDxTLxlp+hyr5q6boJTAJpdrEpbRsj0fZIYsO4l4OY=
X-Received: by 2002:a05:651c:1b84:b0:3a6:62bb:906e with SMTP id
 38308e7fff4ca-3ac6fd4e4cdmr269461fa.20.1792778938495; Fri, 23 Oct 2026
 11:08:58 -0700 (PDT)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CAAzpgGfrHpQZQ8iaH5fqZHzk5tTx39+jGvGkVXxhYFkp-A_bQg@mail.gmail.com>
 <CAAzpgGeAaOjPdiVOmeY7xZqEymyh4BfhESwAvTzczvqj+YuNHw@mail.gmail.com>
In-Reply-To: <CAAzpgGeAaOjPdiVOmeY7xZqEymyh4BfhESwAvTzczvqj+YuNHw@mail.gmail.com>
From: =?UTF-8?B?TG/Dr2MgS0FTU0VM?= <loic.kassel@gmail.com>
Date: Fri, 23 Oct 2026 20:08:47 +0200
X-Gm-Features: AclHuK_kKsOTsWBx0Yucceg6CRaakmJTdlvJSrwgu8_JgodWjgo2txSWsrgvUvI
Message-ID: <CAAzpgGddO8H3EVb-WhXEeiCeoV97NuV0G22UZcHmyi0QZLwcMg@mail.gmail.com>
Subject: Re: [REGRESSION] mac80211_hwsim: CCMP frames dropped on fast-xmit
 (WARNING in ccmp_encrypt_skb, net/mac80211/wpa.c:462)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Sai Pratyusha Magam <sai.magam@oss.qualcomm.com>, Rohan Dutta <quic_drohan@quicinc.com>, 
	linux-wireless@vger.kernel.org, regressions@lists.linux.dev, 
	Felix Fietkau <nbd@nbd.name>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

I tested commit 6832075ed4ef ("wifi: mac80211_hwsim: reserve headroom
for software encryption") for this report, and it fixes it.

I applied its one-line change to the v7.2.11 mac80211_hwsim (Fedora 44)
and loaded it as an out-of-tree module, then disabled my workaround
(fragmentation threshold) on the AP radio. Pinging the station from
behind the bridge:

  - without 6832075ed4ef: 100% packet loss, one WARNING at wpa.c:462
    per packet (10 pings, 10 WARNINGs)
  - with 6832075ed4ef: 0% packet loss, no WARNING

(The module also had my unrelated beacon timer fix applied, which does
not touch this code path.)

6832075ed4ef has no Fixes: tag, so as far as I can tell it will not be
picked up for stable. The problem was introduced in 7.1 by a536be923191
("wifi: mac80211: Fix AAD/Nonce computation for management frames with
MLO"), which made mac80211_hwsim encrypt CCMP/GCMP frames itself, so
7.1, 7.2 and 7.3 are affected. Could it be considered for stable ?

#regzbot fix: 6832075ed4ef

Thanks,
Lo=C3=AFc Kassel
