Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793872884;
	b=GMXCZv6GoMvVoiW3RZqRF66IP1cGBVQauhraHouGZQErnKloFIH0FFDbIfq6jS/DccI1
	 kXcDbgOeGT61wjEO510Hz1UvkfmoVRnz4KmNVoRB3BHJeYYgu5v3oePQYHvMUxIKjrLqI
	 AVfTZZv2ZGYEvAT65n23siMwsREM/F5GRmKfCWY/oCYE9y7jG63Wt3NV6yYK85bQUvkVP
	 mGZgWzFpt3KvCzUlYaa4snuOWuySTAU0kjMORw8lvGs3aZCyJLM7KqOZyF8w00U5dItMD
	 rYIKPG6tLya8g15BWBHN5t6ihjy1bCoj++bUZIZ6OabolHicnFV6YD1432nJBcYzSAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793872884;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Received:
	 X-Forwarded-Encrypted:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=n+1lmuZTLENNkpqKh8T8PUriZ63OKZ7RGcjsYNzzAGM=;
	b=Afux2vC9WhTpaKnADci54KMD+O30y84o0/G+TMFC2NLI+1tda1je+8XS710C4caPKIEu
	 M55/r8j4/kzh7UEZNOkqCXtS6TIVHTtyMMp35AEy37BHQ332wkB4HAtvr+PdQwvPaoDty
	 p9xP6XoYFSFXIqIz5dPoAB5iUVq8KFRoWfmfC/Y9ksRzF+g0rBWue3To2g5vLH4eyQnwQ
	 6Ceny91vwbA962nu/OQODixlLY8PAWIkq394p9g3Gs6h1T6IwZqqLhMtEZ8mRWirBFOWc
	 V1dryrBt93jgXPs0SCtqxVCzxWJLg4wZQnq04fs50/YUtRa/83TbXMw+l+tH1QMg9WA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=linux-m68k.org;
	spf=pass smtp.mailfrom=gmail.com;
	arc=none smtp.remote-ip=209.85.219.45
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63F9E606A31B
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 10:01:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 63F9E606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-91c1f548f87so26531546d6.2
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 02:01:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793872883; x=1794477683;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=n+1lmuZTLENNkpqKh8T8PUriZ63OKZ7RGcjsYNzzAGM=;
        b=kY4C1jncS7N2olg9L6Y0nKP/9EYM+tIRCW/IjNp7JUrBLelK8s1KzV+KAapN3f+xl7
         2OgJ9lQwIcxlvXsC4b1OgIbwaHAr6p8eT5bbbv7IXb8Vt/B7E0u1kF9WBL8MxGZr3QUG
         Cn/wKl7zM9mMXhBFOV/mOl0xbDuvbH4lHNlQ8H/yoaHX/EpIUSDk8r2Hkp6FNy8u5RGn
         Z8lqB0rSlTcmfluGEqgNYynuVOk+7JECGHD0voXACTltUn9OVHaVX3RGfjv16LWeEy2J
         uwnNt2epgS8lduRL0wTOVTeXdUgVDm0Ii3pN0YhAf2nPCT1dSM/3w2xvZza2f2swuV1c
         btWA==
X-Forwarded-Encrypted: i=1; AKwUvByyGm5Jy2IQ9vs0vecUXuOiMTODoXzCdw0QoAzxeHFN0hSq2rzjJOM3ghw3WiuGHqwjZv0YfyfozMPRJRHDkg==@vger.kernel.org
X-Gm-Message-State: APuU4Z9A5shxvt7WZo9exg5GUXhCIClc/Xdhu2EZ0cpiqTyI5aBAQMsO
	SdDUp8bTplbjfk3qMDvDnTOoukVb49baDqdem1iNQT6Q0gADN+1xNDQiIPSbemkAC1M=
X-Gm-Gg: AYBFou1LcA6poFZjD5d01L8eINs02yU0sPXyUGAuhCBHIA1Ixe+dFDiMTwCkhJ6PHdu
	++BmuQoBlFR8iCNVXpyBBdRRi4EC3iH0u53HqnGAC6QEtTxEsXc1jS0rHgE9EX9L9CWpEdC9kIv
	z40QPLkE7ErmDG/+wS3Au/QgIuuQZncsg2x/SIdVK1Uja1/FeIwovgxGpfPfZBq5NcpNTkcvdaS
	nMPbT5CS5KjsPFOu00ybYgMHv0iOlE1igPrkLZ/34I7r9wgQ2eOPYCI5A46/ohkg/9nRWhfjeQx
	ZyQN4of+X7hfXChpPKD4dAXeIsXcTurDnEI4EASUrFve3RBX98N9mWhp80iJyyAbqoQ+snN2FkV
	NeHCjjpJHCOxz2Aq9flVsfY2AQgn+ycc9g/1I/yWbZtPalw0e3666SQMZz/puXCJA6UxXTxHSdL
	V4Q2g1DdaRRdGoD56yWPUjdDveBj0O6Pgv2iO5wz9gX7oc+aeiDbZAI2gnU2LZ9UuMKA3XExx6q
	t5EXwkQIQ058FsJnBN0KcZo/wIIGCTAJPfW6k7TdLWAfeU8Dn0MKR3+1uNmhL3+GHLSLnaimOhH
	xCrMWH3j3OgYefO+JlbvK1C5VqRcKEhHp6Jbjv4fvh+9DwwmOg8hC6UQ1D8X6ZewfQ==
X-Received: by 2002:a05:6214:194a:b0:91c:79c3:7b48 with SMTP id 6a1803df08f44-91ca4a0cfcdmr333585816d6.4.1793872883402;
        Thu, 05 Nov 2026 02:01:23 -0800 (PST)
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com. [209.85.219.51])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91e962b3fc2sm17711366d6.4.2026.11.05.02.01.22
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 02:01:23 -0800 (PST)
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-91c79a9a739so23689356d6.1
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 02:01:22 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvByX5PMjdEBRHz0XbuMcUaC75RgCjPhWGbkQhDRbezbYg4xnGHEaYlAhqEUvV0M8Hv6Rj+ONRSUlgplwiTrHoA==@vger.kernel.org
X-Received: by 2002:a05:6102:6449:b0:7cb:bc5e:7dad with SMTP id
 ada2fe7eead31-7d072baa450mr7614890137.10.1793872492413; Thu, 05 Nov 2026
 01:54:52 -0800 (PST)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261104-work-procfs-arch-v2-0-2aeb952c9597@kernel.org> <20261104-work-procfs-arch-v2-4-2aeb952c9597@kernel.org>
In-Reply-To: <20261104-work-procfs-arch-v2-4-2aeb952c9597@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 5 Nov 2026 10:54:40 +0100
X-Gmail-Original-Message-ID: <CAMuHMdUNBs_NyhFpXonirMXkYptUWsAizMvVpGHUDLzto1LGJg@mail.gmail.com>
X-Gm-Features: AclHuK_RsrcE7hVRjmpZezBV5tMd490Mza2XAQiqUTgUNqAiHAzRP5z7NIbtMh8
Message-ID: <CAMuHMdUNBs_NyhFpXonirMXkYptUWsAizMvVpGHUDLzto1LGJg@mail.gmail.com>
Subject: Re: [PATCH RESEND v2 04/23] m68k/bootinfo: let procfs copy out reads
 of /proc/bootinfo
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

On Wed, 4 Nov 2026 at 20:36, Christian Brauner <brauner@kernel.org> wrote:
> Implement ->proc_read_buf() so procfs copies what is read to userspace
> after it unpinned the entry.
>
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
