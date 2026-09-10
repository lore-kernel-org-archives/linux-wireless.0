Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA88492E50
	for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 13:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789048121; cv=none; b=I8EgCTsjJFQjNoJEzbnwJ3ocaJ+sdW4MxzGfeT+8zwj9QVZEeTz/k0Msot9aVAXbldPrTYVIiXvv+ki2oH4MFvX1vpmmlUj59bBO7xGeCkL/6R43d0KYnMLh0gAwoGEITmuQMHdvAp0Q4a3We10cOT6ahyfp46t+9uq0ibxLhH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789048121; c=relaxed/simple;
	bh=jjWdfeNu7WiGQ/QlsTRNUzwLO7Ce/pXTcsFymcRidyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NXQGQWaGnFfhlOyYLZFpAUAaAcgqpP3sDlpAaIa4UBYuNwzV7PscsH/QOseBbpIcOWkYBpaUFCOcJ8WK4DJxQZLQ4CZoeFEB3auvv3A+fiPBSXIY+mwdY2JerfgFH0u9NQNxzLhuG7+x4eIouH7pdYSSDkpuvadGN0UMmz+bIGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JtYl6dEn; arc=none smtp.client-ip=209.85.128.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JtYl6dEn"
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-861f30636f9so110815107b3.0
        for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 06:48:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789048116; x=1789652916; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1qEJg8nWQh8PutEbi5q7FOZX+DqRZSn/jn1bnmlhI4E=;
        b=JtYl6dEn/vG2FEyjA+c0wF6llb5dzwKSGlnfeawbOvm0SVpNkJyJKO1tYr4fgf+Zt2
         +3xM3j0CrtjJArH5xnjHTdhM4+ymUbuw44itIAEABNnH0diNlHW+RPPenb42jXd72vpQ
         68GEANbSFN6806YKnyrgMPE6WmOhFFStXmF11beZI/LLgD7hHotPJLRWfw2PB/uxJQBS
         0kdLrIbmohsDAPy5SuoYxIoMbAG5Nctrw/ZznIP4yBdcMtM39q1Ti4WUQCjy9OyE1Lys
         r8q86ZcsH4YKylUMZkJatoNbv+tFO71/lThqJ26dmEo2jKyZKgWOMGAqceLKe5QNx8DH
         1kqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789048116; x=1789652916;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1qEJg8nWQh8PutEbi5q7FOZX+DqRZSn/jn1bnmlhI4E=;
        b=gzN7B00WwlejZECGw5ZP6k6BGYVEIvudKvxMNCO0s3CiakrnFUZe74yGQNc2noUoQ2
         1KpXkZ6YBC+ujg/Q49LV9lPwJzPoURolk+YXnnHsuWRwr7zECuZzw/dfCcJr2JvCcjrv
         6fYtGqT/+Ti1mk7gHcO1HcOFmHAZXlmIupKO1O9KR/JUHgajWg/hIFyPbLN6Hya1arq3
         ahjCTvhQawRWii8rIgbJSGNZx3YGLWBHi4DOIIcg+QXPCpwfBeGkzv92mfzfHubRPRl6
         bp9JvsVCUjJ+cqGD7mYUENm/0jAS/fs6nPk+vjGRN8nFemIG353L0GJEFcNTTClrTu1+
         QS2w==
X-Gm-Message-State: AFuF++kfxt/efi1PwaeHNffUvW1MQSZDLpFNMKzaosiSXajmTPc4lMMP
	7FVmuv0y8LO0thPri43fbYB9nKRphKU/6Flm/ovli2iXM96w8x+Zl4NVGTezeDAC
X-Gm-Gg: AYBFou1q52ohMNJ4xT8xno/7Xty/2lb+FqzHFiMSuYrnd9/e3lUblsy0tnX+jwfRSP8
	c6Sj2W8GsjwBNaZObm2vWX9Cs6bDvDss1uA6X1rvJJPyhHZMXEX7cpvwfX81TO6GcwlRxi4XLPZ
	Cg/p151hSa9SeBMIOk611ce0/CGs6TLkkHa3AWdSt1r24TvxkEM/hF2KXH28RCTMDvTa822D6hj
	uZPWut4px4vUjd5xGKE9aYl7mw4rQBL/kZTmSoCNdkPqOXS5q89nycsdO7kxDOTtEWzlZl1H8OZ
	PPJeE3z+hQz50thxraq0Xv9fKiS9a37zsw1x+ZveIoRFM5E2xqKhS6nc8vqTIGc0Wc+oyAgOAoO
	42HgD9xNmG/uM+WnrKn9t61lR8IkdRIsao9cazGStRGrmCFlfovKUNQw8lujRrzh66ESKo2kx0f
	JIjRc2R5ZB2JMy6ntnXnswzoPLcPyPO4bcQfDklnO7ScEG9TMi7iPlKTpLPGGJWw8z96B78fAqV
	GRP5ndENgFbJ/UuUyVhb28GMndoGyv16ywhSHKivhM08Dn7PlAIgunDcPypag5u+GMx5MJnO0gR
	R49Ah4B4
X-Received: by 2002:a05:690c:f02:b0:80c:5ce9:8f29 with SMTP id 00721157ae682-871279410b5mr155753637b3.22.1789048116127;
        Thu, 10 Sep 2026 06:48:36 -0700 (PDT)
