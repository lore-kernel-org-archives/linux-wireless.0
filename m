Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793642756;
	b=Rg9WYinJ7RcXHL4t+gqG6VK3QCnhaFJTyV0bRf5Omoxa933y+Tne/dGLvcItGU94iDST
	 afTONk3loYa6D6NIP5JH1hxMzMr5fRGjdxh4l/aepl66QIkZY0yPZq6ab7hP5BavnyItK
	 CpJs1fBvSJhHO/Nt4uWJ+3UyyX43SvkRmY1btxHVxDFFSxMsEzTGmJyEEyO32VwqAZcqv
	 XaxoiFYmtuW0ZxCVq5siOYc2SNd6LNAYSTsqWNrbIUFbrf0jTDirFrPrDYNu1prC9+Pne
	 Yllt95T4zhXp6ELLuuGvzvG6UweKWRIRucVVZNKN3SoEIjXJbG83ePcCh8i4QX+ehkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793642756;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:X-Forwarded-Encrypted:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=/vXXDZI2TLqXD/tqTZGHj/cF0YcMq0fXP1TpWYkM2ME=;
	b=C8T6NAegHlTwJr3TKfbmI6ep37x8k4UhLYZ4W+1z8F6K/vITmiHuHFfTFEh+VKI1QqKK
	 f4eH+Wia1x+7FDi/iWwiZMep3pBL2irr5jn5E7SAnG+v2rhzpYOTH7GIVqzMyZcEsxOL3
	 /pIbDJqk3jPQmcP3GXEmxVzHUUB2by5mO71FKRmB5UTrO9W+7W25MkYWYpefflYkpvMXh
	 CfBgpZBnxrJPpcAqUjXPZrt+duMU7Zx6JeIPWhz0l/6p2z/yoXw/zUB1sHFDnAMddL4C4
	 GrAISbj/gNStgG55RGST3gzwJuNxjTpciZEzrO/XTR6YfA8ot0psUFMudowrPlvzUqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=linux-foundation.org;
	spf=pass smtp.mailfrom=linuxfoundation.org;
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=HdfvBURZ;
	arc=none smtp.remote-ip=209.85.208.171
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A593C606A339
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 18:05:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A593C606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=HdfvBURZ
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-3ab3b29a210so35846761fa.0
        for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 10:05:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1793642754; x=1794247554; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/vXXDZI2TLqXD/tqTZGHj/cF0YcMq0fXP1TpWYkM2ME=;
        b=HdfvBURZZwMg8HbTz7TSsBerh7TC4okBBByzglIGoA41+zK12lwzj1R+m246WF2670
         MdlBjMoYpUn0Hw6rz0ZHy48UC8jJ0y52EOgxgUXfJ6yOBff46ZnYmJUJEl1YURteibMn
         6OqzAKa5voTBhfGWWnTvAC9hH5QyWPpK0aAL8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793642754; x=1794247554;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=/vXXDZI2TLqXD/tqTZGHj/cF0YcMq0fXP1TpWYkM2ME=;
        b=a7l/LNpCEtf5PPrby0cdMFEvvQFf1uaY6EQRVxTF5shHT7CtuVEgqhsnuAMQlP5yii
         7ZKfR0w9p4bUAVPnnpNAVz8kjT1tXZZj8M1nv3xQvy4TKJ8jjYBWjtQLjmfHD++g1vpt
         p7jEMoFxtGxKx829z9wXhFR1E/IvEgxrHjdyrVTzDqIjNoA8cqpOMI0rd4P8eU20SHKV
         ELJDioPlNSb1skrd/j//mchBoG8g1zUq7It+uydu9uYakFSxq7Uws5mQ9atOT/6uQWj6
         QqNisE3keNPgmgsGpRge1n+nFvpSKoHddMyK9B7Gouz2RRaawuKxZiJYv0RpOpRGpdT2
         Ai8Q==
X-Forwarded-Encrypted: i=1; AKwUvBzAf5GnUOxicKSOgWVU2fQoypaXyDOHb/1poTbhy7an86rlLdvQCriVpfZWDIvaDSO+/iPRvxnybVWLzIy9ng==@vger.kernel.org
X-Gm-Message-State: APuU4Z/HRVHABM1o4t6vc/tctx+eSvhdGPWD2RdUF8+vPU9proPXTgPR
	ttEMjsQqKlNYEbmEQJdvhWLEcPW9mnXzp405sy7f7i1E74A8pxCAWPiwJum530Stn+O/keFmAPM
	SPwHJ3bV9tw==
