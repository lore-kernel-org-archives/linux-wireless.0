Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.177
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792776682;
	b=Zlr7xPaq2PHS934tGhrxO95ipFOL7LfPTXaGGSWIHFcwZbMN3L2GlLh2XS1rZNl2qz2r
	 f3CJvJY893gyVpu/FRH91HdfdRXml8VF3XXt2pD+ncvPlPaBYEuP8bVrbAMr8x4t0lkUs
	 4zlVbYPZNloeE5veSweYHErx96ffGAMeg806ZG4PEOOfTOllRPO49+Ku9CujS10kZ/Y0C
	 tDX0zykAwEZ/uubyFqWy/CYAllmIqu4ep6oB/Rf2zPe5p6P7R8ThiDDiVteySqrqj5OjC
	 x1iNI3C34zS7nmzeTfqpDEweX2Ocj7UUkA8lDPXEk80S+kUQ9QzGgnjYDPaMKgblp5w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792776682;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=lASGxSwfD9Fa0qiAalFQi3F0/w5+yAO/kKxmaqmHFhs=;
	b=lS9kdf1VjYD2sGAX36n7B+fUp8RyEWJQnSAOs78HfyqpnDEnTr0bME+tXyq7w3eoMJGM
	 EYIM3gZwAzloh6khluHYufjz/MBb15pf9X+JS9DerdRmCflq8dUZFz5pvvAsgqq3jTHEM
	 3isgEAI48soAWUwBl9s0SjkGSbEd/HRmWpG9tkVdncl25Hzd5MEjSgjRHbWVAFIGzWLZZ
	 AWzopEykoEWw+HNUF4Jna8rlFWFjVD1hfTO8O7FeJNI+irvZhK9dixFSb8qL9VH9Nu5ml
	 7YW5IXAAfXFmQq86UNOAdbKOUGemIyGBQqeuaTV+d5kVT3zitZ8wxDkXElCS+eYpqvw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=lkopzAu+;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.177
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A01B2606A31F
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 17:31:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A01B2606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=lkopzAu+
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-3a9841363b5so7825291fa.2
        for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 10:31:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792776680; cv=none;
        d=google.com; s=arc-20260327;
        b=JcNm/fFc++Vh2K9b02QAHOeqQfglOQTN5ljZNwB6uvyDjaiglwIogc01JB3hbyIp2s
         PH1YrmfO741FRXGr05oe2nXJQs6VqGbc9V1H2pzVwkEqA1M1ISPDLHb4gis2ytBFQTXb
         M6CJleYbYWmR/nrauc8/SZAYMH4rkmy7Twcclbw3LILml2VLqkNaSlk/xXKP5LVQKSZh
         925l9HwmtbnWkN+SfzaJWVw4jsBnimXMfVmFq5Iv+YDYCTYljtvzbUxzKORFG1OQSDeI
         Ge0eCIRPgE3zvHMc7cUuW6t4WHuFyrSn6CQGCdhNuG3jTXrsfhqJY5oCfas3DpAgK4xf
         Uk0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lASGxSwfD9Fa0qiAalFQi3F0/w5+yAO/kKxmaqmHFhs=;
        fh=pXHtACetm+YVNdzWWvwFY/hX+svbXjiAR0t09cgtgdo=;
        b=Qhq7gc2h8rmkBqsdfXmrisMMS0S2anHyR/jLtKf+99olviR+yP4DX6GAFA+6S0Crhc
         k24zR7Qia/luQs/bOoV7S2pD1i3DKUNHAYZxl1YT3GEffTHhJHuqUqX++HQtjqM+g72m
         UGYOJshLAIkQ24FCYO2RUQlSSJMUuRUoFripofExOfJnwfJKN6rTWstixXFhBGbKXV2E
         QkOGhstYZUts4orYcaJGw9p04z+UqJS6eC2B2W5uQej0lEXFQ08g37jgvq1JMmjXx+iQ
         pY2CvpXpo0F29ncCQYEJa/eDQc+B2CsTvmYwtCy9vXR94mHtvDH6OoOqOqZBJrwjCRc2
         sSLw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792776680; x=1793381480; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=lASGxSwfD9Fa0qiAalFQi3F0/w5+yAO/kKxmaqmHFhs=;
        b=lkopzAu+wePqZ6hUlY4yXUGU0prRdXaN1o8ry7aJVwja5IamdW+3Xv0JxcJnSQelXB
         rRKT3WfwAyE8XffMS0R7fn85jnBqEzsWzy6DBK+5WzUtEbMKRlGqdb/aWuPb20UeUwbU
         YjxiHblkkjO/Xtqlte+3Sim6BACGeWrvo6hZUuKoeopifNGbcslw41Gdc1wPeJyeRf/g
         M1QJsxburI28evOYdZ4rAgBVL3N3IkAUH8Pp234xi4LyV9QK24DHcgHoaX2rfnSyCt5F
         7vEh2BhgsoKE2OEaj2td8HsbaciK8eVqKfkNnl9yytUTFqYuSzWBisizjQjmv139fHpV
         EPMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792776680; x=1793381480;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lASGxSwfD9Fa0qiAalFQi3F0/w5+yAO/kKxmaqmHFhs=;
        b=rlLlBRzwxFxrPTA9aiLgFnvJIiFtUBS5L5g1lTq8TfN5dWEjEVMeSOdA0W6ne9O8tl
         18uWnA2/8mVvss7cMoKOAtGtYttVg5VSO/J+MIUG+L3QoOec6emhGQIP0DNGSk+3xlqP
         XY9bV6B9g2OcpynRPC9NshHMdBEx7FvoG8ESdIgy+wVdXA0WTd3BeCrChbuvNIpPK2Z1
         Rwof9Jh6Z6oKCkJpbeCewH/vrTfDmbWe8T6oM4aULkhIbMiFR3SEgOKV1AIFKqiM/hK5
         vkI/HTERiOlJX7l2zYypFuFJL/7iC5jEbVeEQn5N4nm31BBFL+Bz4yh5inR/2Q08mBo5
         KfoQ==