Received: from toolbx (c-73-124-82-74.hsd1.fl.comcast.net. [73.124.82.74])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8714befac64sm123225737b3.47.2026.09.10.06.48.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 06:48:34 -0700 (PDT)
From: Vladislav Rysin <vrysin@gmail.com>
To: lucid_duck@justthetip.ca
Cc: linux-wireless@vger.kernel.org,
	nbd@nbd.name
Subject: Re: [BUG] mt7925e/MT7927: RX page_pool buffers stamped every 16 bytes, corrupting skb_shared_info->frag_list
Date: Thu, 10 Sep 2026 09:47:48 -0400
Message-ID: <20260910134748.75684-1-vrysin@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260906162742.15333-1-vrysin@gmail.com>
References: <20260906162742.15333-1-vrysin@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Devin,

One correction first: you have not got the vmcores. I offered them in the
first mail but attached nothing, so anything below is from my analysis, not
from dumps you have looked at. Say the word and I will get them to you.

Your buffer arithmetic agrees with what I measured, and buf_size 2048 turns
out to be load-bearing in a way that helps. Separating what I read out of
the dumps from what is derived:

  measured    shinfo at page offset 0xec0 in both dumps
              corrupt bytes at shinfo+8 (frag_list), upper half only
  derived     sizeof(skb_shared_info) = 48 + 17*16 = 320, already
              64-byte aligned so SKB_DATA_ALIGN is a no-op, 2048-320
              = 1728

Where I think the reading goes wrong is the ring.

page_pool hands out 2048-byte fragments, so a 4 KB page holds *two* RX
buffers. Their shinfo lands at page+1728 (0x6c0) and page+3776 (0xec0),
and the frag_list upper half at 0x6cc and 0xecc. Both are 12 mod 16. A
16-byte-stride write at offset 12 therefore lands on the frag_list high
half of *every* buffer in the page, not just occasionally. That is why
four panics produced byte-identical registers rather than intermittent
garbage, and it only makes sense if these pages are page_pool buffers.
It also confirms your 2048 from my side.

The ring cannot be what I measured, for four reasons.

1. Different allocators, and only one of them is contiguous. In the
   in-tree mt76.ko on 7.2.3 the undefined symbols are:

     U dmam_alloc_attrs           <- descriptors, coherent, contiguous
     U page_pool_create
     U page_pool_alloc_frag       <- RX data, scattered fragments
     U page_pool_put_unrefed_netmem

   That is the only coherent allocation path in the module; there is no
   vmalloc allocation (is_vmalloc_addr is only a test). So a ring of any
   size is consecutive pages in the kernel mapping. Mine are not
   consecutive -- stamped 16-byte records per 4 KB page, across the
   17-page window I sampled around the offending buffer:

     8053f 256    80540 256    80541   0    80542 219    80543 204
     80544   0    80545   0    80546   0    80547 256*   80548   0
     80549   0    8054a 256    8054b 256    8054c 256    8054d 256
     8054e   0    8054f   0
                                          (* the page holding the shinfo)

   Seven fully stamped, two partial, interleaved with clean pages. The
   window was my sample, not the extent, so there may be more. I have not
   verified your 1536 entries / 24 KB / six pages, but I do not need to:
   contiguity rules the ring out at any size.

2. Two pages are only partially stamped, 219/256 and 204/256. Every slot
   in a filled ring holds a descriptor.

3. The page holding the shinfo carries live payload in the bytes the
   stamp does not cover -- local MAC, AP MAC and local IPv4 all legible:

     +0e80  00 00 66 ac f7 29 1b 46 f8 1a 2b 1a  24 a6 80 00
     +0ea0  c0 a8 56 22 01 bb e3 fc 94 66 fb f5  24 a6 80 00

   A descriptor ring does not carry payload.

4. If these were ring pages there would be no bug to report. The driver
   writing its own ring is normal, and skb_shared_info would never be in
   range of it.

I also went looking for a benign writer and could not find one. There is
no WED/RRO offload in play: zero wed/rro/airoha/ppe undefined symbols in
mt76, mt7925e, mt7925-common, mt792x-lib and mt76-connac-lib on this
kernel. And the hardware does write an RX descriptor into the buffer --
but at the buffer start, once, where the driver parses it. Neither
produces a repeating 16-byte stride across a whole page and over shinfo.

Which is why I read your last paragraph the opposite way. If this driver
never reads that word, and it is only meaningful to 7915/7996, then the
"driver scribbling its own ring" explanation is gone and the question
narrows instead of closing: something writes DW3-shaped words into
page_pool data buffers, at a 16-byte stride, with the same constant across
four panics, three kernel versions (7.1.10, 7.1.12, 7.2.3) and two driver
builds (the mediatek-mt7927-dkms 2.14 backport and in-tree, the latter
with the kernel Not tainted). Whatever performs that write is the defect.
I agree the constant's *meaning* is a dead end -- I am treating it purely
as a fingerprint for identifying the writer.

Your claim that mt76_desc is the only 16-byte structure in the driver with
a word at offset 12 I cannot check; the DKMS source tree went with the
package. I am content for the shape to be wrong. The stride, the offset,
the constant, the page map and the payload-in-page are measurements and do
not depend on it.

Two limits on what I can still do. The dumps were captured with
makedumpfile -d 31, which excluded the sk_buff slab page, so the skb
cannot be inspected in them -- only the data page survived. And the card
is out of the machine, replaced by an MT7925 USB adapter (mt7925u), which
has not reproduced this in four days. So I cannot capture a cleaner dump
or test a patch against this hardware any more. What I have is the two
dumps and a drgn script that reproduces the above from either of them;
both are yours on request.

Thanks,
Vladislav Rysin
