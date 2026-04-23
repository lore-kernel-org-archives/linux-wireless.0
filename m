Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 863E1342524;
	Thu, 23 Apr 2026 22:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776984898; cv=none; b=E4h5Qfx4QAVmPNkMV5sRYr5X6ERRuDK2y+69im4hdLCAuHgyzBCw8/5OLmSzI6W//U261/naliOhRZl3nBNlkI0TDLeDlNY5RfzvABLCv6+mcY3LrI/npp75CdYJApDdT6zrrMWoYzrF/TUGG9kbOgzVi31mw//rS+iQ2P+bsPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776984898; c=relaxed/simple;
	bh=oo9+ecjWT/Z1mknOQ/2xHkiBtde6zMXiPXDFU83Hr3s=;
	h=From:Date:Message-ID:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S8aEX2JIyClr164aWGI1DHqEMM5yVxjJ92nAttSi92YuPTFeJjWFFQ9lWR2Q/ymTMgb7QiEaaR2mHBOHMgUhxKeu3tlQ018n41rCp7ySB/0sZtvzBnNPIDHMVddQSKc0TC+D7q9grN8hiB8oS+an9OT8B2GIp1bCfReC+BrDtz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from 12-mac80211-minstrel-drop.eml (unknown [111.196.245.116])
	by APP-05 (Coremail) with SMTP id zQCowABX5wo+o+ppqpVsDg--.56179S2;
	Fri, 24 Apr 2026 06:54:54 +0800 (CST)
From: Pengpeng Hou <pengpeng@iscas.ac.cn>
Date: Fri, 24 Apr 2026 06:54:53 +0800
Message-ID: <20260424070112.1-mac80211-minstrel-drop-pengpeng@iscas.ac.cn>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, pengpeng@iscas.ac.cn
Subject: Re: [PATCH] mac80211: minstrel_ht: bound debugfs stats output construction
In-Reply-To: <20260417075642.32502-1-pengpeng@iscas.ac.cn>
References: <20260417075642.32502-1-pengpeng@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowABX5wo+o+ppqpVsDg--.56179S2
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUU5E7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E
	6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28Cjx
	kF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8I
	cVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z2
	80aVCY1x0267AKxVWxJr0_GcWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IE
	w4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jw0_WrylYx0Ex4A2jsIE14v26r4j6F4UMc
	vjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1l
	42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJV
	WUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAK
	I48JMIIF0xvE2Ix0cI8IcVAFwI0_Gr0_Xr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4UJV
	WxJr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF
	0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvjfU0pBTUUUUU
X-CM-SenderInfo: pshqw1xhqjqxpvfd2hldfou0/

Hi Johannes,

Thanks for reviewing it.

I rechecked the current minstrel group/rate bounds and agree that the
overflow claim does not hold statically. I'll drop this patch.

Thanks,
Pengpeng