X-Forwarded-Encrypted: i=1; AKwUvBz5QqmPV7U1sOOX5yRzHHHdP1E/lrbp8+wy8rkMDRjQvXBceEoinr/PECr+U8UrqSD7NH/KgPHp8dregE9WLQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYIFaChZrZ489seLHVxhbzM6iR84Q9AJXtqxiaQOjY7RDl6fdCRD
	M7knH7IvPdpgjx7zEVBdKQl8jt4jyhcxRLSrUh+OzaAoowXcNiTf0LEybFpAgTmqiaOPmc1RYy9
	F0v9fr5bWTjtC7Ts1JEdy/I8vw1oNmNQ4aXfT
X-Gm-Gg: AYBFou2QzwZzFoK4882BvVgDePNTHKukVW7D/sWZXRnOdmDK8Gx/qryzloic8fbSquK
	77spFhliXhTKhLIH4zHD73bb4JgLVt+OZg56kjYzaVnlfSqvP7Dme14xC6OA3dZ/3tQ8412JDqx
	n9DNxzUIfFYWcoQREulXWJ1vk/m32MBGJarrRsYYCePTYlKzfv84PNKmh1bjovMB+bzvC2jmojb
	fAUsLt1cnBhmmZHnJPP0L//jPbjqFfqyzdoz/+rDBAlOFZcIz+Put5PUyYEP9r96hhEdPGJyN5M
	qKKIH2+w7msMn75SSVLXvBz09KIGmZlqOOJU2kKSSGwaD1VrEfLBKfTbMNevEUHmd9+GvYoD+nw
	LZ5Bkdi/1k/ek7UzNk7UDZHvki6h2RLnkmQ9XN7nQNUhKwEJAAaXQCO2W7Z5iUH1MExhD+5mFw3
	/TZM7AkuS2xRFilx8s
X-Received: by 2002:a05:651c:2115:b0:3aa:f617:5c85 with SMTP id
 38308e7fff4ca-3ac6fce2c3emr78031fa.12.1792776679341; Fri, 23 Oct 2026
 10:31:19 -0700 (PDT)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CAAzpgGdksHZjx4jc20zqnAG_PQ2e1ggANQjt2eiycUiWc+vPHg@mail.gmail.com>
 <5e616c87d6855725d0ac726a1de5e88a57dbd312.camel@intel.com>
In-Reply-To: <5e616c87d6855725d0ac726a1de5e88a57dbd312.camel@intel.com>
From: =?UTF-8?B?TG/Dr2MgS0FTU0VM?= <loic.kassel@gmail.com>
Date: Fri, 23 Oct 2026 19:31:07 +0200
X-Gm-Features: AclHuK_5bc_UrTWXpjCHmJv2wY8wQ3iUBulq0P4jSsVVI-7BQsOkwgU8Alb6VW8
Message-ID: <CAAzpgGcdX-hboTJ9xgrx1A3N5eN4OGcPSWR2hKCxyZbJqrCBMA@mail.gmail.com>
Subject: Re: [REGRESSION] mac80211_hwsim: beacons stop after host suspend
 (beacon_timer is CLOCK_MONOTONIC, expiry computed in boottime)
