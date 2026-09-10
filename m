Received: from mail-yx2-f12.google.com (mail-yx2-f12.google.com [74.125.224.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3397A38F92F
	for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 18:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789063369; cv=none; b=VrzTFH9wnMaX4wkOYIJddDucy2SoBBLRGjSqtoaZgSSgYYTO3DECuOgTpHAZsdEslgw2a2LXWui9vhMTKJfCqn2PwcNonl6ITupVchuZTQ3NzTEtqYfVfiES9X8jigit9F9bWv5VwT+LybAOX3rtjfben/7NEz4b0JTUnhIMLnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789063369; c=relaxed/simple;
	bh=YRVCPEPJhoPVtG/a6VW9bjW+joosxu77eM0uMrYhOfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eM+D7OMcBv0HGoyC3LS8dMlglgvmYCws/EidpfCZnaOEqxOMJirocTw0c6kxEu+CMBEvQ6nEJoXYd+mHRT84DPfJXsOVlCWzwFAszkoc/270RB4c5ev058BZomk0qoz/ozebx9R2EllrE6U3ObIDpEjzGFNEewwXJVt+NrDuR4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Dq/IjrIF; arc=none smtp.client-ip=74.125.224.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Dq/IjrIF"
Received: by mail-yx2-f12.google.com with SMTP id 956f58d0204a3-66e4ab201ecso2075732d50.2
        for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 11:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789063366; x=1789668166; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=C8jpXIBy6hQ7UF2ZswjltseX9/6JQO/82aEw+2sAaTs=;
        b=Dq/IjrIFixI/fmdxOEeH/Q+TetpJZdNFed7D32cCHmKAd+Y+x6Uwl5uQfcifwHI4lf
         XX9I9/dyUkRfRYH6ZU2bmJV7hDBSaqqsfu7xIn5l9C6V31up5OFkk5PEDzUN/7OSBnUS
         MRojy/Xxm+ZJQricxxOV+Of0KghFfJwvZvbrOaARyWttRu35W7rYN1XwTZi2/Un27KNx
         ybYYZ+8VS2XZwV3m553IsZ2YIgwsJ26CIF8uKt1u018+6e+GI4ndEElgwozRmMCfwBiw
         3mBkoesL7hOcWoynQu8wLRVgMaOEsCAyKQWwFlbiamyfkVVyOX+HM+JKL9hLe7wdEoP5
         TVRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789063366; x=1789668166;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=C8jpXIBy6hQ7UF2ZswjltseX9/6JQO/82aEw+2sAaTs=;
        b=TUVPg3sKv05hNtan8cH9TqOM25SSYp7Uq6FiHz01s1P3lThLDzBO6rnECUuywGDvSZ
         x4UfYK0rZR6CM12+41RWfb9fJEzJwasJvFY3o+g72TA2uLzsbLFKPRYp4TVsWlAjGLgN
         3xQPJvTGxWIKLu+0bAk7UUCcvYM3bSzuupuRGm5ih3yz5NpwehTqAQSlII/BdFIzseSi
         50wfdjwQ3YD86yYhq0lMFwTm+puzp/xeFkNmejnC5r+AF/eGkZDb06IV3X0mh8pmoxvt
         Vwn0tqSbEnWcM32m6gRk9tcjzM8m+Ii91NJU4nF/5q3RYiZLNyw04lUQoEuS90FD1Yhu
         UOhw==
X-Gm-Message-State: AFuF++kIkxDUfZbsSooNEjazPKNMpsjHQRFhbvtHuNl0yZc66ziwdatb
	1+qWuf0WKd6OEGmK2CWov51nj6GDYIl2VD3VOObndliX/2tvw1NAX3Ck
X-Gm-Gg: AYBFou2+7k3BqDv48WdLw6uKSRCDWeka0QWeydxZJUBMiGN8SULfBntmxiHhD9kB2MG
	Q/tQx0kqspJI21GvNTsYXYLWMms2hsSEICt7ButsjpwR7QtaXvs0gLMbH8RPLdkXsA0d3Fa2Uue
	tr8K1ccJELfj/jbYEernnVu3V5FzMydws3VISAxcRhI4kAksaZsfB9jU8TNJEpYYn0iH20S7oP1
	HxE7b+lr5E/Q2O78kcqzpiMM0RWBntA8Xq5qXeiiSWGM6fTrIda8nQF45bEo6/NnnbtNoMdSEdl
	8YtZdr2K1d/r0EWWPN1LgdMmWBZ3xmwkitm+00RrNp/a51hvNbILbrduaCur8zjXBDkLe4vxwF2
	CFQt2uWnQqHHG4bcyxUWOoy2BFoNsfSjcd0qgIK4FgOXEysyREIBso+r6EABS2/5j+yFpBmmfPL
	n3WwnZMiuwz2D2EN9KsL/DZdncROSTRn5DmW/6c4F9Ba/Cn0vuBB1KwveulVAeq4yUJk7vY1r2K
	JInYc94ShMJk7qwAyi/VVPZHqGcevkUTxtH6D8bl6ZtmBaPIXeX55KKhHRfcApD8cT56Ua+nLhw
	xon7qTj5DDwyOKS0k9x3
X-Received: by 2002:a05:690e:809:20b0:66f:dcfd:5530 with SMTP id 956f58d0204a3-67124a72274mr147887d50.86.1789063365642;
        Thu, 10 Sep 2026 11:02:45 -0700 (PDT)
Received: from toolbx (c-73-124-82-74.hsd1.fl.comcast.net. [73.124.82.74])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-66fb497cf0dsm14338728d50.21.2026.09.10.11.02.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 11:02:44 -0700 (PDT)
From: Vladislav Rysin <vrysin@gmail.com>
To: lucid_duck@justthetip.ca
Cc: linux-wireless@vger.kernel.org,
	nbd@nbd.name
Subject: Re: [BUG] mt7925e/MT7927: RX page_pool buffers stamped every 16 bytes, corrupting skb_shared_info->frag_list
Date: Thu, 10 Sep 2026 14:00:55 -0400
Message-ID: <20260910180055.100698-1-vrysin@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260910134748.75684-1-vrysin@gmail.com>
References: <20260910134748.75684-1-vrysin@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Devin,

The rxdmad_c loop is the most useful thing anyone has put in this thread.
I could not have found it -- the DKMS source went with the package and I
have no tree on this box any more.

    dma.c:184-185   for (i = 0; i < q->ndesc; i++)
                            dmad[i].data3 = cpu_to_le32(data3);

A bounded loop writing only +12 across ndesc 16-byte records is precisely
the footprint, and it changes what I think I am looking at. Two things
follow.

First, it explains something I could not: the partial pages. 219/256 and
204/256 do not fit continuous hardware DMA, which has no reason to stop
mid-page. They fit a loop with a bounded count landing on memory that is
not the ring it was written for.

Second, the timing. The fourth panic was taken inside a reset:

    mt7925e: Message 00020016 (seq 4) timeout
    Workqueue: mt76 mt7925_mac_reset_work [mt7925_common]
    mt7925e_mac_reset -> __local_bh_enable_ip -> do_softirq
      -> net_rx_action -> skb_defer_free_flush -> kfree_skb_list_reason

and the three earlier chip re-inits in my logs each followed an MCU
timeout too. So the question I would ask the source, if I still had it,
is whether any queue-init or fill loop on the reset path can run with
q->desc or q->ndesc describing something other than the coherent ring it
was set up for -- a queue re-initialised while its descriptor pointer
still refers to, or has been reassigned to, page_pool memory. The
corruption itself is already there before the flush; the reset is only
what walks into it.

The constant does not match, granted: 0x0080a624 against 0xf0000000, and
the flag gated to mt7996. So either a different writer with the same
shape, or the same shape with data3 coming from somewhere else. Worth
checking whether anything else in the tree writes a +12 word across a
descriptor array, including on paths shared with 7925.

On your card -- that is the part of this I cannot do any more. Mine is out
of the machine. If you can reproduce it, the dump I never managed to get
is one taken with

    core_collector makedumpfile -l --message-level 7 -d 1

Mine were -d 31, which excluded the sk_buff slab page, so I could only
ever inspect the data page. With -d 1 the skb itself survives, and so do
the module pages, which would let you walk the queue state -- q->desc,
q->ndesc, the page_pool -- at the moment of the fault rather than
inferring it from a data page as I had to.

What reproduced it here, for what it is worth:

    traffic-dependent, not timed: 22h34m, 27h55m, 4h53m, 8h50m of uptime
    plain VHT80, 5745 MHz, 866 Mbit/s, NSS 2 -- never EHT or 320 MHz
    multi-AP mesh, frequent roams and Reason 2 deauths
    Wi-Fi power save made no difference, on or off
    reproduced on 7.1.10 and 7.1.12 with mediatek-mt7927-dkms 2.14, and on
      7.2.3 in-tree with the kernel Not tainted

Everything is here:

    https://drive.google.com/drive/folders/1-NWRQVhtiIBTeNFLe4QukUyrVCM23YDt?usp=sharing

    127.0.0.1-2026-09-03-20:42:25/   1.5 GB   7.1.12, DKMS 2.14
    127.0.0.1-2026-09-04-11:09:39/   1.4 GB   7.2.3, in-tree, Not tainted
    127.0.0.1-2026-09-05-02:16:37/   1.3 GB   7.2.3, in-tree, the reset one
    analyze.py                                drgn script

Each directory has vmcore, vmcore-dmesg.txt and kexec-dmesg.log. The
script prints the stack, the frag_list bytes, the stamped-record count and
the page map from any of the three; it wants kernel-debuginfo matching the
dump's kernel, and the install line for the 7.2.3 vanilla build is in its
docstring. crash 9.0.1 cannot open these at all -- it dies with "invalid
structure member offset: kmem_cache_s_num" on the 7.2 slab layout, which
is why the script is drgn.

All three are -d 31, so the sk_buff page is missing from every one of them.

Thanks,
Vladislav Rysin
