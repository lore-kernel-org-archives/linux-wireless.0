Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83257368D4B;
	Tue, 30 Jun 2026 14:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782829426; cv=none; b=DEY9ZpmRXpSjLEkul+FfIF/e09r893yXMr2obifP1Gv9Mkp9ODYMkELQhRXTK68gWhFpEsSt4F89m60yyqPH375a24kevQ6eSIf9sEqCUbu6ZAuQ3447qAlbqea6moVc2NUxjGLyRCc0nGHhIk4xc6UUPiF2Gtl8Ae782gp4lqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782829426; c=relaxed/simple;
	bh=3O5OEYtoiC/BcR7MNSFFY3fLzuzy0V5o6unbzI7k44Q=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pKObPROSD0CxKSzqLh//LOaUZJhG9DFtGEvtBWAkEGhNhXhQHGaRu00wd6z0Lv11HUGc9yot4a+LcTwU6S3Wo8jye0OXP5IDCCh4/SbxNHZYkgReVa2cP8XEnuxFegIr7BUlzuHSMffhFDBROvaft7TvHhEWceEGSKkN3uLk/fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FAKx/t6u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FAKx/t6u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE4E91F000E9;
	Tue, 30 Jun 2026 14:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782829425;
	bh=4Hhhr2XcfubTUcrvTbwWhwLy7CUCWTZEVOLPtuGC1E4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=FAKx/t6uR6e0YnXhUD4OAIvzCSGSFQqB0vFZUhEgy2dgiJnluy0duaFK6NLRYiwtu
	 fVDfi6acLZR+l3CUXlY5hftQWt/eE24AJXi/lvEcSdMFqXuJ4frYnZ0itSCqWXgRpl
	 NkxGX/Z1g2YgctN43YDAMXODPkhFFnXpPr67j43JUyr96RZ4YBioADsYLsm1iFUxvL
	 kodoBEkjnvidKLPf8W0IWgLBeeikaJ/MwZ32d9NW2RcMvE5Z8DmTV/IfxrRD1LrLCw
	 CIGyHDS/uvzs9a2YLUoQJ/+oG9AWfESzK2/RaL5bmBD/3DuJWQPM2GV+9y8JozF2SR
	 aMsyqYRgaYGUQ==
Date: Tue, 30 Jun 2026 07:23:44 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo Abeni
 <pabeni@redhat.com>, Brian Norris <briannorris@chromium.org>, Edward Cree
 <ecree.xilinx@gmail.com>, Francesco Dolcini <francesco@dolcini.it>, Manish
 Chopra <manishc@marvell.com>, Przemek Kitszel
 <przemyslaw.kitszel@intel.com>, Sudarsana Kalluru <skalluru@marvell.com>,
 Tony Nguyen <anthony.l.nguyen@intel.com>, b43-dev@lists.infradead.org,
 intel-wired-lan@lists.osuosl.org, libertas-dev@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-net-drivers@amd.com, linux-wireless@vger.kernel.org,
 netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/8] drivers/net: replace __get_free_pages()
 with kmalloc()
Message-ID: <20260630072344.159b5d99@kernel.org>
In-Reply-To: <20260630-b4-drivers-net-v1-0-672162a91f37@kernel.org>
References: <20260630-b4-drivers-net-v1-0-672162a91f37@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 30 Jun 2026 13:59:19 +0300 Mike Rapoport (Microsoft) wrote:
>  drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c    |  6 +--
>  drivers/net/ethernet/intel/ice/ice_gnss.c         |  5 +-
>  drivers/net/ethernet/sfc/mcdi.c                   |  7 +--
>  drivers/net/ethernet/sfc/siena/mcdi.c             |  7 +--
>  drivers/net/wireless/broadcom/b43/debugfs.c       | 12 ++---
>  drivers/net/wireless/broadcom/b43legacy/debugfs.c | 11 ++--
>  drivers/net/wireless/marvell/libertas/debugfs.c   | 39 ++++++--------
>  drivers/net/wireless/marvell/mwifiex/debugfs.c    | 62 ++++++++++-------------
>  drivers/net/wireless/ti/wlcore/main.c             | 14 +++--

You gotta split this, wireless and ethernet go via separate trees.
BTW cocci also suggests folding in a memset, IDK if it's worth it.

drivers/net/wireless/broadcom/b43legacy/debugfs.c:217:8-15: WARNING: kzalloc should be used for buf, instead of kmalloc/memset
-- 
pw-bot: cr
