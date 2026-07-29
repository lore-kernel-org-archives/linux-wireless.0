Received: from mail-yx1-f41.google.com (mail-yx1-f41.google.com [74.125.224.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A446D31195C
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 01:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785289304; cv=pass; b=rB8HEXix7BksncDXQOeurposAlkZyG2yl9AjTufkA4nJk6kA5alO9D+nXQ9o1luVOF12Yes5PgiWchIDq+sfvh0K7CaGkY9gLh4JEPdfMeVfLAueYZOq43vjX5W+JS0bBJaSfhJlWcgeHdpvFjZZDRs4+D1nQu80Dnes2WBDVn4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785289304; c=relaxed/simple;
	bh=cSmRAuOQr1yPlDZ61cgpsG1FiMOy5jyM0Q60vBEqdR0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AWDssyiJ0pUpcBNmfq0JUs7u2DAxmxB/y8Bh+gklqXYbQiUQziJ8Xuut+kodnebKIWtswRmYf3CP1EBMfKXE0K7UHNq+ZNfuFAJaOp8WeXFvmC6M2AQfP49/UVITkRed9g+gBDdBR6U1yfkMibUtSL1yNtihqchYFsZhANWRO2E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JkuW2dmP; arc=pass smtp.client-ip=74.125.224.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JkuW2dmP"
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-6680ae2031fso291989d50.3
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 18:41:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785289301; cv=none;
        d=google.com; s=arc-20260327;
        b=ZOFD0KuJYTSQZYCVLhixXAF7909H+mRU88PKM5NWG9OJz0Clp4gcJFEbMg2DMTMpDd
         +3ire7S2YcYkOM7+7HwJNCvcC2RrYupkmKvmRgkFxEA9tAIj+fT3VxXXjDp4HFx/XNhR
         A6BkZossZRhs3M8jPjQkJljkM8AG5Md+qVsOsG6qVUU73sd5d+wn7iWH2PgASBAUmB1Q
         PvNoI3mrwlYlRf6ShqwgYuJsdXcQev+XbNZ0JP5kwMtPFcCO33mSCzCRFt5AujN78ci4
         44ojNKm9pGwYUy+2wtBBtU8X+BVtrUs2MwDoE071BoragXFzm4coSlb2Bs5bjjXPb0Hy
         juEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OuTYP4ZL0opTv+/nzklbamH2mXgvdAXheanX9tRHOds=;
        fh=wxq2cxKIn8NCgRbG0KOD/mWHWjpR/oUXxOPY1MvaA8k=;
        b=Le3LF7G8bDb+Yb99GZCcJ235imdsdntQNU5y90eETKqIvJU61JZP+hGBc2UMyfHAV3
         ZNtTomxV94dPHsX5EZYn3CPChhTyGQHjZpxhVLZEGnqn0l+famgnDNYAGVZ8ewr6ai3z
         75TDoQNKMZNvZuI99pII72JUOfcbQg4v95FoT/eWRRF6Fnl3mB3+wl/2fD50nGSr1yiU
         OA1tiQQI/0fQOaGqYwGcB9tttYlzJC9pqOOleDIHMy40/4/8VgwYB6gDMJ2HZZbA030n
         qdbKk1Ej1QSmNVcKQzvFPPCGe2vRp5a5kVD+wRSoLqG5q1udDj1h/017XPOSLzD6SBC8
         0Lmg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785289301; x=1785894101; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OuTYP4ZL0opTv+/nzklbamH2mXgvdAXheanX9tRHOds=;
        b=JkuW2dmPvgwO90YKpHTinkf96jGm6kehLCs1+hY7F0HCTS4P6pVD8Jt+lFmCacdqds
         kJ1i19eGT4MkxA+LoeZ8geAws6WzX8eblzM1TemzxMnA5jsmYYCoW9/UbhZOHH1aaZjM
         W1PfyhSSgXJ/VUaJkISn+RX1+0Hde7mytl3MdI8SJwTT8oTYjC5lFDQifnAaZrdmILAe
         K8Mo5915O/Ou9//E3h6oUKhoEWDuj6jpXhk9GQ9jhM2t75K5/EQFa/cNUwXlaaqbkV8i
         1CSR9G2m2ptxZVCfN5nXc6dhORA9TyCGxnUkmZF9YITYXge2hSzn3gFEk3PTN3RIuq8K
         gkDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785289301; x=1785894101;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OuTYP4ZL0opTv+/nzklbamH2mXgvdAXheanX9tRHOds=;
        b=Sw62jxFKT0AU8HkXPtnxO+5UdNxIQVTjjsqVZQuiPXJtfxDCNzGUFhC0cjv2+3SIiv
         vr8hZiet6/0wAaoKnkAbJrjkEFWIsxFxG1AQf/5lU5O0y3hZH7iyrenAJ6lhclh3rWsc
         +HQaSWjxj9S6fsej686bA/OJzx/DD9ZHe64iykmtALA/jukrg/onnBzm89cLf7ddPSmU
         58BpwAcmdPiH33b20no/TTYGvRnaEogZ0vy2yJEzIFw+sXV6S86+LuZ2GtvM0VzxppeB
         44BHPNwb2ZtkDORj2rSc2mDzlIXXmNp0q81vAsh1CRjfrLBMwgYpIiz0xT/Z/PvRb1Eh
         9feA==
X-Forwarded-Encrypted: i=1; AHgh+RoqYa72TIaiPAZBCrbAi+UKJhgOjZvUEICy/cS7ipza5KZ/Ss1tK5qdWaEIc+gW0TtjRxFQCF9f7z63D84wkQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwJUL36iwkDHhYsMkrgzloTbQpCukPvHPxRLgm5WcrHx50ZdE3s
	wjJQo9JSYYlAv2fQbqRtKfeJofpi8X6XN3LQgnsAl0r1NlV792BXr4JYnPK6rZJzwyO562jVtie
	0IE6lE30oLQfOFX3aQxDvoruar+NseDjImw==
X-Gm-Gg: AR+sD11Edq0UOpdipj4thOhD7JJV19eLfDuJ7m9316CGjNnFBSp4+fHGVL2UGU6xFdl
	M2Y+RCSq6RiwhdagyRljRpHX2WoUa1l/xVgem082P0XvG7mLcr0xQkKnxPJ1KWigoCSDqyPRSoD
	rT7vIC+1SPkwTHkmsV+V7wVQEngnku3P7i59op0JzDDwibTSF5xAPuF9/KsvJZ3jku9y2nVnCzj
	j5rKVK4QZElSTD9yMFtIFLJGfYXaIBe6cpzU92B5nncp36hqtdFTd4If1p1TKXAV6yeyITitEMz
	l1GZyvudwwJWMRjrHs9DNTPrbjZfcO49AEhtMXMJRN36W33Q2GjlxoBwTDX13lF+KoMCH9PLldj
	lsF/nwURzDe8JLnOaYIrODA+hREJ1Cn4Jsz7rjLh5IDyv
X-Received: by 2002:a05:690c:6d0a:b0:814:4755:2b2b with SMTP id
 00721157ae682-81f991f7bb6mr22462357b3.3.1785289301403; Tue, 28 Jul 2026
 18:41:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260725142028.32560-1-kartikey406@gmail.com> <df56bee8-2347-4909-8859-384a0f87de11@oss.qualcomm.com>
In-Reply-To: <df56bee8-2347-4909-8859-384a0f87de11@oss.qualcomm.com>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Wed, 29 Jul 2026 07:11:29 +0530
X-Gm-Features: AUfX_mwTGA5yOIueKlousgOs2fHojYeuTFehHnwvB_QoCSirFFZFL_gZ2Tzb20o
Message-ID: <CADhLXY4m+KAkJz8-_OLtuvg2fsKx1=BehxBpe0kkAeKQF18QxQ@mail.gmail.com>
Subject: Re: [PATCH v2] wifi: cfg80211: validate IEs in cfg80211_wext_siwgenie()
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org, 
	linux-kernel@vger.kernel.org, 
	syzbot+cc867e537e4bd36f69bb@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 27, 2026 at 2:18=E2=80=AFAM Jeff Johnson
<jeff.johnson@oss.qualcomm.com> wrote:
>
> On 7/25/2026 7:20 AM, Deepanshu Kartikey wrote:
> > The KASAN allocation trace shows that a malformed IE buffer is
> > stored via SIOCSIWGENIE (cfg80211_wext_siwgenie()) without any
> > validation. The crash trace shows that a subsequent SIOCSIWESSID
> > triggers a connection attempt which calls cfg80211_sme_get_conn_ies()
> > to process the stored IE buffer, causing:
> >
> >  - An out-of-bounds read in skip_ie() which reads ies[pos+1]
> >    (the length byte) past the end of the 1-byte buffer.
> >
> >  - An integer underflow in the memcpy size argument when offs
> >    returned by ieee80211_ie_split() exceeds ies_len, causing
> >    unsigned subtraction to wrap to SIZE_MAX and triggering a
> >    fortify panic.
> >
> > Fix this by validating the IE buffer in cfg80211_wext_siwgenie()
> > before storing it. First reject buffers smaller than 2 bytes since
> > a valid IE requires at least a type and length field. Then use
> > for_each_element() and for_each_element_completed() to verify all
> > elements are well-formed. Return -EINVAL if validation fails.
> >
> > Reported-by: syzbot+cc867e537e4bd36f69bb@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=3Dcc867e537e4bd36f69bb
> > Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
> >
> > ---
> > v2: Use for_each_element() and for_each_element_completed() instead
> >     of open-coded validation loop, as suggested by Johannes Berg.
> >     Also add explicit ie_len < 2 check to handle the case where
> >     for_each_element_completed() returns true for a 1-byte buffer.
> > ---
> >  net/wireless/wext-sme.c | 12 ++++++++++++
> >  1 file changed, 12 insertions(+)
> >
> > diff --git a/net/wireless/wext-sme.c b/net/wireless/wext-sme.c
> > index 573b6b15a446..51fc2617a1c3 100644
> > --- a/net/wireless/wext-sme.c
> > +++ b/net/wireless/wext-sme.c
> > @@ -319,6 +319,18 @@ int cfg80211_wext_siwgenie(struct net_device *dev,
> >               return 0;
> >
> >       if (ie_len) {
> > +             const struct element *elem;
> > +
> > +              /* IE must have at least Type + Length bytes */
> > +             if (ie_len < 2)
> > +                     return -EINVAL;
>
> doesn't for_each_element() already handle this?
>              (const u8 *)(_data) + (_datalen) - (const u8 *)_elem >=3D   =
 \
>                 (int)sizeof(*_elem) &&                                  \
>
> > +             for_each_element(elem, extra, ie_len) {
> > +                     /* nothing */
> > +             }
> > +
> > +             if (!for_each_element_completed(elem, extra, ie_len))
> > +                     return -EINVAL;
>
> perhaps this sequence should be refactored into a separate helper that is=
 used
> here, and by the existing functions that have the same pattern?
> validate_beacon_head()
> validate_ie_attr()
>

Thanks for the suggestion. I will send patch v3.

Thanks
Deepanshu
