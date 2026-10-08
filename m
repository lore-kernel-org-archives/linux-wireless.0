Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30DCC3B14C6;
	Thu,  8 Oct 2026 17:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791481099; cv=none; b=j5BoCgbMxDGC+QmYQFdOlDWEkwez/6hM97ONVXjn/+xKvzktRDrtnD6OOq3Q4G60WHWgBYAgddtFBryWAadpbgLoCTou1SZa762Cr4tRxCaKQJxy2vI0+IiDi7GyYqD4OpTfBpiH7jxUl1PWKhs/LzYvizKX0X1JEQx2ZzGaPko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791481099; c=relaxed/simple;
	bh=qYtHttXAHlR0qS19Rqv1FhyQJd4hcKVSBJQ7u9dNS94=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=g9nEDrHI3yxF+KtGFJvfPSbEGTyUJ09UtsUJlNB2BssliMNj92mAVdSCEzDlbkTR0MxBPOQmnDG4roDpeHsDxZ12h6jmvS7k6XKY5jqr92Cr9XPVmwsW1JTVOK8HClrU/agd2bfhYUswKd/GvOOWFU/D8FDRflaom5CaZZTl1/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QStgZHl8; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QStgZHl8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791481098; x=1823017098;
  h=from:to:in-reply-to:references:subject:message-id:date:
   mime-version:content-transfer-encoding;
  bh=qYtHttXAHlR0qS19Rqv1FhyQJd4hcKVSBJQ7u9dNS94=;
  b=QStgZHl8ABrF6s0rgELcRCun9khMW91pPmb3mF1KSvrSi4l/YbDWuREQ
   JAo1lAzPT0ftPfuercWJPAK+kM9x63ifhf5D3tArQgxedO/NWzP7gpI93
   6VQwAovd3BBrdu6hLj4qpRDm5L021oyiaaAGz2Ux4R6Y67V7CpZjllqr6
   jqLMyzGi+Kg2uDFLDfoaXO+LDV1ehycJ5wmRevkzrV7YJtOthcV49smub
   nXvME/SQcbA7G2G25H7vaAADlfd+MRvQVs0FiBwrYWzVvwtLsrrGfuzAF
   jcEMSqd9Pa4WiVg0OH3xef5wgbFysZYeGzJBOwA8ZPcSlUcfLjKfiPjz6
   A==;
X-CSE-ConnectionGUID: ++lO+i9ETFGFF7YuDGUg/Q==
X-CSE-MsgGUID: 9LmXsbv6R8W6hNIMDEeNew==
X-IronPort-AV: E=McAfee;i="6800,10657,11928"; a="279881"
X-IronPort-AV: E=Sophos;i="6.27,146,1787036400"; 
   d="scan'208";a="279881"
Received: from fmviesa011.fm.intel.com ([10.60.135.151])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2026 10:38:17 -0700
X-CSE-ConnectionGUID: 2nk0g4G0RWmUVNn9tDP8Ow==
X-CSE-MsgGUID: ohFYAAIaTWeXIUq4TpcjJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,146,1787036400"; 
   d="scan'208";a="1919313"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.245.140])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2026 10:38:11 -0700
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>, 
 Vinod Koul <vkoul@kernel.org>, Frank Li <Frank.Li@kernel.org>, 
 Michal Simek <michal.simek@amd.com>, Jeff Johnson <jjohnson@kernel.org>, 
 Hans de Goede <hansg@kernel.org>, Andres Salomon <dilinger@queued.net>, 
 Thomas Gleixner <tglx@kernel.org>, Paul Fox <pgf@laptop.org>, 
 Dan Carpenter <error27@gmail.com>, 
 Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>, 
 Hyun Kwon <hyun.kwon@xilinx.com>, dmaengine@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-wireless@vger.kernel.org, ath12k@lists.infradead.org, 
 platform-driver-x86@vger.kernel.org, Jiale Yao <yaojiale02@163.com>
In-Reply-To: <20260926121250.3258285-1-yaojiale02@163.com>
References: <20260926121250.3258285-1-yaojiale02@163.com>
Subject: Re: [PATCH 0/3] debugfs: Reserve space for string terminators
Message-Id: <179148108715.29028.11629364722583143417.b4-ty@b4>
Date: Thu, 08 Oct 2026 20:38:07 +0300
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2

On Sat, 26 Sep 2026 20:12:47 +0800, Jiale Yao wrote:

> The same boundary mistake appears in three debugfs write handlers. Each
> handler has a zero-initialized buffer and allows a user write to fill the
> entire buffer. That overwrites the only NUL terminator before the input
> is parsed with sscanf(), strsep(), or strcasecmp(), which can then read
> beyond the end of the buffer.
> 
> The write paths are independent, so the fixes are split by file and can
> be applied separately. Each patch reserves one byte for the terminating
> NUL while preserving the normal input size for that handler.
> 
> [...]

Thank you for your contribution, it has been applied to my local
review-ilpo-next branch. Note it will show up in the public
platform-drivers-x86/review-ilpo-next branch only once I've pushed my
local branch there, which might take a while.

FYI [if applicable to your patch], as per Linus' policy change, also
fixes are mostly routed through for-next unless the fix is for a
commit introduced in the most recent cycle or is clearly a regression
fix.

The list of commits applied:
[1/3] platform/olpc: Reserve space for a string terminator
      commit: 4ef563af57cc48d5a9662d7c69aa4447c2cc1b2c
[2/3] wifi: ath12k: Reserve space for a string terminator
      (no commit info)
[3/3] dmaengine: xilinx: dpdma: Reserve space for a string terminator
      (no commit info)

--
 i.

