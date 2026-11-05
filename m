Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.217.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793872532;
	b=MVNf+zX6u+3bfg1ulusNHAGCi5JavPnrAEq6OepY6FEahNAAgzsGwpgY2PL9LcOaXq8b
	 xOmf5zTVQJbt2kz5vZeUuGlXqZdqRCVpBJGdI6HEW9A1sqygqbp/j1jf49VaaDXKMQBbr
	 lfxM6v9VK0hF8Nnha8yJn7yPwCW93pf092VXtdVsdLo2dym5/4l/AuamWeTQnC1aHaIkf
	 NaEb2EjKAeUjwPjPDIKUMNda2/FXQS2yXkegC3Ur3xcRcANFxfp38YmgKuToQfqTg27st
	 M6QrEGISoBnNN74fvu2gYG5z7kGcKEcq28WoJg9JJuPcYj0eqBJwzfZWYxlRW+gLhFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793872532;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Received:
	 X-Forwarded-Encrypted:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=LrgDMUrSYXpYgkAhfsYKg0ebb/uLgOfOMhqzX4yL0j4=;
	b=0RpMocacBKLKmFNaDs2HScyIJ4ewur8eCG3XGMfYDZroZjEYXcYJDlYxTYx3IME2tz7d
	 UtLCdZgkaSJ4s07QGKGNGqRgpwBqVmRlRz8Kup+pWnGIgAhNcD7fFjXMaZWeNjwXTki9N
	 svTfOEyVXlOQkf5TWZKFM4XeS7MxcHuCJFjIIyA6VclV8k/ah+JCl6A8D7dr3ty9B3CgV
	 gzyrkZcYS4F+gtdsXwQ6JAYQXEoIGo0lKUPBMDZIMQFh2biBx0Y4PNh/WMj/vFGTeFgkS
	 v5wNeq1I6L3JISBprl+C9XDYWiJcb5DrJuRJELkLw94lAXZ+qi+zomaMVFLSqEHeyaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=linux-m68k.org;
	spf=pass smtp.mailfrom=gmail.com;
	arc=none smtp.remote-ip=209.85.217.49
