Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F2EC3FB7DE
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 14:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784298844; cv=none; b=TOAndtNU7er4EjounYSALqYPpYKs5FbgUz4vTykYiBRUaJQK4EdhaKwts3+VHKiWIoehX8bMGYhSDCc1iOC3McKVvxTGORXw4wcoP3DqIgavGnZoq1pRw6cDRq2joeP6fcVmVoMrAJv5DoYbpHqh2ug63Q/q6lrYURrdZ0IAO80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784298844; c=relaxed/simple;
	bh=RJ7Cgw6Pe8KzUkl5x2cA8hYWw7V0epZ6NvRtFHmR/Vk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=CA9dMN2U5WUAdjNnUJqpJzuPHbLKmn/iuLMLGzFd5elT/hhhC0Qv40LHSF3/pl2YX9zOCekit6N1/1eO3PFAT26mGg5fEzCpWl/iS+rAS2VWfJ937zksHv3oAi+AXtS8JyHdIoV6V08QTqmkhjhym7CxUYN+A0J2zSQQZqgZXR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Kdh/NsLQ; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Kdh/NsLQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784298844; x=1815834844;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=RJ7Cgw6Pe8KzUkl5x2cA8hYWw7V0epZ6NvRtFHmR/Vk=;
  b=Kdh/NsLQgo/8LbOq2O4ojQ5JGtXiKq/LTzkGBuxCKNj9xaG7z0Zz97ER
   vISxzkclP1Cgx4R2RwMrjCkNQifj6oRoGFuIHxqxS2Vmc+5qfykzDU1/m
   QneBkJV0OguQW7abjoMebpdi8UI48uXuxvF97i80FdMcPxWOJz7VvIWFM
   rX+9h6ZkfbfCgFZ/ff0HVawZAYk0GCx28w7nXDafqMZHqplBTAV/Y6oUJ
   4SshtAtWb5wjHTfNQKccwcSQDcfwxs3aNktDseXH9WJgTTI4op+mNNAQF
   oSDp7enFISjrjMQdyfQI8yMVLlWWEo8hgrEBsnnlOwpOZCSVb/NKjtbCw
   Q==;
X-CSE-ConnectionGUID: B01D24NoQjWELDj2RZJBbA==
X-CSE-MsgGUID: jI/gDU3tR5uh8zgV+In5MQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11848"; a="95571395"
X-IronPort-AV: E=Sophos;i="6.25,169,1779174000"; 
   d="scan'208";a="95571395"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2026 07:34:03 -0700
X-CSE-ConnectionGUID: KvFuh549Rp2lZokQwZVkoQ==
X-CSE-MsgGUID: 9Er9N3QpSa2wMMnePmQyxQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,169,1779174000"; 
   d="scan'208";a="255035078"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2026 07:34:02 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH iwlwifi-fixes 0/5] wifi: iwlwifi: fixes - 07-17-2026
Date: Fri, 17 Jul 2026 17:33:35 +0300
Message-Id: <20260717143340.2321964-1-miriam.rachel.korenblit@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

Hi,

A few fixes from our internal tree.

Miri
---

Emmanuel Grumbach (5):
  wifi: iwlwifi: bound aligned TLV advance in FW parser
  wifi: iwlwifi: dbg-tlv: bound aligned TLV walk length
  wifi: iwlwifi: acpi: validate WGDS table revision index
  wifi: iwlwifi: uefi: bound PPAG revision bitmap shift
  wifi: iwlwifi: validate SEC_RT TLV minimum size

 drivers/net/wireless/intel/iwlwifi/fw/acpi.c   |  5 +++++
 drivers/net/wireless/intel/iwlwifi/fw/uefi.c   |  2 +-
 .../net/wireless/intel/iwlwifi/iwl-dbg-tlv.c   | 13 +++++++++++--
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c   | 18 +++++++++++++++---
 4 files changed, 32 insertions(+), 6 deletions(-)

-- 
2.34.1

