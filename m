Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2CF127B353;
	Wed,  1 Jul 2026 13:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782914356; cv=none; b=lCZz2t6kmisiOnWOSD2bFC8eIHU8Wruj5kM8K21eWfhVDoRenuvzPm/jRgx0EdtNdUREma1Q/kPpNCtGnho7Mz3JA+1JGuLVEZ0ud+96UwVh0GrjFJoEMCdoVBJHr072wC10VGbutCqQO6FKnEsoEY8K6cd/ln+ed9EPs867atA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782914356; c=relaxed/simple;
	bh=b2o/Gm9lcosREEItsHlflwLY3iaZob3hfsur+AmRd4U=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=WYEkNjVHvciW6VZ5qLIbes1Qtx4va9zeDO4+88Fnp5ErNWogyD2iExMrcBoXjngty+7NGbBk1xSQSaSTkWQaGEaJKiA2h0YxmF+htXmPwfAOXIBU9EXvlw+sNs06KPI3dmFfpCIj/NtWz4rLVeN+y/JGqqZVpEd0INLCrjxpgwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vlm+1lqn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vlm+1lqn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14DD11F000E9;
	Wed,  1 Jul 2026 13:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782914355;
	bh=LpfnkoRQ/FIEnyqT9WtrevlR/4ONd3yok9y5wj54j9M=;
	h=From:Subject:Date:To:Cc;
	b=Vlm+1lqnw0+3/DGTRCUIaNB1c1zYGlJAGjdv2/E5QfdeDDPjsHdM1kPXDdHsF5YGN
	 3x+fE/ceoDxA2tEV8/6vz4ccOiZvAE/g9lTu2ggMVY1LIdW3rhPgzy/P4cP/22X4BB
	 e933TZn2T+RhdEai0fwPXAXP4mxuvEnuJzpZf1423uKckJhVeWxNLhNyPKFFLugtpO
	 ibOOET9A4lUzyeY0V052OdR+CYiehh/YbhQXoMUgjvT6n8e6TkvedxIdZ2xmNyoGyM
	 6CYy+C1j1qyNX5QZjxiIaInB2gjnLS2PpWBJqFvMmZS3sqI03ko3i7uEC6tFbztQqh
	 BEVYL8FVMTU4w==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH 0/4] drivers/net: replace __get_free_pages() with kmalloc()
Date: Wed, 01 Jul 2026 16:59:09 +0300
Message-Id: <20260701-b4-drivers-wireless-v1-0-60264cdf2efe@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAC0dRWoC/yXMwQrCMBAE0F8pe3YhxjSgvyIesunWrkiU3VqF0
 n830eMbZmYFYxU2OHUrKC9i8igV+10HeUrlyihDNXjno4sHhxRwUFlYDd+ifGcz7P0x9D6MiUK
 Eunwqj/L5vZ4vf9uLbpzndtUalIyRNJU8tagRtu0LbS7gOI4AAAA=
X-Change-ID: 20260630-b4-drivers-wireless-5294524fab46
To: Johannes Berg <johannes.berg@intel.com>
Cc: Brian Norris <briannorris@chromium.org>, 
 Francesco Dolcini <francesco@dolcini.it>, Jakub Kicinski <kuba@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, b43-dev@lists.infradead.org, 
 libertas-dev@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-wireless@vger.kernel.org, netdev@vger.kernel.org
X-Mailer: b4 0.16-dev

This is a (small) part of larger work of replacing page allocator calls
with kmalloc.

My initial intention a few month ago was to remove ugly casts [1], but then
willy pointed out that Linus objected to something like this [2] and it
looks like more than a decade old technical debt.

Largely, anything that doesn't need struct page (or a memdesc in the
future) should just use kmalloc() or kvmalloc() to allocate memory.
kmalloc() guarantees alignment, physical contiguity and working
virt_to_phys() and beside nicer API that returns void * on alloc and
doesn't require to know the allocation size on free, kmalloc() provides
better debugging capabilities than page allocator.

Another thing is that touching these allocation sites gives the reviewers
opportunity to see if a PAGE_SIZE buffer is actually needed or maybe
another size is appropriate.

For larger allocations that don't need physically contiguous memory
kvmalloc() can be a better option that __get_free_pages() because under
memory pressure it's is easier to allocate several order-0 pages than a
physically contiguous chunk with the same number of pages.

And last, but not least, removing needless calls to page allocator should
help with memdesc (aka project folio) conversion. There will be way less
places to audit to see if the user was actually using struct page.

Also in git:
https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git gfp-to-kmalloc/drivers-net-wireless

[1] https://lore.kernel.org/all/20251018093002.3660549-1-rppt@kernel.org/
[2] https://lore.kernel.org/all/CA+55aFwp4iy4rtX2gE2WjBGFL=NxMVnoFeHqYa2j1dYOMMGqxg@mail.gmail.com/

---
Changes in v2:
- split out wireless drivers from a larger set 
- use kzalloc() instead of kmalloc() + memset in b43legacy

v1: https://patch.msgid.link/20260630-b4-drivers-net-v1-0-672162a91f37@kernel.org

---
Mike Rapoport (Microsoft) (4):
      b43, b43legacy: debugfs: use kzalloc() to allocate formatting buffers
      libertas: debugfs: use kzalloc() to allocate formatting buffers
      mwifiex: debugfs: use kzalloc() to allocate formatting buffers
      wlcore: allocate aggregation and firmware log buffers with kzalloc()

 drivers/net/wireless/broadcom/b43/debugfs.c       | 12 ++---
 drivers/net/wireless/broadcom/b43legacy/debugfs.c | 12 ++---
 drivers/net/wireless/marvell/libertas/debugfs.c   | 39 ++++++--------
 drivers/net/wireless/marvell/mwifiex/debugfs.c    | 62 ++++++++++-------------
 drivers/net/wireless/ti/wlcore/main.c             | 14 +++--
 5 files changed, 59 insertions(+), 80 deletions(-)
---
base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
change-id: 20260630-b4-drivers-wireless-5294524fab46

Best regards,
--  
Sincerely yours,
Mike.