X-Gm-Gg: AYBFou3qIKps5sA3JBy/cWa9YhIowPYvgCK+7TsIabsqfGrlQDW1uF08Q/l0uCnD4fN
	1GaXVJccWr4w3pzogkRESGoGidqtZp5JYcjNl85HIch8vZBwaAv7ZqS5scumcxm2Lljtxesfpq0
	UDGbiZ0/qdmZjMXSrQ56Anik623VqfMRpbM+qOzRgdkOKpQperD2f07mI5JqXGdhB+JKFXC6O4P
	qcY+5joCC51UmSjPF0MvYAqhTkz9v4sgqShUd927+jxlYR+GbFkC+omjiRo75hs/l5xo6Cwbr+s
	P4qflc48jd7z8XEQxR06c8eF74bIExTlaiECjN2W3j2ZuBVl5UFQ/BcTzPb9GG3tok2mxxD23XZ
	Z8Wf9NJ4RhZzeaXE0BIn5BBEGwqx/itcbCEHyqKLwIJbjXBFhhp2UApiCABFMTnKTXu2KnQ9F2P
	M4YUQZ3H0diwHRcBa3fu0dctH1bs399mvHqWvtkPETnDSHhRjEEburCCTIReATESmzlyF/Hk+ch
	tHjX6BZ2Vl9GQ0QNDqhoHMoIP4S4guxCPMDrCRiKA8EjcyLP0suI0nfGIpMWtbWjc4RHjfChbDS
	ZCdVjYTkgvhDb3oN/qFzQDYspD1svqeB+f0oIyHl1Bla3cdMrwRpVpNxXi3pH9V1Ny2fTq+d25T
	hGQ==
X-Received: by 2002:a05:651c:1544:b0:3a9:9b67:25fb with SMTP id 38308e7fff4ca-3acb7a34d21mr22263991fa.5.1793642753750;
        Mon, 02 Nov 2026 10:05:53 -0800 (PST)
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com. [209.85.167.51])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3acd5bc94e6sm877301fa.2.2026.11.02.10.05.53
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2026 10:05:53 -0800 (PST)
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5bfbc25a76aso4764077e87.0
        for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 10:05:53 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBx2Z8gC50EtwLE5BfC1EWEf0B7BwcgNC+2YzQoQc+VKNVOQ9fUeNedXCf0TXBBbUUZ+i0VcEHwh9yBdmO0bvQ==@vger.kernel.org
X-Received: by 2002:a17:907:d94:b0:c2d:c80e:8366 with SMTP id
 a640c23a62f3a-c4ca7426f6emr874452266b.0.1793642348398; Mon, 02 Nov 2026
 09:59:08 -0800 (PST)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org> <20261102-work-procfs-bugfixes-v1-1-59422ed3e465@kernel.org>
In-Reply-To: <20261102-work-procfs-bugfixes-v1-1-59422ed3e465@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 2 Nov 2026 09:58:51 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiSA7-mqmAjTQDaU7UjUyWt0TxYwXHafL8ZAPudy+B_uQ@mail.gmail.com>
X-Gm-Features: AclHuK_qZTBVsLQIdymgRHScSFenC6XsGggUDmcuOugjrSTbuVkeASUmC_hYPZo
Message-ID: <CAHk-=wiSA7-mqmAjTQDaU7UjUyWt0TxYwXHafL8ZAPudy+B_uQ@mail.gmail.com>
Subject: Re: [PATCH RFC 01/38] PCI/proc: don't truncate the position of config
 space accesses
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>, 
	Josef Bacik <josef@toxicpanda.com>, Chris Mason <mason@kernel.org>, 
	Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, Eric Dumazet <edumazet@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, Greg Kroah-Hartman <gregkh@suse.de>, 
	Joel Granados <joel.granados@kernel.org>, Kees Cook <kees@kernel.org>, Jan Kara <jack@suse.cz>, 
	Jan Kara <jack@suse.com>, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-acpi@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-um@lists.infradead.org, linux-wireless@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org, ntfs3@lists.linux.dev, 
	platform-driver-x86@vger.kernel.org, coreteam@netfilter.org, 
	kexec@lists.infradead.org, linux-pci@vger.kernel.org, 
	linux-sound@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, ibm-acpi-devel@lists.sourceforge.net, 
	jfs-discussion@lists.sourceforge.net, linux-alpha@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-cifs@vger.kernel.org, 
	linux-fbdev@vger.kernel.org, linux-hwmon@vger.kernel.org, linux-mm@kvack.org, 
	linux-sh@vger.kernel.org, linux-usb@vger.kernel.org, 
	samba-technical@lists.samba.org, sparclinux@vger.kernel.org, 
	linux-m68k@lists.linux-m68k.org, linux-doc@vger.kernel.org, 
	linux-serial@vger.kernel.org, linux-atm-general@lists.sourceforge.net, 
	Takashi Iwai <tiwai@suse.de>, linux-input@vger.kernel.org, linux-raid@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-modules@vger.kernel.org, 
	linux-debuggers@vger.kernel.org, Chuck Lever <cel@kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 2 Nov 2026 at 06:22, Christian Brauner <brauner@kernel.org> wrote:
>
> proc_bus_pci_write() truncates the file position to an int. A pwrite()
> at an offset like 0xfffff000 turns it negative [..]

I think this would actually be better with rw_verify_area() just
checking a per-file maxbytes.

We already have that logic for lseek and friends - using that fairly
hacky combination of s_maxbytes and !unsigned_offsets().

We should combine s_maxbytes and unsigned_offsets() at file open time
into f_maxbytes and check that not just at lseek but in
rw_verify_area.

And then things like proc_bus_pci could set it's size limit in one single place.

Hmm?

                   Linus