Received: from mail-vs1-f49.google.com (mail-vs1-f49.google.com [209.85.217.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF7B606A332
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 09:55:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CDF7B606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vs1-f49.google.com with SMTP id ada2fe7eead31-7c3b75caad1so1060504137.0
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 01:55:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793872531; x=1794477331;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=LrgDMUrSYXpYgkAhfsYKg0ebb/uLgOfOMhqzX4yL0j4=;
        b=mwrIXTS8gVcJ6w8pZWh9vcHvp1MEGqtAOVjYK26jgScnEX3G1UQlUehLugQqCAkylN
         7SJVJpDLQuatwYXCajiw+FbgMZE+w90nwcwGErPnYwVJq29gdQLfXbWBhIZMGy+GrXhf
         6sl2AQFcrNqykqjLgffynrTFBwLIvwE0JRAraLxr6f/sHFjkcIx/CMb8IrF56Grzp4Ai
         Ve+Vuvy56A3XhRtgtOsOwxkYvnicRQdShsPVN7tc5wO7O+qKuuax7+yO+hkPAMoNwqBi
         kKmfpQANIO+Tn3LRyov3ET+UZKxusOfysK965Yy1E70H2tHBTwslsnUKVzPr+30uHTIR
         pnFQ==
X-Forwarded-Encrypted: i=1; AKwUvBxe8n4EAz9DfJdriRGYkV/Q98TnXxgCBTZmAXsIZOmjJYGuEOEzVoZVIqXYSL5I17f3TZBy0WgSHtzfq9fCJQ==@vger.kernel.org
X-Gm-Message-State: APuU4Z9DChgvWEAMt/tmCOt2yXZCEMREQ3vlauGCvgblSTUQ0veVDhG5
	yohOFvuMKjsc4se5AYsojuCAPGUkgLd0/ETLmJeMDhPxqWqRjbI1a0U9+ZvasIP6NZw=
X-Gm-Gg: AYBFou1PA2mKP5CNoVCOh6k/QwSKch9DjsMJSppMWSncoVBGH0mtCszbmfXscLjtNjM
	qLArp4OySnvzH/hmr83vkOGw7dF5W4yZYRgq28WFOn44nn4sR3m7FO9mdhq6bVF+XXToXCC5IRA
	IH55VqrQaMQMhX7EYPiMkKCaJB0w3OupHzTYskvEVNRLRK19NqBm9304JUpsaF8J47eaKtf1Od0
	78jmjG9+ahQ4JYYaHeFu+aRBZH1fk4uBq+ouK82+5yIF1yDK7NBlxfdm8e+VfThyOf7ZHsL8zvo
	AxDgxpQGu17XLudwh9FpSoHVF7TG8IInBN3dqakmkGHOVTdBNnrjS+Cn64YallRfHEZcFALlvQD
	bA7Z9wfrmq7Om4KvQTyGfqQzJsA2O0fo2QAq9o18oXeJEoAnCX0igM6yNoC9BrSBjTeMDoE+ZYv
	Pj3dxPLqt7jTfngI/MAqbH+kkHtE9DAfgbKcv5t3IWMyQIBcas/4JFLW7cbaiSR7Fum4bSJRPQE
	nh28FqL+mPC1IUWSyX4XcXpUhEKH0CBkLuWfHAPUMp+wbmDzUvL8h+6OcdASSAFuf+fClvnCLSB
	w/yZKKXtgZuC+qyyzLJ/PxP/VjNP5syG3QN3cLO2IRAxqx6JlBc3toRMHWtEZKoHFw==
X-Received: by 2002:a05:6102:644b:b0:7c3:a1c6:7a13 with SMTP id ada2fe7eead31-7d072c3bcd3mr9368129137.16.1793872530831;
        Thu, 05 Nov 2026 01:55:30 -0800 (PST)
Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com. [209.85.217.43])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-998d9c906fcsm4171946241.11.2026.11.05.01.55.26
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 01:55:29 -0800 (PST)
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-7c3b75caad1so1060471137.0
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 01:55:26 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBx87urWJOGeNgdU5DPrhmQvHFwh5oKCEgyx3DDN2RDuw40M6Z9UUawev2s81WQrJL/wNbTkR8ICa18z/QugAw==@vger.kernel.org
X-Received: by 2002:a05:6102:5108:b0:7cc:56a:58e5 with SMTP id
 ada2fe7eead31-7d072d84a58mr8269567137.37.1793872526219; Thu, 05 Nov 2026
 01:55:26 -0800 (PST)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org> <20261104-work-procfs-drivers-v2-2-245e54e87116@kernel.org>
In-Reply-To: <20261104-work-procfs-drivers-v2-2-245e54e87116@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 5 Nov 2026 10:55:15 +0100
X-Gmail-Original-Message-ID: <CAMuHMdVHxQvKnJyKHrOZhaOg9Rn2hMeRU1JnMFFEEi31FPZaGg@mail.gmail.com>
X-Gm-Features: AclHuK_UsJ1nGicdWEWcMLQAICTi1A7pGF3yhNkxXkXRPqohle17eXAHHNBsR6k
Message-ID: <CAMuHMdVHxQvKnJyKHrOZhaOg9Rn2hMeRU1JnMFFEEi31FPZaGg@mail.gmail.com>
Subject: Re: [PATCH RESEND v2 02/26] zorro: let procfs copy out reads
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

On Wed, 4 Nov 2026 at 20:43, Christian Brauner <brauner@kernel.org> wrote:
> Implement ->proc_read_buf() so procfs copies what is read from
> /proc/bus/zorro/<slot> to userspace after it unpinned the entry.
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
