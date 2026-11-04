Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793823183;
	b=bwl7HNRCQkTPKLRa5APBTt3mUcxrpHqWAbPQwRKFor4X+WRkS48A54r1WaLGPJbdg+GZ
	 pKYUU7k7qlv1HMObpWqnPm89alDgcWYd1tz6B8Z4QGoQiBYG1V24AZn3tVJuSe+G4sqoy
	 ga9H5YuF4dDJxn2iEX1Rt9nSGr/WCmA4u2xtBUpQ1fSdGAKEqr4x2jnsNhroGoCnDJG0E
	 cW0ok229Xz73xugqCgQMm/on6RsnGoDGBZ8qZYevnBRDloZ5qCHd/gMYv6sAoI6zfWcGi
	 S2hDFoZoasHyveWh67TIKpuFlsPCYXd3GRNndjRKMKYsIUnKE2QoKiGuYvAwy1s8woA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793823183;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:X-Forwarded-Encrypted:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=LCqiLHf1DIbfKNXx3ccWkvqxBhOdwo3yYkazQxIGarg=;
	b=f5+N9UYc+5wXhQArIyjgyEfewqbf9/ZNgSNOlJv+idPmXlGGgukKNTptln0Pg7dWlrr9
	 nTupQnjk9VvUuw2F5Y8l1xkWT1ZFkRIAfgJ7GIoK2TMVrrZhBPXphcBen+crA8nUd1y8T
	 wfnO1BZDTXO03H0gGOtM5aHA6evgWKkZQJrWerYUv5VM9+t+N0xlQbA615EcM3btAw3sC
	 0bCJChlB5QP0u2TPjpScyabU15MKX/HfxbVqUoiXHdjrW0hHQR0V+SJEz4/KkCPrlQsuh
	 rvlBfu/plWF/uVoB7Pn4/egJRDy47d1C+c+99VPbRwIphZrPSS1vONcOQn4GBDLHmNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=linux-foundation.org;
	spf=pass smtp.mailfrom=linuxfoundation.org;
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b="E95/DjOz";
	arc=none smtp.remote-ip=209.85.208.43
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B8EB608079B
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 20:13:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2B8EB608079B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=E95/DjOz
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6b579003f29so83061a12.0
        for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2026 12:13:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1793823181; x=1794427981; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LCqiLHf1DIbfKNXx3ccWkvqxBhOdwo3yYkazQxIGarg=;
        b=E95/DjOzx1wi9jv7V9s/sfuu0rRfvFJ8K5JkcF6uHzdvwVQ8j6YdXq2ilI8Pcwll3q
         GGymSn9yhWXKxZezb1o4P4MtUErWar0lWLU4XH7OrNo1HOTaHeHzU7qFjCgqTQNxs8YA
         Up/vv4lT13XOf7H7yOxFHZtLIDxEtbMS4i2QM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793823181; x=1794427981;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=LCqiLHf1DIbfKNXx3ccWkvqxBhOdwo3yYkazQxIGarg=;
        b=eSJY0LSCXPQXH0QsKLSa9DanSDaSGOVHTAS+dy+3Q+zlfeLMeW7Cmk1vRAM1NHY6mv
         4piO4rbKR00hzswut7nqobMdoM4w8Ub7GNamhTkEOvVzKsrLj1jadPCIlNqNwiszL1hS
         Bd6hjzx8ivvpovWEqLcQgtAXz0Es5b0Bgd8X3YNuKFZxrOi4E4IM3uBeuTqNc9g0luWq
         MHdqZFVzhFatTuWXmq2dmR9aIzXZG1PpcjlJUaPH1DpYAKZQMaSraU8CpKM0T1PywDWW
         rxXDDEvuNL7PyMcVoLZb9eIaoZl8ml2wJW5IEF8y4Oi6H0V/SDBjmROnNrQIvTqeaAer
         +7vQ==
X-Forwarded-Encrypted: i=1; AKwUvBwEq+1xssLHH81Fby5iJLcGhlIG9xGdTG/Vo3p18d/5KKBzK+lZ7qlscd3tCdOaoUOjC5/tEUEjxIIBiXhOhg==@vger.kernel.org
X-Gm-Message-State: APuU4Z9QEyBmNsDHsvlq/WLbXQELTyr2OxFiAVxPjtxvXM0n0u470shT
	LaAHjzSggd6oLhd776GWvjcjeqf2kddlZS8PfApaKIn13+tLJ7krxatBVmQy705KzNQGObY1PM0
	tQfqcJg2IIg==
