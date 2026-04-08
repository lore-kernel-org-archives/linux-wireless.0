Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F6577260F
	for <linux-wireless@vger.kernel.org>; Wed,  8 Apr 2026 03:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775619858; cv=none; b=TQgsGqh6/Gcf1pJgr6ra5u2mdkH5EPYedfhZRoXC0KCe7HwSJBRjfS/ZOzEzBuW4Jrog+3HNljwMKVdUXl6AYzuPbCi7YdpgD+Mr1owXSfll/k/5Vy+ARtG8qsWVWxyt+fB/3RU/BsZ1OXjIgWJHk6I4YYy7LkK/tD2T4Yq1GwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775619858; c=relaxed/simple;
	bh=f0FjpwnTQHsk6vz1WiJKUR5L+oxci6JY4zy7fG2MsMg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QJoh3uSvKAhmu4cx1OwsQLkYNTfuQaQbm9Xxs29+e/EkdGEGTVez1UEFUoK347bAiEGNwm2ZLQPgT1BguZI8d7GdUiHTLd/vCy6Z0MwkX03ioJNlPdrYfjwsN4lMaA1kkjyoCvIvGD8/ceIszAV0Whp71wkBhWwT4irBUA8YKvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=n+ApoufA; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="n+ApoufA"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-35d94f4ee36so3322765a91.3
        for <linux-wireless@vger.kernel.org>; Tue, 07 Apr 2026 20:44:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775619857; x=1776224657; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=acsx94hHoOdSz6ntPvkv7+utIA2UkMA1HGr6OTFkAbU=;
        b=n+ApoufAj2/I4OOo4BYNsvCvDaSNNV2vEazhZC3lcGwE48ik3dK8Cp7Yevl696AiEX
         fxjZUr2oqwebzKAttUF7plB1L9zBniQkq+KZ7goD0CXN+rVngNr5cdX1SLYDEGpdRR6K
         aHAYkkQr2acxUx/j8Iaqt+Xr6+i5YoFBFxuNAYBFoi0KV3fUY8s319iLmZRhtl5874u8
         3ZiFeNO5QE+dGrnl50RuULgkVkL5h+kwKqml+XEwUSntHJhn3eXz+CX88HHHmMt/Nl7S
         6ZCxH2Pqgqk/vp6uOowAbLs5TxrUKSeN4CcUmLc6qbxXqcHw8xd9zHla4V7BIVn0OHNR
         OYcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775619857; x=1776224657;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=acsx94hHoOdSz6ntPvkv7+utIA2UkMA1HGr6OTFkAbU=;
        b=pIC+HzRvlFa+kgd5hXwB0EV1JLqaK92Hmxv2AW6RjzMCVVRkUv3PvNHTHRUUDJT/Ux
         fgJDDF7B+dB4ZBz0qsPGipgVMuIcXwHk9dQSTElFH0ch7tX6JBkFJV6seUgJjK5EiYEH
         Xbqmpwo8A3GOgPKzYHQYiq55eUYMgTl1jymW0dzRuB1adjnPxIwDgPQjcF/W6tEHSMnC
         LKdOTIDAAveMrrITaUHP5iTV/Osrt978GuKE2FNeILmOB2CJTv4nBVvo+n7r4MT9aQ9L
         BzsS1p46h16qbxfzleMDTxfGHFPOfFG1PLsheImfmGjWReoLx6xDb809CGenCXPHr4cI
         awAw==
X-Gm-Message-State: AOJu0YxD8Kyr4AHi7pJcYPLox5aXR0KOaF+R/7k22kNrE18hPEDQ4k+n
	9AzGhbY26ojDowtp6Qwgacp3L0ekY+HOWgEu2KsWASjJOhg+PT5A1Llz