To: "Berg, Benjamin" <benjamin.berg@intel.com>
Cc: "johannes@sipsolutions.net" <johannes@sipsolutions.net>, 
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>, 
	"regressions@lists.linux.dev" <regressions@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Benjamin,

On Thu, 2026-10-23, Berg, Benjamin wrote:
> Do you want to submit a patch?

Done, thanks for the suggestion, this makes it my first submitted patch :
https://lore.kernel.org/linux-wireless/20261023-hwsim-beacon-clock-v1-1-9b3=
f3ffc099b@gmail.com/

I tested it on v7.2.11 by building the patched module out of tree.
Details are in the commit message.

Thanks,
Lo=C3=AFc Kassel


Le ven. 23 oct. 2026 =C3=A0 10:51, Berg, Benjamin <benjamin.berg@intel.com>=
 a =C3=A9crit :
>
> Hi,
>
> On Sun, 2026-10-18 at 01:12 +0200, Lo=C3=AFc KASSEL wrote:
> > [SNIP]
> > but since commit 933f5bec98a1 ("wifi: mac80211_hwsim: register beacon
> > timer by calculating TBTT") the callback re-arms it with an absolute
> > expiry derived from the TSF:
> >
> >   hrtimer_set_expires(&link_data->beacon_timer,
> >                       mac80211_hwsim_tsf_to_boottime(data, tbtt));
> >
> > and the simulated TSF is based on boottime since 1926f4e06dce ("wifi:
> > mac80211_hwsim: rename and switch simulation time to boottime"). So an
> > absolute boottime value is used as a CLOCK_MONOTONIC expiry.
> > [SNIP]
> > Possible fix (untested): set the timer up on CLOCK_BOOTTIME, like the
> > NAN timers in the same driver already are:
> >
> >   -      CLOCK_MONOTONIC, HRTIMER_MODE_ABS_SOFT);
> >   +      CLOCK_BOOTTIME, HRTIMER_MODE_ABS_SOFT);
> >
> > (in mac80211_hwsim_new_radio(), for link_data[i].beacon_timer)
>
> Sure, that looks correct. The TBTT (target beacon transmit time) is
> calculated based on the TSF, which in turn is based on BOOTTIME. So
> obviously, the timer should be registered using CLOCK_BOOTIME.
>
> Do you want to submit a patch? No need for a long explanation here, one
> just needs to point out that TSF is based on the boottime and the timer
> needs to be consistent with that.
>
> > Reproducer (wmediumd not required as far as I can tell, the timer
> > path does not depend on it):
> >
> >   1. modprobe mac80211_hwsim radios=3D2
> >   2. start hostapd (any open or WPA2 config) on the first radio,
> >      scan from the second one: the AP is found
> >   3. suspend the host for a while, e.g. "rtcwake -m mem -s 60"
> >   4. scan again from the second radio: the AP is no longer found;
> >      "iw dev <sta> station dump" on an associated station shows
> >      beacon loss increasing
> >
> > #regzbot introduced: 933f5bec98a1
> >
> > I found this while building a containerlab-based Wi-Fi lab (hwsim
> > radios moved into container netns, wmediumd on the host).
>
> It seems to me that such a setup should not really be suspended. In the
> usual way that the hostap hwsim test suite is run, the issue is
> completely avoided by using a time-controlled environment that runs
> within User Mode Linux.
>
> Benjamin
>
> >
> > Full disclosure: I am not a kernel developer and not very technical.
> > The symptoms above are real and were observed on my machine, but the
> > debugging, the code analysis and this email were done with the help of
> > an AI assistant (Claude). The analysis may therefore contain mistakes.
> > I am happy to test a patch or run any commands you send me.
> >
> > Thanks,
> > Lo=C3=AFc Kassel
> ________________________________________
> Intel Deutschland GmbH
>
> Registered Address: Dornacher Strasse 1, 85622 Feldkirchen, Germany
>
> Tel: +49 (89) 99143-0
>
> www.intel.de
>
> Managing Directors: Candice Moore, Jeffrey Schneiderman, Ramachandran Sit=
araman
>
> Chairperson of the Supervisory Board: Sonja Pierer
>
> Registered Seat: Munich Commercial Register B: Amtsgericht Munich HRB 186=
928
>
> This e-mail and any attachments may contain confidential material for
> the sole use of the intended recipient(s). Any review or distribution
> by others is strictly prohibited. If you are not the intended
> recipient, please contact the sender and delete all copies.



--=20
Loic KASSEL
07.67.99.08.10