X-Gm-Gg: AYBFou2AB9o9sB2x+tz054sa/UMWTkyGiPdwRVNMEbisasJBbyVHHMImvYqP+YYfzbJ
	inpGe/wlGrgP8+72KOOr1+DUw+YB3U6enpVWHpWDzlBzTLkbGPfnJZh9u71DdjibAMdz4oFpK8v
	QjrV2mzQabVSDroh4YHVs6VUrVwAzMpks+cwBmDSeeBNi8abxhDvbuIKB0+5+erXBDQGnCyisGv
	tgSBuwBgjdxXRg3NErXjofcXRYamW1dZkhlMgY048tFJHPzpTBra0K2bBUWIfbSiW3kvknR3FBe
	c+j6D+5KxySr0GUSN6XN1PIy0+a5JaihlYqeJ54d7slMPvG+b+0qVMV1xoMOC66yfonH1bxA4s3
	3pIBKuzu4x/iqJQvqgZcvzuSUCdM8MMVVTUKf+FtPtIwqTdTu/M6nzigjEzYHlFSefJXL1nG7HZ
	fephXHZutIFm1uTlsR6q/gTTIN/cCcoQGuQg48NCw+ZG+zSy4L9hrRI2AN1YGHMq4KkvjySZUBi
	gWCdanUl7unohhBEyQ6X8wph14ELHJby6vbEAUADqUDB+qpa3OI1EYGknQUIN1kFzp0fgXFiAst
	TNMuV8VjdY4Vem7lBwuXVjC5Vp727PYcd4Wbinu2+gxsGe9/l5o2KIvRRrYR5D+No/hUuB218W7
	HgQ==
X-Received: by 2002:a05:6402:52d9:b0:6b3:f891:c2d4 with SMTP id 4fb4d7f45d1cf-6b4d4d7fd67mr13113766a12.29.1793823181609;
        Wed, 04 Nov 2026 12:13:01 -0800 (PST)
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com. [209.85.208.54])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b574e00988sm299548a12.10.2026.11.04.12.13.01
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2026 12:13:01 -0800 (PST)
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6b566cf56c1so863166a12.2
        for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2026 12:13:01 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBzI8+2OwJPnToo8qZZJGwA1gziZ1ustR9qdmft6eG7lAYedcnoHWL2blCOJvfDNC7CKHm2dHmurimPM7BgGcw==@vger.kernel.org
X-Received: by 2002:a17:907:60c8:b0:c49:a4b1:9cb1 with SMTP id
 a640c23a62f3a-c4ca795fa50mr1973235866b.3.1793822725121; Wed, 04 Nov 2026
 12:05:25 -0800 (PST)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261104-work-procfs-v2-0-b45cd5789ac5@brauner> <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
In-Reply-To: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 4 Nov 2026 12:05:08 -0800
X-Gmail-Original-Message-ID: <CAHk-=wj9Y9NcOesBBm+jhPjYa7qO00fD7g7uwX+H-k0-R2difA@mail.gmail.com>
X-Gm-Features: AclHuK9j_YIgrwhhpWOlnull6heAULBd4dgTqoOhUQQjFm_MgoIgrL1vgPfefvI
Message-ID: <CAHk-=wj9Y9NcOesBBm+jhPjYa7qO00fD7g7uwX+H-k0-R2difA@mail.gmail.com>
Subject: Re: [PATCH RESEND v2 00/30] proc: convert the fs, kernel and mm
 entries (Part 5/7)
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
	linux-debuggers@vger.kernel.org, Chuck Lever <cel@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 4 Nov 2026 at 11:49, Christian Brauner <brauner@kernel.org> wrote:
>
> Part 5/7 of "proc: move procfs to what kernfs does", on top of part 2

Christian - way too many patches, re-sent much too often, cc'd to way
too many people.

Nobody is going to read these repeated resends, and all you are doing
is clogging up peoples mailboxes.

             Linus