X-Gm-Gg: AeBDiesImip0RcRqd3xqF8rHh/tIgPQhNKbqCG8XRYVJHw681Az9HCzIF9FLN+ctx7x
	o+sfLzu3Pczz6A9WtFBCrjmpIhc6wQhyBnQRebWbBo1hF82aN9oIsO4wo5SkSp1uMje4ZOQEubJ
	sCjapiXBaS3Bmax8WkGJBoI9PG9Sg4acbnoFMVFBG3fUa589Mtn6y//dbnDw9Z0ftwtIOyWYqLA
	iJg65rtAftKz2AGsBclrg/uOJrupoDmXzRX4NmYpK1xOlVu4qJ2p+1kWFrJQTzRCS23MzSJPzC/
	n2o1RTEQtrrSH8EY2xCExp0SLngv9DrGGZVJTGSrQjCAv5k+n8nDWRc3ExomIEqy+peHBuVonHO
	Nf265iICZPCvpj83eAjlfTeatkFb8n819Xa+h8HleItYMjzRLdnGIPHoRKXyXLJOWGrCKkLrHUN
	j8FedPSj9WZGUegHV8KVdrx/SZ995RvayFwSF75r9o8zM41I4bRUrLSlvaDYtrzR3MEw0mBVzF0
	/5qO5M54/cwrkGAlThK6ba9otrPRiQwsryGITvJdipB
X-Received: by 2002:a17:90b:3c8c:b0:35d:9d6b:9d8a with SMTP id 98e67ed59e1d1-35de68cfc01mr17110567a91.15.1775619856612;
        Tue, 07 Apr 2026 20:44:16 -0700 (PDT)
Received: from archlinux (d108-172-93-216.bchsia.telus.net. [108.172.93.216])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35dd36a1d04sm24495221a91.17.2026.04.07.20.44.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2026 20:44:16 -0700 (PDT)
From: Jay Ng <jayng9663@gmail.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jay Ng <jayng9663@gmail.com>
Subject: [PATCH] wifi: iwlwifi: remove unused header inclusions
Date: Tue,  7 Apr 2026 20:42:36 -0700
Message-ID: <20260408034413.1875915-1-jayng9663@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove header files that are included but provide no symbols,
types, or macros used by the including translation unit.

In iwl-trans.c, fw/api/tx.h defines TX command structures
(iwl_tx_cmd, iwl_tx_resp, TX_CMD_* flags) used by the PCIe TX
path, not by the transport core itself. Similarly, iwl-fh.h
defines Flow Handler register addresses and DMA-related constants
(FH_*, RFH_*, TFD_*) that are consumed by PCIe-specific code,
none of which are referenced in iwl-trans.c.

In iwl-nvm-parse.c, fw/acpi.h defines ACPI/SAR/GEO/PPAG
interfaces (iwl_acpi_*, iwl_sar_*, iwl_geo_*). No references to
any of these interfaces exist in this file.

Signed-off-by: Jay Ng <jayng9663@gmail.com>
---
This is my first commit to the Linux kernel.
Feel free to give any feedback on my process or style.
Thx.

Tested by building the module with clang and W=2:
  make M=drivers/net/wireless/intel/iwlwifi CC=clang W=2 \
    KCFLAGS="-Wno-error=enum-enum-conversion -Wno-error=shadow \
    -Wno-error=unused-macros"
No new warnings introduced.

 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c | 1 -
 drivers/net/wireless/intel/iwlwifi/iwl-trans.c     | 2 --
 2 files changed, 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index 6d235c417fdd..b3589ee10c1b 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -18,7 +18,6 @@
 #include "iwl-prph.h"
 #include "iwl-io.h"
 #include "iwl-csr.h"
-#include "fw/acpi.h"
 #include "fw/api/nvm-reg.h"
 #include "fw/api/commands.h"
 #include "fw/api/cmdhdr.h"
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
index 89901786fd68..ea69cffd3b4b 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
@@ -8,10 +8,8 @@
 #include <linux/bsearch.h>
 #include <linux/list.h>

-#include "fw/api/tx.h"
 #include "iwl-trans.h"
 #include "iwl-drv.h"
-#include "iwl-fh.h"
 #include <linux/dmapool.h>
 #include "fw/api/commands.h"
 #include "pcie/gen1_2/internal.h"
--
2.53.0

