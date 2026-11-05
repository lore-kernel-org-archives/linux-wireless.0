Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793872233;
	b=FQWDhrF2FRYFqgAeblAdSxNDFWa5BSp9YNbbKmWI7mRl7zh66wMJbaxq+us6kCaOnLB+
	 nzJXuSKt0UmWXUeXe6sXHkCny9EtNHm9HlRSknJKehf/+TWspgkAp1Mx1zgxyCLM0NyZH
	 6TTASfPcA+ouRG+Z3LuOXv15VIeci4XEsXpic/gpFP3Zu4rBHhLHGRDtqmSYd4Yxkup7y
	 l5w5uYEhhk3r1J3qBy8fRG/bMEu/4xLg3dBIJYUmMiVfFpDPs2zRZ/oafjSF21CZkIUMO
	 ksz08SJhkcjb92uPkOhIQorJXj+Bm2tFSmPaU2YmP2SIyJxy0o2Dcu+C7E/5mdukgpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793872233;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Received:
	 X-Forwarded-Encrypted:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=SqrTjgENN7Dfs+HehxbKPgACeb32UvvfMAFijNHd6N4=;
	b=W0IqxFEUy+K4a4awml2+QpOskNmNUis1YV7Tqpx7PWbjgvVld5Nsq7QmyNV4fj/eMWKI
	 zXKhuUF+W7inJmLjUVSo25UpGVt1bsm4bcMdnNkEiu30xBrer47UGzo2UJf7smqW25bL4
	 5FGLksyN3VJA/wa3SCteWYY+5JiUfboM0/olkhjDBHYSmDjJnbtMHk9l6Ae35rTfjUbNl
	 iRR85LgrrMZibwEjL+yxHPU92rpG2c1+t0Pls6+KEUdDUSD/Zi+TdwCBfn1Hi1JSUrlSe
	 mrhMxPaMNvp/LZrJ8c6koA+QNFTvHqqok++Wkm2elYycx5da9DVR1CzDBnfuF3aQAfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=linux-m68k.org;
	spf=pass smtp.mailfrom=gmail.com;
	arc=none smtp.remote-ip=209.85.160.170
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD3C606D80F
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 09:50:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6CD3C606D80F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-5365f9a04c5so23449911cf.1
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 01:50:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793872232; x=1794477032;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=SqrTjgENN7Dfs+HehxbKPgACeb32UvvfMAFijNHd6N4=;
        b=lpCkdUI61Tb8E23Ck6eRvsO7U/S7TnR4YxIHLufPsW3e7kiKzCDF5nlvY7MAD9IW3L
         0MMbCXFbzw549/raFYVJ7Sd4LSctQ2hpeSYs2YgzH6Rhz2gfnONoB5/QF57REd5hfO5s
         cpZN1dSLL89VRupQVqAnTv3vaXb/BPrT00kJcdOl3kpkb4+MQ0E40n37TYwXsUHBPEg8
         PxeYotX0fxBMTYkWhh01bnEjU1ZEkTHyhimL3H+tsJVjDCvwpoNm6H4+AS6AwMVHb+6g
         MhqcB6ZMIOtn5jMcTEXVxFGdxp4U9xMM3TXSYG/JbF63elMcx2yU3VvvWhkg59o2Oj2K
         NNPg==
X-Forwarded-Encrypted: i=1; AKwUvBwLPew+72nQSwB1354KhnKKbnddusAwC4vADwp5wlwPg60Eh4NLpxaKjMo9k4ECruGrC8KggvBgU8TD+pxZjQ==@vger.kernel.org
X-Gm-Message-State: APuU4Z+Q0KC5nyRpD1X8uJ8PKEzbQSvMIUxQRH52v3D5IbGPlLgDrSZm
	EGlWjXWQVY9ffykaGHeiiiwbkgI4rM9xd6x6l0Q+iLpgK1+5tAX+DaLatWkT0/wyosA=
X-Gm-Gg: AYBFou3LqvJVRpdiyYgPXc8tHcZ66tXPF5PmYtU73klUxgV8YRQnjn92MyQm7wBoB9E
	habswLx2eXgMQXVqxmNedpR6toCqd61rhUjpCfkQP42rgEg9cpl/hFAY85+XzcXA4A8fV5OwkPd
	Wz2wcFSDErxSikXOJPOu0+sDA3oZPAoRD+ACSTSYMigFJD5EXXJn2693cBNh097PbHXi7D276Et
	ulWGsOcNQdKcEMt/s0Eo3pnuWTdmQlyK018MuuHku0koAqeD97nN9/8w+BiyAxGvhp/DFKekZl/
	d4KGzTqX4mEi31Lq69CSlRTrpuOT4afGSvjxKLaZQFcsSwY5nUTbvelbDsIwS0AHKV8DHq+RROr
	Q45WE1tGhNlBnIn+DE5uKRpPjYnhAOz6T6gSxN45fiR1q36ng2Zdkuu7llAWIeElTuwIIxQSmi8
	cLwTPXDAblbwss6SU+j+mFh3MQay3qyx3xQitgb22WRNvReEIYOhOCU0AXFm4E6+gBKzDD5YObj
	bPhlsVMZsguqlBd8Kc/aJBP2Tl9MnWpiLdp0ZfKlyvgwvAvOaq1WAaLQD+r/zxGDntK/49GYdlo
	ixDzT1ynTHp8oWlj0ESPJl/ORpcBY4Tu67sgQTqwf7ubkt5lBlIzTd79gyPctyeCY2ErLw==
X-Received: by 2002:a05:622a:5793:b0:535:b21:c997 with SMTP id d75a77b69052e-542b3a79103mr305161331cf.8.1793872232242;
        Thu, 05 Nov 2026 01:50:32 -0800 (PST)
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com. [209.85.160.182])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91e7e7007b8sm43234476d6.31.2026.11.05.01.50.31
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 01:50:31 -0800 (PST)
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-5365f9a04c5so23449681cf.1
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 01:50:31 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBwYxAv/qMINTeNw+/xykOs1UJB08KAZ30041WnCqo+5GUwpezhcDWRVpuv/TNHtId5rlFIukXiJLqSfAnBi1Q==@vger.kernel.org
X-Received: by 2002:a05:6102:3ec5:b0:7cc:2bb7:131d with SMTP id
 ada2fe7eead31-7d072baa484mr7324212137.9.1793871885062; Thu, 05 Nov 2026
 01:44:45 -0800 (PST)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org> <20261104-work-procfs-bugfixes-v2-10-021c84d852e0@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-10-021c84d852e0@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 5 Nov 2026 10:44:33 +0100
X-Gmail-Original-Message-ID: <CAMuHMdUy1RYKG0g8OWss3AD-jyYx3DXL0K7ABYkFUdxTxZ9VdQ@mail.gmail.com>
X-Gm-Features: AclHuK9D-nB8icBns0zdoQH8fV1cfUPJ6LOey8o_VlUZpDIGqKC4cFf8-j5-HdE
Message-ID: <CAMuHMdUy1RYKG0g8OWss3AD-jyYx3DXL0K7ABYkFUdxTxZ9VdQ@mail.gmail.com>
Subject: Re: [PATCH RESEND v2 10/51] zorro: size the proc files like what they serve
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>, Jann Horn <jannh@google.com>, 
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
	linux-debuggers@vger.kernel.org, Chuck Lever <cel@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 4 Nov 2026 at 20:18, Christian Brauner <brauner@kernel.org> wrote:
> The files under /proc/bus/zorro hand out a struct ConfigDev and seek
> within that, but their size says sizeof(struct zorro_dev). Say
> sizeof(struct ConfigDev).
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
